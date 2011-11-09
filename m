From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Btrfs pull request
Date: Tue, 8 Nov 2011 20:07:01 -0500
Message-ID: <20111109010701.GI4149@shiny>
References: <20111106183851.GA4339@shiny>
 <CAK-xaQau04whLQm0Fz-fkCZ1AumLs84UiqGi0Rc=GZUzRvV7Gg@mail.gmail.com>
 <4EB7A6CC.5030502@gmx.net>
 <CAK-xaQbvpZQzPVxunSEVDzTXXzQ2HaQWHVR3BwR1iq95URWEdw@mail.gmail.com>
 <4EB7D2D8.2060505@gmx.net>
 <CAK-xaQbmY2Z3OJyQ211cUQn0CM2ho2U+UgpRKK9bUzxhEu6hzQ@mail.gmail.com>
 <4EB8DEAC.7000906@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrea Gelmini <andrea.gelmini@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4EB8DEAC.7000906@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 08, 2011 at 08:47:56AM +0100, Arne Jansen wrote:
> On 07.11.2011 13:50, Andrea Gelmini wrote:
> > 2011/11/7 Arne Jansen <sensille@gmx.net>:
> >> is it 32 or 64 bit?
> > 
> > 64bit.
> > Please take a look at my other reply.
> 
> Can you please have a look with strace to make sure it's
> really the ioctl the ENOMEM originates froM?

Looks like bio_add_page() is failing and we're getting the enomem from
there.  LVM is only letting us put one page in each bio.

-chris
