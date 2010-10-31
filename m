From: Brian Rogers <brian@xyzw.org>
Subject: Re: Can't remove missing drive
Date: Sat, 30 Oct 2010 22:55:57 -0700
Message-ID: <4CCD04ED.1020009@xyzw.org>
References: <096423C3-E94C-4969-95C8-42557AA41D0D@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: William Uther <willu.mailingLists@cse.unsw.edu.au>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <096423C3-E94C-4969-95C8-42557AA41D0D@cse.unsw.edu.au>
List-ID: <linux-btrfs.vger.kernel.org>

On 10/30/2010 12:37 AM, William Uther wrote:
> Hi,
>    I have a raid1 setup with a missing device.  I have added a new device and everything seems to be working fine, except I cannot remove the old, missing, device.  There is no error - but the 'some devices missing' tag doesn't go away.
>
> root@willvo:~# btrfs filesystem show
> failed to read /dev/sr0
> Label: none  uuid: f929c413-01c8-443f-b4f2-86f36702f519
>      Total devices 3 FS bytes used 578.39GB
>      devid    1 size 931.51GB used 604.00GB path /dev/sdb1
>      devid    2 size 931.51GB used 604.00GB path /dev/sdc1
>      *** Some devices missing
>
> Btrfs Btrfs v0.19
> root@willvo:~# btrfs device delete missing /data
> root@willvo:~# btrfs filesystem show
> failed to read /dev/sr0
> Label: none  uuid: f929c413-01c8-443f-b4f2-86f36702f519
>      Total devices 3 FS bytes used 578.39GB
>      devid    1 size 931.51GB used 604.00GB path /dev/sdb1
>      devid    2 size 931.51GB used 604.00GB path /dev/sdc1
>      *** Some devices missing
>
> Btrfs Btrfs v0.19

The lack of a message on the delete operation indicates success. What 
you see is the expected behavior, since 'btrfs filesystem show' is 
reading the partitions directly. Therefore, it won't see any changes 
that haven't been committed to disk yet. The 'some devices missing' 
message should go away after running 'sync', or rebooting, or 
un-mounting the file system.

