Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16681 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbcEJIk6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 May 2016 04:40:58 -0400
Subject: Re: [PATCH] btrfs: switch to common message helpers in open_ctree,
 adjust messages
To: dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <1462786798-15247-1-git-send-email-dsterba@suse.com>
 <573148AB.6080800@oracle.com> <20160510074203.GP29353@twin.jikos.cz>
 <57319541.7000300@oracle.com> <20160510082120.GQ29353@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <57319E9A.8070003@oracle.com>
Date: Tue, 10 May 2016 16:40:58 +0800
MIME-Version: 1.0
In-Reply-To: <20160510082120.GQ29353@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/10/2016 04:21 PM, David Sterba wrote:
> On Tue, May 10, 2016 at 04:01:05PM +0800, Anand Jain wrote:
>>> In more detail:
>>>
>>> * introduce _btrfs_printk that takes a string pointer as 1st argument
>>>     (this could be used for messages before fs_info exists)
>>> * _btrfs_printk(NULL, ...) will be valid
>>> * then btrfs_printk(fs_info, ...) will become a wrapper
>>>     _btrfs_printk(btrfs_sb(fs_info)->s_id, ...)
>>> * _btrfs_err & others do not need to be introduced, we can use the
>>>     standard KERN_ERR
>>
>>    Does it mean logs when fs_info is not available won't have fsid ?
>
> Right, we don't have fsid until we read the superblock from disk
> (somewhere in open_ctree).

  Not only at open_ctree. We create fs_devices with fsid when 'btrfs dev
  scan' and we do populate btrfs_fs_devices->fsid this is well before
  open_ctree is called. OR open_ctree may not be called at all in some
  cases.

>>    Except for the logs in the context such as modload.. which does not
>>    involve a disk. Consistency in logging would help. Like fishing-out
>>    all logs related to a FSID.
>
> Yeah, this is probably related to your patches switching the messages to
> print fsid instead of device. Consistency is desirable of course, though
> we might need to make the output style configurable.

  If there is something that works simple, better. I am fine.

  Generally servers may have more than one fs mounted. So filter
  by fsid comes handy. Without worrying about when it was labeled,
  and troubleshooting scripts to fail.

Thanks, Anand
