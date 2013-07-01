Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:42851 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806Ab3GAHkD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jul 2013 03:40:03 -0400
Received: by mail-ob0-f181.google.com with SMTP id 16so3872183obc.40
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Jul 2013 00:40:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20130626T173801-308@post.gmane.org>
References: <loom.20130617T230152-537@post.gmane.org> <20130617212132.GA19183@localhost.localdomain>
 <CADn-QaOWq7BR0DXn_Xd5YRnDc2NZOBGCn_YfV2y1FjpBg4f_LQ@mail.gmail.com>
 <CADn-QaNS01CGtPJtr9yHkEU-TET7MrhCUbr1j4g3gYROvQ=K+Q@mail.gmail.com> <loom.20130626T173801-308@post.gmane.org>
From: Alexander Skwar <alexanders.mailinglists+nospam@gmail.com>
Date: Mon, 1 Jul 2013 09:39:39 +0200
Message-ID: <CADn-QaPUa6vyqbgB2CMEmfk9q=Z7haE=AxO_4spYDz4JDLHQNA@mail.gmail.com>
Subject: Re: Filesystem
To: Rodrigo Dias Cruz <rodrigodc@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Rodrigo,

On Wed, Jun 26, 2013 at 5:44 PM, Rodrigo Dias Cruz <rodrigodc@gmail.com> wrote:

> I had the very same problem some days ago.
>
> I have not yet found out how to fix the broken btrfs filesystem. However, I
> have been able to recover all my files from the filesystem and copy them to
> a brand new ext4 filesystem, that I am using now.

Well, yeah, I also tried to do "btrfs-restore". Did not work well.

It restored all files, but didn't do so in a good way. An unknown
number of files got corrupted (but btrfs-restore went thru anyway).
For example a VirtualBox image got destroyed and my Hamster
time tracking database. And probably some more.


> At the end, all your files should be found at the directory "/backup". If

They were.

> you wish, you can recreate the filesystem on "/dev/sda1" (using mkfs.btrfs
> or mkfs.ext4) and copy the files back to there.

I think, I got cured from btrfs… As of now, not ready for daily use,
unless you are a real hacker.

It does have nice features, but an ugly userland (in comparison
to ZFS) and is unstable with real danger of data loss.

Maybe in a few years.

Regards,

Alexander
--
=>        Google+ => http://plus.skwar.me         <==
=> Chat (Jabber/Google Talk) => a.skwar@gmail.com <==
