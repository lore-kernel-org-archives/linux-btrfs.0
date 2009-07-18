From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/4] md: Factor out RAID6 algorithms into lib/
Date: Sat, 18 Jul 2009 13:04:55 -0700
Message-ID: <e9c3a7c20907181304w18738febn4e5ab380d10bef4b@mail.gmail.com>
References: <1247494302.19180.268.camel@macbook.infradead.org>
	 <4A608913.1060808@redhat.com> <4A6096A0.5050501@zytor.com>
	 <4A609A52.7070506@redhat.com> <4A609B72.2010901@zytor.com>
	 <4A609CFA.2060707@redhat.com> <4A609D8D.8050501@zytor.com>
	 <1247918016.22313.138.camel@macbook.infradead.org>
	 <e9c3a7c20907180926v8ed6cdew2666086888be0d3b@mail.gmail.com>
	 <alpine.LFD.2.00.0907181937140.25615@twosheds.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	Ric Wheeler <rwheeler@redhat.com>, chris.mason@oracle.com,
	linux-btrfs@vger.kernel.org, neilb@suse.de,
	linux-raid@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0907181937140.25615@twosheds.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 18, 2009 at 11:42 AM, David Woodhouse<dwmw2@infradead.org> wrote:
> On Sat, 18 Jul 2009, Dan Williams wrote:
>> I was under the impression that btrfs wanted to leverage md's stripe
>> handling logic as well, seems that is not the case?
>
> No. We do a bunch of the stuff you mention above, but entirely within the
> file system so we don't have to invent a bunch of layering violations just
> to work around a broken design.

Sure, a layering violation for an existing filesystem.  For btrfs, at
LSF'09, we briefly talked about breaking out more than just the
erasure codes from software-raid into a "libraid".  At some point in
the i/o path a btrfs stripe operation becomes indistinguishable from a
raid5,6 operation so at first glance there appears to be room to share
common infrastructure like portions of handle_stripe for example.

--
Dan
