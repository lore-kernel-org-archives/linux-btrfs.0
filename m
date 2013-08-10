Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758870Ab3HJWKQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 Aug 2013 18:10:16 -0400
Message-ID: <5206BA38.20903@redhat.com>
Date: Sat, 10 Aug 2013 17:10:00 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: anand jain <anand.jain@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: btrfs_rm_device() should zero mirror SB as
 well
References: <1374773376-29853-1-git-send-email-anand.jain@oracle.com> <1374773376-29853-2-git-send-email-anand.jain@oracle.com> <5205556E.8030902@redhat.com> <52059FC2.3080203@oracle.com>
In-Reply-To: <52059FC2.3080203@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/9/13 9:04 PM, anand jain wrote:
> 
> 
>>> btrfs fi show
>>> Label: none  uuid: e7aae9f0-1aa8-41f5-8fb6-d4d8f80cdb2c
>>>          Total devices 1 FS bytes used 28.00KiB
>>>          devid    2 size 2.00GiB used 0.00 path /dev/sdc   <-- WRONG
>>>          devid    1 size 2.00GiB used 20.00MiB path /dev/sdb
>>
>> Ok, now it's findable.  Isn't that exactly how this should behave?
>> What is wrong about this?
> 
>  Total devices is still 1.

Hm, so it is.  But that inconsistency indicates a bug
somewhere else, doesn't it?  (FWIW the above works for me,
w/ the right number of devices shown after removal...)

Anyway, I wonder if we've ever resolved the "when should we look
for backup superblocks?" question.  Because that would inform
decisions about when they should be read, when they must be zeroed, etc.

I thought the plan was that backup superblocks should not be
read unless we explicitly specify it via mount option or btrfs
commandline option.

If we must add code to zero all the superblocks on removal to fix
something that's still discovering them, that seems
to mean backups are still being automatically read.  Should they be?

What is the design intent for when backup SBs whould be used?
Maybe then I could better understand the reason for this change.

Thanks,
-Eric

>>> mount /dev/sdc /btrfs
>>> btrfs fi show --kernel
>>> Label: none  uuid: e7aae9f0-1aa8-41f5-8fb6-d4d8f80cdb2c mounted: /btrfs
>>>          Group profile: metadata: single  data: single
>>>          Total devices 1 FS bytes used 28.00KiB
>>>          devid    1 size 2.00GiB used 20.00MiB path /dev/sdb
>>
>> Oh good, you could bring it back after a potential administrative error,
>> using a recovery tool (btrfs-select-super)!  Isn't that a good thing?
> 
>  Note, here btrfs fi show used the new option --kernel
>  this does not show /dev/sdc though you use it mount.
>  Its all messed up.
> 
>  If user wants to bring back the intentionally deleted
>  disk, then they should rather call btrfs dev add, so
>  that it will take care of integrating the disk back
>  to the FS.
> 
>  recovery tools are for possible recovery from the
>  corruption, delete is not a corruption. Thats an
>  intentional step that user decided to take and the
>  undo for it is 'dev add'.
> 
>> IOWS: what does this change actually fix?
> 
>  Writes zeros to all copies of SB when disk is deleted
>  (before we used to just zero only the first copy).
>  In that way corruption is distinguished from the
>  deleted disk in a fair calculations.
> 
>  Otherwise allowing these things would cost us in terms
>  of support for the administrative error. Which we don't
>  have to encourage.
> 
> Thanks, Anand

