Return-Path: <SRS0=dEEl=PX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7489C43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 22:13:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5ED9920866
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 22:13:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="OWeUinwU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729680AbfAOWNh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 17:13:37 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:45957 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727984AbfAOWNh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 17:13:37 -0500
Received: by mail-lj1-f195.google.com with SMTP id s5-v6so3692720ljd.12
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Jan 2019 14:13:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=X3fDFz/0q5mkALqLzQmvjeKSdKvCJ1yKQWMwhU1cDv4=;
        b=OWeUinwUOSyq6nM28lBmpsy7NxWL1Cboe5TtluJVYdx5p+UAUZBno7zMaVyNVhPLIK
         sXWxbwaqYrHdYJMI4x6E6aw7QOfK9Lc2PAlOJXPGIcjFf2aYsFfae2c71/VlaZE8oacG
         sA7dZ2Eh2cnng0r/YtVtTsoDvZguIKNXPFY1IfJ2FwNtRNSa7F7aW2F6L9rnrYlqqSGv
         jP0joH16H5CXsdREi8sooE9tpuJx5+lKSyqsA6G7U4aTFkbpUtvSTOSIfxxEVl7NtZml
         jBNsm9aDXLOpwuPzHUukmSKcYOKifChXaHB+5egI0CVufTCna71onEbRZPA/NGalBy2p
         WYGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=X3fDFz/0q5mkALqLzQmvjeKSdKvCJ1yKQWMwhU1cDv4=;
        b=ZVSSsIth6OTZzsfdcGr+9gSXYiPmkFI2nE9HQI5s8FFMdv0KzQ9NqBTt2kz+6llcT9
         Kp1UVw1yT66SLsbYKGcubRnM77Gid2rv9qNAKst+eFEKrJndTUfzJ8lghLIT5qcWEBdh
         FYppgh1aq4MgzKOWr2vhwzCRtjXJFM7tReN/jWK8pn/EMN2PyJI4h22bk0uMJCmxreI2
         1FJkNREn7lzBDPrwnfmocImNbRY2et/+az5+duG5I5mB4xx6iJx6803ujou3QSzRWPLg
         GMEvsDrRErrnxwLmbVx6ov3RbZW09eXzT+KDBYmToeaUt/I2zINPfHXrFOCUNaxpCsD5
         D6ag==
X-Gm-Message-State: AJcUukf7VX9buZYbecNEF6DHtcUpFpnfyxMZEnRgpBOInNcHPSJA/bU8
        Rbj+WU7DElFEx0eB6BjlkX62cRAiCar49NvaiMHz65a17yU=
X-Google-Smtp-Source: ALg8bN6EfAPxU1RNmaKBbE2sY+oOW0BdyDCWjybZj4gzrhQXRYqb8sg1hOWjRyBTft0I3BqKfmV0tto/m0+1PrTu9Q4=
X-Received: by 2002:a2e:841:: with SMTP id g1-v6mr4547493ljd.21.1547590414852;
 Tue, 15 Jan 2019 14:13:34 -0800 (PST)
MIME-Version: 1.0
References: <6760df5e-a757-56a0-d8c9-3f172458fc65@ch-sc.de>
In-Reply-To: <6760df5e-a757-56a0-d8c9-3f172458fc65@ch-sc.de>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Tue, 15 Jan 2019 15:13:22 -0700
Message-ID: <CAJCQCtS9KC_Vrc0qFsvJRFq5cWgxPi5xx7NMVtGAjn2iqokK+w@mail.gmail.com>
Subject: Re: issue mounting volume
To:     Christian Schneider <christian@ch-sc.de>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 15, 2019 at 10:03 AM Christian Schneider <christian@ch-sc.de> wrote:

> uname -a
> Linux jane 4.19.6-gentoo #1 SMP PREEMPT Sat Dec 15 13:26:24 CET 2018
> x86_64 Intel(R) Core(TM) i7-4785T CPU @ 2.20GHz GenuineIntel GNU/Linux

Your problem could be due to a block layer bug that's been discovered.
It should be fixed in 4.19.8+
https://lwn.net/Articles/774440/

I'm not sure off hand how to fix the corruption once it's happened;
and I'm not even sure if it's a contributing factor to the power
failure or not. It is disappointing that btrfs check has no way to
iterate or try to infer a correction for a bad leaf, but it's not
certain how badly damaged that leaf is yet. You can output it

'btrfs insp dump-t -b 448888832 <dev>'

and remove file names before posting it; this might help a dev sort
out what the problem is.



-- 
Chris Murphy
