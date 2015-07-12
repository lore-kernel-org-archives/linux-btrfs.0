Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:33963 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbbGLGKF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jul 2015 02:10:05 -0400
Received: by oiab3 with SMTP id b3so117210174oia.1
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Jul 2015 23:10:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQmppYhavcOcef2Nv3ZmpVYe+4b6LLSAvfAMdCD5bTvGw@mail.gmail.com>
References: <CAG+QAKX1eSmarBn+YXq5dkZ0zTWsSDM6cfwTtDg-43-nTRSXWQ@mail.gmail.com>
	<CAC=t97Dy57JMBZ-exzCytMMUUhrV_zh7W9L+fQR_G_LOqfhWhA@mail.gmail.com>
	<CAG+QAKWZ-jTGkK7btiHziDf9LhW31QUSFbJ9DpLy1xqmk7vUCQ@mail.gmail.com>
	<CAG+QAKW1ZH_6AN3CSmXxiQr9xmR_ha=erfruSHxvKYKH6w3WiA@mail.gmail.com>
	<CAG+QAKUuwVSr8wibFi3zdwu1gR72YEjXEV1JFK126juWzDFvDg@mail.gmail.com>
	<CAJCQCtQmppYhavcOcef2Nv3ZmpVYe+4b6LLSAvfAMdCD5bTvGw@mail.gmail.com>
Date: Sat, 11 Jul 2015 23:10:04 -0700
Message-ID: <CAG+QAKVeai3DsimBg10Ykwrnjr-XOX4jqypR7+tBcoPoWZyM7g@mail.gmail.com>
Subject: Re: btrfs full, but not full, can't rebalance
From: Rich Rauenzahn <rrauenza@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just a final note -- I'm finally back in person with the CentOS 7 server and so
booted it to the latest kernel-ml from elrepo.  It is a 4.1 kernel.

But while still remote with the older 3.10 kernel, I also tried doing
a 'mount -oremount,clear_cache /'

I can't swear it helped, but things did seem to get better
afterwards... so it may be worth a try for anyone reading this thread
with a similar problem later.  (Unless someone can definitively say
that clear_cache doesn't work with -oremount.)

Rich
