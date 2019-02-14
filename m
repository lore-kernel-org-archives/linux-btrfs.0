Return-Path: <SRS0=zIgm=QV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44BE6C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Feb 2019 12:21:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F247221900
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Feb 2019 12:21:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbfBNMVd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Feb 2019 07:21:33 -0500
Received: from mailgw-01.dd24.net ([193.46.215.41]:44940 "EHLO
        mailgw-01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbfBNMVd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Feb 2019 07:21:33 -0500
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.27])
        by mailgw-01.dd24.net (Postfix) with ESMTP id 063A95FFD9
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Feb 2019 12:21:32 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at
        mailpolicy-02.live.igb.homer.key-systems.net
Received: from smtp.dd24.net ([192.168.1.35])
        by mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.25]) (amavisd-new, port 10235)
        with ESMTP id IL1DwbjjT4Rm for <linux-btrfs@vger.kernel.org>;
        Thu, 14 Feb 2019 12:21:30 +0000 (UTC)
Received: from gar-nb-etp23.garching.physik.uni-muenchen.de (unknown [141.84.41.132])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp.dd24.net (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Feb 2019 12:21:30 +0000 (UTC)
Message-ID: <95e4d9825c2565473184765c4d77ae0015d01580.camel@scientia.net>
Subject: Re: Reproducer for "compressed data + hole data corruption bug,
 2018 edition" still works on 4.20.7
From:   Christoph Anton Mitterer <calestyo@scientia.net>
To:     linux-btrfs <linux-btrfs@vger.kernel.org>
Date:   Thu, 14 Feb 2019 13:21:29 +0100
In-Reply-To: <CAL3q7H6WSe_C7_+D0x1_Z+KdK=k+iM-t2J4pQSO32ZsY4AEZ=Q@mail.gmail.com>
References: <20180823031125.GE13528@hungrycats.org>
         <20190212030838.GB9995@hungrycats.org>
         <CAL3q7H7T_NX=D8qimRC55g8V-p0k-ygUiW-K5bxF02r-6XT6Rg@mail.gmail.com>
         <20190212165916.GA23918@hungrycats.org>
         <CAL3q7H6eTTw-iTHiQLcJHa5iRRspWxQpfyTQRU1SmcxBqXSppg@mail.gmail.com>
         <20190212181328.GB23918@hungrycats.org>
         <CAL3q7H4k=N=0Cv8hYAZkfTfaG8XJgG1KzT5mA_4XnutxGFc8DA@mail.gmail.com>
         <CAL3q7H6YShEBKDTDZ7_qBoLDMgihP_8NYee_60-LUqd6sF5xZQ@mail.gmail.com>
         <CAL3q7H6WSe_C7_+D0x1_Z+KdK=k+iM-t2J4pQSO32ZsY4AEZ=Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, 2019-02-14 at 01:22 +0000, Filipe Manana wrote:
> The following one liner fixes it:
> https://friendpaste.com/22t4OdktHQTl0aMGxcWLj3

Great to see that fixed... is there any advise that can be given for
users/admins?


Like whether and how any occurred corruptions can be detected (right
now, people may still have backups)?


Or under which exact circumstances did the corruption happen? And under
which was one safe?
E.g. only on specific compression algos (I've been using -o compress
(which should be zlib) for quite a while but never found any
compression),... or only when specific file operations were done (I did
e.g. cp with refcopy, but I think none of the standard tools does hole-
punching)?


Cheers,
Chris.

