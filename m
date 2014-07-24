Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17907 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751174AbaGXV2r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jul 2014 17:28:47 -0400
Message-ID: <53D17A88.5090905@fb.com>
Date: Thu, 24 Jul 2014 17:28:40 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH RFC] btrfs: Use backup superblocks if and only if the
 first superblock is valid but corrupted.
References: <1403841234-10393-1-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1403841234-10393-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/26/2014 11:53 PM, Qu Wenruo wrote:
> Current btrfs will only use the first superblock, making the backup
> superblocks only useful for 'btrfs rescue super' command.
> 
> The old problem is that if we use backup superblocks when the first
> superblock is not valid, we will be able to mount a none btrfs
> filesystem, which used to contains btrfs but other fs is made on it.
> 
> The old problem can be solved related easily by checking the first
> superblock in a special way:
> 1) If the magic number in the first superblock does not match:
>    This filesystem is not btrfs anymore, just exit.
>    If end-user consider it's really btrfs, then old 'btrfs rescue super'
>    method is still available.
> 
> 2) If the magic number in the first superblock matches but checksum does
>    not match:
>    This filesystem is btrfs but first superblock is corrupted, use
>    backup roots. Just continue searching remaining superblocks.

I do agree that in these cases we can trust that the backup superblock
comes from the same filesystem.

But, for right now I'd prefer the admin get involved in using the backup
supers.  I think silently using the backups is going to lead to surprises.

Thanks!

-chris
