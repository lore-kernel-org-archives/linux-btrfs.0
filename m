From: Goffredo Baroncelli <kreijack@libero.it>
Subject: [PATCH] add a --force option to mkfs.btrf [was Re: Odd mkbtrfs behavior
 inside of chroot]
Date: Mon, 03 Jan 2011 20:05:33 +0100
Message-ID: <4D221DFD.60707@libero.it>
References: <915110.93115.qm@web112501.mail.gq1.yahoo.com> <4D2106D0.80609@libero.it>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040305090003080400010303"
Cc: J G <yoosty_cmn@yahoo.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D2106D0.80609@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040305090003080400010303
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi all and happy new year.

this is my first patch of the new year. Hooping that this is a good
sign. :-)

The enclosed patch try to address the problem raised by Justin: how
circumvent the check performed by mkfs.btrfs ?
I add a "-f|--force" switch which permits to bypass the check if a
device is already mounted. I update the man page too.

You can pull the change from

	http://cassiopea.homelinux.net/git/btrfs-progs-unstable.git

branch

	force-mkfs

commit (2900a150cde604f82f1437c931792bfa59c4780b)

Comments are welcome
Regards
G.Baroncelli

- -- 
gpg key: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512



On 01/03/2011 12:14 AM, Goffredo Baroncelli wrote:
> On 01/02/2011 08:52 PM, J G wrote:
>> I just encountered some odd behavior from mkbtrfs.
>> The end goal is to restore a backup to newly created BTRFS partitions while using the latest btrfs-tools. 
>> Here's the steps to what I did:
>> * Booted SystemRescueCD
>> * Partitioned the drives (two 750GB drives with 12 partitions each)
>> * Created an extra partition on sda as a temporary holding place for the backed up files and so I can update btrfs-tools
>> * Formatted/mounted/restored backup files to the temporary partition which I mounted on /mnt/backup
>> * mount -t proc none /mnt/backup/proc; mount -o bind /dev /mnt/backup/dev
>> * chroot /mnt/backup /bin/bash
>> * Updated btrfs-tools to the latest git pull from today (v0.19-35-g1b444cd-dirty).
>> * mkbtrfs /dev/sda5 /dev/sdb5 -L root
>>
>> mkbtrfs returned with:
>>
>> error checking /dev/sda5 mount status
>>
>> So I used strace to find out how it was checking for the mount status. Now, I'm no expert here, but I'm confused as to just why it failed. The last thing of note:
>>
>> lstat("/boot", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
>> lstat("/boot/sysrcd.dat", 0x7fffb29681e0) = -1 ENOENT (No such file or directory)
>> close(3)                                = 0
>> munmap(0x7f11df372000, 4096)            = 0
>> write(2, "error checking /dev/sda5 mount s"..., 38error checking /dev/sda5 mount status
>> ) = 38
>>
>>
>> doesn't explain much. I see that it's checking /proc/mounts to see what's mounted, and then it fails on stating /boot/sysrcd.dat (which doesn't exist in the non-chrooted FS, btw).
>>
>> To make this even weirder, if I format sda5/sdb5 using the SysRescCD version of mkbtrfs (v0.19) and then format sda5/sdb5 using the chroot version, it works fine.
>>
>> Any ideas here? I would expect that mkbtrfs would work inside of a chroot without any assistance from the original root.
>>
>> I have the full strace from the chrooted mkbtrfs failing and from it succeeding, if that's helpful.
> 
> On the basis of the provided information, and on the code it seems that
> mkfs.btrfs tries hard to check that the user is not formatting a mounted
> disk (or loop). So mkfs.btrfs scan the /proc/mount file and checks every
> devices. To do the check it needs to access the original file if this is
> a "loop backend". This is reasonable.
> 
> In this case in a chroot-ed environment the loop file is not accessible.
> 
> If you need a [dirty] "quick hack" to by-pass the problem (not tested):
> - unmount the proc filesystem
> - create an empty file /proc/mounts
> - run btrfs.fsck
> - mount the proc filesystem (removing the fake mounts file)
> - perform a "btrfs device scan"
> - mount the filesystem
> 
> Of course the "right" solution is to add a "--force" switch which
> permits to by-pass these checks. Other mkfs.* tools have this switch.
> 
>>From the mkfs.ext4 man page:
> [...]
>        -F     Force mke2fs to create a filesystem,
>               even if the specified device is  not
>               a   partition  on  a  block  special
>               device, or if  other  parameters  do
>               not  make  sense.  In order to force
>               mke2fs to create a  filesystem  even
>               if  the  filesystem appears to be in
>               use or is mounted (a truly dangerous
>               thing  to  do),  this option must be
>               specified twice.
> 
> [...]
> 
> 
>>
>> .:Justin:.
>>
>>
>>       
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> .
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iD8DBQFNIh34vwTxYT3FBRIRAl1tAJ9k1LVUfahdlvLvK7b4gct55fom3QCfd1Ab
0JfVbWgKf7DXd0Gg1YzaPdU=
=Jt+e
-----END PGP SIGNATURE-----

--------------040305090003080400010303
Content-Type: text/x-patch;
 name="mkfs.btrfs-force.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mkfs.btrfs-force.diff"

diff --git a/man/mkfs.btrfs.8.in b/man/mkfs.btrfs.8.in
index 1e14c6c..f51291c 100644
--- a/man/mkfs.btrfs.8.in
+++ b/man/mkfs.btrfs.8.in
@@ -5,14 +5,14 @@ mkfs.btrfs \- create an btrfs filesystem
 .B mkfs.btrfs
 [ \fB\-A\fP\fI alloc-start\fP ]
 [ \fB\-b\fP\fI byte-count\fP ]
