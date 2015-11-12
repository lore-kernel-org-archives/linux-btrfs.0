Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:25119 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752216AbbKLBVr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Nov 2015 20:21:47 -0500
Date: Wed, 11 Nov 2015 20:21:33 -0500
From: Chris Mason <clm@fb.com>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
CC: "'btrfs'" <linux-btrfs@vger.kernel.org>
Subject: Re: [GIT PULL] Fujitsu for 4.4
Message-ID: <20151112012133.GF26661@ret.masoncoding.com>
References: <03be01d11ad9$3b385cf0$b1a916d0$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <03be01d11ad9$3b385cf0$b1a916d0$@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 09, 2015 at 06:27:26PM +0800, Zhao Lei wrote:
> Hi Chris,
> 
> This is collection of some bug fix and cleanup from fujitsu against btrfs in v4.3,
> the main patch is these 2:
>  Fix lost-data-profile caused by auto removing bg
>  Fix lost-data-profile caused by balance bg
> It can solve the problem of 'lost all data profile by balance and auto-remove-bg',
> discussed in btrfs maillist.
> 
> Plus some enhancement and cleanup in scrub.
> 
> Would you please consider merging the following fixes to integration-4.4 branch?

Thanks, I have these all queued up.  I verified the patches and
cherry-picked them, since Linus doesn't like to see github pulls, but I
do appreciate having them all in one place.

-chris
