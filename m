Return-Path: <SRS0=+P0G=OS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AC7AC07E85
	for <linux-btrfs@archiver.kernel.org>; Sun,  9 Dec 2018 09:28:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20FFF2081C
	for <linux-btrfs@archiver.kernel.org>; Sun,  9 Dec 2018 09:28:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 20FFF2081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=duckstad.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbeLIJ2R (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 9 Dec 2018 04:28:17 -0500
Received: from smtp-out1.caiw.net ([62.45.45.125]:47483 "EHLO
        smtp-out1.caiw.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbeLIJ2R (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Dec 2018 04:28:17 -0500
Received: from barracuda-out-2.caiw.net (barracuda-out.caiw.net [62.45.59.18])
        by smtp-out1.caiw.net (Postfix) with ESMTP id 035B140830
        for <linux-btrfs@vger.kernel.org>; Sun,  9 Dec 2018 10:28:14 +0100 (CET)
X-ASG-Debug-ID: 1544347693-08d4fd46b282490001-6jHSXT
Received: from smtp-out1.caiw.net (smtp-out1.caiw.net [62.45.45.125]) by barracuda-out-2.caiw.net with ESMTP id wmlgdhKoYy0x6bh4; Sun, 09 Dec 2018 10:28:13 +0100 (CET)
X-Barracuda-Envelope-From: bolderbast@duckstad.net
X-Barracuda-RBL-Trusted-Forwarder: 62.45.45.125
Received: from katrien.duckstad.net (200-228-045-062.dynamic.caiway.nl [62.45.228.200])
        by smtp-out1.caiw.net (Postfix) with ESMTP id 742DAE0085;
        Sun,  9 Dec 2018 10:28:13 +0100 (CET)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by katrien.duckstad.net (Postfix) with ESMTP id 676413802F;
        Sun,  9 Dec 2018 10:28:13 +0100 (CET)
X-Barracuda-RBL-IP: 62.45.228.200
X-Barracuda-Effective-Source-IP: 200-228-045-062.dynamic.caiway.nl[62.45.228.200]
X-Barracuda-Apparent-Source-IP: 62.45.228.200
Received: from katrien.duckstad.net ([127.0.0.1])
        by localhost (katrien.duckstad.net [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id smHSabtV3dy7; Sun,  9 Dec 2018 10:28:12 +0100 (CET)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by katrien.duckstad.net (Postfix) with ESMTP id EC75A38030;
        Sun,  9 Dec 2018 10:28:11 +0100 (CET)
X-Virus-Scanned: amavisd-new at katrien.duckstad.net
Received: from katrien.duckstad.net ([127.0.0.1])
        by localhost (katrien.duckstad.net [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 1V01Bd-185rr; Sun,  9 Dec 2018 10:28:11 +0100 (CET)
Received: from bolderbast (unknown [10.4.2.1])
        by katrien.duckstad.net (Postfix) with ESMTPSA id A203D3802F;
        Sun,  9 Dec 2018 10:28:11 +0100 (CET)
Message-ID: <77c6f2ac98a3c89ace6829dd3b5b821533c48621.camel@duckstad.net>
Subject: Re: Need help with potential ~45TB dataloss
From:   Patrick Dijkgraaf <bolderbast@duckstad.net>
X-ASG-Orig-Subj: Re: Need help with potential ~45TB dataloss
To:     Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date:   Sun, 09 Dec 2018 10:28:11 +0100
In-Reply-To: <CAJCQCtSnEhjLiSdfuDUK85fbOjYG2a2Dw+BS9PndMV9ZDL1Wmg@mail.gmail.com>
References: <8bc37755da04dffae1a34cea2a06bcffdf2c75d7.camel@duckstad.net>
         <6ce9cd01-960f-af3d-0273-0b9abfa1d4f8@gmx.com>
         <c723ab8e8e99e54c6f93dc70f897725525f0db29.camel@duckstad.net>
         <c24627dec9738552e1635617aace7720f395ba39.camel@duckstad.net>
         <2b235519-5c8d-9e86-b4f3-28cd7f778c4f@gmail.com>
         <7dac5577-2231-dcba-39fd-c229e4ed5e02@gmx.com>
         <CAJCQCtRgzw=UPfHxeaiDzqKGzrbSKz-B3xfUpBjYM4GGe=W4YA@mail.gmail.com>
         <8e5729f3c15997a13bdce73800146e91222ed89c.camel@duckstad.net>
         <CAJCQCtSnEhjLiSdfuDUK85fbOjYG2a2Dw+BS9PndMV9ZDL1Wmg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: smtp-out1.caiw.net[62.45.45.125]
X-Barracuda-Start-Time: 1544347693
X-Barracuda-URL: https://62.45.59.18:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at caiw.net
X-Barracuda-Scan-Msg-Size: 767
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0012 1.0000 -2.0132
X-Barracuda-Spam-Score: -2.01
X-Barracuda-Spam-Status: No, SCORE=-2.01 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=7.0 KILL_LEVEL=1000.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.63401
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi Chris,

they're SATA.
smartctl -x gives:

SCT Error Recovery Control command not supported

So seems like we can't do enything with it.

-- 
Groet / Cheers,
Patrick Dijkgraaf



On Tue, 2018-12-04 at 12:38 -0700, Chris Murphy wrote:
> On Tue, Dec 4, 2018 at 3:09 AM Patrick Dijkgraaf
> <
> bolderbast@duckstad.net
> > wrote:
> > Hi Chris,
> > 
> > See the output below. Any suggestions based on it?
> 
> If they're SATA drives, they may not support SCT ERC; and if they're
> SAS, depending on what controller they're behind, smartctl might need
> a hint to properly ask the drive for SCT ERC status. Simplest way to
> know is do 'smartctl -x' on one drive, assuming they're all the same
> basic make/model other than size.
> 
> 


