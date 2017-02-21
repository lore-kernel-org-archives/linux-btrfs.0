Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33300 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750922AbdBUAwB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Feb 2017 19:52:01 -0500
Subject: Re: mount troubles after crash
To: Patrick Schmid <schmid@phys.ethz.ch>, <linux-btrfs@vger.kernel.org>
References: <756b50f6-5cd7-dd5c-f180-4f5347c7f8ee@phys.ethz.ch>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <bd53a4db-c07a-3fd5-55af-9ed2a5d17d61@cn.fujitsu.com>
Date: Tue, 21 Feb 2017 08:51:56 +0800
MIME-Version: 1.0
In-Reply-To: <756b50f6-5cd7-dd5c-f180-4f5347c7f8ee@phys.ethz.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 02/20/2017 10:13 PM, Patrick Schmid wrote:
> Hi togehter,
>
> during a balance run, the server crash. after the crash i got the
> attached error messages....
>
> Kernel: 4.9.11

A known bug when qgroup is enabled.
Fixed in v4.10-rcs.

Please mount using v4.10 kernels and it will mount without problem.

Thanks,
Qu

> Btrfs-Tools: v4.9.1
>
> btrfs check --repair failed with:
>
> couldn't open RDWR because of unsupported option features (3).
> Open ctree failed
>
>
> is there a way to fix this 140TB filesystem?
>
> Regards Patrick


