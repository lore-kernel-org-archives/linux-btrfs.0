Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60521 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065AbaHLQi0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Aug 2014 12:38:26 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XHF5c-0007dr-R5
	for linux-btrfs@vger.kernel.org; Tue, 12 Aug 2014 18:38:24 +0200
Received: from coffee.modeemi.fi ([130.230.72.140])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Aug 2014 18:38:24 +0200
Received: from flux-btrfs by coffee.modeemi.fi with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Aug 2014 18:38:24 +0200
To: linux-btrfs@vger.kernel.org
From: Erkki Seppala <flux-btrfs@inside.org>
Subject: Re: Ideas for a feature implementation
Date: Tue, 12 Aug 2014 19:38:14 +0300
Message-ID: <m49mwb9ek95.fsf@coffee.modeemi.fi>
References: <1407698476.20187.YahooMailNeo@web192906.mail.sg3.yahoo.com>
	<53E83035.8010603@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn <ahferroin7@gmail.com> writes:

> Another thing that isn't listed there, that I would personally love to
> see is support for secure file deletion.

As discussed in the followups, it is difficult to do a really secure
deletion and a security-conscious person would opt to use encryption
instead. Ability to encrypt subvolumes or files would probably serve
those needs sufficiently, though it sounds like it could easily be a
longer task than 4 months.

-- 
  _____________________________________________________________________
     / __// /__ ____  __               http://www.modeemi.fi/~flux/\   \
    / /_ / // // /\ \/ /                                            \  /
   /_/  /_/ \___/ /_/\_\@modeemi.fi                                  \/

