Return-Path: <SRS0=W6bw=RH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE906C43381
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Mar 2019 15:46:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7B03206B8
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Mar 2019 15:46:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbfCDPqG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 Mar 2019 10:46:06 -0500
Received: from mailgw-01.dd24.net ([193.46.215.41]:37685 "EHLO
        mailgw-01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfCDPqG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Mar 2019 10:46:06 -0500
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.27])
        by mailgw-01.dd24.net (Postfix) with ESMTP id 72E415FFAA;
        Mon,  4 Mar 2019 15:46:04 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at
        mailpolicy-02.live.igb.homer.key-systems.net
Received: from smtp.dd24.net ([192.168.1.35])
        by mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.25]) (amavisd-new, port 10235)
        with ESMTP id vvE5YDn04ete; Mon,  4 Mar 2019 15:46:02 +0000 (UTC)
Received: from heisenberg.fritz.box (ppp-82-135-82-31.dynamic.mnet-online.de [82.135.82.31])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp.dd24.net (Postfix) with ESMTPSA;
        Mon,  4 Mar 2019 15:46:02 +0000 (UTC)
Message-ID: <35900bed4a0ecb25b25c8d35be8bd1a5c38b59a8.camel@scientia.net>
Subject: Re: Reproducer for "compressed data + hole data corruption bug,
 2018 edition" still works on 4.20.7
From:   Christoph Anton Mitterer <calestyo@scientia.net>
To:     fdmanana@gmail.com
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Date:   Mon, 04 Mar 2019 16:46:00 +0100
In-Reply-To: <CAL3q7H53VWwCU78WgD928NgD=qcKaJd4Kh7sLOY2yv-Cfy9oOg@mail.gmail.com>
References: <20180823031125.GE13528@hungrycats.org>
         <20190212030838.GB9995@hungrycats.org>
         <CAL3q7H7T_NX=D8qimRC55g8V-p0k-ygUiW-K5bxF02r-6XT6Rg@mail.gmail.com>
         <20190212165916.GA23918@hungrycats.org>
         <CAL3q7H6eTTw-iTHiQLcJHa5iRRspWxQpfyTQRU1SmcxBqXSppg@mail.gmail.com>
         <20190212181328.GB23918@hungrycats.org>
         <CAL3q7H4k=N=0Cv8hYAZkfTfaG8XJgG1KzT5mA_4XnutxGFc8DA@mail.gmail.com>
         <CAL3q7H6YShEBKDTDZ7_qBoLDMgihP_8NYee_60-LUqd6sF5xZQ@mail.gmail.com>
         <CAL3q7H6WSe_C7_+D0x1_Z+KdK=k+iM-t2J4pQSO32ZsY4AEZ=Q@mail.gmail.com>
         <95e4d9825c2565473184765c4d77ae0015d01580.camel@scientia.net>
         <CAL3q7H53VWwCU78WgD928NgD=qcKaJd4Kh7sLOY2yv-Cfy9oOg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, 2019-02-15 at 12:02 +0000, Filipe Manana wrote:
> Upgrade to a kernel with the patch (none yet) or build it from
> source?
> Not sure what kind of advice you are looking for.

Well more something of the kind that Zygo wrote in his mail, i.e some
explanation of the whole issue in order to find out whether one might
be affected or not.


> As I said in the previous reply, and in the patch's changelog [1],
> the
> corruption happens at read time.
> That means nothing stored on disk is corrupted. It's not the end of
> the world.

Well but there are many cases where data is read and then written
again... and while Zygo's mail already answers a lot, at least the
question of whether it could happen on btrfs send/receive is still
open.


My understanding was that btrfs is considered "stable" for the normal
use cases (so e.g. perhaps without special features like raid56).

Data corruption is always quite serious, even if it's just on reads and
people may have workloads where data is read (possibly with corruption)
and (permanently) written again... so the whole thing *could* be quite
serious and IMO justifies a more thorough explanation for end-users and
not just a small commit message for developers.


Also, while it was really great to see how fast this got fixed then in
the end... it's also a bit worrying that Zygo apparently reported it
already some time ago and it got somehow lost.



Cheers,
Chris.

