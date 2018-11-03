Return-Path: <SRS0=HXCT=NO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99B34C32789
	for <linux-btrfs@archiver.kernel.org>; Sat,  3 Nov 2018 01:38:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 301B320831
	for <linux-btrfs@archiver.kernel.org>; Sat,  3 Nov 2018 01:38:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 301B320831
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728404AbeKCKsA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 3 Nov 2018 06:48:00 -0400
Received: from mailgw-02.dd24.net ([193.46.215.43]:58858 "EHLO
        mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728233AbeKCKr7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Nov 2018 06:47:59 -0400
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.27])
        by mailgw-02.dd24.net (Postfix) with ESMTP id 0AE2F5FF46;
        Sat,  3 Nov 2018 01:38:27 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at
        mailpolicy-02.live.igb.homer.key-systems.net
Received: from smtp.dd24.net ([192.168.1.36])
        by mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.25]) (amavisd-new, port 10236)
        with ESMTP id Uq_VsuD6mcjF; Sat,  3 Nov 2018 01:38:25 +0000 (UTC)
Received: from heisenberg.fritz.box (ppp-82-135-88-3.dynamic.mnet-online.de [82.135.88.3])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp.dd24.net (Postfix) with ESMTPSA;
        Sat,  3 Nov 2018 01:38:25 +0000 (UTC)
Message-ID: <5b35282669719fbfdea0a0076a45732ffb082561.camel@scientia.net>
Subject: Re: fsck lowmem mode only: ERROR: errors found in fs roots
From:   Christoph Anton Mitterer <calestyo@scientia.net>
To:     Su Yue <Damenly_Su@gmx.com>, Su Yue <suy.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date:   Sat, 03 Nov 2018 02:38:24 +0100
In-Reply-To: <a88d9b34-6a99-ce64-4794-8e25f590f50e@gmx.com>
References: <8d8c90d3edfcc9e73428d3730496d48b1160b39b.camel@scientia.net>
         <a141cad2-0a08-555e-eb05-da2dceb54025@cn.fujitsu.com>
         <7146cafcc48d46ad123388d492807cbba08e101c.camel@scientia.net>
         <94750beb-c339-756a-11ec-f2bcc72b98e3@cn.fujitsu.com>
         <e2ac3e05ddd1297d4017cbeecfa4b392b04613ad.camel@scientia.net>
         <04ccd53107bb11e08baaa8c1ec55b11b00133d3b.camel@scientia.net>
         <412fc97cf7979251b96c101c87e4ff171049a6dc.camel@scientia.net>
         <a88d9b34-6a99-ce64-4794-8e25f590f50e@gmx.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, 2018-11-03 at 09:34 +0800, Su Yue wrote:
> Sorry for the late reply cause I'm busy at other things.
No worries :-)


> I just looked through related codes and found the bug.
> The patches can fix it. So no need to do more tests.
> Thanks to your tests and patience. :)
Thanks for fixing :-)


Best wishes,
Chris.

