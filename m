Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:58749 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751547AbdITXTu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Sep 2017 19:19:50 -0400
Subject: Re: WARNING: CPU: 3 PID: 439 at fs/btrfs/ctree.h:1559
 btrfs_update_device+0x1c5/0x1d0 [btrfs]
To: Rich Rauenzahn <rich@shroop.net>, Rich Rauenzahn <rrauenza@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAG+QAKXTRiC0s5pH_EQoz7Zd7nNfMC5++AN+EFgU6yY=3uvckw@mail.gmail.com>
 <69ee49ff-d2d6-bec9-055c-18697b71ec20@gmx.com>
 <1f8d39cd-a36a-6b4d-dea8-7a9acd9f9396@shroop.net>
 <a7334014-9f8e-55e0-83d1-0c14ce1522f6@gmx.com>
 <8df27746-487b-c5f2-59a0-8eb24b95571a@gmx.com>
 <eda7f67a-ee75-2536-96d6-27bd816c34f0@gmx.com>
 <417135a6-2cba-578b-e2a2-264f8cd53ce5@shroop.net>
 <c2161464-65e0-93b9-f118-2f3938deef00@shroop.net>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <b45b34b5-1dc5-deda-6725-6e281d0e343c@gmx.com>
Date: Thu, 21 Sep 2017 07:19:39 +0800
MIME-Version: 1.0
In-Reply-To: <c2161464-65e0-93b9-f118-2f3938deef00@shroop.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月21日 02:10, Rich Rauenzahn wrote:
> 
> On 9/20/2017 9:58 AM, Rich Rauenzahn wrote:
>>
>> What's the most direct way to do that?  (Was about to risk breaking 
>> the mirror and repartitioning!  I'd rather not!)
>>
>> Hmm -- maybe this worked:
>>
>> $ sudo btrfs filesystem resize -1m /.MEDIA/
>> Resize '/.MEDIA/' of '-1m'
> No, doesn't seem to have worked.  I used btrfs fi show --raw /.MEDIA to 
> see the size in bytes, and then ...
> 
> sudo btrfs filesystem resize N:SIZE /.MEDIA/
> 

Yes, this is what I did to my fs.
While in fact you can do it better by using:

btrfs fi resize N:max <path>

Or

btrfs fi resize N:-1 <path>

The first one will resize the devid N to its max size.
The 2nd one will resize the devid N to current size - 1 (byte).

Both will go through shrink routine, which will do the round_down.

Thanks,
Qu

> Where N was the disk number in the show output, and SIZE was the number 
> of bytes to set it to that was a multiple of 4k.
> 
> Rich
