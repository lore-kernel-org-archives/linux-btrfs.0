Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:41147 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751543AbdINWSZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Sep 2017 18:18:25 -0400
Date: Thu, 14 Sep 2017 22:18:24 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: kreijack@inwind.it
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BUG: BTRFS and O_DIRECT could lead to wrong checksum and wrong
 data
Message-ID: <20170914221824.GD7067@carfax.org.uk>
References: <cf8a733f-2c9d-7ffe-e865-4c13d99dfb60@libero.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="8w3uRX/HFJGApMzv"
In-Reply-To: <cf8a733f-2c9d-7ffe-e865-4c13d99dfb60@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--8w3uRX/HFJGApMzv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   As far as I know, both of these are basically known issues, with no
good solution, other than not using O_DIRECT. Certainly the first
issue is one I recognise. The second isn't one I recognise directly,
but is unsurprising to me.

   There have been discussions -- including developers -- on this list
as recent as a month or so ago. The general outcome seems to be that
any problems with O_DIRECT are not going to be fixed.

   Hugo.

On Fri, Sep 15, 2017 at 12:00:19AM +0200, Goffredo Baroncelli wrote:
> Hi all,
> 
> I discovered two bugs when O_DIRECT is used...
> 
> 1) a corrupted file doesn't return -EIO when O_DIRECT is used
> 
> Normally BTRFS prevents to access the contents of a corrupted file; however I was able read the content of a corrupted file simply using O_DIRECT
> 
> # in a new btrfs filesystem, create a file
> $ sudo mkfs.btrfs -f /dev/sdd5
> $ mount /dev/sdd5 t
> $ (while true; do echo -n "abcefg" ; done )| sudo dd of=t/abcd bs=$((16*1024)) iflag=fullblock count=1024
> 
> # corrupt the file
> $ sudo filefrag -v t/abcd 
> Filesystem type is: 9123683e
> File size of t/abcd is 16777216 (4096 blocks of 4096 bytes)
>  ext:     logical_offset:        physical_offset: length:   expected: flags:
>    0:        0..    3475:      70656..     74131:   3476:            
>    1:     3476..    4095:      74212..     74831:    620:      74132: last,eof
> t/abcd: 2 extents found
> $ sudo umount t
> $ sudo ~/btrfs/btrfs-progs/btrfs-corrupt-block -l $((70656*4096)) -b 10 /dev/sdd5
> mirror 1 logical 289406976 physical 289406976 device /dev/sdd5
> corrupting 289406976 copy 1
> 
> # try to access the file; expected result: -EIO
> $ sudo mount /dev/sdd5 t
> $ dd if=t/abcd | hexdump -c | head
> dd: error reading 't/abcd': Input/output error
> 0+0 records in
> 0+0 records out
> 0 bytes copied, 0.000477413 s, 0.0 kB/s
> 
> 
> # try to access the file using O_DIRECT; expected result: -EIO, instead the file is accessible
> $ dd if=t/abcd iflag=direct bs=4096 | hexdump -c | head
> 0000000 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001
> *
> 0001000   f   g   a   b   c   e   f   g   a   b   c   e   f   g   a   b
> 0001010   c   e   f   g   a   b   c   e   f   g   a   b   c   e   f   g
> 0001020   a   b   c   e   f   g   a   b   c   e   f   g   a   b   c   e
> 0001030   f   g   a   b   c   e   f   g   a   b   c   e   f   g   a   b
> 0001040   c   e   f   g   a   b   c   e   f   g   a   b   c   e   f   g
> 0001050   a   b   c   e   f   g   a   b   c   e   f   g   a   b   c   e
> 0001060   f   g   a   b   c   e   f   g   a   b   c   e   f   g   a   b
> 0001070   c   e   f   g   a   b   c   e   f   g   a   b   c   e   f   g
> 
> (dmesg report the checksum mismatch)
> [13265.085645] BTRFS warning (device sdd5): csum failed root 5 ino 257 off 0 csum 0x98f94189 expected csum 0x0ab6be80 mirror 1
> 
> Note the first 4k filled by 0x01 !!!!!
> 
> Conclusion: even if the file is corrupted and normally BTRFS prevent to access it, using O_DIRECT
> a) no error is returned to the caller
> b) instead of the page stored on the disk, it is returned a page filled with 0x01 (according also with the function __readpage_endio_check())
> 
> 
> 2) The second bug, is a more severe bug. If during a writing of a buffer with O_DIRECT, the buffer is updated at the same time by a second process, the checksum may be incorrect.
> 
> At the end of the email there is the code which shows the problem: two process share the same memory: the first write it to the disk, the second update the buffer continuously. A third process try to read the file, but it got time to time -EIO
> 
> If you ran my code in a btrfs filesystem you got a lot of 
> 
> ERROR: read thread; r = 8192, expected = 16384
> ERROR: read thread; r = 8192, expected = 16384
> ERROR: read thread; e = 5 - Input/output error
> ERROR: read thread; e = 5 - Input/output error
> 
> The firsts lines are related to a shorter read (which may happens). The lasts lines are related to a checksum mismatch. The dmesg is filled by lines like
> [...]
> [14873.573547] BTRFS warning (device sdd5): csum failed root 5 ino 259 off 4096 csum 0x0683c6df expected csum 0x55eb85e6 mirror 1
> [...]
> 
> This is definitely a bug. 
> 
> I think that using O_DIRECT and updating a page at the same time could happen in a VM. In BTRFS this  could lead to a wrong checksum. The problem is that if BTRFS detects a checksum error during a reading:
> a) if O_DIRECT is not used in the read
> 	* -EIO is returned
> Definitely BAD
> 
> b) if O_DIRECT is used in the read
> 	* it doesn't return the error to the caller
> 	* it returns a page filled by 0x01 instead of the data from the disk
> Even worse than a)	
> 
> Note1: even using O_DIRECT with O_SYNC, the problem still persist.
> Note2: the man page of open(2) is filled by a lot of notes about O_DIRECT, but also it stated that using O_DIRECT+fork()+mmap(... MAP_SHARED) is legally.
> Note3: even "ZFS on linux" has its trouble with O_DIRECT: if fact ZFS doesn't support it; see https://github.com/zfsonlinux/zfs/issues/224
> 
> BR
> G.Baroncelli
> 
> ----- cut --- cut --- cut ----
> 
> #define _GNU_SOURCE
> #include <stdio.h>
> #include <stdlib.h>
> #include <sys/mman.h>
> #include <assert.h>
> #include <errno.h>
> #include <sys/types.h>
> #include <sys/stat.h>
> #include <fcntl.h>
> #include <string.h>
> #include <unistd.h>
> 
> #define FILESIZE	(4096*4)
> 
> int fd;
> char *buffer = NULL;
> 
> void read_thread(const char *nf) {
> 	
> 	void *data = mmap(NULL,  FILESIZE,
> 				PROT_READ|PROT_WRITE, 
> 				MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
> 	
> 	assert(data);
> 	fprintf(stderr, "read_thread:  data = %p\n", data);
> 	int rfd;
> 	rfd = open(nf, O_RDONLY);
> 	
> 	for(;;) {
> 		ssize_t r = pread(rfd, data, FILESIZE, 0);
> 		if (r < 0) {
> 			int e = errno;
> 			fprintf(stderr, "ERROR: read thread; e = %d - %s\n", 
> 			       e, strerror(e));
> 
> 		} else if (r != FILESIZE) {
> 			fprintf(stderr, "ERROR: read thread; r = %ld, expected = %d\n", 
> 			       r, FILESIZE);
> 		}
> 	}
> }
> 
> void write_thread(void) {
> 
> 	for(;;) {
> 		ssize_t r = pwrite(fd, buffer, FILESIZE, 0);
> 		assert(r == FILESIZE);
> 	}
> }
> 
> void update_thread(void) {
> 
> 	for(;;) {
> 		int i;
> 		for (i = 0 ; i < FILESIZE ; i++)
> 			buffer[i] += i+10;
> 	}
> }
> 
> 
> int main(int argc, char **argv) {
> 	
> 	if (argc < 2) {
> 		fprintf(stderr, "usage: %s <fname>\n", argv[0]);
> 		exit(100);
> 	}
> 	
> 	
> 	buffer = mmap(NULL,  FILESIZE,
> 				PROT_READ|PROT_WRITE, 
> 				MAP_SHARED|MAP_ANONYMOUS, -1, 0);
> 	
> 	assert(buffer);
> 	fprintf(stderr, "main:  data = %p\n", buffer);
> 	
> 	fd = open(argv[1], O_RDWR|O_DIRECT|O_CREAT, 0660);
> 	assert(fd>=0);
> 	
> 	ssize_t r = pwrite(fd, buffer, FILESIZE, 0);
> 	assert(r == FILESIZE);
> 	
> 	pid_t child;
> 	
> 	child = fork();
> 	assert(child >= 0);
> 	if (child == 0)
> 		write_thread();
> 	fprintf(stderr, "write_thread pid = %d\n", child);
> 	
> 	child = fork();
> 	assert(child >= 0);
> 	if (child == 0)
> 		read_thread(argv[1]);
> 	fprintf(stderr, "read_thread pid = %d\n", child);
> 	
> 	child = fork();
> 	assert(child >= 0);
> 	if (child == 0)
> 		update_thread();
> 	fprintf(stderr, "update_thread pid = %d\n", child);
> 	
> 	for(;;)
> 		sleep(100*100*100);
> 
> 	
> 	return 0;
> }
> 
> ----- cut --- cut --- cut -- 

-- 
Hugo Mills             | "There's more than one way to do it" is not a
hugo@... carfax.org.uk | commandment. It is a dire warning.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--8w3uRX/HFJGApMzv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZuwAwAAoJEFheFHXiqx3kQPMQALFPSQQa/HuoLmvNsG8iuv/w
BuoNw44aOTLVTOiylwCD0yoOYDo1quE9l+jpR5GWTE5nD3jVpVM4GlGql3UvsBcH
VIejJul2yHGxHWwrPDE1RU61AXN/vcEoqZ16C5AjQS0BHX+jaZwQOq7b2rNBHlsN
E8pgjGeOqAg78x3Bh/iuiAzc/dUEeCTvi60htklQJrLugvRCt1NKet6BEgDz00Kp
U8sfepbpl6e+RyWP/qgCacDgVhEJdEe1eJAINtxVL6PSVfJzUfE1OjKoeTaPbU1H
flpdx/4Wv//ueGilBqkI9mElNzQegxB3hlyrh6zja/wdV+MhZk6BEHAv6/Kyxf2r
hOdzulmQukG3e7X4pDfBe3jmAoxV4TGsADg73hthEMkcrq1ziAWGz2wZD288t6nY
0K4Cugi7x9X0Ime3NGXyVxenQL67hs0KPtXSQDxh95PjQQT2AhGj781Im8OzY3fP
JwVIdsw3crGs9f4jb+stE6ncYSVJ19/eTxkIB3RBJkP6a/feHxbajydXDGx0MOQu
6o4rk+X/29pDKO/ykl/bY74k2Zc33KwsW/hrm3U/QykjFSmhY99uvKcGIx9TCaKx
4D2VCQ44zc0kIAggd3BAYsNUxHnDj/+TpCYOp4I8SeMSOI9s15uMgLaW9B5Tg6Bg
/ajRYdgoUC8VIwJvpdY2
=8BRP
-----END PGP SIGNATURE-----

--8w3uRX/HFJGApMzv--
