Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-01v.sys.comcast.net ([96.114.154.160]:34792 "EHLO
        resqmta-po-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751614AbdITQ7E (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Sep 2017 12:59:04 -0400
Subject: Re: WARNING: CPU: 3 PID: 439 at fs/btrfs/ctree.h:1559
 btrfs_update_device+0x1c5/0x1d0 [btrfs]
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Rich Rauenzahn <rrauenza@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAG+QAKXTRiC0s5pH_EQoz7Zd7nNfMC5++AN+EFgU6yY=3uvckw@mail.gmail.com>
 <69ee49ff-d2d6-bec9-055c-18697b71ec20@gmx.com>
 <1f8d39cd-a36a-6b4d-dea8-7a9acd9f9396@shroop.net>
 <a7334014-9f8e-55e0-83d1-0c14ce1522f6@gmx.com>
 <8df27746-487b-c5f2-59a0-8eb24b95571a@gmx.com>
 <eda7f67a-ee75-2536-96d6-27bd816c34f0@gmx.com>
From: Rich Rauenzahn <rich@shroop.net>
Message-ID: <417135a6-2cba-578b-e2a2-264f8cd53ce5@shroop.net>
Date: Wed, 20 Sep 2017 09:58:59 -0700
MIME-Version: 1.0
In-Reply-To: <eda7f67a-ee75-2536-96d6-27bd816c34f0@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 9/19/2017 10:39 PM, Qu Wenruo wrote:
>
> In v4.13 kernel, the newly added devices are in fact rounded down.
> But existing device doesn't get the round down.
>
> So it's recommended to resize (shrink) your fs for very small size to 
> fix it if you don't want to wait for the kernel fix.
>

What's the most direct way to do that?  (Was about to risk breaking the 
mirror and repartitioning!  I'd rather not!)

Hmm -- maybe this worked:

$ sudo btrfs filesystem resize -1m /.MEDIA/
Resize '/.MEDIA/' of '-1m'

> Thanks,
> Qu
>>>
>>> So I'm wondering if it's caused by added new btrfs device.
>>>

Possibly... I've added and removed disks to some of the btrfs fs's.
