From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Subject: Re: Introduce option to rebalance only metadata
Date: Wed, 16 Nov 2011 01:17:05 -0200
Message-ID: <ory5vgpxhq.fsf@livre.localdomain>
References: <orr51fpxyv.fsf@livre.localdomain>
	<20111110194307.GL28749@carfax.org.uk>
	<20111115094004.GC8597@zambezi.lan>
	<20111115094535.GD8597@zambezi.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
To: Ilya Dryomov <idryomov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111115094535.GD8597@zambezi.lan> (Ilya Dryomov's message of
	"Tue, 15 Nov 2011 11:45:35 +0200")
List-ID: <linux-btrfs.vger.kernel.org>

On Nov 15, 2011, Ilya Dryomov <idryomov@gmail.com> wrote:

> And the exact command to mimic your patch is

> btrfs fi restripe start -m <mount point>

Thanks.  I wasn't aware of the restripe patch when I wrote this Quick
Hack (TM).

-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer
