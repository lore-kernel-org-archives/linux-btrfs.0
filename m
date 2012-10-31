Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:49964 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab2JaKsC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Oct 2012 06:48:02 -0400
Received: by mail-ia0-f174.google.com with SMTP id y32so909952iag.19
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Oct 2012 03:48:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAE5mzvgRqTC+zismMUt0AOYWP52EN9taowARqU=he1cmVMSTEQ@mail.gmail.com>
References: <508FB45B.9040101@gmail.com>
	<508FC26A.1010206@pepinghege.net>
	<CAE5mzvhkrV9XD3_X_w_eLk7R4jrf4PxhEBJYTU7Hr6YtFDDd6Q@mail.gmail.com>
	<50904949.8010603@gmail.com>
	<20121030221412.GB11422@carfax.org.uk>
	<20121030221947.GC11422@carfax.org.uk>
	<50906702.1010608@gmail.com>
	<CAE5mzvgMskhBgH506BageXREifs63Zn_HKDaWBMuesS8Np66SQ@mail.gmail.com>
	<CAFDW0j+1wx2_ZewQ69W7fyLuMyYxq29g62FGH5uX9kAFv-H3eQ@mail.gmail.com>
	<CAE5mzvgRqTC+zismMUt0AOYWP52EN9taowARqU=he1cmVMSTEQ@mail.gmail.com>
Date: Wed, 31 Oct 2012 11:48:01 +0100
Message-ID: <CAFDW0jLGFwrg-9GDoBUxHa6M0ZgjB4W4GJg3b88+6L-dGLJMUw@mail.gmail.com>
Subject: Re: Why btrfs inline small file by default?
From: Ahmet Inan <ainan@mathematik.uni-freiburg.de>
To: cwillu <cwillu@cwillu.com>
Cc: ching <lsching17@gmail.com>, Hugo Mills <hugo@carfax.org.uk>,
        Felix Pepinghege <postfach@pepinghege.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> i also dont see any benefit from inlining small files:

>> with defaults (inlining small files):
>> real    4m39.253s
>> Data: total=10.01GB, used=9.08GB
>> Metadata, DUP: total=2.00GB, used=992.48MB

>> without inline:
>> real    4m42.085s
>> Data: total=11.01GB, used=10.85GB
>> Metadata, DUP: total=1.00GB, used=518.59MB
>
> I suggest you take a closer look at your numbers.

both use 12GiB in total and both need 280 seconds.
am i missing something?

Ahmet
