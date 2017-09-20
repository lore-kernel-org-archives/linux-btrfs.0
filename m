Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-11v.sys.comcast.net ([96.114.154.170]:41610 "EHLO
        resqmta-po-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751307AbdITSLK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Sep 2017 14:11:10 -0400
Subject: Re: WARNING: CPU: 3 PID: 439 at fs/btrfs/ctree.h:1559
 btrfs_update_device+0x1c5/0x1d0 [btrfs]
From: Rich Rauenzahn <rich@shroop.net>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Rich Rauenzahn <rrauenza@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAG+QAKXTRiC0s5pH_EQoz7Zd7nNfMC5++AN+EFgU6yY=3uvckw@mail.gmail.com>
 <69ee49ff-d2d6-bec9-055c-18697b71ec20@gmx.com>
 <1f8d39cd-a36a-6b4d-dea8-7a9acd9f9396@shroop.net>
 <a7334014-9f8e-55e0-83d1-0c14ce1522f6@gmx.com>
 <8df27746-487b-c5f2-59a0-8eb24b95571a@gmx.com>
 <eda7f67a-ee75-2536-96d6-27bd816c34f0@gmx.com>
 <417135a6-2cba-578b-e2a2-264f8cd53ce5@shroop.net>
Message-ID: <c2161464-65e0-93b9-f118-2f3938deef00@shroop.net>
Date: Wed, 20 Sep 2017 11:10:57 -0700
MIME-Version: 1.0
In-Reply-To: <417135a6-2cba-578b-e2a2-264f8cd53ce5@shroop.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 9/20/2017 9:58 AM, Rich Rauenzahn wrote:
>
> What's the most direct way to do that?  (Was about to risk breaking 
> the mirror and repartitioning!  I'd rather not!)
>
> Hmm -- maybe this worked:
>
> $ sudo btrfs filesystem resize -1m /.MEDIA/
> Resize '/.MEDIA/' of '-1m'
No, doesn't seem to have worked.  I used btrfs fi show --raw /.MEDIA to 
see the size in bytes, and then ...

sudo btrfs filesystem resize N:SIZE /.MEDIA/

Where N was the disk number in the show output, and SIZE was the number 
of bytes to set it to that was a multiple of 4k.

Rich
