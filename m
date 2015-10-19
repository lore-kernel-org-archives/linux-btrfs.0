Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49456 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbbJSGT5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Oct 2015 02:19:57 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zo3nW-0007Kq-Nw
	for linux-btrfs@vger.kernel.org; Mon, 19 Oct 2015 08:19:54 +0200
Received: from coffee.modeemi.fi ([130.230.72.140])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2015 08:19:54 +0200
Received: from flux-btrfs by coffee.modeemi.fi with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2015 08:19:54 +0200
To: linux-btrfs@vger.kernel.org
From: Erkki Seppala <flux-btrfs@inside.org>
Subject: Re: btrfs autodefrag?
Date: Mon, 19 Oct 2015 09:19:48 +0300
Message-ID: <m49zizfbcsb.fsf@coffee.modeemi.fi>
References: <56227910.7000208@gmail.com>
	<CAGfcS_kBeqT6bQKJNegjkcFNcEyqNF2ETg_KY64Y-7-2mc+9-g@mail.gmail.com>
	<20151018144015.GV25907@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills <hugo@carfax.org.uk> writes:
>    It has to be disabled because if you enable it, there's a race
> condition: since you're overwriting existing data (rather than CoWing
> it), you can't update the checksums atomically. So, in the interests
> of consistency, checksums are disabled.

I suppose this has been suggested before, but couldn't it store both the
new and the old checksums and be satisfied if either of them match?

The user is probably not happy that a partial write is going to be
difficult to read from the device due to a checksum error, but there is
no promise of recently-overwritten data state with traditional
filesystems either in case of sudden powerdown, assuming there is no
data journaling..

-- 
  _____________________________________________________________________
     / __// /__ ____  __               http://www.modeemi.fi/~flux/\   \
    / /_ / // // /\ \/ /                                            \  /
   /_/  /_/ \___/ /_/\_\@modeemi.fi                                  \/

