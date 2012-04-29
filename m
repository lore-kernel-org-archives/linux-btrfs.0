From: tsuna <tsunanet@gmail.com>
Subject: Re: Ceph on btrfs 3.4rc
Date: Sun, 29 Apr 2012 14:09:54 -0700
Message-ID: <CAFKYj4d2YvpttC-Z58-MY0ZC4tug3bQft-9z8_RRrrmJAm2T8A@mail.gmail.com>
References: <CAJafhzSVZ3+1ApgJU=sQu6gM62BeWVGG4mqFPNYRHx79czYJtQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org
To: Christian Brunner <christian@brunner-muc.de>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <CAJafhzSVZ3+1ApgJU=sQu6gM62BeWVGG4mqFPNYRHx79czYJtQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 20, 2012 at 8:09 AM, Christian Brunner
<christian@brunner-muc.de> wrote:
> After running ceph on XFS for some time, I decided to try btrfs again.
> Performance with the current "for-linux-min" branch and big metadata
> is much better.

I've heard that although performance from btrfs is better at first, it
degrades over time due to metadata fragmentation, whereas XFS'
performance starts off a little worse, but remains stable even after
weeks of heavy utilization.  Would be curious to hear your (or
others') feedback on that topic.

-- 
Benoit "tsuna" Sigoure
Software Engineer @ www.StumbleUpon.com
