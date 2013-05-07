Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:8826 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab3EGGRP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 May 2013 02:17:15 -0400
Message-ID: <51889C68.2080806@jan-o-sch.net>
Date: Tue, 07 May 2013 08:17:12 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: dsterba@suse.cz, chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add ioctl to wait for qgroup rescan completion
References: <1367867657-4630-1-git-send-email-list.btrfs@jan-o-sch.net> <1367867657-4630-2-git-send-email-list.btrfs@jan-o-sch.net> <20130506212039.GD16456@twin.jikos.cz>
In-Reply-To: <20130506212039.GD16456@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 06, 2013 at 23:20 (+0200), David Sterba wrote:
> On Mon, May 06, 2013 at 09:14:17PM +0200, Jan Schmidt wrote:
>> --- a/include/uapi/linux/btrfs.h
>> +++ b/include/uapi/linux/btrfs.h
>> @@ -530,6 +530,7 @@ struct btrfs_ioctl_send_args {
>>  			       struct btrfs_ioctl_quota_rescan_args)
>>  #define BTRFS_IOC_QUOTA_RESCAN_STATUS _IOR(BTRFS_IOCTL_MAGIC, 45, \
>>  			       struct btrfs_ioctl_quota_rescan_args)
>> +#define BTRFS_IOC_QUOTA_RESCAN_WAIT _IO(BTRFS_IOCTL_MAGIC, 46)
> 
> Why do you need an ioctl when the same can be achieved by polling the
> RESCAN_STATUS value ? The code does not anything special that has to be
> done within kernel.

It's because I don't like polling :-) A rescan can take hours to complete, and
you wouldn't like to see one ioctl per second for such a period either, I guess.
(Plus: Everybody would lose like .9 seconds for each run of the xfstest I'm
writing - accumulates to ages at least!)

If you're worried about ioctl numbers, we could turn it into flags for
BTRFS_IOC_QUOTA_RESCAN, but I don't see we're short on ioctl numbers yet. The
reason why I chose a separate ioctl is that it is more like an attach operation
to support both, specifying it when starting a fresh scan and waiting for a scan
that's already running. I find it more intuitive to have it separate.

-Jan
