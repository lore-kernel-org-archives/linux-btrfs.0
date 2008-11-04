From: Chris Samuel <chris@csamuel.org>
Subject: Re: Compressed Filesystem
Date: Tue, 4 Nov 2008 11:08:48 +1100
Message-ID: <200811041108.51460.chris@csamuel.org>
References: <20081027145401.GB10896@tux64-03> <53696.2001:470:e828:1::2:2.1225304096.squirrel@avalon.arbitraryconstant.com> <1225310922.6448.300.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1804182.IZdjAG35tu";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1225310922.6448.300.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1804182.IZdjAG35tu
Content-Type: multipart/mixed;
  boundary="Boundary-01=_QK5DJgllXvtdzAL"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_QK5DJgllXvtdzAL
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thu, 30 Oct 2008 7:08:42 am Chris Mason wrote:

> The decompression does spread across cpus, and I've gotten about 800MB/s
> doing decompress and checksumming on a zero filled compressed file. =A0At
> the time, the disk was reading 14MB/s.

=46WIW I've got a pretty ugly patch to Bonnie++ that makes it use data from=
=20
/dev/urandom for writes rather than just blocks of zero's which give, um,=20
optomistic values for throughput on filesystems that do compression.

Still not particularly realistic in terms of an actual workload, but maybe=
=20
just a tad less unrealistic. :-)

Caveat emptor - I've not tried this since I sent it to Russell Coker in=20
January '07.

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP


--Boundary-01=_QK5DJgllXvtdzAL
Content-Type: text/x-patch;
  charset="iso-8859-15";
  name="bonnie++-1.03a-urand.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="bonnie++-1.03a-urand.patch"

diff -ur bonnie++-1.03a/bonnie++.cpp bonnie++-1.03a-urand/bonnie++.cpp
=2D-- bonnie++-1.03a/bonnie++.cpp	2002-12-04 00:40:35.000000000 +1100
+++ bonnie++-1.03a-urand/bonnie++.cpp	2007-01-01 13:03:41.644378000 +1100
@@ -41,6 +41,9 @@
 #include <string.h>
 #include <sys/utsname.h>
 #include <signal.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
=20
 #ifdef AIX_MEM_SIZE
 #include <cf.h>
@@ -148,6 +151,28 @@
   }
 }
=20
+void load_random_data(char *temp_buffer,int length)
+{
+	int filedes, numbytes;
+
+	filedes=3Dopen("/dev/urandom",O_RDONLY);
+	if(filedes<0)
+	{
+		perror("Open of /dev/urandom failed, falling back to 0's");
+		memset(temp_buffer, 0, length);
+	}
+	else
+	{
+		numbytes=3Dread(filedes,temp_buffer,length);
+		if(numbytes!=3Dlength)
+			{
+				perror("Read from /dev/urandom failed, falling back to 0's");
+				memset(temp_buffer, 0, length);
+			}
+		close(filedes);
+	}
+}
+
 int main(int argc, char *argv[])
 {
   int    file_size =3D DefaultFileSize;
@@ -477,7 +502,8 @@
       return 1;
     globals.decrement_and_wait(FastWrite);
     if(!globals.quiet) fprintf(stderr, "Writing intelligently...");
=2D    memset(buf, 0, globals.chunk_size());
+    // memset(buf, 0, globals.chunk_size());
+    load_random_data(buf, globals.chunk_size());
     globals.timer.timestamp();
     bufindex =3D 0;
     // for the number of chunks of file data

--Boundary-01=_QK5DJgllXvtdzAL--

--nextPart1804182.IZdjAG35tu
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQEVAwUASQ+Sk41yjaOTJg85AQISKAgAoHFxJ3JtSr9kJLaJwdoSPK92nSofQzoZ
VcNqZPHr/uYCkEQlSPenY6RdqJnEszcyr9x2ZXZPFHgUYGvVC5FIeuoB+33Do4DH
6IQcWYu1nSm99T85lMwsu7zBFF9vzSwBAI4t1Gz7Ftk0ww4Lq/ySVX8ySEENLJlb
5N0Yfi5efb6P7OtTwEgAMWleAi4MmFI05IZmghuA37v1zk1KJPxnBQFXVocnKYJD
p3V6JvOWWRVhqXNvbyNRQFsJxpBcouvHNcZEuYdsC2f3g7ths/ukstLfWhNdX7YK
nYD+CPS1UXrlbsB1bi1wZsMzXwZ1m1h/73MftYogQuKxKHdv/QOD4g==
=2c/Z
-----END PGP SIGNATURE-----

--nextPart1804182.IZdjAG35tu--
