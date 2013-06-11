Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43188 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab3FKNPl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Jun 2013 09:15:41 -0400
Message-ID: <51B72301.7040103@oracle.com>
Date: Tue, 11 Jun 2013 21:15:45 +0800
From: anand jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/9] btrfs-progs: btrfs_scan_for_fsid doesn't need all
 the arguments
References: <1370876190-16520-1-git-send-email-anand.jain@oracle.com> <1370876190-16520-2-git-send-email-anand.jain@oracle.com> <51B63050.9080808@redhat.com>
In-Reply-To: <51B63050.9080808@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




On 06/11/2013 04:00 AM, Eric Sandeen wrote:
> On 6/10/13 9:56 AM, Anand Jain wrote:
>> btrfs_scan_for_fsid uses only one argument run_ioctl out of 3
>> so remove the rest two of them
>
> and run_ioctl is only ever '1' (and it's completely unobvious
> at the call point what '1' means).

There was this below patch for it. It was defined
as BTRFS_SCAN_REGISTER here.

   subject: v6: access to backup superblock

I need to rebase this patch though.

> Why not just go with 0 args?

> Then only btrfs_scan_one_dir and btrfs_scan_block_devices
> will have a non-obvious 0/1 arg.... :(
>
> -Eric

btrfs_scan_for_fsid as such needs a revamp so that
it will use kernel-probes if device is mounted, so
as of now I would like to keep it as it is.

Thanks for the comments.

Anand

