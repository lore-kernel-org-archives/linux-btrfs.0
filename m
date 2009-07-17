From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/4] md: Factor out RAID6 algorithms into lib/
Date: Fri, 17 Jul 2009 11:20:00 -0400
Message-ID: <4A6096A0.5050501@zytor.com>
References: <1247494302.19180.268.camel@macbook.infradead.org> <e9c3a7c20907151223j1d976ea9gdd224c9e6c2c36e3@mail.gmail.com> <4A5F6590.9000006@zytor.com> <4A608913.1060808@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Dan Williams <dan.j.williams@intel.com>,
	David Woodhouse <dwmw2@infradead.org>, chris.mason@oracle.com,
	linux-btrfs@vger.kernel.org, neilb@suse.de,
	linux-raid@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A608913.1060808@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Ric Wheeler wrote:
> 
> Worth sharing a pointer to a really neat set of papers that describe 
> open source friendly RAID6 and erasure encoding algorithms that were 
> presented last year and this at FAST:
> 
> http://www.cs.utk.edu/~plank/plank/papers/papers.html
> 
> If I remember correctly, James Plank's papers also have implemented and 
> benchmarked the various encodings,
> 

I have seen the papers; I'm not sure it really makes that much 
difference.  One of the things that bugs me about these papers is that 
he compares to *his* implementation of my optimizations, but not to my 
code.  In real life implementations, on commodity hardware, we're 
limited by memory and disk performance, not by CPU utilization.

	-hpa

