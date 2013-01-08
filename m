Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:44689 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab3AHBRL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Jan 2013 20:17:11 -0500
Date: Mon, 7 Jan 2013 20:17:09 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: David Sterba <dsterba@suse.cz>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [bug] csum mismatches and failed xfstests with 3.8-rc1 and rc2
Message-ID: <20130108011709.GA5535@shiny>
References: <20130104125059.GE20089@twin.jikos.cz>
 <20130107170351.GM20089@twin.jikos.cz>
 <20130107170640.GN20089@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130107170640.GN20089@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 07, 2013 at 10:06:40AM -0700, David Sterba wrote:
> On Mon, Jan 07, 2013 at 06:03:51PM +0100, David Sterba wrote:
> > with top commit 5f243b9b46a22e5790dbbc36f574c2417af49a41 (something post
> > -rc2) I see more checksum errors
> >
> > $ dmesg|grep csum|wc -l
> > 100
> 
> more of dmesg:

I think Josef tracked this down to some enospc problems during truncate.
Looks like it isn't a regression, just harder to hit now.  We'll try and
confirm tomorrow.

-chris
