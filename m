Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36641 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751614AbaGYLrv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jul 2014 07:47:51 -0400
Message-ID: <53D243E1.9070607@fb.com>
Date: Fri, 25 Jul 2014 07:47:45 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: integration tree updated
References: <53D1B595.7070908@fb.com> <53D1BE15.1080000@cn.fujitsu.com>
In-Reply-To: <53D1BE15.1080000@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/24/2014 10:16 PM, Qu Wenruo wrote:
> Hi chris,
> 
> It seems that two of my wrong patches got merged in integration branch:
> 6068d17c8ab5bce946e9678ed2064e9f966cbe62 btrfs: Merge default subvolume
> mount codes into btrfs_mount_subvol().
> 8a2166332e332541f13b34b7248c0f14f575731e btrfs: Call mount_subtree()
> even 'subvolid=' mount option is given.
> 
> These two patches does not completely work, and the successor patch is
> under review.(the show_path one)
> 
> If it is OK for you, please remove these two patches.

Thanks! these are removed.

-chris
