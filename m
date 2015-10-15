Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53153 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751103AbbJOBpX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Oct 2015 21:45:23 -0400
Date: Wed, 14 Oct 2015 21:45:15 -0400
From: Chris Mason <clm@fb.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PULL REQUEST][PATCH 0/2] Small fixes for 4.3 merge windows
Message-ID: <20151015014515.GG4890@ret.masoncoding.com>
References: <1444807573-29853-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1444807573-29853-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 14, 2015 at 03:26:11PM +0800, Qu Wenruo wrote:
> Hi Chris,
> 
> This pull is quite a small one, with 2 small and safe patches.
> 
> The first one is a fix that get missing in 4.2 merge windows.
> Just remove an empty header I created in qgroup rework.
> 
> The other one is found in qgroup reserve rework, but that's also very
> small and safe, with test case submitted:
> https://patchwork.kernel.org/patch/7292921/

Thanks Qu, I'll get these tested.

-chris
