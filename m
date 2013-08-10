Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44341 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031731Ab3HJCE7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Aug 2013 22:04:59 -0400
Message-ID: <52059FC2.3080203@oracle.com>
Date: Sat, 10 Aug 2013 10:04:50 +0800
From: anand jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: btrfs_rm_device() should zero mirror SB as
 well
References: <1374773376-29853-1-git-send-email-anand.jain@oracle.com> <1374773376-29853-2-git-send-email-anand.jain@oracle.com> <5205556E.8030902@redhat.com>
In-Reply-To: <5205556E.8030902@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



>> btrfs fi show
>> Label: none  uuid: e7aae9f0-1aa8-41f5-8fb6-d4d8f80cdb2c
>>          Total devices 1 FS bytes used 28.00KiB
>>          devid    2 size 2.00GiB used 0.00 path /dev/sdc   <-- WRONG
>>          devid    1 size 2.00GiB used 20.00MiB path /dev/sdb
>
> Ok, now it's findable.  Isn't that exactly how this should behave?
> What is wrong about this?

  Total devices is still 1.

>> mount /dev/sdc /btrfs
>> btrfs fi show --kernel
>> Label: none  uuid: e7aae9f0-1aa8-41f5-8fb6-d4d8f80cdb2c mounted: /btrfs
>>          Group profile: metadata: single  data: single
>>          Total devices 1 FS bytes used 28.00KiB
>>          devid    1 size 2.00GiB used 20.00MiB path /dev/sdb
>
> Oh good, you could bring it back after a potential administrative error,
> using a recovery tool (btrfs-select-super)!  Isn't that a good thing?

  Note, here btrfs fi show used the new option --kernel
  this does not show /dev/sdc though you use it mount.
  Its all messed up.

  If user wants to bring back the intentionally deleted
  disk, then they should rather call btrfs dev add, so
  that it will take care of integrating the disk back
  to the FS.

  recovery tools are for possible recovery from the
  corruption, delete is not a corruption. Thats an
  intentional step that user decided to take and the
  undo for it is 'dev add'.

> IOWS: what does this change actually fix?

  Writes zeros to all copies of SB when disk is deleted
  (before we used to just zero only the first copy).
  In that way corruption is distinguished from the
  deleted disk in a fair calculations.

  Otherwise allowing these things would cost us in terms
  of support for the administrative error. Which we don't
  have to encourage.

Thanks, Anand
