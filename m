From: Jim <jim@webstarts.com>
Subject: btrfs won't mount
Date: Mon, 26 Sep 2011 22:52:47 -0400
Message-ID: <4E813A7F.8010805@webstarts.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Btrfs list,
I am testing btrfs on a (to me) large filesystem.  The tree consists of 
/data/sites/0000...0419/email.addr/files.
Within each of the 420 directories are 2562 directories each with 20 
files on average.  The files range from
small html files to larger (50 MB) videos.  These are currently stored 
on an ext3 filesystem and shared with nfs.
They will be moved to btrfs on 12 1TB drives raid0 drbd'd onto a similar 
slave.  I have tested the setup on a
smaller demo system and it worked perfectly.  I used scripts to create 
subvol at the email.addr level and was
going to rsync the files into these subvols.  I was running 2 instances 
of the script when it simply stopped.
Two btrfs subvol create processes were open and dead.  I tried to kill 
the processes to no avail.  I tried to
unmount btrfs also with no success.  I then rebooted the machine and 
although reboot was successful btrfs
would not mount.  I am assuming something got corrupted since I get the 
bad superblock error.  Will dump2fs
give me superblock info on a btrfs system.  If this is the case (or if I 
need a new btrfs command) how would
I use btrfs fsck to repair using an alternate superblock (btrfs fsck -b 
xxxxx /dev/sda).  Below is the error
message and output from tail dmesg and messages.  I will be happy to 
supply any other data necessary to help
me resolve this.  Thanks for any assistance.
Jim

Btrfs v0.19-91-g8b4c2a2
[root@btrfs ~]# mount /dev/sda /btrfs
mount: wrong fs type, bad option, bad superblock on /dev/sda,
        missing codepage or helper program, or other error
        In some cases useful info is found in syslog - try
        dmesg | tail  or so

[root@btrfs ~]# tail /var/log/dmesg
audit: name_count maxed, losing inode data: dev=00:06, inode=21524
audit: name_count maxed, losing inode data: dev=00:06, inode=21524
audit: name_count maxed, losing inode data: dev=00:06, inode=21524
audit: name_count maxed, losing inode data: dev=00:06, inode=6066
audit: name_count maxed, losing inode data: dev=00:06, inode=21529
audit: name_count maxed, losing inode data: dev=00:06, inode=21529
audit: name_count maxed, losing inode data: dev=00:06, inode=21529
audit: name_count maxed, losing inode data: dev=00:06, inode=21529
Btrfs loaded

Sep 26 18:04:02 btrfs kernel: device fsid 
0d06a739-ca45-4e3b-b652-e5c34d80afb9 devid 1 transid 1038915 /dev/sda
Sep 26 18:04:02 btrfs kernel: btrfs: failed to read the system array on sda
Sep 26 18:04:02 btrfs kernel: btrfs: open_ctree failed

