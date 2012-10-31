Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from loup.kjorling.se ([87.237.208.114]:51211 "EHLO loup.kjorling.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932448Ab2JaKz2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Oct 2012 06:55:28 -0400
Date: Wed, 31 Oct 2012 10:55:03 +0000
From: Michael =?utf-8?B?S2rDtnJsaW5n?= <michael@kjorling.se>
To: Ahmet Inan <ainan@mathematik.uni-freiburg.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Why btrfs inline small file by default?
Message-ID: <20121031105503.GA26070@yeono.kjorling.se>
References: <508FC26A.1010206@pepinghege.net>
 <CAE5mzvhkrV9XD3_X_w_eLk7R4jrf4PxhEBJYTU7Hr6YtFDDd6Q@mail.gmail.com>
 <50904949.8010603@gmail.com>
 <20121030221412.GB11422@carfax.org.uk>
 <20121030221947.GC11422@carfax.org.uk>
 <50906702.1010608@gmail.com>
 <CAE5mzvgMskhBgH506BageXREifs63Zn_HKDaWBMuesS8Np66SQ@mail.gmail.com>
 <CAFDW0j+1wx2_ZewQ69W7fyLuMyYxq29g62FGH5uX9kAFv-H3eQ@mail.gmail.com>
 <CAE5mzvgRqTC+zismMUt0AOYWP52EN9taowARqU=he1cmVMSTEQ@mail.gmail.com>
 <CAFDW0jLGFwrg-9GDoBUxHa6M0ZgjB4W4GJg3b88+6L-dGLJMUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAFDW0jLGFwrg-9GDoBUxHa6M0ZgjB4W4GJg3b88+6L-dGLJMUw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 31 Oct 2012 11:48 +0100, from ainan@mathematik.uni-freiburg.de (Ahmet Inan):
>>> i also dont see any benefit from inlining small files:
> 
>>> with defaults (inlining small files):
>>> real    4m39.253s
>>> Data: total=10.01GB, used=9.08GB
>>> Metadata, DUP: total=2.00GB, used=992.48MB

This uses 10290.40 MB total, if we pad with zeroes (9.08GB plus
992.48MB).


>>> without inline:
>>> real    4m42.085s
>>> Data: total=11.01GB, used=10.85GB
>>> Metadata, DUP: total=1.00GB, used=518.59MB

Under the same assumption, this uses 11628.99 MB total (10.85GB +
518.59MB).


>> I suggest you take a closer look at your numbers.
> 
> both use 12GiB in total and both need 280 seconds.
> am i missing something?

With inlining, you're using about 1.3 GB less disk space and require a
few seconds less wall-clock time for the same thing. A 10% difference
in storage space requirement does not seem like "no benefit" to me,
and both sets of numbers favor the default (with inlining).

-- 
Michael Kjörling • http://michael.kjorling.se • michael@kjorling.se
                “People who think they know everything really annoy
                those of us who know we don’t.” (Bjarne Stroustrup)
