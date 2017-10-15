Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:39880 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750918AbdJOATs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 14 Oct 2017 20:19:48 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:38764)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <postmaster@root.t00.sabi.co.uk>)
        id 1e3Weg-0001L0-Al
        for linux-btrfs@vger.kernel.org; Sun, 15 Oct 2017 01:19:46 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1e3WeZ-0005i3-WA
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Oct 2017 01:19:40 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <23010.43419.227953.492453@tree.ty.sabi.co.uk>
Date: Sun, 15 Oct 2017 01:19:39 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Is it safe to use btrfs on top of different types of devices?
In-Reply-To: <CAGtRCvfkDnUBxqWNgEOXz+Gam0dPubatROQgqxE2D_uCAZhihQ@mail.gmail.com>
References: <CAGtRCvfkDnUBxqWNgEOXz+Gam0dPubatROQgqxE2D_uCAZhihQ@mail.gmail.com>
From: pg@btrs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> A few years ago I tried to use a RAID1 mdadm array of a SATA
> and a USB disk, which lead to strange error messages and data
> corruption.

That's common, quite a few reports of similar issues in previous
entries in this mailing list and for many other filesystems.

> I did some searching back then and found out that using
> hot-pluggable devices with mdadm is a paved road to data
> corruption.

That's an amazing jump of logic.

> Reading through that old bug again I see that it was
> autoclosed due to old age but still hasn't been addressed:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/320638

I suspect that it is very easy to misinterpret what the reported
issue is. However it is an interesting corner case what could
happen with any type of hardware device, not just hot-pluggable,
and one that I will try to remember even if unlikely to occur in
practice. I was only aware (dimly) of something quite similar in
the case of different logical sector sizes.

> I would like to ask whether btrfs may also be prone to data
> corruption issues in this scenario

Btrfs like (nearly) all UNIX/Linux filesystems does not run on
top of "devices", but on top of "files" of type "block device".

If the block device abstraction layer and lower layers work
correctly, Btrfs does not have problems of that sort when adding
new devices; conversely if the block device layer and lower
layers do not work correctly, no mainline Linux filesystem I know
can cope with that.

Note: "work correctly" does not mean "work error-free".

> (due to the same underlying issue as the one described in the
> bug above for mdadm), or is btrfs unaffected by the underlying
> issue

"Socratic method" questions:

* What do you think is the underlying issue in that bug report?
  (hint: something to do with host adapters or device bridges)
* Why do you think that bug report is in any way related to your
  issues with "a RAID1 mdadm array of a SATA and a USB disk"?

> and is safe to use with a mix of regular and hot-pluggable
> devices as well?

In my experience Btrfs works very well with a set of block
devices abstracting over on both regular and hot-pluggable
device, as far as that goes.

I personally don't like relying on Btrfs multi-device volumes,
but that has nothing to do with your concerns, but with basic
Btrfs multi-device handling design choices.

If you have concerns about the reliability of specific storage
and system configurations you should become or find a system
integration and qualification engineer who understand the many
subletities of storage devices and device-system interconnects
and who would run extensive tests on it; storage and system
commissioning is often far from trivial even in seemingly simple
cases, due in part to the enormous complexity of interfaces, even
when they have few bugs, and test made with one combination often
do not have the same results even on apparently similar
combinations.

I suspect that you should have asked a completely different set
of questions (XY problem), but the above are I think good answers
to the questions that you have actually asked.
