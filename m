Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:43178 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbaHXPsO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Aug 2014 11:48:14 -0400
Received: by mail-pa0-f43.google.com with SMTP id lf10so19510741pab.30
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Aug 2014 08:48:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$cd143$1f075140$a44693a2$c17a5577@cox.net>
References: <CAGP2HaPx2pXbN=FyBH5MskrsufDXcWtddVfG4Kaie-ZVg=ivJg@mail.gmail.com>
	<pan$cd143$1f075140$a44693a2$c17a5577@cox.net>
Date: Sun, 24 Aug 2014 15:48:10 +0000
Message-ID: <CAGP2HaM3C-rzoisqqirGRHo=0nQpdrW4xPH=nkmDo45C84jpKA@mail.gmail.com>
Subject: Re: btrfs unmountable, any btrfs tool segfaults
From: Nikolay Shtabel <shtabnik@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the link, I'm glad to see that restore work for you.
I've tried this also and everything doesn't work ending up with segfault.

Unfortunately in my case I had some important files on btrfs
partition, due to performance reasons (it was on SSD).

I doesn't find solution in mailing-list archives, because there are
not so many cases in which tools refuses to work.

So, now I'm trying to debug btrfs tools, aiming first to get
btrfs-zero-log working.

>
> First answer (probably not too helpful, but gets the point across):
>
> Since btrfs is still not fully stable and you are urged to keep backups
> if you value the data, then restore from them.  If you don't have them,
> by definition you obviously don't value the data enough to bother with
> the hassle of backing it up, so no big deal if you lose it, right?
>
> Second answer (hopefully more helpful, but I'm obviously a bit grumpy
> today; I could put off answering until I'm not so grumpy, but I know what
> it's like to be waiting for an answer, so read thru the grumpy and we can
> both hope the solution works):
>
> It used to be common courtesy to read a couple weeks of the the backgroup/
> backlist before posting questions as they might be answered already.  I
> guess it isn't so these days...
>
> Anyway, see the second half of the following post (the first half is a
> different problem and solution) dealing with using restore with btrfs-
> find-root and etc, along with the wiki link mentioned (and of course the
> manpages as well).  With some luck you can still get btrfs restore
> working.  It worked for me recently (as you can see there, I had backups
> but they weren't as current as I would have liked).
>
> http://permalink.gmane.org/gmane.comp.file-systems.btrfs/37980
>
