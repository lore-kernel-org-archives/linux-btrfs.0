Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f175.google.com ([209.85.220.175]:36620 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913AbaHLRob (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Aug 2014 13:44:31 -0400
Received: by mail-vc0-f175.google.com with SMTP id ik5so13515869vcb.6
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Aug 2014 10:44:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53E9068B.3090005@jrs-s.net>
References: <loom.20140811T193907-62@post.gmane.org>
	<53E90409.5050105@jrs-s.net>
	<CAP6pX24fWPrZ3368WxaViYT2_N2WcCWtso3KqxF_SRrDTS54xQ@mail.gmail.com>
	<CAP6pX26e79LZzMMwdeE7JOeGyoLtRxqvJhScBX1LDEwJ7UNe3Q@mail.gmail.com>
	<53E9068B.3090005@jrs-s.net>
Date: Tue, 12 Aug 2014 19:44:30 +0200
Message-ID: <CAFvQSYStbiwXZottPhOkgohcfd=-c+gNbkHg+e-MTGN0b+_hWg@mail.gmail.com>
Subject: Re: Announcement: buttersink - like rsync for btrfs snapshots
From: Clemens Eisserer <linuxhippy@gmail.com>
To: Jim Salter <jim@jrs-s.net>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jim,

> To any core btrfs devs who are listening and care - the unreliability of
> btrfs send/receive is IMO the single biggest roadblock to adoption of btrfs
> as a serious next-gen FS.

For you it are send/receive deficiencies, however there are many other
feature/enhancement requests having top priority for other users.

Fact is, just crying for improvements won't make things better - if
you want a feature/enhancement done, you have several options:
- Implement/fix it yourself
- Go to your distribution provider with whom you have a support
contract and make him implement what you would like to see
- Sponsor somebody yourself to get it sone.

> with (very) occasional filesystem corruption... IF I can rely on replication
> to keep my data safe on another box.  Without the replication, there's just
> no reasonable case to be made to replace ZFS.

... and now the usual ZFS comparison to make devs jealous ;)

Best regards, Clemens
