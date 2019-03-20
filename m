Return-Path: <SRS0=xnYl=RX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC7D5C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 00:59:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B9F52175B
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 00:59:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbfCTA7c (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Mar 2019 20:59:32 -0400
Received: from mailgw-02.dd24.net ([193.46.215.43]:49758 "EHLO
        mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbfCTA7c (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Mar 2019 20:59:32 -0400
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.27])
        by mailgw-02.dd24.net (Postfix) with ESMTP id 6C2555FD14
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Mar 2019 00:59:30 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at
        mailpolicy-02.live.igb.homer.key-systems.net
Received: from smtp.dd24.net ([192.168.1.36])
        by mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.25]) (amavisd-new, port 10236)
        with ESMTP id l3yR-w0Y8xOZ for <linux-btrfs@vger.kernel.org>;
        Wed, 20 Mar 2019 00:59:28 +0000 (UTC)
Received: from heisenberg.fritz.box (ppp-82-135-82-31.dynamic.mnet-online.de [82.135.82.31])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp.dd24.net (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Mar 2019 00:59:28 +0000 (UTC)
Message-ID: <d35fa8de087c746f9affb789cf3ab599a3d042c1.camel@scientia.net>
Subject: Re: delayed_refs has NO entry / btrfs_update_root:136: Aborting
 unused transaction(No space left).
From:   Christoph Anton Mitterer <calestyo@scientia.net>
To:     linux-btrfs <linux-btrfs@vger.kernel.org>
Date:   Wed, 20 Mar 2019 01:59:26 +0100
In-Reply-To: <b2a668d7124f1d3e410367f587926f622b3f03a4.camel@scientia.net>
References: <b2a668d7124f1d3e410367f587926f622b3f03a4.camel@scientia.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Anything I should do with respect to this?

I.e. is further debug info needed for an interested developer? or can I
simply scrap that particular image (which is not an important one)?

Cheers,
Chris. 


On Sun, 2019-03-17 at 04:42 +0100, Christoph Anton Mitterer wrote:
> (resending,... seems this hasn't gotten through to the list, when
> I've
> sent it the first time)
> 
> 
> Hi.
> 
> On Debian's 4.19.28-2 kernel (which includes the recent read-
> corruption 
> on compression fix) the following happens:
> 
> As a consequence of the bug from the "Reproducer for "compressed data
> +
> hole data corruption bug, 2018 edition" still works on 4.20.7" mail
> thread I started (trying) to verify whether any of my data was
> affected.
> 
> Part of this was looking for files which actually are compressed by
> the
> two methods Zygo mentioned (compsize and filefrag -v).
> 
> For this I used two scripts like the attached ones (yes I know, bad
> performance) being fed by find path -type f -exec script {} \; .
> 
> 
> I've did this already on one of my disks, which I btrfs checked
> before
> (both normal and lowmem mode with no error), blockdev --setro'ed the
> device and mounted it ro.
> 
> The filefrag seems to cause all kinds of errors and call traces,
> giving
> the dmesg output attached.
> 
> 
> Any ideas what causes that?
> 
> 
> These days I unfortunately strongly loose trust in the stability and
> integrity of btrfs :-(
> 
> 
> Cheers,
> Chris.