-[ \fB \-d\fP\fI data-profile\fP ]
-[ \fB \-l\fP\fI leafsize\fP ]
-[ \fB \-L\fP\fI label\fP ]
-[ \fB \-m\fP\fI metadata profile\fP ]
-[ \fB \-n\fP\fI nodesize\fP ]
-[ \fB \-s\fP\fI sectorsize\fP ]
-[ \fB \-h\fP ]
-[ \fB \-V\fP ] \fI device\fP [ \fI device ...\fP ]
+[ \fB\-d\fP\fI data-profile\fP ]
+[ \fB\-f\fP ]
+[ \fB\-l\fP\fI leafsize\fP ]
+[ \fB\-L\fP\fI label\fP ]
+[ \fB\-m\fP\fI metadata profile\fP ]
+[ \fB\-n\fP\fI nodesize\fP ]
+[ \fB\-s\fP\fI sectorsize\fP ]
+[ \fB\-V\fP ] \fIdevice\fP [ \fIdevice ...\fP ]
 .SH DESCRIPTION
 .B mkfs.btrfs
 is used to create an btrfs filesystem (usually in a disk partition, or an array
@@ -34,6 +34,9 @@ mkfs.btrfs uses all the available storage for the filesystem.
 Specify how the data must be spanned across the devices specified. Valid
 values are raid0, raid1, raid10 or single.
 .TP
+\fB\-f\fR, \fB\-\-force \fR
+Don't check if the device is already mounted.
+.TP
 \fB\-l\fR, \fB\-\-leafsize \fIsize\fR
 Specify the leaf size, the least data item in which btrfs stores data. The
 default value is the page size.
diff --git a/mkfs.c b/mkfs.c
index 2e99b95..21bcc7a 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -271,6 +271,7 @@ static void print_usage(void)
 	fprintf(stderr, "\t -A --alloc-start the offset to start the FS\n");
 	fprintf(stderr, "\t -b --byte-count total number of bytes in the FS\n");
 	fprintf(stderr, "\t -d --data data profile, raid0, raid1, raid10 or single\n");
+	fprintf(stderr, "\t -f --force don't check if a device is already mounted\n");
 	fprintf(stderr, "\t -l --leafsize size of btree leaves\n");
 	fprintf(stderr, "\t -L --label set a label\n");
 	fprintf(stderr, "\t -m --metadata metadata profile, values like data profile\n");
@@ -332,6 +333,7 @@ static struct option long_options[] = {
 	{ "sectorsize", 1, NULL, 's' },
 	{ "data", 1, NULL, 'd' },
 	{ "version", 0, NULL, 'V' },
+	{ "force", 0, NULL, 'f' },
 	{ 0, 0, 0, 0}
 };
 
@@ -358,10 +360,11 @@ int main(int ac, char **av)
 	int first_fd;
 	int ret;
 	int i;
+	int force=0;
 
 	while(1) {
 		int c;
-		c = getopt_long(ac, av, "A:b:l:n:s:m:d:L:V", long_options,
+		c = getopt_long(ac, av, "A:b:l:n:s:m:d:L:Vf", long_options,
 				&option_index);
 		if (c < 0)
 			break;
@@ -401,6 +404,9 @@ int main(int ac, char **av)
 			case 'V':
 				print_version();
 				break;
+			case 'f':
+				force=1;
+				break;
 			default:
 				print_usage();
 		}
@@ -423,13 +429,16 @@ int main(int ac, char **av)
 
 	file = av[optind++];
 	ret = check_mounted(file);
-	if (ret < 0) {
-		fprintf(stderr, "error checking %s mount status\n", file);
-		exit(1);
-	}
-	if (ret == 1) {
-		fprintf(stderr, "%s is mounted\n", file);
-		exit(1);
+	if(!force){
+		if (ret < 0) {
+			fprintf(stderr, "error checking %s mount status\n", 
+				file);
+			exit(1);
+		}
+		if (ret == 1) {	
+			fprintf(stderr, "%s is mounted\n", file);
+			exit(1);
+		}
 	}
 	ac--;
 	fd = open(file, O_RDWR);
@@ -479,15 +488,17 @@ int main(int ac, char **av)
 	zero_end = 1;
 	while(ac-- > 0) {
 		file = av[optind++];
-		ret = check_mounted(file);
-		if (ret < 0) {
-			fprintf(stderr, "error checking %s mount status\n",
-				file);
-			exit(1);
-		}
-		if (ret == 1) {
-			fprintf(stderr, "%s is mounted\n", file);
-			exit(1);
+		if(!force){
+			ret = check_mounted(file);
+			if (ret < 0) {
+				fprintf(stderr, "error checking %s"
+					" mount status\n",file);
+				exit(1);
+			}
+			if (ret == 1) {
+				fprintf(stderr, "%s is mounted\n", file);
+				exit(1);
+			}
 		}
 		fd = open(file, O_RDWR);
 		if (fd < 0) {

--------------040305090003080400010303
Content-Type: application/pgp-signature;
 name="mkfs.btrfs-force.diff.sig"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="mkfs.btrfs-force.diff.sig"

iD8DBQBNIh39vwTxYT3FBRIRAqd7AKCD1ORfaHMzMSAHw28Pf2u/Zo7XjgCfaJDibNfdthTo
s5HV3ogwc7UiJKY=
--------------040305090003080400010303--
