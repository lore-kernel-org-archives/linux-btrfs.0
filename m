Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22833 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751188AbdDCBEb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Apr 2017 21:04:31 -0400
Subject: Re: Is btrfs-convert able to deal with sparse files in a ext4
 filesystem?
To: Kai Herlemann <btrfs@linux.kai-herlemann.de>,
        <linux-btrfs@vger.kernel.org>
References: <CADN-S7MzE=6x25DK0XOPzfBGCEpTjdUSokBkuCPGhCvCURzLPg@mail.gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <fde235e9-ce7e-c44c-a62d-46b7c08d8c2b@cn.fujitsu.com>
Date: Mon, 3 Apr 2017 09:04:27 +0800
MIME-Version: 1.0
In-Reply-To: <CADN-S7MzE=6x25DK0XOPzfBGCEpTjdUSokBkuCPGhCvCURzLPg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 04/01/2017 05:48 PM, Kai Herlemann wrote:
> Hi,
> I have on my ext4 filesystem some sparse files, mostly images from
> ext4 filesystems.
> Is btrfs-convert (4.9.1) able to deal with sparse files or can that
> cause any problems?

AFAIK, btrfs convert can handle it well, not matter if it's sparse or not.

Secondly, it's strongly recommended to use latest btrfs-convert, which 
is 4.10.2.

Although the convert part is not changed in recent release, but the 
rollback part (which rolls converted btrfs back to ext*) under goes a 
large modification to co-operate with convert.

Without that modification, rollback is not functional, which is fine if 
you don't want to rollback to ext*, but just in case.

Thanks,
Qu

>
> Thanks in advance,
> Kai
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


