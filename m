Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9891 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753949Ab3LPPSK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 10:18:10 -0500
From: Chris Mason <clm@fb.com>
To: "hkbakke@gmail.com" <hkbakke@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Blocket for more than 120 seconds
Date: Mon, 16 Dec 2013 15:18:06 +0000
Message-ID: <1387207097.18897.6.camel@ret.masoncoding.com>
References: <CAD_cGvFdrhwC2erqYTMjPRG7Y=69tsT2O+S-GHYK7+wpBwFSFQ@mail.gmail.com>
	 <46A0D70E-99DF-46FE-A4E8-71E9AC45129F@colorremedies.com>
	 <CAD_cGvHkpkuveYFKm4kjgc0SkJ=mQ4mpChes0F25fdjc5r3PmQ@mail.gmail.com>
	 <337E6C9D-298E-4F77-91D7-648A7C65D360@colorremedies.com>
	 <CAD_cGvGLHgHagW-G5Qz1yXY4w14BBiZsJj3K0-FmjEGzoo-_rw@mail.gmail.com>
	 <840381F8-BDCA-43BF-A170-6E10C2908B8A@colorremedies.com>
	 <CAD_cGvF8-pxXXvwpB+yNYnKRW09S4c0VuKUGiWa7=8C2uFkvqA@mail.gmail.com>
In-Reply-To: <CAD_cGvF8-pxXXvwpB+yNYnKRW09S4c0VuKUGiWa7=8C2uFkvqA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2013-12-15 at 03:35 +0100, Hans-Kristian Bakke wrote:
> I have done some more testing. I turned off everything using the disk
> and only did defrag. I have created a script that gives me a list of
> the files with the most extents. I started from the top to improve the
> fragmentation of the worst files. The most fragmentet file was a file
> of about 32GB with over 250 000 extents!
> It seems that I can defrag a two to three largish (15-30GB) ~100 000
> extents files just fine, but after a while the system locks up (not a
> complete hard lock, but everythings hangs and a restart is necessary
> to get a fully working system again)
> 
> It seems like defrag operations is triggering the issue. Probably in
> combination with the large and heavily fragmentet files.
> 

I'm trying to understand how defrag factors into your backup workload?
Do you have autodefrag on, or are you running a defrag as part of the
backup when you see these stalls?

If not, we're seeing a different problem.

-chris

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
