Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18673C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 02:12:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AF1A20841
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 02:12:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nuclearwinter.com header.i=@nuclearwinter.com header.b="w5JSYwuO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7AF1A20841
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nuclearwinter.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbeJKJhk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 05:37:40 -0400
Received: from titan.nuclearwinter.com ([205.185.120.7]:56880 "EHLO
        titan.nuclearwinter.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbeJKJhj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 05:37:39 -0400
Received: from [IPv6:2601:6c5:8000:6b90:54ff:ba2b:b29:792c] ([IPv6:2601:6c5:8000:6b90:54ff:ba2b:b29:792c])
        (authenticated bits=0)
        by titan.nuclearwinter.com (8.14.7/8.14.7) with ESMTP id w9B2CPYT003486
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Wed, 10 Oct 2018 22:12:27 -0400
DKIM-Filter: OpenDKIM Filter v2.11.0 titan.nuclearwinter.com w9B2CPYT003486
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nuclearwinter.com;
        s=201211; t=1539223948;
        bh=zeMobw1Uhf9kN3KE+oU+4X1JyoRVrxPdVjDRvH8U5iQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=w5JSYwuOAYFixQAwPGcqliWMaVg0lRfhu3oiuSsjR8OawN2xOl/BmXiZ+pdvVcQc9
         MmxNZzi2D+TsBzC0a+5rreUYA4J8WUPPL4NNCoCgEJEQVbYbXEkidt23eQQWUkH0i7
         0hvwxENu7KR1ToACmO8s5DfsDhuuQB7tFwzbwR6o=
Subject: Re: Scrub aborts due to corrupt leaf
To:     Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>,
        Chris Murphy <lists@colorremedies.com>,
        =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Cc:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <3af15796-2629-ef87-21c9-2bb3c1366732@nuclearwinter.com>
 <3725e6f2-b1ed-8d3d-aec7-1518dad1cb03@gmx.com>
 <3bf7c73d-ce25-88ce-271f-ab8c9ae6c01d@nuclearwinter.com>
 <3d82a2b9-41da-26b8-9b74-71d17d8a8a76@gmx.com>
 <273c99b2-d7e0-bea3-a4a4-7337115beb6f@nuclearwinter.com>
 <0136878c-d4ae-37b0-4903-601367286cf7@nuclearwinter.com>
 <e84595a6-b1c4-0698-b5d3-251165a11412@gmx.com>
 <CAJCQCtR-j3c99KSpsnUuy5yn5Jx7NAYGXmiDfcrZt4yc8ghCEA@mail.gmail.com>
 <cd4ffeae-0b06-f8ae-1a4e-1165428daee2@gmx.com>
 <9c7290ea-668d-c10a-9328-91adfac14d5a@nuclearwinter.com>
 <dd08eb00-faf8-cd88-aeb6-e5ed75a2889f@nuclearwinter.com>
 <4652a690-26ed-fb90-9386-3020ee9e9841@applied-asynchrony.com>
 <CAJCQCtTV3a9rH6ystLCbLUVoh4b1LL5yXWiOBPp6Fa28efZf_w@mail.gmail.com>
 <35ccf3c1-c18d-cce9-23b8-d24a35fe5549@mendix.com>
From:   Larkin Lowrey <llowrey@nuclearwinter.com>
Message-ID: <9e6b268b-b545-bad1-f33a-b29ea1af7db0@nuclearwinter.com>
Date:   Wed, 10 Oct 2018 22:12:22 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <35ccf3c1-c18d-cce9-23b8-d24a35fe5549@mendix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.16 (titan.nuclearwinter.com [IPv6:2605:6400:20:950:ed61:983f:b93a:fc2b]); Wed, 10 Oct 2018 22:12:28 -0400 (EDT)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 10/10/2018 7:55 PM, Hans van Kranenburg wrote:
> On 10/10/2018 07:44 PM, Chris Murphy wrote:
>>
>> I'm pretty sure you have to umount, and then clear the space_cache
>> with 'btrfs check --clear-space-cache=v1' and then do a one time mount
>> with -o space_cache=v2.
> The --clear-space-cache=v1 is optional, but recommended, if you are
> someone who do not likes to keep accumulated cruft.
>
> The v2 mount (rw mount!!!) does not remove the v1 cache. If you just
> mount with v2, the v1 data keeps being there, doing nothing any more.

Theoretically I have the v2 space_cache enabled. After a clean umount...

# mount -onospace_cache /backups
[  391.243175] BTRFS info (device dm-3): disabling free space tree
[  391.249213] BTRFS error (device dm-3): cannot disable free space tree
[  391.255884] BTRFS error (device dm-3): open_ctree failed

# mount -ospace_cache=v1 /backups/
mount: /backups: wrong fs type, bad option, bad superblock on 
/dev/mapper/Cached-Backups, missing codepage or helper program, or other 
error
[  983.501874] BTRFS info (device dm-3): enabling disk space caching
[  983.508052] BTRFS error (device dm-3): cannot disable free space tree
[  983.514633] BTRFS error (device dm-3): open_ctree failed

# btrfs check --clear-space-cache v1 /dev/Cached/Backups
Opening filesystem to check...
couldn't open RDWR because of unsupported option features (3).
ERROR: cannot open file system

# btrfs --version
btrfs-progs v4.17.1

# mount /backups/
[ 1036.840637] BTRFS info (device dm-3): using free space tree
[ 1036.846272] BTRFS info (device dm-3): has skinny extents
[ 1036.999456] BTRFS info (device dm-3): bdev /dev/mapper/Cached-Backups 
errs: wr 0, rd 0, flush 0, corrupt 666, gen 25
[ 1043.025076] BTRFS info (device dm-3): enabling ssd optimizations

Backups will run tonight and will beat on the FS. Perhaps if something 
interesting happens I'll have more log data.

--Larkin
