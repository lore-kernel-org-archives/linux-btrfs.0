Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:51630 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754135AbaBRIdX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Feb 2014 03:33:23 -0500
Received: from frosties.localnet ([149.172.224.32]) by smtp.web.de (mrweb103)
 with ESMTPSA (Nemesis) id 0Lz3FM-1XJtey3dh2-0149QH for
 <linux-btrfs@vger.kernel.org>; Tue, 18 Feb 2014 09:33:20 +0100
Date: Tue, 18 Feb 2014 09:33:17 +0100
From: Goswin von Brederlow <goswin-v-b@web.de>
To: dsterba@suse.cz, Josef Bacik <jbacik@fb.com>, cwillu <cwillu@cwillu.com>,
        Hugo Mills <hugo@carfax.org.uk>,
        "lin >> linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: What to do about df and btrfs fi df
Message-ID: <20140218083317.GA19265@frosties>
References: <52F9014F.6070901@fb.com>
 <20140210170606.GK6490@carfax.org.uk>
 <CAE5mzvgFLfQoaNx1eWB2z_kJW-pe1bFY_3LxDMV9XbtKApo=xw@mail.gmail.com>
 <52F91A4A.4080807@fb.com>
 <CAE5mzvhc0FCL81=ajAFyzHK6L1vP2uuQrjf6UfMX-vDxH+-pKQ@mail.gmail.com>
 <52F91D53.5060902@fb.com>
 <20140217170820.GM16073@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140217170820.GM16073@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 17, 2014 at 06:08:20PM +0100, David Sterba wrote:
> On Mon, Feb 10, 2014 at 01:41:23PM -0500, Josef Bacik wrote:
> > 
> > 
> > On 02/10/2014 01:36 PM, cwillu wrote:
> > >IMO, used should definitely include metadata, especially given that we
> > >inline small files.
> > >
> > >I can convince myself both that this implies that we should roll it
> > >into b_avail, and that we should go the other way and only report the
> > >actual used number for metadata as well, so I might just plead
> > >insanity here.
> > >
> > 
> > I could be convinced to do this.  So we have
> > 
> > total: (total disk bytes) / (raid multiplier)
> > used: (total used in data block groups) +
> > 	(total used in metadata block groups)
> > avail: total - (total used in data block groups +
> > 		total metadata block groups)
> 
> The size of global block reserve should be IMO subtracted from 'avail',
> this reports the space as free, but is in fact not.

How much global block reserve is there? Does that explain why I can't
use the last 270G of my 19TB btrfs?
 
> The "used" amount of the global reserve might be included into
> filesystem 'used', but I've observed the global reserve used for short
> periods of time under some heavy stress, I'm convinced it needs to be
> accounted in the df report.

As a comparison the ext2/3/4 filesystem has a % reserved for root and
does not show this in available. So you get filesystem with 0 bytes
free but root can still write to them.

I would argue that available should not include the reserve. It is not
available for normal operations, right?

MfG
	Goswin
