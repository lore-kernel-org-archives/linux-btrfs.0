Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44913 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbaBQRIW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Feb 2014 12:08:22 -0500
Date: Mon, 17 Feb 2014 18:08:20 +0100
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: cwillu <cwillu@cwillu.com>, Hugo Mills <hugo@carfax.org.uk>,
        "lin >> linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: What to do about df and btrfs fi df
Message-ID: <20140217170820.GM16073@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <52F9014F.6070901@fb.com>
 <20140210170606.GK6490@carfax.org.uk>
 <CAE5mzvgFLfQoaNx1eWB2z_kJW-pe1bFY_3LxDMV9XbtKApo=xw@mail.gmail.com>
 <52F91A4A.4080807@fb.com>
 <CAE5mzvhc0FCL81=ajAFyzHK6L1vP2uuQrjf6UfMX-vDxH+-pKQ@mail.gmail.com>
 <52F91D53.5060902@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52F91D53.5060902@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 10, 2014 at 01:41:23PM -0500, Josef Bacik wrote:
> 
> 
> On 02/10/2014 01:36 PM, cwillu wrote:
> >IMO, used should definitely include metadata, especially given that we
> >inline small files.
> >
> >I can convince myself both that this implies that we should roll it
> >into b_avail, and that we should go the other way and only report the
> >actual used number for metadata as well, so I might just plead
> >insanity here.
> >
> 
> I could be convinced to do this.  So we have
> 
> total: (total disk bytes) / (raid multiplier)
> used: (total used in data block groups) +
> 	(total used in metadata block groups)
> avail: total - (total used in data block groups +
> 		total metadata block groups)

The size of global block reserve should be IMO subtracted from 'avail',
this reports the space as free, but is in fact not.

The "used" amount of the global reserve might be included into
filesystem 'used', but I've observed the global reserve used for short
periods of time under some heavy stress, I'm convinced it needs to be
accounted in the df report.
