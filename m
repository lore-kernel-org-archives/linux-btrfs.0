From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/4] md: Factor out RAID6 algorithms into lib/
Date: Sun, 19 Jul 2009 22:21:36 -0700
Message-ID: <4A63FEE0.9090103@zytor.com>
References: <1247494302.19180.268.camel@macbook.infradead.org>	 <4A608913.1060808@redhat.com> <4A6096A0.5050501@zytor.com>	 <4A609A52.7070506@redhat.com> <4A609B72.2010901@zytor.com>	 <4A609CFA.2060707@redhat.com> <4A609D8D.8050501@zytor.com>	 <1247918016.22313.138.camel@macbook.infradead.org>	 <e9c3a7c20907180926v8ed6cdew2666086888be0d3b@mail.gmail.com>	 <alpine.LFD.2.00.0907181937140.25615@twosheds.infradead.org>	 <e9c3a7c20907181304w18738febn4e5ab380d10bef4b@mail.gmail.com> <1248026647.5646.36.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Dan Williams <dan.j.williams@intel.com>,
	Ric Wheeler <rwheeler@redhat.com>, chris.mason@oracle.com,
	linux-btrfs@vger.kernel.org, neilb@suse.de,
	linux-raid@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1248026647.5646.36.camel@macbook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

David Woodhouse wrote:
> 
> At this point we've actually implemented the fundamental parts of
> RAID[56] support in btrfs, and it's looking like all we really want is
> the arithmetic routines.
> 

Given that you have no legacy requirements, and that supporting more
than two disks may be interesting, it may very well be worth spending
some time at new codes now rather than later.  Part of that
investigation, though, is going to have to be if and how they can be
accelerated.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

