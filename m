Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17395 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab3COMCy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Mar 2013 08:02:54 -0400
Message-ID: <51430E10.5070807@oracle.com>
Date: Fri, 15 Mar 2013 20:03:28 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3 v4] btrfs-progs: disable using backup superblock by
 default
References: <1362756300-30212-1-git-send-email-anand.jain@oracle.com> <1363230357-7438-1-git-send-email-anand.jain@oracle.com> <1363230357-7438-4-git-send-email-anand.jain@oracle.com> <514153B0.7020100@redhat.com> <514190AA.2080405@oracle.com> <5141E31B.30407@redhat.com> <5141E36C.10905@redhat.com>
In-Reply-To: <5141E36C.10905@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



>>>> <maybe a little more commit log would be good?>
>>>>
>>>> So here is what confuses me now. :)
>>>>
>>>> *every* caller of btrfs_read_dev_super() is now called with
>>>> 0 for the flags variable, so it never reads the backup
>>>> under any circumstance.
>>>>
>>>> If it's always called w/ 0, what is the point of the argument?
>>>> Is there another patch you have planned that would use this argument
>>>> later?
>>>
>>>   Thanks for the review. yes true. as of now it (BTRFS_SCAN_BACKUP_SB)
>>>   only serves the purpose if in future should we need it.
>>>   purpose is something like a user initiated thread which
>>>   should to go to the backup-SB if primary-SB is not found ?.
>>>   Or I can drop BTRFS_SCAN_BACKUP_SB idea depending on how
>>>   it is convenient as a whole.
>>
>> See what others think, perhaps, but if nobody is using it, I think
>> it should just go away.  I'd call it "dead code." :)
>>
>> But I am surprised that none of the commands which accept alternate
>> superblock locations find their way into btrfs_read_dev_super() -
>> that seems odd to me.  Is it re-implemented or open-coded in other
>> places?
>
> So to be clearer, rather than removing the code right away, maybe
> it's worth a look to see if the other commands which *want* backup
> superblocks should be using this same code.  Then you'd have a reason
> for your new flag.  :)


  when non primary SB (sb_bytenr) is specified in btrfs_read_dev_super()
  (that is when user is involved)  it would directly fetch it. so its
  not a problem when we know which SB to read other than the primary SB.

  However when primary SB is specified it would look for only primary SB
  unless BTRFS_SCAN_BACKUP_SB flag is set (with the patch). Now, do we
  need this flag ? looks like Yes ! (sorry to change my opinion here
  though) and as below..

  In some cases when user is _not_ involved. Like in

  check_mounted().

  In a multi dev btrfs mounted fs. If by any chance the primary SB
  is corrupted then we would say the device is NOT mounted even
  if it is mounted.

eg:
# mkfs.btrfs /dev/sdb /dev/sdc -f && mount /dev/sdb /btrfs
# ./check-mounted /dev/sdc
its btrfs
/dev/sdc is currently mounted. Aborting.
# dd if=/dev/zero of=/dev/sdc count=8 seek=$(((64 * 1024)/512))
# ./check-mounted /dev/sdc
Not mounted
# cat /proc/mounts | egrep btrfs
/dev/sdb /btrfs btrfs rw,seclabel,relatime,noacl,space_cache 0 0


  So we have to set BTRFS_SCAN_BACKUP_SB for check_mounted()
  But the above scenario is not simple enough to be practical though.


-Anand
