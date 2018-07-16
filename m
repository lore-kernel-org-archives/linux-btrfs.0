Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:49636 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727329AbeGPP0C (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jul 2018 11:26:02 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6GEs4Jk066800
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 14:58:13 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2k7a33vt0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 14:58:13 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w6GEwCZ2029340
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 14:58:12 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w6GEwC02021186
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 14:58:12 GMT
Subject: Re: [PATCH] btrfs: rename btrfs_parse_early_options
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
References: <20180716141807.18551-1-anand.jain@oracle.com>
Message-ID: <80318d04-43fb-71a4-8a0d-f0c254d9f128@oracle.com>
Date: Mon, 16 Jul 2018 23:01:37 +0800
MIME-Version: 1.0
In-Reply-To: <20180716141807.18551-1-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/16/2018 10:18 PM, Anand Jain wrote:
> Rename btrfs_parse_early_options() to btrfs_parse_device_options(). As
> btrfs_parse_early_options() parses the -o device options and scan the
> device provided. So this rename specifies its action. Also the function
> name is inline with btrfs_parse_subvol_options().
> No functional changes.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---

Forgot to mention: This should be applied on top of
   Gu Jinxiang (2):
   btrfs: make fs_devices to be a local variable
   btrfs: get device pointer from btrfs_scan_one_device

Thanks.
