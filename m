Return-Path: <SRS0=Izu+=AR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E65B9C433DF
	for <linux-btrfs@archiver.kernel.org>; Mon,  6 Jul 2020 10:07:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD65420739
	for <linux-btrfs@archiver.kernel.org>; Mon,  6 Jul 2020 10:07:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="HTfqfw2g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbgGFKHO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 6 Jul 2020 06:07:14 -0400
Received: from mail.synology.com ([211.23.38.101]:45938 "EHLO synology.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728264AbgGFKHO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Jul 2020 06:07:14 -0400
Subject: Re: [PATCH] btrfs: speedup mount time with force readahead chunk tree
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
        t=1594030032; bh=Swn5q4leTSSMBbi6dgHqpx+++L8AGuHVAJ5GOZwdh4o=;
        h=Subject:To:References:From:Date:In-Reply-To;
        b=HTfqfw2gfIozHdFFq+fVD4ED0P4++fg3AoZY+RAkNdE1M+yTMnVIxCO/RKE2rMaB9
         stiEVoPjN/8bSuG1kxAgArAkPTF6M6AI1yS1886HwB+czL2+oo7WkxrlOyvT/C6xAT
         yfXvHVNu97uAHKjqV4ku6RGoJrLG0eiZsuEjD0o8=
To:     Nikolay Borisov <nborisov@suse.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <20200701092957.20870-1-robbieko@synology.com>
 <aeb651c8-0739-100b-90ad-9f36ecdc26e6@synology.com>
 <7da55a96-131c-b987-edfb-97375a940cd2@gmx.com>
 <375407fc-3c3c-6628-3e80-a5300a897e4e@synology.com>
 <497f7ba0-4efb-b1a2-79a1-62ed2621c743@gmx.com>
 <d46206f1-0f6e-1f28-347b-6feb46657e26@suse.com>
From:   Robbie Ko <robbieko@synology.com>
Message-ID: <49129199-a7a5-007b-f639-62adbe800148@synology.com>
Date:   Mon, 6 Jul 2020 18:07:12 +0800
MIME-Version: 1.0
In-Reply-To: <d46206f1-0f6e-1f28-347b-6feb46657e26@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Synology-MCP-Status: no
X-Synology-Spam-Flag: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Virus-Status: no
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


Nikolay Borisov 於 2020/7/6 下午4:37 寫道:
>
> On 6.07.20 г. 11:28 ч., Qu Wenruo wrote:
>>
>> On 2020/7/6 下午4:05, Robbie Ko wrote:
>>> I've known btrfs_read_block_groups for a long time,
>>>
>>> we can use BG_TREE freature to speed up btrfs_read_block_groups.
>>>
>>> https://lwn.net/Articles/801990/
>>>
>>>
>>> But reading the chunk tree also takes some time,
>>>
>>> we can speed up the chunk tree by using the readahead mechanism.
>>>
>>> Why we not just use regular forward readahead?
>>> - Because the regular forward readahead ,
>>>    reads only the logical address adjacent to the 64k,
>>>    but the logical address of the next leaf may not be in 64k.
>> Great, please add these into the changelog for the need of
>> READA_FORWARD_FORCE.
> <nod> Performance patches should come with data backing their
> performance improvements claims.

Ok, I will add these into the changelog.


>
>> But on the other hand, it looks like we could change READA_FORWARD
>> without introducing the _FORCE version,
>> as _FORCE variant is what we really want.
>>
>>
>> That logical bytenr limit looks not reasonable to me, which makes that
>> READA_FORWARD near useless to me.
>>
>> Although in that direction, we also need to verify all existing
>> READA_FORWARD are really correctly.
>>
>> Personally I tend to prefer change existing READA_FORWARD and review all
>> existing callers.
> I agree, we should ideally revise the existing READA_FORWARD and give it
> better semantics if the current ones are needlessly rigid. Only if this
> improves way too cumbersome i.e breaking assumption which are made
> should we introduce yet another mode. Because this other mode is really
> just special casing and we should avoid special cases as much as possible.


Ok, I'll modify the existing READA_FORWARD mechanism to make it better

and send a V2 patch.


>
>
> <snip>
