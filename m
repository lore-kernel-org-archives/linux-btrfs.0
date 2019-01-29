Return-Path: <SRS0=91MX=QF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09DE4C169C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 19:55:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A034C2084C
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 19:55:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=libero.it header.i=@libero.it header.b="Al/2TE4h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729341AbfA2Tzc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 29 Jan 2019 14:55:32 -0500
Received: from smtp-32.italiaonline.it ([213.209.10.32]:40815 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726984AbfA2Tzc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Jan 2019 14:55:32 -0500
X-Greylist: delayed 488 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jan 2019 14:55:29 EST
Received: from venice.bhome ([94.38.145.70])
        by smtp-32.iol.local with ESMTPA
        id oZLqgOB5kMwWBoZLqg4F79; Tue, 29 Jan 2019 20:47:19 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2014;
        t=1548791239; bh=JJMolTMS8f1OyGF4DiebjbHo3W/psB6goX8nW2nV1u4=;
        h=Reply-To:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=Al/2TE4hgHg4fRH2RSCy2F6QWnjGWNbUACsww0AYbs6YFd+wDhjFEer4A4llJHZ29
         xK1oORxY0x1mhLQC62uVZht3dMIrjFrxSwfrUq4KrQL5K1SoDyXkQtuGiBihfvwyD3
         MtXzxzfKHTlepNPYOxKky0KF5baBavzUNveQK7VfeuyNcgGW1NHe8eTsz6XqXraM1V
         Wx4PXUPKdnaZBompQmubYHccZaJZjjUn6AAAPX2j0forgF4Qj4vIEq6vDP/Mb7Butl
         qJ6F0i662C8kcG0DDIovne0Klz10t44ozAUqv4kYE+j71WAtMOkDMsiJ6SnVMBkGFk
         JsfxVLnauEkZg==
X-CNFS-Analysis: v=2.3 cv=c6h6vi1l c=1 sm=1 tr=0
 a=iMf660l5wNhVPkRQRjbP0g==:117 a=iMf660l5wNhVPkRQRjbP0g==:17
 a=IkcTkHD0fZMA:10 a=4jqkTvAoAAAA:8 a=9r0XvWVT7kJZ7IYm-1MA:9 a=QEXdDO2ut3YA:10
 a=Hh_HAVYRK2TLt7S9I1XE:22
Reply-To: kreijack@inwind.it
Subject: Re: RAID56 Warning on "multiple serious data-loss bugs"
To:     Chris Murphy <lists@colorremedies.com>,
        Remi Gauvin <remi@georgianit.com>
Cc:     DanglingPointer <danglingpointerexception@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <5d7f63b2-d340-7c3a-679b-26e97ac258a6@gmail.com>
 <59a60289-1130-27b4-960b-9014fc8d68e8@gmx.com>
 <a18f2081-cf5d-d914-bb16-dba51c949c30@gmail.com>
 <36be9ca6-4aa0-f00a-c1b4-a59026a1909e@georgianit.com>
 <CAJCQCtQ=mGdZ+90uR68hwqFcZaNP8xQwKXkpO395xB+KBXRkxA@mail.gmail.com>
From:   Goffredo Baroncelli <kreijack@libero.it>
Openpgp: preference=signencrypt
Autocrypt: addr=kreijack@libero.it; keydata=
 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
Message-ID: <80f46e68-4cda-3a22-385b-0ab0a47b079a@libero.it>
Date:   Tue, 29 Jan 2019 20:47:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ=mGdZ+90uR68hwqFcZaNP8xQwKXkpO395xB+KBXRkxA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfC6+q3eRr9gs6dZpsMHbVyipec5v7gGbLh9RkUgMUWnLHQELRK5tfcprJAC8eRzOxwnl1xnzku3tYq0OZypn3MhUjfnMpDeecEkuQTNcktzD5TUbWmJ7
 c7rhsIOtVdKgzVGPxcyvlekCa9eKrocV1aGjsigV50yXqPe9cLcif0owBW/i2D97ADKtx2kuxbNVy9YA/lXF7NYGBjCi2bKkZz84kdOkTgA7/2osFwrJX2Eg
 OFDAkLuIWarzLoUyax5w89fnWsTp6mqvxYq+br7HnHIHrKOfrDotZmdyfAGz2yBY
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 29/01/2019 20.02, Chris Murphy wrote:
> On Mon, Jan 28, 2019 at 3:52 PM Remi Gauvin <remi@georgianit.com> wrote:
>>
>> On 2019-01-28 5:07 p.m., DanglingPointer wrote:
>>
>>> From Qu's statement and perspective, there's no difference to other
>>> non-BTRFS software RAID56's out there that are marked as stable (except
>>> ZFS).
>>> Also there are no "multiple serious data-loss bugs".
>>> Please do consider my proposal as it will decrease the amount of
>>> incorrect paranoia that exists in the community.
>>> As long as the Wiki properly mentions the current state with the options
>>> for mitigation; like backup power and perhaps RAID1 for metadata or
>>> anything else you believe as appropriate.
>>
>> Should implement some way to automatically scrub on unclean shutdown.
>> BTRFS is the only (to my knowlege) Raid implementation that will not
>> automatically detect an unclean shutdown and fix the affected parity
>> blocks, (either by some form of write journal/write intent map, or full
>> resync.)
> 
> There's no dirty bit set on mount, and thus no dirty bit to unset on
> clean mount, from which to infer a dirty unmount if it's present at
> the next mount.

It would be sufficient to use the log, which BTRFS already has. During each transaction, when an area is touched by a rwm cycle, it has to tracked in the log.
In case of unclean shutdown, it is already implemented a way to replay the log. So it would be sufficient to track a scrub of these area as "log replay".

Of course I am talking as not a BTRFS developers, so the reality could be more complex: e.g. I don't know how it would be easy to raise a scrub process on per area basis.

BR
G.Baroncelli



-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
