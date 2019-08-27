Return-Path: <SRS0=Pg1I=WX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA026C3A59F
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Aug 2019 00:01:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B59972173E
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Aug 2019 00:01:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbfH0ABB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 20:01:01 -0400
Received: from mailgw-02.dd24.net ([193.46.215.43]:38010 "EHLO
        mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbfH0ABB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Aug 2019 20:01:01 -0400
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-01.live.igb.homer.key-systems.net [192.168.1.26])
        by mailgw-02.dd24.net (Postfix) with ESMTP id F3D7D5FD2C;
        Tue, 27 Aug 2019 00:00:59 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at
        mailpolicy-01.live.igb.homer.key-systems.net
Received: from smtp.dd24.net ([192.168.1.36])
        by mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-01.live.igb.homer.key-systems.net [192.168.1.25]) (amavisd-new, port 10236)
        with ESMTP id zvQLUd_NUpJD; Tue, 27 Aug 2019 00:00:58 +0000 (UTC)
Received: from heisenberg.fritz.box (ppp-46-244-241-26.dynamic.mnet-online.de [46.244.241.26])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp.dd24.net (Postfix) with ESMTPSA;
        Tue, 27 Aug 2019 00:00:57 +0000 (UTC)
Message-ID: <a8968a812e270a0dd80c4cf431a8437d3a7daba5.camel@scientia.net>
Subject: Re: Massive filesystem corruption since kernel 5.2 (ARCH)
From:   Christoph Anton Mitterer <calestyo@scientia.net>
To:     =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>,
        linux-btrfs@vger.kernel.org
Date:   Tue, 27 Aug 2019 02:00:55 +0200
In-Reply-To: <18d24f2f-4d33-10aa-5052-c358d4f7c328@petaramesh.org>
References: <11e4e889f903ddad682297c4420faeb0245414cf.camel@scientia.net>
         <18d24f2f-4d33-10aa-5052-c358d4f7c328@petaramesh.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hey.


On Sun, 2019-08-25 at 12:00 +0200, Swâmi Petaramesh wrote:
> I haven't seen any filesystem issue since, but I haven't used the
> system
> very much yet.

Hmm strange... so could it have been a hardware issue?

Cheers,
Chris.

