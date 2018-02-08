Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cc-smtpout1.netcologne.de ([89.1.8.211]:56404 "EHLO
        cc-smtpout1.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752281AbeBHLhM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Feb 2018 06:37:12 -0500
Received: from cc-smtpin3.netcologne.de (cc-smtpin3.netcologne.de [89.1.8.203])
        by cc-smtpout1.netcologne.de (Postfix) with ESMTP id E734513673
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Feb 2018 12:37:10 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by cc-smtpin3.netcologne.de (Postfix) with ESMTP id E31EF11DBD
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Feb 2018 12:37:10 +0100 (CET)
Received: from [209.85.217.172] (helo=cc-smtpin3.netcologne.de)
        by localhost with ESMTP (eXpurgate 4.1.9)
        (envelope-from <s.schumacher@netcologne.de>)
        id 5a7c3666-02b7-7f0000012729-7f0000018928-1
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Feb 2018 12:37:10 +0100
Received: from mail-ua0-f172.google.com (mail-ua0-f172.google.com [209.85.217.172])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by cc-smtpin3.netcologne.de (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Feb 2018 12:37:09 +0100 (CET)
Received: by mail-ua0-f172.google.com with SMTP id x4so2645062uaj.11
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Feb 2018 03:37:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQT7pDTrOrSMF-LXrB45yP32qytTOmAqjTv6EA5nnZfmw@mail.gmail.com>
References: <CAA3ktqnd8_kmiVNq_7L6G0ekiqGzSrfVbzTTc_5aUU9AygE02A@mail.gmail.com>
 <CAJCQCtQT7pDTrOrSMF-LXrB45yP32qytTOmAqjTv6EA5nnZfmw@mail.gmail.com>
From: Stefan Malte Schumacher <s.schumacher@netcologne.de>
Date: Thu, 8 Feb 2018 12:37:08 +0100
Message-ID: <CAA3ktqnAt00TXGsSNpp7TyX++eZTiCO+31nY5xd8h2Zro_xktg@mail.gmail.com>
Subject: Re: Crash when unraring large archives on btrfs-filesystem
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> How much RAM on the machine and how much swap available? This looks like a
> lot of dirty data has accumulated, and then also there's swapping happening.
> Both swap out and swap in.

The machine has 16GB Ram and 40GB Swap on a SSD. Its not doing much
besides being my personal file archive, so there should be plenty of
free memory for btrfs. I have remounted the filesystem with the
clear_cache option and now will apply the tweaks mentioned by Duncan.
If this does not fix the problem I will install a more current kernel
from stretch-backports. Testing currently has btrfs-progs 4.13.3-1. Is
this version safe to use and should I upgrade it along with the
kernel?
