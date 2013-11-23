Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:50426 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab3KWHzK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Nov 2013 02:55:10 -0500
MIME-Version: 1.0
In-Reply-To: <20131120222903.GA3654@lazy.lzy>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>
	<20131120222903.GA3654@lazy.lzy>
Date: Sat, 23 Nov 2013 08:55:08 +0100
Message-ID: <CAGKKSfUejP=pb6HHF-48ciu5GSSd_ZCZMXHyL6iHLcQHvDs8yQ@mail.gmail.com>
Subject: Re: Triple parity and beyond
From: Andrea Mazzoleni <amadvance@gmail.com>
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        David Brown <david.brown@hesbynett.no>,
        David Smith <creamyfish@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Piergiorgio,

> How about par2? How does this work?
I checked the matrix they use, and sometimes it contains some singular
square submatrix.
It seems that in GF(2^16) these cases are just less common. Maybe they
were just unnoticed.

Anyway, this seems to be an already known problem for PAR2, with an
hypothetical PAR3 fixing it:

http://sourceforge.net/p/parchive/discussion/96282/thread/d3c6597b/

Ciao,
Andrea
