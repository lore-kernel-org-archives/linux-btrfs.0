From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: Don't prevent removal of devices that break raid reqs
Date: Tue, 15 Nov 2011 11:37:13 +0200
Message-ID: <20111115093713.GB8597@zambezi.lan>
References: <orvcqrpycf.fsf@livre.localdomain>
 <20111111022100.GD4435@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>,
	Alexandre Oliva <oliva@lsd.ic.unicamp.br>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111111022100.GD4435@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 10, 2011 at 09:21:00PM -0500, Chris Mason wrote:
> On Thu, Nov 10, 2011 at 05:32:48PM -0200, Alexandre Oliva wrote:
> > Instead of preventing the removal of devices that would render existing
> > raid10 or raid1 impossible, warn but go ahead with it; the rebalancing
> > code is smart enough to use different block group types.
> > 
> > Should the refusal remain, so that we'd only proceed with a
> > newly-introduced --force option or so?
> 
> Hmm, going to three devices on raid10 doesn't turn it into
> raid1.  It turns it into a degraded raid10.
> 
> We'll need a --force or some kind.  There are definitely cases users
> have wanted to do this but it is rarely a good idea ;)

I'm not sure about use cases Chris talks about, but sans those I think
we should prevent breaking raids.  If user wants to downgrade his FS he
can do that explicitly with restriper.  As for the relocation code
'smartness', we already have a confusing case where balancing silently
upgrades single to raid0.

Chris, can you describe those cases in detail so I can integrate and
align this whole thing with restriper before it's merged ?  (I added a
--force option for some of the transitions, probably best not to add
another closely related one)

Thanks,

		Ilya
