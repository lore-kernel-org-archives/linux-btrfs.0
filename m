Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vn0-f44.google.com ([209.85.216.44]:39883 "EHLO
	mail-vn0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbbF1SaH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Jun 2015 14:30:07 -0400
Received: by vnav203 with SMTP id v203so21397610vna.6
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Jun 2015 11:30:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+xOVSMjO0e5TPfksr=TmnT9zc5=hJemYPtn_tg+xxsWbFMV=A@mail.gmail.com>
References: <CA+xOVSOD1YY-=Cm+vmzTUV9cHe9idtDkRr0RmpRP5a0Z6eC4YQ@mail.gmail.com>
	<CA+xOVSNu547eo6TY_mwLypTGWuE5AmyMqC6GwR06Sir1282vqA@mail.gmail.com>
	<CAJCQCtSv15DVDju7vhm=Luc5hqWvce__F7iovh87uxq37bNg0Q@mail.gmail.com>
	<CA+xOVSMjO0e5TPfksr=TmnT9zc5=hJemYPtn_tg+xxsWbFMV=A@mail.gmail.com>
Date: Sun, 28 Jun 2015 12:30:06 -0600
Message-ID: <CAJCQCtSB7Kf-vz0NRJ2KRktiZa-8kSROBJ46ir7t12RJL4ysNA@mail.gmail.com>
Subject: Re: btrfs replace seems to corrupt the file system
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is a work around for the file system not reading files when
there are csum errors, which is btrfs check --init-csum-tree, but
there is a caveat:

You might need a newer btrfs-progs, I forget exactly what version it
will reconstruct new csums, maybe 3.18 or 3.19. Older versions create
a new csum tree that's empty so you get a bunch of errors for
everything but you can still read files at least and see if they're
corrupt or not.

Before you do that, you could try btrfs restore to extract some files
and see if they are really corrupt or if the csum error is bogus.

If the files are corrupted, then the (new device) backup is probably
useless anyway and there's no point in keeping it around. You can
still keep the old device backup that won't mount in case someone
eventually can say how to reset it as if the replace did not occur.

I'm willing to bet that the data is OK, and you've run into some
obscure bug on csum computation during the replace that went bad and
it's just that the csums are all wrong. Speculation though.


Chris Murphy
