From: Arne Jansen <sensille@gmx.net>
Subject: Re: [GIT PULL] Btrfs pull request
Date: Wed, 09 Nov 2011 10:06:55 +0100
Message-ID: <4EBA42AF.3000501@gmx.net>
References: <20111106183851.GA4339@shiny> <CAK-xaQau04whLQm0Fz-fkCZ1AumLs84UiqGi0Rc=GZUzRvV7Gg@mail.gmail.com> <4EB7A6CC.5030502@gmx.net> <CAK-xaQbvpZQzPVxunSEVDzTXXzQ2HaQWHVR3BwR1iq95URWEdw@mail.gmail.com> <4EB7D2D8.2060505@gmx.net> <CAK-xaQbmY2Z3OJyQ211cUQn0CM2ho2U+UgpRKK9bUzxhEu6hzQ@mail.gmail.com> <4EB8DEAC.7000906@gmx.net> <20111109010701.GI4149@shiny> <20111109074847.GA16742@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Andrea Gelmini <andrea.gelmini@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111109074847.GA16742@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 09.11.2011 08:48, Christoph Hellwig wrote:
> On Tue, Nov 08, 2011 at 08:07:01PM -0500, Chris Mason wrote:
>> Looks like bio_add_page() is failing and we're getting the enomem from
>> there.  LVM is only letting us put one page in each bio.
> 
> Yes, at the moment all bio based DM targets only allow single page I/O.

That's... unexpected. I guess this won't change with 3.3? For 3.3 I have
to rework that part from scrub to account for Chris' bigblocks. If it can
wait that long I'd prefer to fix both at once. Chris?

-Arne
