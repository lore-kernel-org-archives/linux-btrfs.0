Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B1A1C4338F
	for <linux-btrfs@archiver.kernel.org>; Sun, 22 Aug 2021 08:33:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 692F061284
	for <linux-btrfs@archiver.kernel.org>; Sun, 22 Aug 2021 08:33:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231807AbhHVIea (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 22 Aug 2021 04:34:30 -0400
Received: from wmail.tana.it ([62.94.243.226]:39063 "EHLO wmail.tana.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231147AbhHVIea (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 22 Aug 2021 04:34:30 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Aug 2021 04:34:29 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tana.it; s=delta;
        t=1629620925; bh=n/3PEkrT15jQ6DimLJAqKvxWCz89VByX40jhjHv3zb4=;
        l=308; h=To:From:Date;
        b=CPKcd49dWr4GJDZaokPUcT4VC7TVp2+WgaHX0TS3cH3ZCnz0+qRN9iVWXznXVqTMM
         lm/LUcalEvw1N3Fb5sPzarXGLMe5yp0XVJNYOKAcZm5PXabFM6WowgOv5MxWj7YZlf
         K0LBinwsACIQshCSG2GCy/R4Ue6ai4oe9n+dOLGGYf3ydVjaFH+St+g1JSksr
Authentication-Results: tana.it; auth=pass (details omitted)
Original-From: Alessandro Vesely <vesely@tana.it>
Received: from [192.168.1.103] ([2.198.14.130])
  (AUTH: CRAM-MD5 uXDGrn@SYT0/k, TLS: TLS1.3,128bits,ECDHE_RSA_AES_128_GCM_SHA256)
  by wmail.tana.it with ESMTPSA
  id 00000000005DC0CE.0000000061220ABD.0000270E; Sun, 22 Aug 2021 10:28:45 +0200
To:     linux-btrfs@vger.kernel.org
From:   Alessandro Vesely <vesely@tana.it>
Subject: FAQ: What deos the acronym BTRFS stand for?
Message-ID: <803068ca-2a3f-b27b-f3df-f3363127c0e7@tana.it>
Date:   Sun, 22 Aug 2021 10:28:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi all,

https://btrfs.wiki.kernel.org/index.php/FAQ is missing this question.

I had to google to a dictionary to find B-tree File System.  I'd add 
it on top of the FAQ, but I'm too lazy to create a wiki account.


Best
Ale
-- 

I hope this message will get through even if I'm not a subscriber.





