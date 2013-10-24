Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:45749 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879Ab3JXUwW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Oct 2013 16:52:22 -0400
Received: by mail-wi0-f174.google.com with SMTP id cb5so144232wib.13
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Oct 2013 13:52:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGqmi74OvQ=BFroP+QCf6eUtc61__LYRGtZJNcPz1XrSWX-q_w@mail.gmail.com>
References: <CAGqmi74OvQ=BFroP+QCf6eUtc61__LYRGtZJNcPz1XrSWX-q_w@mail.gmail.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Thu, 24 Oct 2013 23:52:01 +0300
Message-ID: <CAGqmi74F9GurJL73qtU4JG+Fi4RbXE7tiaO1uEQqEY2ym278eA@mail.gmail.com>
Subject: Re: swapfile on btrfs, temporary solution for wiki
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, i suggest temporary solution to use swap file under btrfs.
I test it, and it work good.

I invent simple the way, how create and using swap file, just see
following sh code:

swapfile=$(losetup -f) #free loop device
truncate -s 8G /swap   #create 8G sparse swap file
losetup $swapfile /swap #mount file to loop
mkswap  $swapfile
swapon  $swapfile

i just adding this to rc.local and this work good.
May be, add it to btrfs Wiki as temporary solution to using swap file?

Timofey

2013/10/21 Тимофей Титовец <nefelim4ag@gmail.com>:
> Hello list, i know what btrfs  don't support swap files.
> I read arch wiki and when i reading about systemd addon for auto
> create swapfile on btrfs, i invent the way, how create and using swap
> file, just see following sh code:
>
> swapfile=$(losetup -f) #free loop device
> truncate -s 8G /swap   #create 8G sparse swap file
> losetup $swapfile /swap #mount file to loop
> mkswap  $swapfile
> swapon  $swapfile
>
> i just adding this to rc.local and this just work.
> May be, add it to Wiki as temporary solution to using swap file?
> (sorry for my bad english)
