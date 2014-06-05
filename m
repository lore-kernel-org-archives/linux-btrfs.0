Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58470 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbaFEIPK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Jun 2014 04:15:10 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WsSpE-00039D-JX
	for linux-btrfs@vger.kernel.org; Thu, 05 Jun 2014 10:15:04 +0200
Received: from coffee.modeemi.fi ([130.230.72.140])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Jun 2014 10:15:04 +0200
Received: from flux-btrfs by coffee.modeemi.fi with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Jun 2014 10:15:04 +0200
To: linux-btrfs@vger.kernel.org
From: Erkki Seppala <flux-btrfs@inside.org>
Subject: Re: Very slow filesystem
Date: Thu, 05 Jun 2014 11:12:03 +0300
Message-ID: <m491tv3hj1o.fsf@coffee.modeemi.fi>
References: <CAEezp7uMXA3t8-GDVcVzx9An+hPBZmynYZ-wUXzhJuP93czs1w@mail.gmail.com>
	<m498upbhj8f.fsf@coffee.modeemi.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Erkki Seppala <flux-btrfs@inside.org> writes:

> If the number is hitting your seek rate (ie. 1/0.0075 for 7.5 ms seek =
> 133), then fragmentation is sure to be blamed.

Actually the number may very well be off by at least a factor of two (I
tested that my device did 400 tps when I expected 200; perhaps bulk
transfers cause more transactions than I expect), but it should be in
the ballpark I think :).

-- 
  _____________________________________________________________________
     / __// /__ ____  __               http://www.modeemi.fi/~flux/\   \
    / /_ / // // /\ \/ /                                            \  /
   /_/  /_/ \___/ /_/\_\@modeemi.fi                                  \/

