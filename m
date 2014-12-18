Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45138 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbaLRRn3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Dec 2014 12:43:29 -0500
Date: Thu, 18 Dec 2014 18:43:27 +0100
From: David Sterba <dsterba@suse.cz>
To: Merlijn Wajer <merlijn@wizzup.org>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [RFC] btrfs-progs: Support for musl libc (and perhaps also
 uclibc)
Message-ID: <20141218174326.GF27601@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <548C4E9D.2080309@wizzup.org>
 <20141217164924.GB27601@twin.jikos.cz>
 <5492AC94.8050104@wizzup.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5492AC94.8050104@wizzup.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 18, 2014 at 11:29:40AM +0100, Merlijn Wajer wrote:
> That is fine; at this point there are not a lot of people using an
> alternative libc, so this is common practice. I'll be here with a new
> round of patches if it breaks in a future release; it shouldn't really
> break too often. :)

Good. I've put the patches to 3.18 queue.
