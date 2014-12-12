Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45412 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754104AbaLLJSU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 04:18:20 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XzMMT-0001YC-Rj
	for linux-btrfs@vger.kernel.org; Fri, 12 Dec 2014 10:18:09 +0100
Received: from coffee.modeemi.fi ([130.230.72.140])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Dec 2014 10:18:09 +0100
Received: from flux-btrfs by coffee.modeemi.fi with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Dec 2014 10:18:09 +0100
To: linux-btrfs@vger.kernel.org
From: Erkki Seppala <flux-btrfs@inside.org>
Subject: Re: Balance & scrub & defrag
Date: Fri, 12 Dec 2014 11:17:58 +0200
Message-ID: <m49egs5b515.fsf@coffee.modeemi.fi>
References: <CAAe=sHWSR=G0+hJCbLCQfgBB_b9VQxu2Q8JETMuRgz79fcBUbg@mail.gmail.com>
	<5488F0A8.7070503@pobox.com>
	<44336672.dmUL7ANCyf@russell.coker.com.au>
	<548A4560.9010105@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Robert White <rwhite@pobox.com> writes:

> You need to buy better disks. 8-)

Where can one buy these better disks with reasonable prices?-) Disks are
best thought of as consumables.

> I use SMART (smartmontools etc) and its tests to keep track of and
> warn me of such issues. It's way more likely to catch incipient media
> failures long before scrub would.

That may be sort of true, but I think even SMART is helped by the fact
that the media is read through from the beginning to the end*, so it can
detect even the errors that don't bubble through the IO layer. And BTRFS
can indeed note errors that the media doesn't - two checksums is better
than one checksum, assuming they aren't exactly the same algorithm ;).

Do you alternatively execute SMART self tests?

* scrub doesn't do this, it reads only through used data

-- 
  _____________________________________________________________________
     / __// /__ ____  __               http://www.modeemi.fi/~flux/\   \
    / /_ / // // /\ \/ /                                            \  /
   /_/  /_/ \___/ /_/\_\@modeemi.fi                                  \/

