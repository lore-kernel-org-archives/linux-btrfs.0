From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Data-deduplication?
Date: Wed, 15 Oct 2008 16:15:43 +0200
Message-ID: <20081015141543.GT12131@one.firstfloor.org>
References: <20081012020629.GA14615@bludgeon.org> <878wssswqa.fsf@basil.nowhere.org> <48F5F284.1020309@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
	Ray Van Dolson <rayvd@bludgeon.org>,
	linux-btrfs@vger.kernel.org
To: Avi Kivity <avi@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48F5F284.1020309@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 15, 2008 at 03:39:16PM +0200, Avi Kivity wrote:
> Andi Kleen wrote:
> >Ray Van Dolson <rayvd@bludgeon.org> writes:
> >
> >  
> >>I recall their being a thread here a number of months back regarding
> >>data-deduplication support for bttfs.
> >>
> >>Did anyone end up picking that up and giving a go at it?  Block level
> >>data dedup would be *awesome* in a Linux filesystem.  It does wonders
> >>for storing virtual machines w/ NetApp and WAFL, and even ZFS doesn't
> >>have this feature yet (although I've read discussions on them looking
> >>to add it).
> >>    
> >
> >There are some patches to do in QEMU's cow format for KVM. That's
> >user level only.
> >  
> 
> And thus, doesn't work for sharing between different images, especially 
> at runtime. 

It would work if the images are all based once on a reference image, won't it?
I would imagine that's the common situation for installing lots of VMs.

> I'd really, really [any number of reallies], really like to 
> see btrfs deduplication.

Sure it would be useful for a couple of things.

-Andi

-- 
ak@linux.intel.com
