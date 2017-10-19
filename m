Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:33590 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752061AbdJSSkY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Oct 2017 14:40:24 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:53214)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <postmaster@root.t00.sabi.co.uk>)
        id 1e5Fjz-0000DR-2L
        for linux-btrfs@vger.kernel.org; Thu, 19 Oct 2017 19:40:23 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1e5F7Y-00036b-SG
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Oct 2017 19:00:40 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <23016.59464.506830.81205@tree.ty.sabi.co.uk>
Date: Thu, 19 Oct 2017 19:00:40 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Is it safe to use btrfs on top of different types of devices?
In-Reply-To: <0a93b5df-dad5-ff27-b7d3-ac2519892696@gmail.com>
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
        <0a93b5df-dad5-ff27-b7d3-ac2519892696@gmail.com>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> [ ... ] However, the disappearance of the device doesn't get
> propagated up to the filesystem correctly,

Indeed, sometimes it does, sometimes it does not, in part
because of chipset bugs, in part because the USB protocol
signaling side does not handle errors well even if the chipset
were bug free.

> and that is what causes the biggest issue with BTRFS. Because
> BTRFS just knows writes are suddenly failing for some reason,
> it doesn't try to release the device so that things get
> properly cleaned up in the kernel, and thus when the same
> device reappears (as it will when the disconnect was due to a
> transient bus error, which happens a lot), it shows up as a
> different device node, which gets scanned for filesystems by
> udev, and BTRFS then gets really confused because it now sees
> 3 (or more) devices for a 2 device filesystem.

That's a good description that should be on the wiki.
