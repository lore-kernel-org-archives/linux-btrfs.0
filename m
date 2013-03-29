Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:55141 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956Ab3C2NXO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Mar 2013 09:23:14 -0400
Message-ID: <515595B9.9080802@petaramesh.org>
Date: Fri, 29 Mar 2013 14:23:05 +0100
From: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: scrub "correcting" tons of errors ?
References: <515563D7.3020706@petaramesh.org> <20130329125832.GB1876@localhost.localdomain> <515591D9.5010802@petaramesh.org> <20130329131218.GC1876@localhost.localdomain>
In-Reply-To: <20130329131218.GC1876@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 29/03/2013 14:12, Josef Bacik a écrit :
> Screenshots are welcome, 

I posted one to http://dl.free.fr/jsRQ8JXZh (use your email address or
the list's one to fetch it)

It may or may not be very interesting, but that's all I got.

> I have no doubt scrub is fixing actual problems
Looks like it actually is. First times it hanged, I restarted it from
the start and it wasn't finding errors during the first GBs anymore, so
I assumed it has fixed them in the previous pass (even though it
eventually crashed the disk susbsystem).

> , but it
> definitely shouldn't be hanging the box so I'd like to get those fixed if
> possible.  Sysrq+w during hangs are very usefull but may be too much output for
> screenshots, netconsole works very nicely for this

I'll restart the complete scrub (now everything is supposedly fixed...?)
and let you know if it hangs agan and I can put the hand on something.

Kind regards.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

