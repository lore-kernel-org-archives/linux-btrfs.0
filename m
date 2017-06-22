Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-33-i5.italiaonline.it ([212.48.25.234]:36788 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751064AbdFVFPZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Jun 2017 01:15:25 -0400
Reply-To: kreijack@inwind.it
Subject: Re: Exactly what is wrong with RAID5/6
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Chris Murphy <lists@colorremedies.com>, waxhead <waxhead@dirtcellar.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <1f5a4702-d264-51c6-aadd-d2cf521a45eb@dirtcellar.net>
 <60421001-5d74-2fb4-d916-7a397f246f20@cn.fujitsu.com>
 <CAJCQCtRM4L1DSbWU7okANdimoO6F-KgSV=y2KEovj0zMW7h6bA@mail.gmail.com>
 <1d88f12a-bd2a-9fff-cb53-da847f4526c7@cn.fujitsu.com>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <896c9f64-68ca-7112-2387-24028f4628c3@inwind.it>
Date: Thu, 22 Jun 2017 07:15:22 +0200
MIME-Version: 1.0
In-Reply-To: <1d88f12a-bd2a-9fff-cb53-da847f4526c7@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-06-22 04:12, Qu Wenruo wrote:
> 
> And in that case even device of data stripe 2 is missing, btrfs don't really need to use parity to rebuild it, as btrfs knows there is no extent in that stripe, and data csum matches for data stripe 1.

You are assuming that there is no data in disk2. This is likely, due to COW nature of BTRFS. But it is not always true. 

Anyway, the same problem happens if you are writing data on disk2 . If 
a) data (disk2) is written 
b) parity is not updated (due to a power failure)

until that you don't lose anything, but if

c) disk1 disappear 

you are not in position to recompute valid data in disk1 using only data2 and parity


> No need to use parity at all.
> 
> So that's why I think the hole write is not an urgent case to handle right now.
> 
> Thanks,
> Qu


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
