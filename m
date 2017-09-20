Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:62225 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751636AbdITX1M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Sep 2017 19:27:12 -0400
Subject: Re: RFC: Btrfs does not store checksum type? Only size? O_o
To: Timofey Titovets <nefelim4ag@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAGqmi76MPGYFiksk5Jt05wjhQoQXpQuu1CiJFhxQw8QEB0gPpw@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <28d9d0f8-11b7-29c8-e540-61f18f1aa9a7@gmx.com>
Date: Thu, 21 Sep 2017 07:27:04 +0800
MIME-Version: 1.0
In-Reply-To: <CAGqmi76MPGYFiksk5Jt05wjhQoQXpQuu1CiJFhxQw8QEB0gPpw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月21日 04:31, Timofey Titovets wrote:
> I was reading the kernel code and docs and didn't find anything about
> some info like "cheksum type" as btrfs have for compression code.
> (I only found some silent "hack" in btrfs-progs, that print "checksum
> type", but get "checksum size")

Checksum type is global, so one btrfs fs uses the same checksum type for 
all its meta and data.

So checksum type is in superblock. Check btrfs_super_block->csum_type.

> 
> If i understood all correctly btrfs only store checksum size, i.e. 4
> for current CRC32C.

Yes.

> 
> May be that can be useful to rewrite some part of code and reuse
> checksum size, as checksum type.
> 
> For backward compatibility current CRC32C size can be used for identify CRC32C.

Since we have superblock csum type, why introducing new one?
(Unless you're going to allow multi csum algorithm to co-exist in one 
btrfs fs)

Thanks,
Qu
> As that will not add any new checksum, that allow make that with zero "blood".
> And later if we add new checksum type, that possible to add compat
> flag for that.
> 
> What you think?
> 
> Thanks.
> 
