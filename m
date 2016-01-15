Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:35344 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689AbcAOJdp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jan 2016 04:33:45 -0500
Received: by mail-ig0-f176.google.com with SMTP id t15so7809994igr.0
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Jan 2016 01:33:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$b0586$d2b2b229$291cbb7b$f3802e23@cox.net>
References: <CAGkb5vfzcOmj1Js=pBR6=-Uad7jY2bJy5ht3F-m-1TEOBjwCYA@mail.gmail.com>
	<5697D0E9.3080007@gmail.com>
	<20160114192647.GB24567@localhost.localdomain>
	<5697F9E7.1020004@gmail.com>
	<pan$b0586$d2b2b229$291cbb7b$f3802e23@cox.net>
Date: Fri, 15 Jan 2016 09:33:44 +0000
Message-ID: <CAGkb5vdQU6z0SaMAW+WHTNxdKj8L0mdDe6zOyByzYLiK=CKfsw@mail.gmail.com>
Subject: Re: Query about proposed dedup patches and behaviours
From: James Hogarth <james.hogarth@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 15 January 2016 at 01:47, Duncan <1i5t5.duncan@cox.net> wrote:
>
> Hugo should really explain as he was the one that said that, but upon
> looking into it, he found that while he was correct in a sense, his
> reasoning was a bit narrow, and autodefrag isn't snapshot aware in the
> wider context.
>
> Without attempting to explain his reasoning as I think I sort of
> understand it but not well enough to try to explain, autodefrag isn't
> snapshot aware and will break reflinks, but due to $reasons, autodefrag's
> damage to reflinking apparently isn't as bad as manual defrag.
>
> That's the best I can do to explain the situation.  In general,
> autodefrag remains bad for reflinks, but apparently not h***-bad, as
> manual defrag is.
>

As I recall it's something like autodefrag will break the reflink
pretty much to the same extent as if you just starting writing to each
instance.

http://article.gmane.org/gmane.comp.file-systems.btrfs/51441

Looking through the patches again I see that Qu has indeed already
looked to on disk hash rather than in memory so that relieves my
memory blooming concerns.

http://thread.gmane.org/gmane.comp.file-systems.btrfs/52215

It does appear that btrfs-progs is only being extended to enable or
disable dedup on a whole pool rather than to dedup X files

http://news.gmane.org/find-root.php?message_id=1452751070%2d2460%2d3%2dgit%2dsend%2demail%2dquwenruo%40cn.fujitsu.com

I suppose that one could in principle target a btrfs balance to
particular extents after enabling dedupe on the pool in order to try
and target particular files but that seems rather cumbersome, and if
wanting to dedup an entire pool then enabling the feature followed by
a full balance ought to do it.

So I see two things out of this:

1) A least a note in the man page (or command output as well
preferably) reminding that autodefrag will to an extent work against
dedupe (and it may be worth testing the effect of both enabled and if
poor preventing one whilst the other is there).

2) Qu is there any intention to be able to do btrfs dedup
/path1../pathN or is the intention for this work only to enable
in-band across an entire pool (less any files with the proposed
attribute changed to say nodedup)?

If there is no intention for 2 then the duperemove packaging is still
worthwhile to carry out.
