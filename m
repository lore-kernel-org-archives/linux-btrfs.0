Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:50946 "EHLO smtp2-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728805AbeH2SE5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Aug 2018 14:04:57 -0400
Received: from mail.tol.fr (unknown [IPv6:2a01:e34:eeaf:c5f0:428d:5cff:fee6:854e])
        by smtp2-g21.free.fr (Postfix) with ESMTP id 8E4752003D6
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Aug 2018 16:07:49 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mail.tol.fr (Postfix) with ESMTP id 315EB9780521
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Aug 2018 16:07:49 +0200 (CEST)
Received: from mail.tol.fr ([127.0.0.1])
        by localhost (sos.couderc.eu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id j1VBytgIusNJ for <linux-btrfs@vger.kernel.org>;
        Wed, 29 Aug 2018 16:07:48 +0200 (CEST)
Received: from [192.168.163.11] (unknown [192.168.163.254])
        by mail.tol.fr (Postfix) with ESMTPSA id C05499780362
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Aug 2018 16:07:48 +0200 (CEST)
Subject: Re: How to erase a RAID1 ?
To: linux-btrfs@vger.kernel.org
References: <04e4b43f-b21e-b6fd-dfad-0506ff35aff7@couderc.eu>
 <52b06c19-c9e2-29c1-b761-98d770c2d6c7@gmx.com>
From: Pierre Couderc <pierre@couderc.eu>
Message-ID: <2e47e913-104e-8d0c-8d49-69518681147b@couderc.eu>
Date: Wed, 29 Aug 2018 16:07:48 +0200
MIME-Version: 1.0
In-Reply-To: <52b06c19-c9e2-29c1-b761-98d770c2d6c7@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/29/2018 02:52 PM, Qu Wenruo wrote:
>
> On 2018/8/29 下午8:49, Pierre Couderc wrote:
>> I want to reinstall a RAID1 btrfs system (wchis is now under debian
>> stretch, and will be reinstalled in stretch).
> If you still want to use btrfs, just umount the original fs, and
>
> # mkfs.btrfs -f <old devices>
>
>
The problem is to "unmount" the RAID1 system..

I have not found how to do that.

I have found a solution by reinstalling under debian, it now asks if 
need to reformat thez btrfs disk...
