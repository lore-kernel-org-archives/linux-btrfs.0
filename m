Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:36255 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbcC0E5x (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Mar 2016 00:57:53 -0400
Received: by mail-io0-f169.google.com with SMTP id 124so146900830iov.3
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Mar 2016 21:57:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160327033032.6dce42e0@jupiter.sol.kaishome.de>
References: <20160322090342.595fefac@jupiter.sol.kaishome.de>
	<56F1068E.6050806@cn.fujitsu.com>
	<20160322194854.161e9c4c@jupiter.sol.kaishome.de>
	<56F21898.3020101@cn.fujitsu.com>
	<20160326203035.4b876a04@jupiter.sol.kaishome.de>
	<CAJCQCtSzKT2BZ15JwgR4b6Nk+n2tsHBLizwJXOqJ93Jbuv05rQ@mail.gmail.com>
	<CAJCQCtQYkCDLks0Wvnt2nqTRMAvh6wQ5nsHB4GPD4wFA8geAsw@mail.gmail.com>
	<20160327033032.6dce42e0@jupiter.sol.kaishome.de>
Date: Sat, 26 Mar 2016 22:57:53 -0600
Message-ID: <CAJCQCtSOURe5Cy-ytB3Tg_s46hgWsGKLn6fXjy8vt+TBQKNucg@mail.gmail.com>
Subject: Re: csum errors in VirtualBox VDI files
From: Chris Murphy <lists@colorremedies.com>
To: Kai Krakow <hurikhan77@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 26, 2016 at 7:30 PM, Kai Krakow <hurikhan77@gmail.com> wrote:

> Both filesystems on this PC show similar corruption now - but they are
> connected to completely different buses (SATA3 bcache + 3x SATA2
> backing store bache{0,1,2}, and USB3 without bcache = sde), use
> different compression (compress=lzo vs. compress-force=zlib), but
> similar redundancy scheme (draid=0,mraid=1 vs. draid=single,mraid=dup).
> A hardware problem would induce completely random errors on these
> pathes.
>
> Completely different hardware shows similar problems - but that system
> is currently not available to me, and will stay there for a while
> (it's a non-production installation at my workplace). Why would similar
> errors show up here, if it'd be a hardware error of the first system?

Then there's something about the particular combination of mount
options you're using with the workload that's inducing this, if it's
reproducing on two different systems. What's the workload and what's
the full history of the mount options? Looks like it started life as
compress lzo and then later compress-force zlib and then after that
the addition of space_cache=v2?

Hopefully Qu has some advice on what's next. It might not be a bad
idea to get a btrfs-image going.



-- 
Chris Murphy
