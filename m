Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:50431 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbaC3VFy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Mar 2014 17:05:54 -0400
Received: by mail-lb0-f172.google.com with SMTP id c11so5177407lbj.17
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Mar 2014 14:05:52 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20140330002837.GQ22552@merlins.org>
References: <20140330002837.GQ22552@merlins.org>
Date: Sun, 30 Mar 2014 22:05:52 +0100
Message-ID: <CAL3q7H5mxvN+TxtK3_Oeef=S3rVGu2QywD6d8Zd6ABUj1B44Nw@mail.gmail.com>
Subject: Re: Btrfs file content missmatch incrementally sending subvolumes
 containing systemd journal files
From: Filipe David Manana <fdmanana@gmail.com>
To: Marc MERLIN <marc@merlins.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 30, 2014 at 12:28 AM, Marc MERLIN <marc@merlins.org> wrote:
> I had someone asking me about this bug:
> Btrfs file content missmatch incrementally sending subvolumes containing systemd journal files
> https://bugzilla.kernel.org/show_bug.cgi?id=66941
>
> Specifically:
> Just to note, I have also this issue with other files:
> jkarlson/.config/chromium/Default/Archived History
> jkarlson/.local/share/Trash/files/wheezy-x86_64.img
> jkarlson/.local/share/evolution/addressbook/system/log.0000000001
> jkarlson/.local/storage/vm-images/wheezy-x86_32.img
> jkarlson/.local/storage/vm-images/wheezy-x86_64.img
> jkarlson/.local/storage/vm-images/windows-2008-server.img
>
> This is a bit worrisome since it affects sqlite3 too apparently
> (firefox/chrome).
>
> Do others know the status of this?

I think I might have found and fixed this today.
See the patch I just sent to the list:

https://patchwork.kernel.org/patch/3910081/

It affects only the 3.14 codebase (any of the RCs).

>
> Thanks,
> Marc
> --
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
