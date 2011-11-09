From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PULL] Btrfs pull request
Date: Wed, 9 Nov 2011 02:48:47 -0500
Message-ID: <20111109074847.GA16742@infradead.org>
References: <20111106183851.GA4339@shiny>
 <CAK-xaQau04whLQm0Fz-fkCZ1AumLs84UiqGi0Rc=GZUzRvV7Gg@mail.gmail.com>
 <4EB7A6CC.5030502@gmx.net>
 <CAK-xaQbvpZQzPVxunSEVDzTXXzQ2HaQWHVR3BwR1iq95URWEdw@mail.gmail.com>
 <4EB7D2D8.2060505@gmx.net>
 <CAK-xaQbmY2Z3OJyQ211cUQn0CM2ho2U+UgpRKK9bUzxhEu6hzQ@mail.gmail.com>
 <4EB8DEAC.7000906@gmx.net>
 <20111109010701.GI4149@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>,
	Arne Jansen <sensille@gmx.net>,
	Andrea Gelmini <andrea.gelmini@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111109010701.GI4149@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 08, 2011 at 08:07:01PM -0500, Chris Mason wrote:
> Looks like bio_add_page() is failing and we're getting the enomem from
> there.  LVM is only letting us put one page in each bio.

Yes, at the moment all bio based DM targets only allow single page I/O.
