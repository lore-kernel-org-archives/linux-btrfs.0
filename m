Return-Path: <SRS0=+qyB=SO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAEC0C10F0E
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 13:35:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81DC92171F
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 13:35:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbfDLNfX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:35:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:46024 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726765AbfDLNfX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Apr 2019 09:35:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3791AAD51;
        Fri, 12 Apr 2019 13:35:21 +0000 (UTC)
Subject: Re: [PATCH 2/2] btrfs: reserve delalloc metadata differently
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org
References: <20190410195610.84110-1-josef@toxicpanda.com>
 <20190410195610.84110-3-josef@toxicpanda.com>
 <0098847c-71fb-b305-3f2a-392ce2737ed4@suse.com>
 <20190412132639.2be46k54avhiwlcb@macbook-pro-91.dhcp.thefacebook.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <50324bcb-a6c3-c287-3d89-fb8cc9fea3f4@suse.com>
Date:   Fri, 12 Apr 2019 16:35:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190412132639.2be46k54avhiwlcb@macbook-pro-91.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 12.04.19 г. 16:26 ч., Josef Bacik wrote:
> On Fri, Apr 12, 2019 at 04:06:25PM +0300, Nikolay Borisov wrote:
>>
>>
>> On 10.04.19 г. 22:56 ч., Josef Bacik wrote:
>>> With the per-inode block rsvs we started refilling the reserve based on
>>> the calculated size of the outstanding csum bytes and extents for the
>>> inode, including the amount we were adding with the new operation.
>>>
>>> However generic/224 exposed a problem with this approach.  With 1000
>>> files all writing at the same time we ended up with a bunch of bytes
>>> being reserved but unusable.
>>>
>>> When you write to a file we reserve space for the csum leaves for those
>>> bytes, the number of extent items required to cover those bytes, and a
>>> single credit for updating the inode at ordered extent finish for that
>>> range of bytes.  This is held until the ordered extent finishes and we
>>> release all of the reserved space.
>>>
>>> If a second write comes in at this point we would add a single
>>> reservation for the new outstanding extent and however many reservations
>>> for the csum leaves.  
>>
>> If a second write comes we won't do anything different than the first
>> i.e calculate the number of extent items + csums bytes required, add
>> them to the block reservation and call btrfs_inode_rsv_refill which
>> should refill the delta necessary for the 2nd write.
>>
>>
>> At this point we find the delta of how much we
>>> have reserved and how much outstanding size this is and attempt to
>>> reserve this delta.  If the first write finishes it will not release any
>>> space, because the space it had reserved for the initial write is still
>>> needed for the second write.  However some space would have been used,
>>
>> Each and every reservation is responsible for itself how come the first
>> one will know some of its space is required for the second, hence it
>> won't be released?
>>
> 
> Write 1 comes in, sets the size to 3mib, reserves 3mib.
> Write 2 comes in, sets the size to 5 mib, attempts to reserve 2mib.
>   - can't reserve because there's not enough space, starts flushing.
> Write 1 finishes, used 1mib of it's 3mib reservation
> Write 1 sets the size to 3mib
> We still have 2mib in reserves, which is less than 3mib, so no bytes are
>   released to the space info.
> 
> Now multiply this by 1000, you have 1000 files with 2mib sitting in their
> reservations, but they need 2mib, and there's no space to be squeezed from the
> rest of the fs, so they start to ENOSPC out one by one.
> 
> With the new thing we get this
> 
> Write 1 comes in, reserves 3mib, sets the size to 3mib.
> Write 2 comes in, attempts to reserve 3mib.
>   - can't reserve because there's not enough space, starts flushing.

Um, no, you've removed btrfs_inode_rsv_refill so there is no flushing
happening in btrfs_delalloc_reserve_metadata whatsoever. None of the 2
remaining callers of btrfs_delalloc_reserve_metadata does any flushing
based on the retval of that function.

This actually means that you should also remove the 'flush' variable in
the same function otherwise you are leaving unused variable behind,
which is not nice.

> Write 1 finishes, used 1mib of it's 3mib reservation
> Write 1 sets the size to 0mib

Reveweing the way oustanding_extents are used I'm getting a little bit
confused - on the one hand we are modifying this value when we reserve
metadata on the other hand we are also modifying the count when adding
ordered extents. Shouldn't that count have been already accounted when
doing the initial metadata reservation?

> Write 1 releases 2mib to the space_info, allowing the next waiter to claim 2mib
>   of whatever it's reservation was.
> 
> Multiply this by 1000.  As we get smaller and smaller amounts of metadata space
> to work with, we get less and less writes happening in parallel, because we only
> have X inodes worth of reservations to be in flight at any given time.  Thanks,
> 
> Josef
> 
