Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.221]:35142 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932496AbdGXQmY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 12:42:24 -0400
Received: from mordor.fritz.box (xd932dc59.dyn.telefonica.de [217.50.220.89])
        by smtp.strato.de (RZmta 41.1 DYNA|AUTH)
        with ESMTPSA id N05fbdt6OGgMqVA
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate)
        for <linux-btrfs@vger.kernel.org>;
        Mon, 24 Jul 2017 18:42:22 +0200 (CEST)
Message-ID: <1500914542.2781.11.camel@cloud.haefemeier.eu>
Subject: Re: Best Practice: Add new device to RAID1 pool
From: Cloud Admin <admin@cloud.haefemeier.eu>
To: linux-btrfs@vger.kernel.org
Date: Mon, 24 Jul 2017 18:42:22 +0200
In-Reply-To: <20170724190808.148964a6@natsu>
References: <1500895655.2781.6.camel@cloud.haefemeier.eu>
         <18d96f74-00a8-9bb9-dddc-f50940d0971e@gmail.com>
         <20170724190808.148964a6@natsu>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag, den 24.07.2017, 19:08 +0500 schrieb Roman Mamedov:
> On Mon, 24 Jul 2017 09:46:34 -0400
> "Austin S. Hemmelgarn" <ahferroin7@gmail.com> wrote:
> 
> > > I am a little bit confused because the balance command is running
> > > since
> > > 12 hours and only 3GB of data are touched. This would mean the
> > > whole
> > > balance process (new disc has 8TB) would run a long, long time...
> > > and
> > > is using one cpu by 100%.
> > 
> > Based on what you're saying, it sounds like you've either run into
> > a 
> > bug, or have a huge number of snapshots
> 
> ...and possibly quotas (qgroups) enabled. (perhaps automatically by
> some tool,
> and not by you). Try:
> 
>   btrfs quota disable <mountpoint>
> 
It seems this was one part of my problem. See my answer to Austin.
> 
With respect,
> Roman
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
