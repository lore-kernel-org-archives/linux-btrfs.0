Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27095 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab3DJDEX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Apr 2013 23:04:23 -0400
Message-ID: <5164D6E8.9080104@oracle.com>
Date: Wed, 10 Apr 2013 11:05:12 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: make btrfs dev scan multi path aware
References: <1363867004-22912-1-git-send-email-anand.jain@oracle.com> <20130408152238.GE18193@twin.jikos.cz>
In-Reply-To: <20130408152238.GE18193@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 04/08/2013 11:22 PM, David Sterba wrote:
> On Thu, Mar 21, 2013 at 07:56:44PM +0800, Anand Jain wrote:
>>   We should avoid using non multi-path (mp) path for mp disks
>>   As of now there is no good way (like api) to check that.
>>   A workaround way is to check if the O_EXCL open is unsuccessful.
>>   This is safe since otherwise the BTRFS_IOC_SCAN_DEV ioctl would
>>   fail if the disk-path can not be opened with the flag O_EXCL set.
>
> Agreed. Alternatively we could try to parse the /sys entries.

  sorry to confuse you on this David. hope the below
  description will clarify..

  this patch actually combined two fixes - one as in the
  subject here, and the other a small fix which is to check if
  the kernel module is loaded.

  the later revised patch separated this into two patch-set
    - v6: access to backup superblock (dt: 04/05/13)
    - [PATCH 0/9] a bunch of miscellaneous bug fixes (dt: 04/05/13)

  in the above v6... as indicated I have dropped the
   [PATCH] btrfs-progs: make btrfs dev scan multi path aware
  since its found that when btrfs is mounted it would open
  the dev with O_EXCL as well, so we can't depend on this
  workaround.

  Further original problem related to the multi-path wasn't
  reproducible with my above two patch-sets applied (in the
  same order) on top integration-20130321 . IMO I lost the
  trigger as I don't think there is any fix related to
  multi path. If there is any good reproducible test-case
  related to multi-path I would dig further.

  The above patch set viz. "v6: access to backup superblock"
  and "[PATCH 0/9] a bunch of miscellaneous bug fixes" are
  important. They bring a lot of stability around the area
  of mkfs, btrfs fi show, btrfs dev scan.

Thanks, Anand

