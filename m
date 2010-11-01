From: William Uther <willu.mailingLists@cse.unsw.edu.au>
Subject: Re: Can't remove missing drive
Date: Mon, 1 Nov 2010 11:36:40 +1100
Message-ID: <8ADD7A79-8133-4D40-B842-EB5691104905@cse.unsw.edu.au>
References: <096423C3-E94C-4969-95C8-42557AA41D0D@cse.unsw.edu.au> <4CCD04ED.1020009@xyzw.org>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CCD04ED.1020009@xyzw.org>
List-ID: <linux-btrfs.vger.kernel.org>

Thanks to Chris and Brian for the help!

On 31/10/2010, at 11:01 PM, Chris Mason wrote:

> 
> On Sat, Oct 30, 2010 at 06:37:06PM +1100, William Uther wrote:
>> [snip - issues removing a missing drive - see below for new log]
>> 
>> Is this actually a problem, or can I just keep running as is?  It seems to mount fine without -odegraded.
>> 
>> Any ideas how I can list the missing devices?  Any ideas on how I can remove the missing devices?
> 
> What have you tried so far?

Well, to remove the missing drive I've tried `btrfs-vol -r missing /data` and newer `btrfs` command.  I've previously tried with the system mounted in degraded mode.  The wiki, <https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices>, suggests that you should mount the new disk before removing the missing disk.

I've also tried removing the old device with `btrfs device delete /dev/loop0 /data` - i.e. giving the missing device explicitly.  Also, the 'missing' device, /dev/loop0, is there - just not connected to anything.  I thought that might be the issue so I moved it out of the way and tried to remove 'missing' again.  No change.

To list the missing devices I tried `btrfs filesystem show` - that shows 'some devices missing' but doesn't list them.  Interestingly, the new log below shows that `btrfs device delete missing` shows that `btrfs delete` doesn't think there are any devices missing.

> The general formula is:
> 
> mount -o degraded /dev/xxx /mnt (where xxx is one drive still in the
> array)
> 
> btrfs-vol -r missing /mnt
> 
> I'd suggest pulling the master branch of the unstable tree first, it has
> a fix for the btrfs-vol -r missing code.

Ok.  Is this kernel or tools or both?  I'll assume both.  I probably wont be able to get to that for a few days.

On 31/10/2010, at 4:55 PM, Brian Rogers wrote:

> The lack of a message on the delete operation indicates success. What you see is the expected behavior, since 'btrfs filesystem show' is reading the partitions directly. Therefore, it won't see any changes that haven't been committed to disk yet. The 'some devices missing' message should go away after running 'sync', or rebooting, or un-mounting the file system.

Thanks for the suggestion, but that doesn't seem to work.  I've tried rebooting multiple times.  The new log below might be more interesting - note that `btrfs device delete missing` claims that there is no missing device.

root@willvo:~# btrfs filesystem sync /data
FSSync '/data'
root@willvo:~# btrfs filesystem show
failed to read /dev/sr0
Label: none  uuid: f929c413-01c8-443f-b4f2-86f36702f519
	Total devices 3 FS bytes used 577.81GB
	devid    1 size 931.51GB used 604.00GB path /dev/sdb1
	devid    2 size 931.51GB used 604.00GB path /dev/sdc1
	*** Some devices missing

Btrfs Btrfs v0.19
root@willvo:~# btrfs device delete missing /data
root@willvo:~# tail -1 /var/log/syslog
Nov  1 11:20:39 willvo kernel: [175031.411348] btrfs: no missing devices found to remove
root@willvo:~# btrfs filesystem show
failed to read /dev/sr0
Label: none  uuid: f929c413-01c8-443f-b4f2-86f36702f519
	Total devices 3 FS bytes used 577.81GB
	devid    1 size 931.51GB used 604.00GB path /dev/sdb1
	devid    2 size 931.51GB used 604.00GB path /dev/sdc1
	*** Some devices missing

Btrfs Btrfs v0.19
root@willvo:~# btrfs filesystem sync /data
FSSync '/data'
root@willvo:~# btrfs filesystem show
failed to read /dev/sr0
Label: none  uuid: f929c413-01c8-443f-b4f2-86f36702f519
	Total devices 3 FS bytes used 577.81GB
	devid    1 size 931.51GB used 604.00GB path /dev/sdb1
	devid    2 size 931.51GB used 604.00GB path /dev/sdc1
	*** Some devices missing

Btrfs Btrfs v0.19

Cheers,

Will      :-}

