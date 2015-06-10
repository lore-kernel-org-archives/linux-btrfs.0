Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32933 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849AbbFJGiq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Jun 2015 02:38:46 -0400
Message-ID: <5577DB6E.8000301@oracle.com>
Date: Wed, 10 Jun 2015 14:38:38 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: rw-mount-problem after raid1-failure
References: <2227931.EqpnWnc32X@malu-aspire-v3-771>	<557790A9.3080705@oracle.com> <pan$cff9$37e01034$74a19930$1abaea06@cox.net>
In-Reply-To: <pan$cff9$37e01034$74a19930$1abaea06@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Ah thanks David. So its 2 disks RAID1.

Martin,

  disk pool error handle is primitive as of now. readonly is the only
  action it would take. rest of recovery action is manual. thats
  unacceptable in a data center solutions. I don't recommend btrfs VM
  productions yet. But we are working to get that to a complete VM.

  For now, for your pool recovery: pls try this.

     - After reboot.
     - modunload and modload (so that kernel devlist is empty)
     - mount -o degraded <good-disk> <-- this should work.
     - btrfs fi show -m <-- Should show missing if you don't let me know.
     - Do a replace of the missing disk without reading the source disk.

Good luck.

Thanks, Anand


On 06/10/2015 11:58 AM, Duncan wrote:
> Anand Jain posted on Wed, 10 Jun 2015 09:19:37 +0800 as excerpted:
>
>> On 06/09/2015 01:10 AM, Martin wrote:
>>> Hello!
>>>
>>> I have a raid1-btrfs-system (Kernel 3.19.0-18-generic, Ubuntu Vivid
>>> Vervet, btrfs-tools 3.17-1.1). One disk failed some days ago. I could
>>> remount the remaining one with "-o degraded". After one day and some
>>> write-operations (with no errrors) I had to reboot the system. And now
>>> I can not mount "rw" anymore, only "-o degraded,ro" is possible.
>>>
>>> In the kernel log I found BTRFS: too many missing devices, writeable
>>> mount is not allowed.
>>>
>>> I read about https://bugzilla.kernel.org/show_bug.cgi?id=60594 but I
>>> did no conversion to a single drive.
>>>
>>> How can I mount the disk "rw" to remove the "missing" drive and add a
>>> new one?
>>> Because there are many snapshots of the filesystem, copying the system
>>> would be only the last alternative ;-)
>>
>> How many disks you had in the RAID1. How many are failed ?
>
> The answer is (a bit indirectly) in what you quoted.  Repeating:
>
>>> One disk failed[.] I could remount the remaining one[.]
>
> So it was a two-device raid1, one failed device, one remaining, unfailed.
