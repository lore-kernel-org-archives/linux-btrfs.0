Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f178.google.com ([209.85.128.178]:56714 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489AbaENPgY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 11:36:24 -0400
Received: by mail-ve0-f178.google.com with SMTP id sa20so2604788veb.37
        for <linux-btrfs@vger.kernel.org>; Wed, 14 May 2014 08:36:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$43445$a1ed5a9d$d03f1b1$41238e2b@cox.net>
References: <CAPm-YUXRNPhrq+xoJt-S3NvVgg+NOQHB7wj1fjf+XAKs+yUJOg@mail.gmail.com>
 <pan$43445$a1ed5a9d$d03f1b1$41238e2b@cox.net>
From: Scott Middleton <scott@assuretek.com.au>
Date: Wed, 14 May 2014 23:36:03 +0800
Message-ID: <CAPm-YUWryMcGFop+miu+dnMBac6gf-mdJCx07XHPxdr66h3Big@mail.gmail.com>
Subject: Re: send/receive and bedup
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi



> I left this for a couple days hoping someone else with a more directly
> similar use-case would answer, but none so far, so I'll give it a go...

Thanks for getting back to me mate!


>
> First some general boilerplate.  Btrfs is still under heavy development
> and keeping current with especially the kernel is *STRONGLY* recommended,
> as every new kernel still brings lots of fixes, meaning if you're running
> an old kernel, you're running known-buggy code with fixes available in a
> current kernel.  Similarly, you probably don't want to let the btrfs-progs
> userspace tools get too outdated either, tho that's not as critical as it
> mostly means not being able to take advantage of the latest features and
> fixes for maintenance, not the risk of operational data loss if one of
> the known-fixed old-version kernel bugs hits that you have when running
> an older kernel.
>

My test environment is:
root@Ubuntu-14:~/btrfs/btrfs-progs# uname -a
Linux Ubuntu-14 3.14.1-031401-generic #201404141220 SMP Mon Apr 14
16:21:48 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux

root@Ubuntu-14:~/btrfs/btrfs-progs# which btrfs
/usr/local/bin/btrfs
root@Ubuntu-14:~/btrfs/btrfs-progs# btrfs --version
Btrfs v3.14.1

I read so much about BtrFS that I mistaked Bedup with Duperemove.
Duperemove is actually what I am testing.

I also plan on testing SDFS - opendedup again! They have some
development since the last time I tried,  Not a fan of having to use
Java though!

> Second, as you've done some research already you're likely aware of this,
> but just in case, let me give you the link to the wiki.  If you haven't
> read up there, please do, as it's likely to be quite helpful. =:^)
>
> Memory or bookmark: https://btrfs.wiki.kernel.org


Lots of bookmarks. One of my faves is:
https://wiki.archlinux.org/index.php/Btrfs


It will be interesting on what happens. I rsync'd the clients data
from a 2TB mdadm RAID to a standard 3TB BtrFS drive, Currently running
 Duperemove on it. I reckon it will take days but it will be
interesting to see what happens.
