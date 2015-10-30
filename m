Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52118 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758776AbbJ3I5p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Oct 2015 04:57:45 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zs5VI-0000jd-69
	for linux-btrfs@vger.kernel.org; Fri, 30 Oct 2015 09:57:44 +0100
Received: from coffee.modeemi.fi ([130.230.72.140])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2015 09:57:44 +0100
Received: from flux-btrfs by coffee.modeemi.fi with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2015 09:57:44 +0100
To: linux-btrfs@vger.kernel.org
From: Erkki Seppala <flux-btrfs@inside.org>
Subject: Re: BTRFS BUG at insert_inline_extent_backref+0xe3/0xf0 while rebalancing
Date: Fri, 30 Oct 2015 10:57:35 +0200
Message-ID: <m49a8r0buo0.fsf@coffee.modeemi.fi>
References: <m49lhavbh8n.fsf@coffee.modeemi.fi>
	<CAL3q7H5+BnHoDw3heasPpRw_kXv=rZdOYYFgtj8N39rAjWiY1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Filipe Manana <fdmanana@gmail.com> writes:
> Try this (just sent a few minutes ago):
> https://patchwork.kernel.org/patch/7463161/

I've been using this patch for a week now, doing two rebalances a day
(one per file system) - no problem so far. Thanks!

Probably unrelated to this I did experience one reboot without any
trace, possibly because I had enabled panic = 10 and panic_on_oops = 1,
but that event did not happen anytime near a balance was happening. I
wonder if the hang detector could trigger that configuration to reboot?

Thanks again for the great work, your detective work is always
impressive :).

-- 
  _____________________________________________________________________
     / __// /__ ____  __               http://www.modeemi.fi/~flux/\   \
    / /_ / // // /\ \/ /                                            \  /
   /_/  /_/ \___/ /_/\_\@modeemi.fi                                  \/

