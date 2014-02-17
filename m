Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:55342 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074AbaBQJl7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Feb 2014 04:41:59 -0500
Received: from frosties.localnet ([149.172.224.32]) by smtp.web.de (mrweb103)
 with ESMTPSA (Nemesis) id 0LkyEb-1WpDpA2xAz-00aot8 for
 <linux-btrfs@vger.kernel.org>; Mon, 17 Feb 2014 10:41:57 +0100
Date: Mon, 17 Feb 2014 10:41:56 +0100
From: Goswin von Brederlow <goswin-v-b@web.de>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfsck does not fix
Message-ID: <20140217094156.GA32531@frosties>
References: <6210673.6TYUkLGl6b@merkaba>
 <52DED1C2.60103@friedels.name>
 <52F6A955.5020808@friedels.name>
 <A0A6914C-DDA5-4904-83FA-B59AA420C9C6@colorremedies.com>
 <52F73E2B.9080103@friedels.name>
 <837FAEE6-9A8E-4A88-AEDF-B9B2B3C3B618@colorremedies.com>
 <82A12D91-416E-4B2F-80ED-23ACFD466633@colorremedies.com>
 <53010EF9.60805@friedels.name>
 <21AD6EBC-FDDA-4BDE-B0B4-D6A8BBAD58F0@colorremedies.com>
 <pan$475be$cb0c1165$a3d91acc$c206709@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$475be$cb0c1165$a3d91acc$c206709@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 17, 2014 at 03:20:58AM +0000, Duncan wrote:
> Chris Murphy posted on Sun, 16 Feb 2014 12:54:44 -0700 as excerpted:
> > Also, 10 hours to balance two disks at 2.3TB seems like a long time. I'm
> > not sure if that's expected.
> 
> FWIW, I think you may not realize how big 2.3 TiB is, and/or how slow 
> spinning rust can be when dealing with TiBs of potentially fragmented 
> data...
> 
> 2.3TiB * 1024GiB/TiB * 1024 MiB/GiB / 10 hours / 60 min/hr / 60 sec/min =
> 
> 66.99... real close to 67 MiB/sec
> 
> Since it's multiple TiB we're talking and only two devices, that's almost 
> certainly spinning rust, not SSD, and on spinning rust, 67 MiB/sec really 
> isn't /that/ bad, especially if the filesystem wasn't new and had been 
> reasonably used, thus likely had some fragmentation to deal with.

Don't forget that that is 67MiB/s reading data and 67MiB/s writing
data giving a total of 134MiB/s. 

Still, on a good system each disk should have about that speed so it's
about 50% of theoretical maximum. Which is quite good given that the
disks will need to seek between every read and write. In comparison
moving data with LVM gets only about half that speed and that doesn't
even have the overhead of a filesystem to deal with.

MfG
	Goswin
