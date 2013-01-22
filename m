Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:51636 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556Ab3AVVjc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jan 2013 16:39:32 -0500
Received: by mail-lb0-f181.google.com with SMTP id gm6so1658755lbb.40
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Jan 2013 13:39:31 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 22 Jan 2013 23:39:31 +0200
Message-ID: <CANoGd8=7Q=1yDiQxhkwQiNSf2d78p85AN-kkEn=i_2Vsat6paA@mail.gmail.com>
Subject: File system development question
From: Racz Zoli <racz.zoli@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

First of all I would like to apologize for writing about my question
on this mailing list (I know this place isn`t for newbies), but I`ve
sent multiple emails to the kernelnewbies mailing list a week ago, and
nobody answered since. I posted my question on linux forums, but the
result was pretty much the same.

I started learning file system development some time ago. I`ve read
the section about block devices in Andrew Tanenbaum`s Operating system
design and implementation book and many other documentations to learn
how block devices actually work, but now I`m having a hard time
implementing what I`ve learnt using the linux vfs api. Because of the
complexity of vfs, and the lack of detailed documentation I`m
progressing really slow, and many times, after I write a chunk of
code, I only end up with kernel panics, or segfaults and find out days
later that I didn`t initialize something the api needed. I`ve spent
days searching on the internet for tutorials and howtos, but many of
them are incomplete, some of them don`t even compile, or simply they
are written for older kernel versions, and because of the interface
changes in the vfs api they are pretty much useless. On one of my
machines I`m running the 2.6.32 series and 3.6.xx on the other one.

Can somebody help me with links to documentations, books or howtos
about how and where to start file system development in linux? It
doesn`t necessarily need to contain a full source code. I don`t want
to only copy paste somebody else`s code, and voila, I`m a kernel
developer. I would like to understand step by step how the vfs api is
actually working, how to do things, and maybe in the future to be able
to write my own file system, or to contribute to an existing one.

Thank you in advance.
Zoli.
