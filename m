Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:36599 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932304AbcFCJ5l (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jun 2016 05:57:41 -0400
Received: by mail-oi0-f46.google.com with SMTP id j1so118887883oih.3
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jun 2016 02:57:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160603095344.GV14027@torres.zugschlus.de>
References: <CAGQ70Yc=HHxJspMCKFBpEURRu=53pZW3k3rVDVO3QPGP_b9Tkw@mail.gmail.com>
 <20160603095344.GV14027@torres.zugschlus.de>
From: Martin <rc6encrypted@gmail.com>
Date: Fri, 3 Jun 2016 11:57:40 +0200
Message-ID: <CAGQ70Ydvyx_cii9SCXV_Xh5ikEEmkUCtTsR24Pno_zUBzd2YmA@mail.gmail.com>
Subject: Re: Recommended why to use btrfs for production?
To: Marc Haber <mh+linux-btrfs@zugschlus.de>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Do you plan to use Snapshots? How many of them?

Yes, minimum 7 for each day of the week.

Nice to have would be 4 extra for each week of the month and then 12
for each month of the year.
