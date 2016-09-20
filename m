Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:36030 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751643AbcITQd7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 12:33:59 -0400
Received: by mail-oi0-f53.google.com with SMTP id t83so28268869oie.3
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Sep 2016 09:33:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160911174631.GJ24451@merlins.org>
References: <57D51BF9.2010907@online.no> <57D53E3A.1030106@online.no>
 <15194548.valIGHoaRh@merkaba> <2682119.DRdtbgPpNZ@merkaba>
 <57D55072.2010701@online.no> <20160911174631.GJ24451@merlins.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 20 Sep 2016 10:33:56 -0600
Message-ID: <CAJCQCtQfM4G+-emy5=7in3+WTfEB8MSaO3vcwfXjsbRTibAVjA@mail.gmail.com>
Subject: Re: Is stability a joke?
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc: Waxhead <waxhead@online.no>, Martin Steigerwald <martin@lichtvoll.de>,
        Marc MERLIN <marc@merlins.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs-convert has been rewritten as of btrfs-progs 4.6, and therefore
the conversion page could use an update:
https://btrfs.wiki.kernel.org/index.php/Conversion_from_Ext3

Anyone wanting to update the page should advise the code is new, check
the changelog, the latest btrfs-progs version should be used, and
there still may be edge cases:
https://btrfs.wiki.kernel.org/index.php/Changelog

Also, the status page doesn't mention the convert feature.


Chris Murphy
