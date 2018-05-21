<html>
<body>

<h1>Hello world!</h1>
<p>Testing VPN connection between GCP and AWS</p>

<?php
$con=mysqli_connect("${dbendpoint}","${dbuser}","${dbpass}","${dbname}");
// Check connection
if (mysqli_connect_errno())
{
echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

$result = mysqli_query($con,"SELECT * FROM Persons");

echo "<table border='1'>
<tr>
<th>Firstname</th>
<th>LastInitial</th>
</tr>";

while($row = mysqli_fetch_array($result))
{
echo "<tr>";
echo "<td>" . $row['FirstName'] . "</td>";
echo "<td>" . $row['LastInitial'] . "</td>";
echo "</tr>";
}
echo "</table>";

mysqli_close($con);
?>

</body>
</html>