From: Shane Meyers <shane@smugmug.com>
Subject: Verifying TRIM support on SSDs when using BtrFS
Date: Thu, 8 Sep 2011 17:24:35 -0700
Message-ID: <CANc=jovfdW5evaDGrtJaoGCEhLS8xrc7f93mwzEqxknisGetEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,

My company is considering using BtrFS for some of our production
systems, but before we can use it, I must positively verify that the
TRIM command is being issued to the SSDs. =A0I attempted to verify TRIM
first using examples that work for Ext4
<http://andyduffell.com/techblog/?p=3D852>, but I had to make changes t=
o
the procedure to work with BtrFS.

The server is Ubuntu 11.04 server 64-bit release (mkfs.btrfs version
0.19). I have installed the Linux 3.0.0 kernel as the BtrFS changelog
states that bulk TRIM is not available in the kernel shipped with
Ubuntu 11.04 (2.6.38).

My testing methodology:

* Manually TRIM the disks before starting: for i in {0..10} ; do let
A=3D"$i * 65536" ; hdparm --trim-sector-ranges $A:65535
--please-destroy-my-drive /dev/sda ; done
* Verify the drive was TRIM'd: ./sectors.pl |grep + | tee sectors-$(dat=
e +%s)
* Partition the drive: fdisk /dev/sda
* Make the file system: mkfs.btrfs /dev/sda1
* Mount: sudo mount -t btrfs -o ssd /dev/sda1 /mnt
* Create a file: dd if=3D/dev/urandom of=3D/mnt/testfile bs=3D1k count=3D=
50000
oflag=3Ddirect
* Verify the file is on the disk: ./sectors.pl | tee sectors-$(date +%s=
)
* Delete the test file: rm /mnt/testfile
* See that the test file is TRIM'd from the disk: ./sectors.pl | tee
sectors-$(date +%s)
* Verify the TRIM'd blocks: diff the two most recent sectors-* files

At this point, the pre-delete and post delete verifications still show
the same disk blocks in use. I should instead see a reduction in the
number of in use blocks. Waiting an hour (in case it takes a while for
the TRIM command to be issued) after the test file is deleted still
shows the same blocks in use.

I have also tried mounting with the "-o ssd,discard" options, but that
doesn't seem to help at all.

I also posted this question at
<http://serverfault.com/questions/307397/verify-trim-support-with-btrfs=
-on-ssd>
but a good answer has yet to surface.  If you are interested, you can
see my sectors.pl and a little more detail at that URL.

Is my testing methodology flawed?  Am I missing something here?
Thanks for your help.

-shane
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
