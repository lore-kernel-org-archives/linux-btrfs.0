Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:33592 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752558AbdJSSkY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Oct 2017 14:40:24 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:53216)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <postmaster@root.t00.sabi.co.uk>)
        id 1e5Fjz-0000DW-HY
        for linux-btrfs@vger.kernel.org; Thu, 19 Oct 2017 19:40:23 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1e5F3N-000364-4Q
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Oct 2017 18:56:21 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <23016.59202.386422.937769@tree.ty.sabi.co.uk>
Date: Thu, 19 Oct 2017 18:56:18 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Is it safe to use btrfs on top of different types of devices?
In-Reply-To: <CAA-GF5vfbm=fzhRchfTK=w9bHbApUGHeDw7Bgm3awZ1HN6s0jg@mail.gmail.com>
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
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> [ ... ] when writes to a USB device fail due to a temporary
> disconnection, the kernel can actually recognize that a write
> error happened. [ ... ]

Usually, but who knows? Maybe half transfer gets written; maybe
the data gets written to the wrong address; maybe stuff gets
written but failure is reported, and this not just if the
connection dies, but also if it does not.

> are USB drives really that unreliable [ ... ]

Welcome to the "real world", also called "Shenzen" :-).

There aren't that many "USB drives", as I wrote somewhere there
are usually USB host bus adapters (on the system side) and USB
IO bus (usually SATA) bridges (on the device side).

They both have to do difficult feats of conversion and signaling,
and in the USB case they are usually designed by a stressed,
overworked engineer in Guangzhou or Taiwan employed by a no-name
contractor working who submitted the lowest bid to a no-name
manufacturer, and was told to do the cheapest design to fabricate
in the shortest possible time. Most of the time they mostly work,
good enough for keyboard and mice, and for photos of cats on usb
sticks; most users jut unplug and replug them in if they flake
out. BTW my own USB keyboard and mice and their USB host bus
adapter occasionaly crash too, and the cases where my webcam
flakes out are more common than when it does not. USB is a mixed
bag of poorly designed protocols and complex too, and it is very
easy to do a bad implementation.

There are similar SATA chips too (occasionally JMicron and
Marvell for example are somewhat less awesome than they could
be), and practically all Firewire bridge chips of old "lied" a
lot except a few Oxford Semi ones (the legendary 911 series).
I have even seen lying SAS "enterprise" grade storage
interconnects. I had indeed previously written:

  > If you have concerns about the reliability of specific
  > storage and system configurations you should become or find a
  > system integration and qualification engineer who understand
  > the many subletities of storage devices and device-system
  > interconnects and who would run extensive tests on it;
  > storage and system commissioning is often far from trivial
  > even in seemingly simple cases, due in part to the enormous
  > complexity of interfaces, even when they have few bugs, and
  > test made with one combination often do not have the same
  > results even on apparently similar combinations.

On the #Btrfs IRC channel there is a small group of cynical
helpers, and when someone mentions "strange things happening" one
of them usually immediately asks "USB?" and in most cases the
answer is "how did you know?".

That plus Btrfs is designed to work on top of a "well defined"
block device abstraction that is assumed to "work correctly"
(except for data corruption), and the Linux block device
abstraction and SATA and USB layers beneath it are not designed
to handle devices that "lie" (well, there are blacklists with
workaround for known systematic bugs, but that is partial).
