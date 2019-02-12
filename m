Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43B28C282CA
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 15:33:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E6ED217FA
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 15:33:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729066AbfBLPdI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Feb 2019 10:33:08 -0500
Received: from mailgw-02.dd24.net ([193.46.215.43]:55517 "EHLO
        mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728347AbfBLPdI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Feb 2019 10:33:08 -0500
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.27])
        by mailgw-02.dd24.net (Postfix) with ESMTP id 5FA5F5FE3C
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2019 15:33:06 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at
        mailpolicy-02.live.igb.homer.key-systems.net
Received: from smtp.dd24.net ([192.168.1.36])
        by mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.25]) (amavisd-new, port 10236)
        with ESMTP id MLPbYHZdWA_y for <linux-btrfs@vger.kernel.org>;
        Tue, 12 Feb 2019 15:33:01 +0000 (UTC)
Received: from heisenberg.fritz.box (ppp-82-135-82-31.dynamic.mnet-online.de [82.135.82.31])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp.dd24.net (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2019 15:33:00 +0000 (UTC)
Message-ID: <f9dd5e63917604f3f137154d744c4f13f40f5c3a.camel@scientia.net>
Subject: Re: Reproducer for "compressed data + hole data corruption bug,
 2018 edition" still works on 4.20.7
From:   Christoph Anton Mitterer <calestyo@scientia.net>
To:     linux-btrfs@vger.kernel.org
Date:   Tue, 12 Feb 2019 16:33:00 +0100
In-Reply-To: <20190212030838.GB9995@hungrycats.org>
References: <20180823031125.GE13528@hungrycats.org>
         <20190212030838.GB9995@hungrycats.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hey.

Sounds like a highly severe (and long standing) bug?

Is anyone doing anything about it?


Cheers,
Chris.

