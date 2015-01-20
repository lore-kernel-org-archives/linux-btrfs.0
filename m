Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f175.google.com ([209.85.160.175]:34878 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbbATHic (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Jan 2015 02:38:32 -0500
Received: by mail-yk0-f175.google.com with SMTP id q9so5225839ykb.6
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Jan 2015 23:38:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+WRLO8gGUxxHhqQfgQWXyU0kT2=nf7u5oPFYJTWY=hSMNBj=w@mail.gmail.com>
References: <CA+WRLO9nCFgjHzY1F_xR5PpmgaSEemfmZ=MtiSpiaHcROQnq-A@mail.gmail.com>
	<CA+WRLO8gGUxxHhqQfgQWXyU0kT2=nf7u5oPFYJTWY=hSMNBj=w@mail.gmail.com>
Date: Tue, 20 Jan 2015 00:38:31 -0700
Message-ID: <CAJCQCtRe+0n84PUZuWKw0UUwK_RF_AhW4sMZ+07r96qaNvRWKg@mail.gmail.com>
Subject: Re: btrfs convert running out of space
From: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> On Mon, Jan 19, 2015 at 5:13 PM, Gareth Pye <gareth@cerberos.id.au> wrote:
> I just tried from a slightly different tack, after doing another
> -dusage=2 pass I did the following:
> # btrfs balance start -v -dconvert=raid1 -dsoft -dusage=96 /data
> Dumping filters: flags 0x1, state 0x0, force is off
>   DATA (flags 0x302): converting, target=16, soft is on, usage=96
> Done, had to relocate 0 out of 3763 chunks
> # btrfs balance start -v -dconvert=raid1 -dsoft -dusage=99 /data
> Dumping filters: flags 0x1, state 0x0, force is off
>   DATA (flags 0x302): converting, target=16, soft is on, usage=99
> ERROR: error during balancing '/data' - No space left on device


I guess I don't really understand the purpose of combining dconvert
and dusage. Sure, it should either work or give an error, so there may
still be a bug here. But I'm just not following why they'd be used
together, seems superfluous. What happens when they're tried
separately? I'm not sure which one's instigating the problem.

Also I think you should upgrade to btrfs-progs 3.18, seeing as 3.12 is
old and if there's a bug in that version of progs vs the kernel, it's
not going to get fixed.



-- 
Chris Murphy
