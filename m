From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: different st_dev's in one subvolume
Date: Thu, 2 Jun 2011 01:39:41 +0100
Message-ID: <20110602003941.GA4319@yahoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hiya,

please consider this:

~# truncate -s1G ./a
~# mkfs.btrfs ./a
~# sudo mount -o loop ./a /mnt/1
~# cd /mnt/1
/mnt/1# ls
/mnt/1# btrfs sub c A
Create subvolume './A'
/mnt/1# btrfs sub c A/B
Create subvolume 'A/B'
/mnt/1# touch A/inA A/B/inB
/mnt/1# btrfs sub snap A A.snap
Create a snapshot of 'A' in './A.snap'
/mnt/1# zmodload zsh/stat
/mnt/1# zstat +device ./**/*
. 25
A 26
A/B 27
A/B/inB 27
A/inA 26
A.snap 28
A.snap/B 23
A.snap/inA 28

Why does A.snap/B have a different st_dev from A.snap's?

Also:

/mnt/1# touch A.snap/B/foo
touch: cannot touch `A.snap/B/foo': Permission denied

I can rmdir that directory OK though.

Also note that the permissions are different:

/mnt/1# ll A
total 0
drwx------ 1 root root 6 Jun  2 00:54 B/
-rw-r--r-- 1 root root 0 Jun  2 00:54 inA
/mnt/1# ll A.snap
total 0
drwxr-xr-x 1 root root 0 Jun  2 01:29 B/
-rw-r--r-- 1 root root 0 Jun  2 00:54 inA

If I create another snap of A or A.snap, the "B" in there gets
the same st_dev (23).

/mnt/1# btrfs sub create A.snap/B/C
Create subvolume 'A.snap/B/C'
ERROR: cannot create subvolume
# btrfs sub snap A.snap/B B.snap
ERROR: 'A.snap/B' is not a subvolume

-- 
Stephane
