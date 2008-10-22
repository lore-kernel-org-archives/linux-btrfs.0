From: jim owens <jowens@hp.com>
Subject: Re: Some very basic questions
Date: Wed, 22 Oct 2008 12:56:47 -0400
Message-ID: <48FF5B4F.5090807@hp.com>
References: <20081021132322.271ad728.skraw@ithnet.com>	 <48FDD710.5050702@hp.com> <20081021190136.89b2c6af.skraw@ithnet.com>	 <20081021171513.GA8799@infradead.org> <48FE11F9.7040700@gmail.com>	 <20081022142759.ac33a16c.skraw@ithnet.com>	 <1224681345.6448.4.camel@think.oraclecorp.com>	 <20081022155221.e147a36b.skraw@ithnet.com> <f224c6140810220856k5ff653ccv194db074dc482523@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Stephan von Krawczynski <skraw@ithnet.com>,
	linux-btrfs@vger.kernel.org
To: Michel Salim <michel.sylvan@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <f224c6140810220856k5ff653ccv194db074dc482523@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Michel Salim wrote:
> 
> Though it would be nice to have a tool that would provide enough
> information to make a warranty claim -- does btrfs keep enough
> information for such a tool to be written?

Failed device I/O (rather than bad checksums and other
fs-specific error detections) should be logged at a lower
layer in the standard system logs.

Warranties are really about who you buy your drives from,
if you go cheap don't expect any replacements.  If you buy
quality stuff, the failures usually occur right after
the warranty expires :)  In the case of bad manufacturing
batches, the good vendors figure that out real fast and
don't hassle you about replacing them as they fail.

And even from a good vendor, don't expect you can run
a drive with a 1-year 20% duty-cycle warranty like
it was a 100% duty-cycle drive and get the vendor
to replace them if they fail in < 1 year.  People often
complain the vendor does not stand behind the warranty
when they are really badly violating the usage terms.

jim
