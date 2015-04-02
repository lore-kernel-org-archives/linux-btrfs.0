Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bitfolk.com ([85.119.80.223]:41629 "EHLO mail.bitfolk.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872AbbDBJ6l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Apr 2015 05:58:41 -0400
Date: Thu, 2 Apr 2015 09:58:39 +0000
From: Andy Smith <andy@strugglers.net>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: Is this normal? Should I use scrub?
Message-ID: <20150402095839.GS4327@bitfolk.com>
References: <20150401151114.GR4327@bitfolk.com>
 <20150401154202.GD32078@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150401154202.GD32078@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Hugo,

Thanks for your help.

On Wed, Apr 01, 2015 at 03:42:02PM +0000, Hugo Mills wrote:
> On Wed, Apr 01, 2015 at 03:11:14PM +0000, Andy Smith wrote:
> > Should I run a scrub as well?
> 
>    Yes. The output you've had so far will be just the pieces that the
> FS has tried to read, and where, as a result, it's been able to detect
> the out-of-date data. A scrub will check and fix everything.

Thanks, things seem to be fine now. :)

What's the difference between "verufy" and "csum" here?

scrub status for 472ee2b3-4dc3-4fc1-80bc-5ba967069ceb
scrub device /dev/sdh (id 2) history
        scrub started at Wed Apr  1 20:05:58 2015 and finished after 14642 seconds
        total bytes scrubbed: 383.42GiB with 0 errors
scrub device /dev/sdg (id 3) history
        scrub started at Wed Apr  1 20:05:58 2015 and finished after 14504 seconds
        total bytes scrubbed: 382.62GiB with 0 errors
scrub device /dev/sdf (id 4) history
        scrub started at Wed Apr  1 20:05:58 2015 and finished after 14436 seconds
        total bytes scrubbed: 383.00GiB with 0 errors
scrub device /dev/sdk (id 5) history
        scrub started at Wed Apr  1 20:05:58 2015 and finished after 21156 seconds
        total bytes scrubbed: 1.13TiB with 14530 errors
        error details: verify=10909 csum=3621
        corrected errors: 14530, uncorrectable errors: 0, unverified errors: 0
scrub device /dev/sdj (id 6) history
        scrub started at Wed Apr  1 20:05:58 2015 and finished after 5693 seconds
        total bytes scrubbed: 119.42GiB with 0 errors
scrub device /dev/sde (id 7) history
        scrub started at Wed Apr  1 20:05:58 2015 and finished after 5282 seconds
        total bytes scrubbed: 114.45GiB with 0 errors

Cheers,
Andy
