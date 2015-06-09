Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45837 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751371AbbFINCV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Jun 2015 09:02:21 -0400
Message-ID: <5576E3D3.40008@fb.com>
Date: Tue, 9 Jun 2015 09:02:11 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Filipe Manana <fdmanana@suse.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [GIT PULL] Send fixes for 4.2
References: <1433301319-515-1-git-send-email-fdmanana@suse.com> <55769308.1070803@cn.fujitsu.com>
In-Reply-To: <55769308.1070803@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/09/2015 03:17 AM, Qu Wenruo wrote:
> Hi, Chris and Filipe.
> 
> Would you consider the patch from Filipe to be merged into 4.2?
> 
> [PATCH] Btrfs: avoid syncing log in the fast fsync path when not necessary
> 
> https://patchwork.kernel.org/patch/6138811/
> 
> 
> The performance regression is already in 4.1, and I really don't like to
> see the performance regression be there for 4.2.
> 
> So please consider include this patch in 4.2 merge window.

Thanks Qu, pulling this in now.

-chris

