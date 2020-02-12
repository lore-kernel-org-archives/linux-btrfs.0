Return-Path: <SRS0=4+pS=4A=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB07BC2BA83
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Feb 2020 11:32:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6051C2073C
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Feb 2020 11:32:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="VrIkOZhu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbgBLLcs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Feb 2020 06:32:48 -0500
Received: from mail.synology.com ([211.23.38.101]:54730 "EHLO synology.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725874AbgBLLcs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Feb 2020 06:32:48 -0500
Received: from _ (localhost [127.0.0.1])
        by synology.com (Postfix) with ESMTPA id ED3A2DB18D89;
        Wed, 12 Feb 2020 19:32:45 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
        t=1581507166; bh=xo8bLUPSQKlReoaYq/8B6DCtYsDPN89ZqIOXXQBwA6M=;
        h=Date:From:To:Subject:In-Reply-To:References;
        b=VrIkOZhuC5Pdfw0evs0OuR58KPRf0Lpbmv0e/DPQcvU8bqPV6swIlbNttJxhw/wRS
         QNvdJ5N8QJdNMfZG9y1b+867LCu+gFkwH5dwQJlR/XLPo6ApRbur3oXv/p4IHLm29P
         noQorvOGWaACLfcdEvKJ/JR8ZZ9OECnwziT4TEAY=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Wed, 12 Feb 2020 19:32:45 +0800
From:   ethanwu <ethanwu@synology.com>
To:     dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        ethanwu <ethanwu@synology.com>,
        Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/4] btrfs: backref, only collect file extent items
 matching backref offset
In-Reply-To: <20200211182159.GD2902@twin.jikos.cz>
References: <20200207093818.23710-1-ethanwu@synology.com>
 <20200207093818.23710-2-ethanwu@synology.com>
 <0badf0be-d481-10fb-c23d-1b69b985e145@toxicpanda.com>
 <c0453c3eb7c9b4e56bd66dbe647c5f0a@synology.com>
 <20200210162927.GK2654@twin.jikos.cz>
 <5901b2be7358137e691b319cbad43111@synology.com>
 <aeb36a34-bc9c-8500-9f36-554729a078fc@gmx.com>
 <20200211182159.GD2902@twin.jikos.cz>
Message-ID: <c3b0f59840b81f4dd440264fb4276d9f@synology.com>
X-Sender: ethanwu@synology.com
User-Agent: Roundcube Webmail/1.1.2
X-Synology-MCP-Status: no
X-Synology-Spam-Flag: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Virus-Status: no
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

David Sterba 於 2020-02-12 02:21 寫到:
> On Tue, Feb 11, 2020 at 12:33:48PM +0800, Qu Wenruo wrote:
>> >> 39862272 have 30949376
>> >> [ 5949.328136] repair_io_failure: 22 callbacks suppressed
>> >> [ 5949.328139] BTRFS info (device vdb): read error corrected: ino 0
>> >> off 39862272 (dev /dev/vdd sector 19488)
>> >> [ 5949.333447] BTRFS info (device vdb): read error corrected: ino 0
>> >> off 39866368 (dev /dev/vdd sector 19496)
>> >> [ 5949.336875] BTRFS info (device vdb): read error corrected: ino 0
>> >> off 39870464 (dev /dev/vdd sector 19504)
>> >> [ 5949.340325] BTRFS info (device vdb): read error corrected: ino 0
>> >> off 39874560 (dev /dev/vdd sector 19512)
>> >> [ 5949.409934] BTRFS warning (device vdb): csum failed root -9 ino 257
>> >> off 2228224 csum
>> 
>> This looks like an existing bug, IIRC Zygo reported it before.
>> 
>> Btrfs balance just randomly failed at data reloc tree.
>> 
>> Thus I don't believe it's related to Ethan's patches.
> 
> Ok, than the patches make it more likely to happen, which could mean
> that faster backref processing hits some race window. As there could be
> more we should first fix the bug you say Zygo reported.

I added a log to check if find_parent_nodes is ever called under
test btrfs/125. It turns out that btrfs/125 doesn't pass through the
function. What my patches do is all under find_parent_nodes.
Therefore, I don't think my patch would make btrfs/125 more likely
to happen, at least it doesn't change the behavior of functions
btrfs/125 run through.

Is it easy to reproduce in your test environment?

Thanks,
ethanwu
