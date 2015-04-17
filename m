Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:36350 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbbDQCTq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Apr 2015 22:19:46 -0400
Received: by igblo3 with SMTP id lo3so4147428igb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Apr 2015 19:19:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$9774f$be540432$25bcbd9d$e84db021@cox.net>
References: <553046DA.7090809@gmail.com>
	<pan$9774f$be540432$25bcbd9d$e84db021@cox.net>
Date: Thu, 16 Apr 2015 22:19:46 -0400
Message-ID: <CAPL5yKfgMzvBfDGwj=F3VZfGneYtTSA4saZ4T7jhNFihftCx2Q@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: have restore set atime/mtime
From: Dan Merillat <dan.merillat@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

That's not a bad idea.  In my case it was all owned by the same user
(media storage) so the only thing of interest was the timestamps.

I can whip up a patch to do that as well.

On Thu, Apr 16, 2015 at 9:09 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Dan Merillat posted on Thu, 16 Apr 2015 19:33:46 -0400 as excerpted:
>
>> The inode is already found, use the data and make restore friendlier.
>
> Unless things have changed recently, restore doesn't even restore user/
> group ownership, let alone permissions.  IOW, atime/mtime are the least
> of the problem (particularly if people are running noatime as is
> recommended, unless you really need it for some reason).
>
> It simply creates the files it restores as the owner/group it is run as
> (normally root), using standard umask rules, I believe.
>
> So if you're going to have it start restoring metadata at all, might as
> well have it do ownership/perms too, if it can.  Otherwise atime/mtime
> are hardly worth bothering with.
>
> --
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
