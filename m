Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54730 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757127AbcCURvR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 13:51:17 -0400
Date: Mon, 21 Mar 2016 13:51:07 -0400
From: Chris Mason <clm@fb.com>
To: <fdmanana@kernel.org>
CC: <linux-btrfs@vger.kernel.org>, <miklos@szeredi.hu>
Subject: Re: [PATCH] Btrfs: fix crash/invalid memory access on fsync when
 using overlayfs
Message-ID: <20160321175107.rseoedz5yw6ckb3q@floor.thefacebook.com>
References: <1458581924-18589-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1458581924-18589-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 21, 2016 at 05:38:44PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> If the lower or upper directory of an overlayfs mount belong to a btrfs
> file system and we fsync the file through the overlayfs' merged directory
> we ended up accessing an inode that didn't belong to btrfs as if it were
> a btrfs inode at btrfs_sync_file() resulting in a crash like the following:

Thanks Filipe, I'll put this in a second pull this week, even if its the
only patch in it ;)

-chris
