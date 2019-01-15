Return-Path: <SRS0=dEEl=PX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD78FC43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 12:28:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8278220657
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 12:28:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728795AbfAOM26 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 07:28:58 -0500
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:43679 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728671AbfAOM26 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 07:28:58 -0500
X-Originating-IP: 217.233.237.245
Received: from localhost (pD9E9EDF5.dip0.t-ipconnect.de [217.233.237.245])
        (Authenticated sender: leonard@lausen.nl)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id F09081BF20A;
        Tue, 15 Jan 2019 12:28:55 +0000 (UTC)
From:   Leonard Lausen <leonard@lausen.nl>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org
Subject: Re: BTRFS critical corrupt leaf bad key order
In-Reply-To: <338c02b6-4cbd-87fb-88ea-8165b41b9208@gmx.com>
References: <87d0oyw46b.fsf@lausen.nl> <ddda9d3e-7d63-755c-d421-0e3828059d78@gmx.com> <20190115120359.GG2900@twin.jikos.cz> <338c02b6-4cbd-87fb-88ea-8165b41b9208@gmx.com>
Date:   Tue, 15 Jan 2019 12:28:53 +0000
Message-ID: <87a7k2je9m.fsf@lausen.nl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


Thanks Qu and David for your prompt attention!

Qu Wenruo <quwenruo.btrfs@gmx.com> writes:
>> following tree-dumps:
>> 
>>   sudo btrfs inspect dump-tree -t root /dev/mapper/vg1-root > /tmp/btrfsdumproot
>>   sudo btrfs inspect dump-tree -b 1350630375424 /dev/mapper/vg1-root > /tmp/btrfsdump1350630375424
>> 
>> The root dump is at https://termbin.com/lz0l and the block dump at
>> https://termbin.com/oev5 . The number 1350630375424 does not occur in
>> the root dump. The root dump has 16715 lines, the block dump only 645.
>
> Super nice move, it shows the corruption and the cause.
>
> 	item 66 key (1714119835648 METADATA_ITEM 0) itemoff 13325 itemsize 33
> 	item 67 key (10510212874240 METADATA_ITEM 0) itemoff 13283 itemsize 42
> 	item 68 key (1714119868416 METADATA_ITEM 0) itemoff 13250 itemsize 33
>
> See the key objectid of key 67 is way larger than item 66/68.
>
> And furthermore, it indeed looks like a bit rot:
> 0x18f19810000 (1714119835648)
> 0x98f19814000 (10510212874240)
> 0x18f19818000 (1714119868416)
>
> See one bit got flipped.

Thanks for the explanation!

> I don't know it's corrupted in memory or on the SSD, although I tend to
> believe it's caused by memory bit flip.
> But anyway, it can be fixed by patching the corrupted leaf manually.
>
> I'm working on the fix.
> Please make sure there is no write into the fs (just in case, since the
> fs should be RO).
>
> And prepare a LiveUSB on which you could compile btrfs-progs (needs some
> dependency).
>
> It shouldn't take me too long time crafting the fix.

Thanks Qu! I see that ArchLinux LiveUSB is based on linux 4.20.0, but
4.20.1 contains some btrfs fixes. Should I make sure to be at least on
4.20.1 for this?

David Sterba <dsterba@suse.cz> writes:
> On Tue, Jan 15, 2019 at 07:48:47PM +0800, Qu Wenruo wrote:
>> See the key objectid of key 67 is way larger than item 66/68.
>> 
>> And furthermore, it indeed looks like a bit rot:
>> 0x18f19810000 (1714119835648)
>> 0x98f19814000 (10510212874240)
>> 0x18f19818000 (1714119868416)
>> 
>> See one bit got flipped.

>> I don't know it's corrupted in memory or on the SSD, although I tend to
>> believe it's caused by memory bit flip.
>
> Single bit flips are almost always caused by RAM, not storage (that
> fails in larger blocks or does not even return any data)
>> But anyway, it can be fixed by patching the corrupted leaf manually.
>
> That will fix one instance of the corrupted key, without an analysis how
> far the wrong key got spred it's still risky.

How could I analyse this?
