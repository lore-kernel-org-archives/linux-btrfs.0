Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:49134 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750943AbeDEGdU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Apr 2018 02:33:20 -0400
Subject: Re: [PATCH] btrfs-progs: build: Do not use cp -a to install files
To: Peter Kjellerstedt <peter.kjellerstedt@axis.com>,
        linux-btrfs@vger.kernel.org
Cc: pkj@axis.com
References: <20180404140459.20644-1-pkj@axis.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <30cee140-7ffd-9461-2c4c-b26d11b6eb20@oracle.com>
Date: Thu, 5 Apr 2018 14:35:18 +0800
MIME-Version: 1.0
In-Reply-To: <20180404140459.20644-1-pkj@axis.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/04/2018 10:04 PM, Peter Kjellerstedt wrote:
> Using cp -a to install files will preserve the ownership of the
> original files (if possible), which is typically not wanted. E.g., if
> the files were built by a normal user, but are being installed by
> root, then the installed files would maintain the UIDs/GIDs of the
> user that built the files rather than be owned by root.

  Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand
