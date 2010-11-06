From: William Uther <willu.mailingLists@cse.unsw.edu.au>
Subject: Re: Can't remove missing drive
Date: Sat, 6 Nov 2010 18:11:20 +1100
Message-ID: <BF9D8F2E-F027-4E86-8F87-A2E085DE71A1@cse.unsw.edu.au>
References: <096423C3-E94C-4969-95C8-42557AA41D0D@cse.unsw.edu.au> <4CCD04ED.1020009@xyzw.org> <8ADD7A79-8133-4D40-B842-EB5691104905@cse.unsw.edu.au>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <8ADD7A79-8133-4D40-B842-EB5691104905@cse.unsw.edu.au>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

  I was trying to remove a 'missing' drive from a raid1 setup.  It was suggested on this list that I update to HEAD.  I updated my kernel to Ubuntu-lts-2.6.37-2.9, which appears to have the latest BTRFS code in it.  I then tried to remove my missing drive again:

root@willvo:~# btrfs filesystem show
failed to read /dev/sr0
Label: none  uuid: f929c413-01c8-443f-b4f2-86f36702f519
	Total devices 3 FS bytes used 594.71GB
	devid    1 size 931.51GB used 604.00GB path /dev/sdb1
	devid    2 size 931.51GB used 604.00GB path /dev/sdc1
	*** Some devices missing

Btrfs v0.19-36-gcbc979b-dirty
root@willvo:~# btrfs device delete missing /data
root@willvo:~# tail -1 /var/log/syslog
Nov  6 13:36:29 willvo kernel: [ 1227.711276] btrfs: no missing devices found to remove
root@willvo:~# btrfs filesystem show
failed to read /dev/sr0
Label: none  uuid: f929c413-01c8-443f-b4f2-86f36702f519
	Total devices 3 FS bytes used 594.71GB
	devid    1 size 931.51GB used 604.00GB path /dev/sdb1
	devid    2 size 931.51GB used 604.00GB path /dev/sdc1
	*** Some devices missing

Btrfs v0.19-36-gcbc979b-dirty

This is already strange as 'btrfs device delete' cannot find the missing device that 'btrfs filesystem show' knows about.  But then things get really strange...

root@willvo:~# btrfs filesystem df /data
Data, RAID0: total=1.18TB, used=596.74GB
System: total=4.00MB, used=96.00KB
Metadata, RAID0: total=2.00GB, used=993.35MB

Why is my filesystem suddenly showing RAID0?  Note that the used space displayed still seems to suggest raid 1.  Unfortunately I didn't notice the raid0 label right away, and did:

root@willvo:~# btrfs filesystem balance /data
root@willvo:~# btrfs filesystem show
failed to read /dev/sr0
Label: none  uuid: f929c413-01c8-443f-b4f2-86f36702f519
	Total devices 3 FS bytes used 594.71GB
	devid    1 size 931.51GB used 298.88GB path /dev/sdb1
	devid    2 size 931.51GB used 298.88GB path /dev/sdc1
	*** Some devices missing

Btrfs v0.19-36-gcbc979b-dirty
root@willvo:~# btrfs filesystem df /data
Data, RAID0: total=596.00GB, used=593.75GB
System: total=4.00MB, used=52.00KB
Metadata, RAID0: total=1.75GB, used=979.95MB

Which seems to have believed the spurious raid0 setting and converted my setup from raid1 to raid0 - albeit still with missing devices.

Is there any way to 'convert back' to raid1?  My reading suggests that feature isn't implemented yet - although I managed to magically convert from raid1 to raid0, so who knows.

Cheers,

Will      :-}

