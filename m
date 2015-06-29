Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:35994 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882AbbF2LXD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Jun 2015 07:23:03 -0400
Received: by wguu7 with SMTP id u7so138552305wgu.3
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2015 04:23:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$36112$278c5ce$95ee5224$7ba3d78f@cox.net>
References: <CA+xOVSOD1YY-=Cm+vmzTUV9cHe9idtDkRr0RmpRP5a0Z6eC4YQ@mail.gmail.com>
	<CA+xOVSNu547eo6TY_mwLypTGWuE5AmyMqC6GwR06Sir1282vqA@mail.gmail.com>
	<CAJCQCtSv15DVDju7vhm=Luc5hqWvce__F7iovh87uxq37bNg0Q@mail.gmail.com>
	<CA+xOVSMjO0e5TPfksr=TmnT9zc5=hJemYPtn_tg+xxsWbFMV=A@mail.gmail.com>
	<CADfjVrhmUhWAs0+6_s-hDcoLyrXdvkY1fZgoKv2VRDt2F8MWhQ@mail.gmail.com>
	<CA+xOVSOxTnRpfxnw=FpizBNGJmdi5y_aEPRZqHos6W5u4=HgbQ@mail.gmail.com>
	<CAJCQCtTv+yAQAQsBrbWEFo4_i0_tUUtbxwU1R4xDDhPTzQNGAQ@mail.gmail.com>
	<CA+xOVSMgqwOGxdhAjEZQHOCNhaJs-g2ieDE7qss8skyF4=shkw@mail.gmail.com>
	<pan$36112$278c5ce$95ee5224$7ba3d78f@cox.net>
Date: Mon, 29 Jun 2015 12:23:01 +0100
Message-ID: <CAMU1PDgjf54Cqq4cjnWEup4Z2Ri+Fvrd1WqoBkaXqYkmEZds1w@mail.gmail.com>
Subject: Re: btrfs replace seems to corrupt the file system
From: Mike Fleetwood <mike.fleetwood@googlemail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 29 June 2015 at 09:08, Duncan <1i5t5.duncan@cox.net> wrote:
> Meanwhile, unlike many filesystems, btrfs uses the UUID as part of the
> metadata, so changing the UUID isn't as simple as rewriting a superblock;
> the metadata must be rewritten to the new UUID.  There's actually a tool
> now available to do just that, but it's new enough I'm not even sure it's
> available in release form yet; if so, it'll be latest releases.
> Otherwise, it'd be in integration branch.

FYI, btrfstune with changing file system UUID capability, was included
in btrfs-progs 4.1 released last week, Mon, 22 Jun 2015.
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg44182.html

Mike
