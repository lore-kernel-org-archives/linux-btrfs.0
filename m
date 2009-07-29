From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/4] md: Factor out RAID6 algorithms into lib/
Date: Wed, 29 Jul 2009 11:20:58 -0700
Message-ID: <4A70930A.1050006@zytor.com>
References: <1247494302.19180.268.camel@macbook.infradead.org> <e9c3a7c20907151223j1d976ea9gdd224c9e6c2c36e3@mail.gmail.com> <4A5F6590.9000006@zytor.com> <4A608913.1060808@redhat.com> <4A6096A0.5050501@zytor.com> <4A609A52.7070506@redhat.com> <4A609B72.2010901@zytor.com> <4A609CFA.2060707@redhat.com> <4A609D8D.8050501@zytor.com> <1247918016.22313.138.camel@macbook.infradead.org> <4A61C3D9.6020200@zytor.com> <h3t5ig$2n2$1@ger.gmane.org> <h3t5lm$2n2$2@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Alex Elsayed <eternaleye@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <h3t5lm$2n2$2@ger.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/18/2009 11:52 AM, Alex Elsayed wrote:
> Alex Elsayed wrote:
> 
>> H. Peter Anvin wrote:
>>> implementation in Java, called "Jerasure".)  Implementability using real 
>>> array instruction sets is key to decent performance.
>> Actually, it is made clear in the paper that Jerasure is written as a C 
>> library, and Clearsafe is the only Java implementation. Don't let the name 
>> fool you. ;D
> And again, I make a typo. s/Clearsafe/Cleversafe/.
> 

It's still their own implementation of poor quality.  That it is poor
quality shows in the numbers, which are dramatically lower than the
actual Linux implementation -- by an order of magnitude or more.  In
other words, they build a strawman and knock it down.

The actual Linux implementation blasts any of the numbers they have in
their paper, which I presume means they haven't optimized any of them.
As such, all the numbers are meaningless.

	-hpa

