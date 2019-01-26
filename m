Return-Path: <SRS0=UsBE=QC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16BD5C282C7
	for <linux-btrfs@archiver.kernel.org>; Sat, 26 Jan 2019 12:07:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF9EC218A6
	for <linux-btrfs@archiver.kernel.org>; Sat, 26 Jan 2019 12:07:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dirtcellar.net header.i=@dirtcellar.net header.b="Ra1tM3of"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728701AbfAZMHo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 26 Jan 2019 07:07:44 -0500
Received: from smtp.domeneshop.no ([194.63.252.55]:55939 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbfAZMHo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 26 Jan 2019 07:07:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dirtcellar.net; s=ds201810;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Reply-To; bh=M2xR9O5tI/2F8XqZNg0LwOotUkmpgv25UpPxiQoVOe8=;
        b=Ra1tM3ofJ02EV8z9LEtrt2+gsE269tdlah9rKCqx422JCuP9Y3yD35HDGgURmFEubBxCUgj+GohNpVbvai4+mbL4pfTKvv2c2ZLkrQOTQp0TCmFjX4qtWLUL919WcbH4A5EbjkmT4Dn1tp+DwAyHA2n44s1qJVVjbwKNwCqmji6ZINDd6hFUy0mSaJEGgLC2hOBrLBRAVrJ5CorHEuNwTlJTXQi0meNG29lzVRAJlnw6f21aNmAFMyBozGs4NDTnt5NZz/BhehcS/3n75s8oNIyuBFXK1EQQw/yNfaaeYs59YYdPX67S9WGBPBWu/riIYK0Fo/g1syyXJUq+5z+qRQ==;
Received: from 0.79-161-197.customer.lyse.net ([79.161.197.0]:40615 helo=[10.0.0.10])
        by smtp.domeneshop.no with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <waxhead@dirtcellar.net>)
        id 1gnMkQ-0002uu-3S; Sat, 26 Jan 2019 13:07:42 +0100
Reply-To: waxhead@dirtcellar.net
Subject: Re: RAID56 Warning on "multiple serious data-loss bugs"
To:     DanglingPointer <danglingpointerexception@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <5d7f63b2-d340-7c3a-679b-26e97ac258a6@gmail.com>
From:   waxhead <waxhead@dirtcellar.net>
Message-ID: <f7f5d96f-2650-9162-02ef-c9200364c86a@dirtcellar.net>
Date:   Sat, 26 Jan 2019 13:07:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Firefox/52.0 SeaMonkey/2.49.4
MIME-Version: 1.0
In-Reply-To: <5d7f63b2-d340-7c3a-679b-26e97ac258a6@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

DanglingPointer wrote:
> 
> Hi All,
> 
> For clarity for the masses, what are the "multiple serious data-loss 
> bugs" as mentioned in the btrfs wiki?
> The bullet points on this page: 
> https://btrfs.wiki.kernel.org/index.php/RAID56
> don't enumerate the bugs.  Not even in a high level.  If anything what 
> can be closest to a bug or issue or "resilience use-case missing" would 
> be the first point on that page.
> 
> "Parity may be inconsistent after a crash (the "write hole"). The 
> problem born when after "an unclean shutdown" a disk failure happens. 
> But these are *two* distinct failures. These together break the BTRFS 
> raid5 redundancy. If you run a scrub process after "an unclean shutdown" 
> (with no disk failure in between) those data which match their checksum 
> can still be read out while the mismatched data are lost forever."
> 
> So in a nutshell; "What are the multiple serious data-loss bugs?" If 
> there aren't any, perhaps updating the wiki should be considered for 
> something less the "dramatic" .
> 
I would just like to add that according to the status page the only 
missing piece from a implementation point of view is the write hole.
https://btrfs.wiki.kernel.org/index.php/Status#RAID56

What effect exactly the write hole might have on *data* is not pointed 
out in detail, but I would imagine that for some it might be desirable 
to run a btrfs filesystem with metadata in "RAID" 1/10 mode and data in 
"RAID" 5/6.

As far as I can understand this would leave you in a position where your 
filesystem structures are relatively safe as "RAID" 1/10 mode is 
considered stable. e.g. you should not loose or corrupt your filesystem 
in the event of a crash / brownout. On the other hand you might loose or 
corrupt a file being written which may or may not be acceptable for 
some. In any case a scrub should fix any inconsistencies.

My point being that such a configuration might be (just?) as safe as for 
exampel mdraid 5/6 and in some cases perhaps even more thanks to 
checksumming and the self-heal features of btrfs.

Unless I am totally off I think it would be wise to add the metadata 
"RAID" 1/10 and data "RAID" 5/6 method to the wiki as a possible "no 
worse than any other XYZ solution" if you need storage and don't have 
that much metadata in your filesystem.
