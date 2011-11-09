From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Btrfs pull request
Date: Wed, 9 Nov 2011 07:11:55 -0500
Message-ID: <20111109121155.GJ4149@shiny>
References: <20111106183851.GA4339@shiny>
 <CAK-xaQau04whLQm0Fz-fkCZ1AumLs84UiqGi0Rc=GZUzRvV7Gg@mail.gmail.com>
 <4EB7A6CC.5030502@gmx.net>
 <CAK-xaQbvpZQzPVxunSEVDzTXXzQ2HaQWHVR3BwR1iq95URWEdw@mail.gmail.com>
 <4EB7D2D8.2060505@gmx.net>
 <CAK-xaQbmY2Z3OJyQ211cUQn0CM2ho2U+UgpRKK9bUzxhEu6hzQ@mail.gmail.com>
 <4EB8DEAC.7000906@gmx.net>
 <20111109010701.GI4149@shiny>
 <20111109074847.GA16742@infradead.org>
 <4EBA42AF.3000501@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Andrea Gelmini <andrea.gelmini@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4EBA42AF.3000501@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 09, 2011 at 10:06:55AM +0100, Arne Jansen wrote:
> On 09.11.2011 08:48, Christoph Hellwig wrote:
> > On Tue, Nov 08, 2011 at 08:07:01PM -0500, Chris Mason wrote:
> >> Looks like bio_add_page() is failing and we're getting the enomem from
> >> there.  LVM is only letting us put one page in each bio.
> > 
> > Yes, at the moment all bio based DM targets only allow single page I/O.
> 
> That's... unexpected. I guess this won't change with 3.3? For 3.3 I have
> to rework that part from scrub to account for Chris' bigblocks. If it can
> wait that long I'd prefer to fix both at once. Chris?

For 3.2, lets just do one page per bio and crank up the bios per device
to correspond.

-chris
