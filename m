Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41813 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755003AbcDGMCf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Apr 2016 08:02:35 -0400
Date: Thu, 7 Apr 2016 13:59:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Patrik Lundquist <patrik.lundquist@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: device stats: Print devid instead of null
Message-ID: <20160407115900.GJ3412@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1459870063-6439-1-git-send-email-patrik.lundquist@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1459870063-6439-1-git-send-email-patrik.lundquist@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 05, 2016 at 05:27:43PM +0200, Patrik Lundquist wrote:
> Print e.g. "[devid:4].write_io_errs   6" instead of
> "[(null)].write_io_errs   6" when device is missing.
> 
> Signed-off-by: Patrik Lundquist <patrik.lundquist@gmail.com>

Applied, thanks.
