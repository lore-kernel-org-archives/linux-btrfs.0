Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:33828 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752471AbdJSS77 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Oct 2017 14:59:59 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:53288)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <postmaster@root.t00.sabi.co.uk>)
        id 1e5G2v-0000wc-Ig
        for linux-btrfs@vger.kernel.org; Thu, 19 Oct 2017 19:59:57 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1e5G2f-0003F1-V2
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Oct 2017 19:59:42 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <23016.63003.322789.169343@tree.ty.sabi.co.uk>
Date: Thu, 19 Oct 2017 19:59:39 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Is it safe to use btrfs on top of different types of devices?
In-Reply-To: <23016.59202.386422.937769@tree.ty.sabi.co.uk>
References: <CAGtRCvfkDnUBxqWNgEOXz+Gam0dPubatROQgqxE2D_uCAZhihQ@mail.gmail.com>
        <CAGtRCvfqUP_79cKC_Rzs6MD_uZiVbjt9QW0_BeOpACN_c3ev5w@mail.gmail.com>
        <d27ec863-d4fb-3ffd-78a4-c12789054bd9@gmail.com>
        <CAA-GF5vs_Mw9bW20ykXAr7Fr4DK_1bDM6qk0k54-oi5g-veK2g@mail.gmail.com>
        <d15a82aa-7d6e-ba36-76cc-8771e0359379@gmail.com>
        <20171017011443.bupcsskm7joc73wb@angband.pl>
        <e8497dd4-7341-a708-7828-282001738a95@gmail.com>
        <CAA-GF5sO78HjdWHRZKfENRwgGPF91Vz-Odm7PphiiEMVEENykg@mail.gmail.com>
        <23015.23766.971947.937708@tree.ty.sabi.co.uk>
        <cc34039f-9e84-c280-c793-1e381cbb2001@gmail.com>
        <23016.34313.523398.532675@tree.ty.sabi.co.uk>
        <CAA-GF5vfbm=fzhRchfTK=w9bHbApUGHeDw7Bgm3awZ1HN6s0jg@mail.gmail.com>
        <23016.59202.386422.937769@tree.ty.sabi.co.uk>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[ ... ]

>> are USB drives really that unreliable [ ... ]
[ ... ]
> There are similar SATA chips too (occasionally JMicron and
> Marvell for example are somewhat less awesome than they could
> be), and practically all Firewire bridge chips of old "lied" a
> lot [ ... ]
> That plus Btrfs is designed to work on top of a "well defined"
> block device abstraction that is assumed to "work correctly"
> (except for data corruption), [ ... ]

When I insist on the reminder that Btrfs is designed to use the
block-device protocol and state machine, rather than USB and
SATA devices, it is because that makes more explicit that the
various layer between the USB and SATA device can "lie" too,
including for example the Linux page cache which is just below
the block-device layer. But also the disk scheduler, the SCSI
protocol handler, the USB and SATA drivers and disk drivers, the
PCIe chipset, the USB or SATA host bus adapter, the cable, the
backplane.

This paper reports the results of some testing of "enterprise
grade" storage systems at CERN, and some of the symptoms imply
that "lies" can happen *anywhere*. It is scary. It supports
having data checksumming in the filesystem, a rather extreme
choice.
