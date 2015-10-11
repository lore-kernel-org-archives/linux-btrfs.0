Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:38743 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbbJKUtv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Oct 2015 16:49:51 -0400
Received: by wiclk2 with SMTP id lk2so129583132wic.1
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Oct 2015 13:49:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEtw4r27FonYkrgdm8sdu1vLYP8KTdjWuu8=tOEatqJ8esRvgg@mail.gmail.com>
References: <CAEtw4r3r-E1deboGDCfNkUL-ZKUdn4+B++oeu9M4H_7hHDj0TA@mail.gmail.com>
	<BLU436-SMTP5651E81A1B27D60895E652A9340@phx.gbl>
	<CAEtw4r3Qg-5cian-GjAuCmjaTnzea0OrHgxZO_VM1OwjoF2oxQ@mail.gmail.com>
	<CAEtw4r2HMrJciX4tgC9d9qSVucCJng-tyJxWPFX7h-5oqePV_w@mail.gmail.com>
	<CAEtw4r0mGLUS5HPfxeu5ip57iLk3SeJ04nJsr9CTchXu2mMMkw@mail.gmail.com>
	<CAEtw4r27FonYkrgdm8sdu1vLYP8KTdjWuu8=tOEatqJ8esRvgg@mail.gmail.com>
Date: Sun, 11 Oct 2015 22:49:50 +0200
Message-ID: <CAEtw4r2GQMhfmk0TLiM12C6GSCQz7Ph4DYx-wzrCDn+bbbx4pw@mail.gmail.com>
Subject: Re: kernel BUG at /linux/fs/btrfs/extent-tree.c:1833!
From: Peter Becker <floyd.net@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

the output of btrfs check --readonly /dev/sdb

http://pastebin.com/UxkeVd7Y

many entrys with "extent buffer leak"


the output of  btrfs-show-super -i0 /dev/sd[bcd] &&  btrfs-show-super
-i1 /dev/sd[bcd] &&  btrfs-show-super -i2 /dev/sd[bcd]

http://pastebin.com/zs7B8827
http://pastebin.com/Kn1kwgYv
http://pastebin.com/CHC52ef7
