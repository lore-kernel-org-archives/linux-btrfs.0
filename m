Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49494 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbaLERqC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Dec 2014 12:46:02 -0500
Date: Fri, 5 Dec 2014 18:46:01 +0100
From: David Sterba <dsterba@suse.cz>
To: Shriramana Sharma <samjnaa@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Possible to undo subvol delete?
Message-ID: <20141205174601.GM9754@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <547C6922.6030206@gmail.com>
 <CAH-HCWW4vUXzM6S1fCzwxdPiWHBZaf5ZNZexjRmND2WkzNK-qg@mail.gmail.com>
 <20141201184621.5dd7fcd9@natsu>
 <CAH-HCWV7mAz0cqO9r910aNa+wzufauvc_nOOpoB9ogDPdf7RsA@mail.gmail.com>
 <20141202031403.GZ17395@hungrycats.org>
 <CAH-HCWWnxqExQOexPF3jY6F1=jJA35Se5RkVw87u52F6BSic2g@mail.gmail.com>
 <20141202125610.GS12140@twin.jikos.cz>
 <CAH-HCWUm1CiapmHjy66DRKHa6NRegEW03es1DkK1SWv0159ZMw@mail.gmail.com>
 <20141203185311.GX12140@twin.jikos.cz>
 <CAH-HCWUj-3PAPDPnQcSvBm7DidzfFfiOB+v-LTOi08uTMZQaWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAH-HCWUj-3PAPDPnQcSvBm7DidzfFfiOB+v-LTOi08uTMZQaWw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 04, 2014 at 07:36:34PM +0530, Shriramana Sharma wrote:
> Well I don't know about you, but I'm just running an openSUSE 13.2
> system updated to Tumbleweed here, and even if I just hit "btrfs"
> enter (no sudo, no btrfs commands) on my regular (non-root) prompt, I
> am getting:
> 
> $ btrfs
> Absolute path to 'btrfs' is '/usr/sbin/btrfs', so running it may
> require superuser privileges (eg. root).
> $
> 
> ... so what to say of btrfs subvol, whether followed by crea or del!

Oh I see. That must be some clever shell addon that prints that if you
don't have /sbin in PATH and try to call a command from that path.
