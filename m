Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:33287 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182AbcFCKPO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jun 2016 06:15:14 -0400
Received: by mail-oi0-f42.google.com with SMTP id k23so119787833oih.0
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jun 2016 03:15:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <57515566.5050809@mendix.com>
References: <CAGQ70Yc=HHxJspMCKFBpEURRu=53pZW3k3rVDVO3QPGP_b9Tkw@mail.gmail.com>
 <57515566.5050809@mendix.com>
From: Martin <rc6encrypted@gmail.com>
Date: Fri, 3 Jun 2016 12:15:13 +0200
Message-ID: <CAGQ70YfEzCcU1eM1e45zeghzs20FpkJOuyBGLsJ20ggTVhSwWA@mail.gmail.com>
Subject: Re: Recommended why to use btrfs for production?
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Before trying RAID5/6 in production, be sure to read posts like these:
>
> http://www.spinics.net/lists/linux-btrfs/msg55642.html

Very interesting post and very recent even.

If I decide to try raid6 and of course everything is replicated each
day (for a bit of a safety net), and disks begin to fail, how much
help will I likely get from this list to recover?
