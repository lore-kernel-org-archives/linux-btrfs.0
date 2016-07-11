Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42248 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbcGKKUi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jul 2016 06:20:38 -0400
Date: Mon, 11 Jul 2016 12:20:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger@applied-asynchrony.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, Wang Shilong <wangshilong1991@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] btrfs-progs: du: fix to skip not btrfs dir/file
Message-ID: <20160711102049.GT13336@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1467807934-23403-1-git-send-email-wangshilong1991@gmail.com>
 <577D091F.6020407@applied-asynchrony.com>
 <CAP9B-QkSBGBLbcHfBCR_zg6fVntmyLUpZ1yEfRsWiAYnFo8Hew@mail.gmail.com>
 <20160706152027.GM10223@carfax.org.uk>
 <577D26E9.50607@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <577D26E9.50607@applied-asynchrony.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 06, 2016 at 05:42:33PM +0200, Holger Hoffstätte wrote:
> >    At the absolute minimum, I think that these messages should go to
> > stderr (like du does when it deosn't have permissions), and should go
> > away with -q. They're still irritating, but at least you can get rid
> > of them easily.
> 
> If anything this should require a --verbose, not the other way
> around. Maybe instead of breaking the output just indicate the
> special status via "-- --" values, or default to 0.00?

The '--' replacement values sound good to me (0.00 would be confusing).

> Still, we're explicitly only interested in btrfs stuff and not
> anything else, so printing non-information can only yield noise.

I think the extra lines would happen mostly in scenario where
directories are mountpoints and thus have a potentially different
filesystem. If we print just a single line for a mountpoint (and not
descend to it), I don't think it will create that much noise in the
output.
