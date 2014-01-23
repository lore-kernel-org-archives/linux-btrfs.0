Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60369 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbaAWQAh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jan 2014 11:00:37 -0500
Date: Thu, 23 Jan 2014 17:00:35 +0100
From: David Sterba <dsterba@suse.cz>
To: George Eleftheriou <eleftg@gmail.com>
Cc: Ian Hinder <ian.hinder@aei.mpg.de>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs and ECC RAM
Message-ID: <20140123160035.GO6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <AE93F05D-BEE7-4CE6-970E-137EA41D1C7B@aei.mpg.de>
 <CAPpBBdNfxchPw0DCLxNNoFZc5jGec88Q5j0C-uGy88oae0TDiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAPpBBdNfxchPw0DCLxNNoFZc5jGec88Q5j0C-uGy88oae0TDiw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 20, 2014 at 01:17:08AM +0100, George Eleftheriou wrote:
> Without having further knowledge on that matter, I tend to believe
> (but I hope I'm wrong) that BTRFS is as vulnerable as ZFS to memory
> errors. Since I upgraded recently, it's a bit too late for purchasing
> ECC-capable infrastructure (change of CPU + motherboard + RAM) so I
> just chose to ignore this risk by performing a memtest86 right before
> every scrub (and having my regular backups ready).

Also, I haven't seen it mentioned in the thread, scrub can also run in
read-only mode:

  $ btrfs scrub start -r /mnt

so you can do a safe RO pass before a RW one and examine the reported
problems before they get fixed automatically.
