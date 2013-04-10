Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f49.google.com ([209.85.219.49]:52609 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab3DJJJ0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Apr 2013 05:09:26 -0400
Received: by mail-oa0-f49.google.com with SMTP id j6so214169oag.22
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Apr 2013 02:09:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5165291C.7050704@jan-o-sch.net>
References: <CAFDW0j+XvnX4ZmP2Y=wpLen+pezAXxPL+ubigRfD-Yt_a=5c=g@mail.gmail.com>
	<5165291C.7050704@jan-o-sch.net>
Date: Wed, 10 Apr 2013 11:09:25 +0200
Message-ID: <CAFDW0jJMgJsWXb5TW0vvesca4HOX8FVcmmqBvc0Dw3WJzOJYMw@mail.gmail.com>
Subject: Re: kernel BUG at fs/btrfs/ctree.c:1144!
From: Ahmet Inan <ainan@mathematik.uni-freiburg.de>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> The real problem, however, is not caused by that commit but by a tree mod log
> bug. I expect that fs/btrfs/ctree.c:1144 is this BUG_ON in your kernel from
> __tree_mod_log_rewind (my line numbers don't match):
>
> 1138                 switch (tm->op) {
> 1139                 case MOD_LOG_KEY_REMOVE_WHILE_FREEING:
> 1140                         BUG_ON(tm->slot < n);
>
> I've got a fix for that I'm currently testing, expect it on the list soon.
Yea, thats the line.

> For the meantime I recommend to not defrag your filesystem.
Ok, already disabled and rebooted.
Will come back to You if i still get that Problem.

> As a general remark, please send your stack traces inline, not as attachment if
> possible.
Google mail always screws longer than 80 lines in plain text mode and
non plain text is not what You want.
Maybe i should go back to using mutt.

Thank You,

Ahmet
