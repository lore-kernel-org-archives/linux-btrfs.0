From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/4] md: Factor out RAID6 algorithms into lib/
Date: Wed, 29 Jul 2009 11:16:49 -0700
Message-ID: <4A709211.3080408@zytor.com>
References: <1247494302.19180.268.camel@macbook.infradead.org> <e9c3a7c20907151223j1d976ea9gdd224c9e6c2c36e3@mail.gmail.com> <4A5F6590.9000006@zytor.com> <4A608913.1060808@redhat.com> <4A6096A0.5050501@zytor.com> <4A609A52.7070506@redhat.com> <4A609B72.2010901@zytor.com> <4A609CFA.2060707@redhat.com> <4A609D8D.8050501@zytor.com> <4A609FA0.7060404@redhat.com> <h3qhmp$3di$1@ger.gmane.org> <h3qhri$3di$2@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Alex Elsayed <eternaleye@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <h3qhri$3di$2@ger.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

>>
>> http://www.cs.utk.edu/~plank/plank/papers/CS-96-332.html even describes an 
>> implementation _very_ similar to the current code, right down to using a 
>> table for the logarithm and inverse logarithm calculations.
>>

We don't use a table for logarithm and inverse logarithm calculations.
Any time you do a table lookup you commit suicide from a performance
standpoint.

	-hpa

