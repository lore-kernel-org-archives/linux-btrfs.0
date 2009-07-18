From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: [PATCH 1/4] md: Factor out RAID6 algorithms into lib/
Date: Sat, 18 Jul 2009 11:50:56 -0700
Message-ID: <h3t5ig$2n2$1@ger.gmane.org>
References: <1247494302.19180.268.camel@macbook.infradead.org> <e9c3a7c20907151223j1d976ea9gdd224c9e6c2c36e3@mail.gmail.com> <4A5F6590.9000006@zytor.com> <4A608913.1060808@redhat.com> <4A6096A0.5050501@zytor.com> <4A609A52.7070506@redhat.com> <4A609B72.2010901@zytor.com> <4A609CFA.2060707@redhat.com> <4A609D8D.8050501@zytor.com> <1247918016.22313.138.camel@macbook.infradead.org> <4A61C3D9.6020200@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Cc: linux-raid@vger.kernel.org
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

H. Peter Anvin wrote:
> implementation in Java, called "Jerasure".)  Implementability using real 
> array instruction sets is key to decent performance.
Actually, it is made clear in the paper that Jerasure is written as a C 
library, and Clearsafe is the only Java implementation. Don't let the name 
fool you. ;D



