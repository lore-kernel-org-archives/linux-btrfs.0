Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.217]:13907 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751534AbdGYRqn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Jul 2017 13:46:43 -0400
Received: from mordor.fritz.box (x5f74b90b.dyn.telefonica.de [95.116.185.11])
        by smtp.strato.de (RZmta 41.1 DYNA|AUTH)
        with ESMTPSA id 305b16t6PHkf2Mb
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate)
        for <linux-btrfs@vger.kernel.org>;
        Tue, 25 Jul 2017 19:46:41 +0200 (CEST)
Message-ID: <1501004801.3020.1.camel@cloud.haefemeier.eu>
Subject: Re: Best Practice: Add new device to RAID1 pool
From: Cloud Admin <admin@cloud.haefemeier.eu>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date: Tue, 25 Jul 2017 19:46:41 +0200
In-Reply-To: <aac851d3-4187-fc94-bdcb-e79b83b74da8@dirtcellar.net>
References: <1500895655.2781.6.camel@cloud.haefemeier.eu>
         <CAJCQCtT3nEaHox7jiO-jf6hCjpUSRz=AahrapgZDajJdeYr1Rw@mail.gmail.com>
         <aac851d3-4187-fc94-bdcb-e79b83b74da8@dirtcellar.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag, den 24.07.2017, 23:12 +0200 schrieb waxhead:
> 
> Chris Murphy wrote:
> 
> This may be a stupid question , but are your pool of butter (or
> BTRFS 
> pool) by any chance hooked up via USB? If this is USB2.0 at 
No, it is a SATA array with (currently) four 8TB discs.

