Return-Path: <SRS0=+P0G=OS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A227C07E85
	for <linux-btrfs@archiver.kernel.org>; Sun,  9 Dec 2018 09:32:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D60F72081C
	for <linux-btrfs@archiver.kernel.org>; Sun,  9 Dec 2018 09:32:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D60F72081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=duckstad.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbeLIJcM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 9 Dec 2018 04:32:12 -0500
Received: from smtp-out2.caiw.net ([62.45.45.126]:36333 "EHLO
        smtp-out2.caiw.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbeLIJcM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Dec 2018 04:32:12 -0500
Received: from barracuda-out-2.caiw.net (barracuda-out-2.caiw.net [62.45.59.18])
        by smtp-out2.caiw.net (Postfix) with ESMTP id 4C0BB61796
        for <linux-btrfs@vger.kernel.org>; Sun,  9 Dec 2018 10:32:10 +0100 (CET)
X-ASG-Debug-ID: 1544347929-08d4fd1ca952c10001-6jHSXT
Received: from smtp-out1.caiw.net (smtp-out1.caiw.net [62.45.45.125]) by barracuda-out-2.caiw.net with ESMTP id IAFcXiyAArUuiAnY; Sun, 09 Dec 2018 10:32:09 +0100 (CET)
X-Barracuda-Envelope-From: bolderbast@duckstad.net
X-Barracuda-RBL-Trusted-Forwarder: 62.45.45.125
Received: from katrien.duckstad.net (200-228-045-062.dynamic.caiway.nl [62.45.228.200])
        by smtp-out1.caiw.net (Postfix) with ESMTP id B70F5E0086;
        Sun,  9 Dec 2018 10:32:09 +0100 (CET)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by katrien.duckstad.net (Postfix) with ESMTP id AAB993802F;
        Sun,  9 Dec 2018 10:32:09 +0100 (CET)
X-Barracuda-RBL-IP: 62.45.228.200
X-Barracuda-Effective-Source-IP: 200-228-045-062.dynamic.caiway.nl[62.45.228.200]
X-Barracuda-Apparent-Source-IP: 62.45.228.200
Received: from katrien.duckstad.net ([127.0.0.1])
        by localhost (katrien.duckstad.net [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id gYo7-0dpp-NQ; Sun,  9 Dec 2018 10:32:08 +0100 (CET)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by katrien.duckstad.net (Postfix) with ESMTP id 40DFE38030;
        Sun,  9 Dec 2018 10:32:08 +0100 (CET)
X-Virus-Scanned: amavisd-new at katrien.duckstad.net
Received: from katrien.duckstad.net ([127.0.0.1])
        by localhost (katrien.duckstad.net [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id XX2pDcZx2i-d; Sun,  9 Dec 2018 10:32:08 +0100 (CET)
Received: from bolderbast (unknown [10.4.2.1])
        by katrien.duckstad.net (Postfix) with ESMTPSA id DA0AE3802F;
        Sun,  9 Dec 2018 10:32:07 +0100 (CET)
Message-ID: <e4e01618e9036750c4131e1a1e7094da58fba0be.camel@duckstad.net>
Subject: Re: Need help with potential ~45TB dataloss
From:   Patrick Dijkgraaf <bolderbast@duckstad.net>
X-ASG-Orig-Subj: Re: Need help with potential ~45TB dataloss
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Date:   Sun, 09 Dec 2018 10:32:07 +0100
In-Reply-To: <10cf1cd081ef7ea933af84d061363f68954edb0e.camel@duckstad.net>
References: <8bc37755da04dffae1a34cea2a06bcffdf2c75d7.camel@duckstad.net>
         <6ce9cd01-960f-af3d-0273-0b9abfa1d4f8@gmx.com>
         <c723ab8e8e99e54c6f93dc70f897725525f0db29.camel@duckstad.net>
         <19cde2a5-6a07-4c14-6e84-9496f91422d7@gmx.com>
         <10cf1cd081ef7ea933af84d061363f68954edb0e.camel@duckstad.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: smtp-out1.caiw.net[62.45.45.125]
X-Barracuda-Start-Time: 1544347929
X-Barracuda-URL: https://62.45.59.18:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at caiw.net
X-Barracuda-Scan-Msg-Size: 314
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.2090 1.0000 -0.7804
X-Barracuda-Spam-Score: -0.78
X-Barracuda-Spam-Status: No, SCORE=-0.78 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=7.0 KILL_LEVEL=1000.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.63401
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

So, does anyone have any suggestion on how I might recover some of the
data? If not, I'll cut my losses and create a new array...

Thanks!

-- 
Groet / Cheers,
Patrick Dijkgraaf



On Tue, 2018-12-04 at 10:58 +0100, Patrick Dijkgraaf wrote:
> Hi, thanks again.
> Please see answers inline.
> 
> 

