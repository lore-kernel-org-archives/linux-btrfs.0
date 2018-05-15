Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:38610 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752188AbeEOISH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 May 2018 04:18:07 -0400
Subject: Re: [PATCH] btrfs: property: Set incompat flag of lzo/zstd
 compression
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <cover.1526370458.git.misono.tomohiro@jp.fujitsu.com>
 <35713081-318c-8bca-22bc-8b9c4894c0d8@jp.fujitsu.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <4ebea14c-15f4-3845-f5c8-ca9c46268da5@oracle.com>
Date: Tue, 15 May 2018 16:20:32 +0800
MIME-Version: 1.0
In-Reply-To: <35713081-318c-8bca-22bc-8b9c4894c0d8@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/15/2018 03:51 PM, Misono Tomohiro wrote:
> Incompat flag of lzo/zstd compression should be set at:
>   1. mount time (-o compress/compress-force)
>   2. when defrag is done
>   3. when property is set
> 
> Currently 3. is missing and this commit adds this.
> 
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>

Reviewed-by: Anand Jain <anand.jain@oracle.com>
