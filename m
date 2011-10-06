From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH v0 07/18] btrfs: generic data structure to build unique lists
Date: Fri, 7 Oct 2011 00:19:06 +0200
Message-ID: <20111006221906.GC17912@twin.jikos.cz>
References: <cover.1317915010.git.sensille@gmx.net> <3a697c3e44dd5955c167f2f548ee4ced1e3dabef.1317915010.git.sensille@gmx.net> <m2y5wx3loj.fsf@firstfloor.org>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arne Jansen <sensille@gmx.net>, chris.mason@oracle.com,
	linux-btrfs@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m2y5wx3loj.fsf@firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 06, 2011 at 01:33:00PM -0700, Andi Kleen wrote:
> Arne Jansen <sensille@gmx.net> writes:
> 
> > ulist is a generic data structures to hold a collection of unique u64
> > values. The only operations it supports is adding to the list and
> > enumerating it.
> > It is possible to store an auxiliary value along with the key.
> > The implementation is preliminary and can probably be sped up
> > significantly.
> > It is used by subvolume quota to translate recursions into iterative
> > loops.
> 
> Hmm, sounds like a job for lib/idr.c 
> 
> What do your ulists do that idr doesn't?

Arne's ulists keep full u64 values, IDR are int based.


david
