Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from loup.kjorling.se ([87.237.208.114]:55800 "EHLO loup.kjorling.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757665Ab2J3Jn0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Oct 2012 05:43:26 -0400
Date: Tue, 30 Oct 2012 09:42:53 +0000
From: Michael =?utf-8?B?S2rDtnJsaW5n?= <michael@kjorling.se>
To: Goffredo Baroncelli <kreijack@gmail.com>
Cc: kreijack@inwind.it, linux-btrfs@vger.kernel.org,
        cwillu <cwillu@cwillu.com>, Martin Steigerwald <Martin@lichtvoll.de>,
        Chris Murphy <lists@colorremedies.com>,
        Hugo Mills <hugo@carfax.org.uk>
Subject: Re: [RFC][V2] New attempt to a better "btrfs fi df"
Message-ID: <20121030094253.GA20662@yeono.kjorling.se>
References: <50899151.1070503@inwind.it>
 <508F015F.5090507@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <508F015F.5090507@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 29 Oct 2012 23:21 +0100, from kreijack@gmail.com (Goffredo Baroncelli):
> Hi all,
> 
> this is a new attempt to improve the output of the command "btrfs fi df".
> 
> The previous attempt received a good reception. However there was no a
> general consensus about the wording.

In general, I like it. And I think that especially with today's large
terminals (with frame buffers and X11), one doesn't need to be too
fixated at an 80 column terminal width.

One thing, though; what is the difference between "unused" and
"unallocated"? If there is no difference, I feel the same word should
be used throughout.

-- 
Michael Kjörling • http://michael.kjorling.se • michael@kjorling.se
                “People who think they know everything really annoy
                those of us who know we don’t.” (Bjarne Stroustrup)
