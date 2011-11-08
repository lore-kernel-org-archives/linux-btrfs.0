From: Arne Jansen <sensille@gmx.net>
Subject: Re: [GIT PULL] Btrfs pull request
Date: Tue, 08 Nov 2011 08:47:56 +0100
Message-ID: <4EB8DEAC.7000906@gmx.net>
References: <20111106183851.GA4339@shiny> <CAK-xaQau04whLQm0Fz-fkCZ1AumLs84UiqGi0Rc=GZUzRvV7Gg@mail.gmail.com> <4EB7A6CC.5030502@gmx.net> <CAK-xaQbvpZQzPVxunSEVDzTXXzQ2HaQWHVR3BwR1iq95URWEdw@mail.gmail.com> <4EB7D2D8.2060505@gmx.net> <CAK-xaQbmY2Z3OJyQ211cUQn0CM2ho2U+UgpRKK9bUzxhEu6hzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Andrea Gelmini <andrea.gelmini@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAK-xaQbmY2Z3OJyQ211cUQn0CM2ho2U+UgpRKK9bUzxhEu6hzQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 07.11.2011 13:50, Andrea Gelmini wrote:
> 2011/11/7 Arne Jansen <sensille@gmx.net>:
>> is it 32 or 64 bit?
> 
> 64bit.
> Please take a look at my other reply.

Can you please have a look with strace to make sure it's
really the ioctl the ENOMEM originates froM?

Thanks,
Arne

> 
> Thanks a lot for your time,
> Andrea

