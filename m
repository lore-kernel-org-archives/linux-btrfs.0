Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502Ab3COQey (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Mar 2013 12:34:54 -0400
Message-ID: <51434DAC.9000206@redhat.com>
Date: Fri, 15 Mar 2013 11:34:52 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3 v4] btrfs-progs: disable using backup superblock by
 default
References: <1362756300-30212-1-git-send-email-anand.jain@oracle.com> <1363230357-7438-1-git-send-email-anand.jain@oracle.com> <1363230357-7438-4-git-send-email-anand.jain@oracle.com> <514153B0.7020100@redhat.com> <514190AA.2080405@oracle.com> <5141E31B.30407@redhat.com> <5141E36C.10905@redhat.com> <51430E10.5070807@oracle.com>
In-Reply-To: <51430E10.5070807@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 3/15/13 7:03 AM, Anand Jain wrote:
> 
> 
>>>>> <maybe a little more commit log would be good?>
>>>>>
>>>>> So here is what confuses me now. :)
>>>>>
>>>>> *every* caller of btrfs_read_dev_super() is now called with
>>>>> 0 for the flags variable, so it never reads the backup
>>>>> under any circumstance.
>>>>>
>>>>> If it's always called w/ 0, what is the point of the argument?
>>>>> Is there another patch you have planned that would use this argument
>>>>> later?
>>>>
>>>>   Thanks for the review. yes true. as of now it (BTRFS_SCAN_BACKUP_SB)
>>>>   only serves the purpose if in future should we need it.
>>>>   purpose is something like a user initiated thread which
>>>>   should to go to the backup-SB if primary-SB is not found ?.
>>>>   Or I can drop BTRFS_SCAN_BACKUP_SB idea depending on how
>>>>   it is convenient as a whole.
>>>
>>> See what others think, perhaps, but if nobody is using it, I think
>>> it should just go away.  I'd call it "dead code." :)
>>>
>>> But I am surprised that none of the commands which accept alternate
>>> superblock locations find their way into btrfs_read_dev_super() -
>>> that seems odd to me.  Is it re-implemented or open-coded in other
>>> places?
>>
>> So to be clearer, rather than removing the code right away, maybe
>> it's worth a look to see if the other commands which *want* backup
>> superblocks should be using this same code.  Then you'd have a reason
>> for your new flag.  :)
> 
> 
>  when non primary SB (sb_bytenr) is specified in btrfs_read_dev_super()
>  (that is when user is involved)  it would directly fetch it. so its
>  not a problem when we know which SB to read other than the primary SB.

Oh, right - I had forgotten that, I'm sorry.

So the behavior is:

if sb_bytenr is specified and it is not the first sb, read it and return
it on success.

Otherwise, read the first superblock and return it if it's ok.

If it's bad, and *if* your new flag is set, continue reading other
superblocks until a good one is found, or return failure if none are found.

Now that I think about it, that's a somewhat convoluted set of behaviors
for one function.

>  However when primary SB is specified it would look for only primary SB
>  unless BTRFS_SCAN_BACKUP_SB flag is set (with the patch). 

Right, ok.

> Now, do we
>  need this flag ? looks like Yes ! (sorry to change my opinion here
>  though) and as below..
> 
>  In some cases when user is _not_ involved. Like in
> 
>  check_mounted().
> 
>  In a multi dev btrfs mounted fs. If by any chance the primary SB
>  is corrupted then we would say the device is NOT mounted even
>  if it is mounted.
> 
> eg:
> # mkfs.btrfs /dev/sdb /dev/sdc -f && mount /dev/sdb /btrfs
> # ./check-mounted /dev/sdc
> its btrfs
> /dev/sdc is currently mounted. Aborting.
> # dd if=/dev/zero of=/dev/sdc count=8 seek=$(((64 * 1024)/512))
> # ./check-mounted /dev/sdc

what is "./check-mounted?"

> Not mounted
> # cat /proc/mounts | egrep btrfs
> /dev/sdb /btrfs btrfs rw,seclabel,relatime,noacl,space_cache 0 0
> 
> 
>  So we have to set BTRFS_SCAN_BACKUP_SB for check_mounted()
>  But the above scenario is not simple enough to be practical though.

(Seems like a mount check would be best implemented by asking the kernel
which devices are in use for mounted btrfs filesystems, rather than
scanning the block devices directly, but maybe that's a different issue.)

I guess I need to stop & think more carefully about this, it seems like
I am not seeing the whole picture.

The overall goal here is to not discover "btrfs" devices which actually
only have stale backup superblocks present, right?

The loop in btrfs_read_dev_super() might be ok for verifying backups,
but it should probably fail outright on the first bad one it finds,
or at least if the primary is bad; the user would be notified of the
inconsistency and could take corrective action w/ fsck or whatnot, right?

-Eric

> 
> -Anand

