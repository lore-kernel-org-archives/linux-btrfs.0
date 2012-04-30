From: Christian Brunner <christian@brunner-muc.de>
Subject: Re: Ceph on btrfs 3.4rc
Date: Mon, 30 Apr 2012 12:28:08 +0200
Message-ID: <CAJafhzT8D9Hk0atMRWQpCK5Gr_=O+XqMEkPKQzCr351Gf+v3_Q@mail.gmail.com>
References: <CAJafhzSVZ3+1ApgJU=sQu6gM62BeWVGG4mqFPNYRHx79czYJtQ@mail.gmail.com>
	<CAFKYj4d2YvpttC-Z58-MY0ZC4tug3bQft-9z8_RRrrmJAm2T8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org
To: tsuna <tsunanet@gmail.com>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <CAFKYj4d2YvpttC-Z58-MY0ZC4tug3bQft-9z8_RRrrmJAm2T8A@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2012/4/29 tsuna <tsunanet@gmail.com>:
> On Fri, Apr 20, 2012 at 8:09 AM, Christian Brunner
> <christian@brunner-muc.de> wrote:
>> After running ceph on XFS for some time, I decided to try btrfs agai=
n.
>> Performance with the current "for-linux-min" branch and big metadata
>> is much better.
>
> I've heard that although performance from btrfs is better at first, i=
t
> degrades over time due to metadata fragmentation, whereas XFS'
> performance starts off a little worse, but remains stable even after
> weeks of heavy utilization. =A0Would be curious to hear your (or
> others') feedback on that topic.

Metadata fragmentation was a big problem (for us) in the past. With
the "big metatdata feature" (mkfs.btrfs -l 64k -n 64k) these problems
seem to be solved. We do not use it in production yet, but my stress
test didn't show any degradation. The only remaining issues I've seen
are these warnings.

Regards,
Christian
--
To unsubscribe from this list: send the line "unsubscribe ceph-devel" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
