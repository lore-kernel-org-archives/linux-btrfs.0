Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:41933 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934407AbaGRO2u (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Jul 2014 10:28:50 -0400
Received: by mail-vc0-f174.google.com with SMTP id la4so7513559vcb.19
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Jul 2014 07:28:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140718190524.143439e1@natsu>
References: <1405627978.2630.39.camel@s-Air>
	<e1b3b459-ea44-4272-9320-4cb5218b3966@email.android.com>
	<pan$b430d$ca43159e$977364a9$ed50906b@cox.net>
	<20140718053422.78784982@ws>
	<20140718190524.143439e1@natsu>
Date: Fri, 18 Jul 2014 16:28:48 +0200
Message-ID: <CAK5rZE40vzf3F54Xks8PeGaD6fJFXGF9_+tKYnNXYmHnu06FSQ@mail.gmail.com>
Subject: Re: Questions on incremental backups
From: Imran Geriskovan <imran.geriskovan@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's not about snapshots but here is an other incremental
backup recipe for optical mediums like DVDs, BlueRays:

Base Backup:
1) Create encrypted loopback devices of DVD or BlueRay sizes.
2) Create a compressed multi device Btrfs spanning these
    loopback devices. (To save space, you may use single
    metadata if this is not your only backup)
3) Rsync your data into this fs.
4) Unmount it and make it SEED fs (btrfstune -S 1..)
5) Burn loopback device files to DVDs, Bluerays.

Incremental Part:
a) Before your next backup, create additional encrypted
   loopback devices as needed.
b) Mount your base backup. (It will mount as read-only)
c) Add devices created at (a) to your base backup fs.
d) Rsync into your fs. (Note that incremental data
    will only go into the devices at (a)
e) Unmount all.
f) Only burn devices at (a) to DVDs, Bluerays. These
   are your incremental disks.

Regards,
Imran
