Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vn0-f51.google.com ([209.85.216.51]:35493 "EHLO
	mail-vn0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbbF1TcP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Jun 2015 15:32:15 -0400
Received: by vnbg190 with SMTP id g190so964998vnb.2
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Jun 2015 12:32:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+xOVSOxTnRpfxnw=FpizBNGJmdi5y_aEPRZqHos6W5u4=HgbQ@mail.gmail.com>
References: <CA+xOVSOD1YY-=Cm+vmzTUV9cHe9idtDkRr0RmpRP5a0Z6eC4YQ@mail.gmail.com>
	<CA+xOVSNu547eo6TY_mwLypTGWuE5AmyMqC6GwR06Sir1282vqA@mail.gmail.com>
	<CAJCQCtSv15DVDju7vhm=Luc5hqWvce__F7iovh87uxq37bNg0Q@mail.gmail.com>
	<CA+xOVSMjO0e5TPfksr=TmnT9zc5=hJemYPtn_tg+xxsWbFMV=A@mail.gmail.com>
	<CADfjVrhmUhWAs0+6_s-hDcoLyrXdvkY1fZgoKv2VRDt2F8MWhQ@mail.gmail.com>
	<CA+xOVSOxTnRpfxnw=FpizBNGJmdi5y_aEPRZqHos6W5u4=HgbQ@mail.gmail.com>
Date: Sun, 28 Jun 2015 13:32:14 -0600
Message-ID: <CAJCQCtTv+yAQAQsBrbWEFo4_i0_tUUtbxwU1R4xDDhPTzQNGAQ@mail.gmail.com>
Subject: Re: btrfs replace seems to corrupt the file system
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 28, 2015 at 1:20 PM, Mordechay Kaganer <mkaganer@gmail.com> wrote:


> Then (if it's OK, hopefully) we'll see how to redo the replace. Maybe,
> unmount and do a simple "dd" will be the best option? At least it's
> not going to corrupt the original data :-).

Use of dd can cause corruption of the original.

"Do not make a block-level copy of a btrfs filesystem to a block
device, and then try to mount either the original or the copy while
both are visible to the same kernel."

https://btrfs.wiki.kernel.org/index.php/Gotchas

Once you do the dd, you can't mount either one of the copies until one
of the copies is completely hidden (i.e. on an LV that's inactive and
flagged to never automatically become active).

I think it's too risky just to avoid using a newer kernel. I'd sooner
create a new file system and tediously btrfs send/receive the
subvolumes you want to keep.


-- 
Chris Murphy
