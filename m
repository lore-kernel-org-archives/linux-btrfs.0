From: William Uther <willu.mailingLists@cse.unsw.edu.au>
Subject: Can't remove missing drive
Date: Sat, 30 Oct 2010 18:37:06 +1100
Message-ID: <096423C3-E94C-4969-95C8-42557AA41D0D@cse.unsw.edu.au>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
  I have a raid1 setup with a missing device.  I have added a new device and everything seems to be working fine, except I cannot remove the old, missing, device.  There is no error - but the 'some devices missing' tag doesn't go away.

root@willvo:~# btrfs filesystem show
failed to read /dev/sr0
Label: none  uuid: f929c413-01c8-443f-b4f2-86f36702f519
    Total devices 3 FS bytes used 578.39GB
    devid    1 size 931.51GB used 604.00GB path /dev/sdb1
    devid    2 size 931.51GB used 604.00GB path /dev/sdc1
    *** Some devices missing

Btrfs Btrfs v0.19
root@willvo:~# btrfs device delete missing /data
root@willvo:~# btrfs filesystem show
failed to read /dev/sr0
Label: none  uuid: f929c413-01c8-443f-b4f2-86f36702f519
    Total devices 3 FS bytes used 578.39GB
    devid    1 size 931.51GB used 604.00GB path /dev/sdb1
    devid    2 size 931.51GB used 604.00GB path /dev/sdc1
    *** Some devices missing

Btrfs Btrfs v0.19

There are a number of sub-volumes of /data that are mounted in other locations.  I'm using kernel 2.6.36 (the lucid backport of the natty kernel) and similar btrfs-tools (lucid backport of natty tools).  Interestingly looking at the output of `dh -h`, it appears that the 'missing' devices are no longer being counted in the filesystem size - there is just a phantom 'missing' tag in btrfs-show.

Is this actually a problem, or can I just keep running as is?  It seems to mount fine without -odegraded.

Any ideas how I can list the missing devices?  Any ideas on how I can remove the missing devices?

Be well,

Will        :-}

