Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:39395 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935344Ab2JaLKo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Oct 2012 07:10:44 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so1827144iea.19
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Oct 2012 04:10:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121031105503.GA26070@yeono.kjorling.se>
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
	<20121031105503.GA26070@yeono.kjorling.se>
Date: Wed, 31 Oct 2012 12:10:44 +0100
Message-ID: <CAFDW0jLQV+jDzny-ejgKO+8jx0ELi3YR_+bK_4zEgE-tQb2pGA@mail.gmail.com>
Subject: Re: Why btrfs inline small file by default?
From: Ahmet Inan <ainan@mathematik.uni-freiburg.de>
To: =?UTF-8?Q?Michael_Kj=C3=B6rling?= <michael@kjorling.se>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>>>> with defaults (inlining small files):
>>>> real    4m39.253s
>>>> Data: total=10.01GB, used=9.08GB
>>>> Metadata, DUP: total=2.00GB, used=992.48MB
>
> This uses 10290.40 MB total, if we pad with zeroes (9.08GB plus
> 992.48MB).

>>>> without inline:
>>>> real    4m42.085s
>>>> Data: total=11.01GB, used=10.85GB
>>>> Metadata, DUP: total=1.00GB, used=518.59MB
>
> Under the same assumption, this uses 11628.99 MB total (10.85GB +
> 518.59MB).

> With inlining, you're using about 1.3 GB less disk space and require a
thank you for clarifying this. 10% is indeed a benefit.

> few seconds less wall-clock time for the same thing.
those where only 2 tests, have to make a lot more runs
to make qualified judgement there.
one percent difference is noise floor to me.

Ahmet
