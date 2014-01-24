Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32874 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752359AbaAXOvy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jan 2014 09:51:54 -0500
Message-ID: <52E27E02.7080606@fb.com>
Date: Fri, 24 Jan 2014 09:51:46 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix extent_from_logical to deal with skinny metadata
References: <1390511177-3395-1-git-send-email-jbacik@fb.com> <52E1BCDB.9060004@cn.fujitsu.com>
In-Reply-To: <52E1BCDB.9060004@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 01/23/2014 08:07 PM, Wang Shilong wrote:
> Hello Josef,
>
> I have sent a patch before to address this issue:
>       https://patchwork.kernel.org/patch/3472211/
>
> I introduced another function btrfs_previous_extent_item() to
> search previous extent item, I think you must miss my path before
> giving this patch ^_^.

I sure did, we'll take yours since it was first.  Thanks,

Josef
