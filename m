Return-Path: <SRS0=qFN0=RR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74372C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 20:22:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 440CA2077B
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 20:22:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbfCNUW4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Mar 2019 16:22:56 -0400
Received: from mailgw-02.dd24.net ([193.46.215.43]:57795 "EHLO
        mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727220AbfCNUWz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Mar 2019 16:22:55 -0400
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-01.live.igb.homer.key-systems.net [192.168.1.26])
        by mailgw-02.dd24.net (Postfix) with ESMTP id 78184600F3;
        Thu, 14 Mar 2019 20:22:54 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at
        mailpolicy-01.live.igb.homer.key-systems.net
Received: from smtp.dd24.net ([192.168.1.36])
        by mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-01.live.igb.homer.key-systems.net [192.168.1.25]) (amavisd-new, port 10236)
        with ESMTP id KIOrcp82EAH7; Thu, 14 Mar 2019 20:22:53 +0000 (UTC)
Received: from heisenberg.fritz.box (ppp-82-135-82-31.dynamic.mnet-online.de [82.135.82.31])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp.dd24.net (Postfix) with ESMTPSA;
        Thu, 14 Mar 2019 20:22:53 +0000 (UTC)
Message-ID: <f1d3b79ac3496fc9bdeac2b0a863f6124365713a.camel@scientia.net>
Subject: Re: Reproducer for "compressed data + hole data corruption bug,
 2018 edition" still works on 4.20.7
From:   Christoph Anton Mitterer <calestyo@scientia.net>
To:     fdmanana@gmail.com
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Date:   Thu, 14 Mar 2019 21:22:51 +0100
In-Reply-To: <CAL3q7H599_kDPDFHMRqSwNLXKtANC7aaqBe+Hm6JjpR37uS1Vg@mail.gmail.com>
References: <CAL3q7H7T_NX=D8qimRC55g8V-p0k-ygUiW-K5bxF02r-6XT6Rg@mail.gmail.com>
         <20190212165916.GA23918@hungrycats.org>
         <CAL3q7H6eTTw-iTHiQLcJHa5iRRspWxQpfyTQRU1SmcxBqXSppg@mail.gmail.com>
         <20190212181328.GB23918@hungrycats.org>
         <CAL3q7H4k=N=0Cv8hYAZkfTfaG8XJgG1KzT5mA_4XnutxGFc8DA@mail.gmail.com>
         <CAL3q7H6YShEBKDTDZ7_qBoLDMgihP_8NYee_60-LUqd6sF5xZQ@mail.gmail.com>
         <CAL3q7H6WSe_C7_+D0x1_Z+KdK=k+iM-t2J4pQSO32ZsY4AEZ=Q@mail.gmail.com>
         <95e4d9825c2565473184765c4d77ae0015d01580.camel@scientia.net>
         <20190215054031.GC9995@hungrycats.org>
         <f9fddae4bc3d59e539b7bc56ae75a5f04a165682.camel@scientia.net>
         <20190307200712.GG23918@hungrycats.org>
         <CAL3q7H599_kDPDFHMRqSwNLXKtANC7aaqBe+Hm6JjpR37uS1Vg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Oh and just for double checking:

In the original patch you've posted and which Zygo tested, AFAIU, you
had one line replaced.
( https://friendpaste.com/22t4OdktHQTl0aMGxcWLj3 )

In the one submitted there were two occasions of replacing 
em->orig_start with em->start.
( https://lore.kernel.org/linux-btrfs/20190214151720.23563-1-fdmanana@kernel.org/ )

I assume that's on purpose?

Cheers,
Chris.

