Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39566 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774AbaBRQn3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Feb 2014 11:43:29 -0500
Date: Tue, 18 Feb 2014 17:43:27 +0100
From: David Sterba <dsterba@suse.cz>
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: dsterba@suse.cz, Josef Bacik <jbacik@fb.com>, cwillu <cwillu@cwillu.com>,
        Hugo Mills <hugo@carfax.org.uk>,
        "lin >> linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: What to do about df and btrfs fi df
Message-ID: <20140218164326.GH16073@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <52F9014F.6070901@fb.com>
 <20140210170606.GK6490@carfax.org.uk>
 <CAE5mzvgFLfQoaNx1eWB2z_kJW-pe1bFY_3LxDMV9XbtKApo=xw@mail.gmail.com>
 <52F91A4A.4080807@fb.com>
 <CAE5mzvhc0FCL81=ajAFyzHK6L1vP2uuQrjf6UfMX-vDxH+-pKQ@mail.gmail.com>
 <52F91D53.5060902@fb.com>
 <20140217170820.GM16073@twin.jikos.cz>
 <20140218083317.GA19265@frosties>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140218083317.GA19265@frosties>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 18, 2014 at 09:33:17AM +0100, Goswin von Brederlow wrote:
> > The size of global block reserve should be IMO subtracted from 'avail',
> > this reports the space as free, but is in fact not.
> 
> How much global block reserve is there? Does that explain why I can't
> use the last 270G of my 19TB btrfs?

The size is dynamically adjusted according to the current fs usage, but
is not larger than 512MB. I don't think it's related to the issue you
are observing.

> > The "used" amount of the global reserve might be included into
> > filesystem 'used', but I've observed the global reserve used for short
> > periods of time under some heavy stress, I'm convinced it needs to be
> > accounted in the df report.
> 
> As a comparison the ext2/3/4 filesystem has a % reserved for root and
> does not show this in available. So you get filesystem with 0 bytes
> free but root can still write to them.
> 
> I would argue that available should not include the reserve. It is not
> available for normal operations, right?

This is different from the ext2 reserve for root, it's a reserved space
for certain internal filesystem operations or as an emergency pool, eg.
when one wants to delete files from a full filesystem.
