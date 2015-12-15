Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:33133 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932803AbbLOEFk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 23:05:40 -0500
Received: by mail-io0-f178.google.com with SMTP id 186so6794599iow.0
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Dec 2015 20:05:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <566ED124.30803@gmail.com>
References: <CA+ve2MYBAPbLPiX4i2oZeDeu+9=JurXHsx5fMef2iV3rRrCKxg@mail.gmail.com>
	<pan$eea04$e9596e27$78b44461$c5754723@cox.net>
	<1448488198.4717.4.camel@gmail.com>
	<pan$8ce6a$31af576$4416e55e$7b867388@cox.net>
	<1448562347.8809.16.camel@scientia.net>
	<pan$54542$5eb77bd3$8682bff8$82310de1@cox.net>
	<1448582805.11377.9.camel@scientia.net>
	<pan$34543$2ed1f043$2f803125$884b36c0@cox.net>
	<1448683025.6837.4.camel@scientia.net>
	<pan$46a28$81694e9d$c6d5f048$1c8bcdd8@cox.net>
	<1449958538.15961.3.camel@scientia.net>
	<566ED124.30803@gmail.com>
Date: Mon, 14 Dec 2015 21:05:39 -0700
Message-ID: <CAJCQCtQKvnkbe9KUSyA1dvRFomA1ZzgDC20s9UaN1LuQzM7pzA@mail.gmail.com>
Subject: Re: btrfs: poor performance on deleting many large files
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 14, 2015 at 7:24 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:

>
> If you have software that actually depends on atimes, then that software is
> broken (and yes, I even feel this way about Mutt).  The way atimes are
> implemented on most systems breaks the semantics that almost everyone
> expects from them, because they get updated for anything that even looks
> sideways at the inode from across the room.  Most software that uses them
> expects them to answer the question 'When were the contents of this file
> last read?', but they can get updated even for stuff like calculating file
> sizes, listing directory contents, or modifying the file's metadata.

This Jonathan Corbet article still applies:
http://lwn.net/Articles/397442/

What a mess!

Hey. The 5 year anniversary was in July. Wanna bring it up again, Austin? Haha.
http://thread.gmane.org/gmane.linux.kernel.cifs/294

Users want file creation time. Specifically, an immutable time for
that file that persists across file system copies. The time of its
first occurrence on a particular volume is not useful information.
Getting that requires what seems to be an unlikely consensus.


-- 
Chris Murphy
