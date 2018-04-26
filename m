Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:40868 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753947AbeDZIJa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Apr 2018 04:09:30 -0400
Subject: Re: [PATCH] btrfs: remove unused fs_info parameter
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1524728942-14403-1-git-send-email-gujx@cn.fujitsu.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <d7a177ad-5cfb-9c8a-0688-5845213674ec@oracle.com>
Date: Thu, 26 Apr 2018 16:11:21 +0800
MIME-Version: 1.0
In-Reply-To: <1524728942-14403-1-git-send-email-gujx@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/26/2018 03:49 PM, Gu Jinxiang wrote:
> Since the commit below parameter fs_info in alloc_reloc_control
> be no used. So remove it.
> commit c6100a4b4e3d ("Btrfs: replace tree->mapping with
> tree->private_data")
> 
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>

Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand
