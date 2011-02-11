From: Milan Broz <mbroz@redhat.com>
Subject: Re: LOOP_GET_STATUS(64) truncates pathnames to 64 chars (was Re:
 Bug in mkfs.btrfs?!)
Date: Fri, 11 Feb 2011 20:31:51 +0100
Message-ID: <4D558EA7.2070707@redhat.com>
References: <20110122144513.GA2539@scooter>	<20110122145222.GB2539@scooter>	<20110122151124.GC29985@carfax.org.uk>	<20110122155612.GA3664@scooter>	<20110123181827.GF29985@carfax.org.uk>	<4D3CA568.7050506@libero.it>	<20110124130104.GA7354@scooter>	<4D3E160F.4050006@csamuel.org>	<20110210122927.GB20488@foxbat.suse.cz>	<20110211130412.GA2591@scooter>	<4D55870C.8020805@redhat.com> <AANLkTi=Arg-09F0DXsWNhsYgyPar=rKs7G_OQG2uMm4f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Samuel <chris@csamuel.org>, kreijack@inwind.it,
	Hugo Mills <hugo-lkml@carfax.org.uk>,
	linux-btrfs@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
To: Felix Blanke <felixblanke@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=Arg-09F0DXsWNhsYgyPar=rKs7G_OQG2uMm4f@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/11/2011 08:23 PM, Felix Blanke wrote:
> What do you mean with "configured"?
> 
> I'm using loop devices with loop aes, and I've looked into /sys for a device which is actually in use.

Ehm. It is really Loop-AES?

Then ask author to backport it there, Loop-AES is not mainline code.
He usually replaces the whole upstream loop implementation with old patched version.

Milan
