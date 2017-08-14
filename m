Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:58887 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750950AbdHNGhP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Aug 2017 02:37:15 -0400
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
To: Christoph Hellwig <hch@infradead.org>,
        Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <84806456-eed9-00b9-b3f6-99e46cefba33@swiftspirit.co.za>
 <4c094049-f8c8-a0ea-674b-33c6905d744a@gmx.com>
 <CAJCQCtRGUBWD6Mw6pAiKGAPgGz+vqy3sgmbEBDETPYsxJw8G7w@mail.gmail.com>
 <b14a36dd-fcab-a38b-cbf9-adbd096da3a3@gmx.com>
 <1502496618.6092.6.camel@scientia.net> <20170812074248.GA3352@infradead.org>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <e560ba2d-ad11-abe6-bb3a-788d7b5a7562@gmx.com>
Date: Mon, 14 Aug 2017 14:36:34 +0800
MIME-Version: 1.0
In-Reply-To: <20170812074248.GA3352@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年08月12日 15:42, Christoph Hellwig wrote:
> On Sat, Aug 12, 2017 at 02:10:18AM +0200, Christoph Anton Mitterer wrote:
>> Qu Wenruo wrote:
>>> Although Btrfs can disable data CoW, nodatacow also disables data
>>> checksum, which is another main feature for btrfs.
>>
>> Then decoupling of the two should probably decoupled and support for
>> notdatacow+checksumming be implemented?!
> 
> And how are you going to write your data and checksum atomically when
> doing in-place updates?

Exactly, that's the main reason I can figure out why btrfs disables 
checksum for nodatacow.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
