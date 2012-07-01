Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout11.t-online.de ([194.25.134.85]:55089 "EHLO
	mailout11.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123Ab2GAPG7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Jul 2012 11:06:59 -0400
Date: 01 Jul 2012 17:06:00 +0200
From: Hullen@t-online.de (Helmut Hullen)
To: linux-btrfs@vger.kernel.org
Message-ID: <CC03PBLeCXB@helmut.hullen.de>
In-Reply-To: <CALi3HZrwGO9=X3RG5FfN_04jW0F7T=405pVy4BXZg_6hE4W6XQ@mail.gmail.com>
Subject: Re: Strange directories in /
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: helmut@hullen.de
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Markus,

Du meintest am 01.07.12:

> I am running btrfs for a few months now. I just realized that I have
> a few strange directories in /

> % ls / -1
> ?
> ???J??
>  Q???
> PL????
> PR????
> bin
> boot
> dev
> etc
> home
> lib
> lib32
> lib64
> lost+found
> media
> mnt
> opt
> proc
> p?c'??
> root
> run
> sbin
> sys
> tmp
> usr
> var
> ??????

> Is this a known problem? I have absolutely no idea where these
> directories come from.

That are no (real) directories, that is a damaged file system. Look for  
your backup.

Viele Gruesse!
Helmut
