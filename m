Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.humilis.net ([82.95.169.224]:33767 "EHLO panda.humilis.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927Ab2LMJRR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Dec 2012 04:17:17 -0500
Date: Thu, 13 Dec 2012 10:17:14 +0100
From: Sander <sander@humilis.net>
To: merc1984@f-m.fm
Cc: cwillu <cwillu@cwillu.com>, Mitch Harder <mitch.harder@sabayonlinux.org>,
        linux-btrfs@vger.kernel.org
Subject: Re: Encryption
Message-ID: <20121213091714.GA14965@panda>
Reply-To: sander@humilis.net
References: <1354896969.6088.140661163160337.103F13F1@webmail.messagingengine.com>
 <1355332339.17999.140661165184497.5BC0F72B@webmail.messagingengine.com>
 <CAKcLGm8gH09DgouymqLL1MKi49kZvHx36M=X1yk5gCWD+iOhQQ@mail.gmail.com>
 <1355337523.8384.140661165218221.778EBD55@webmail.messagingengine.com>
 <CAE5mzvjrGZVU7p9dTWiJ1pNZUe_Xj5m78FJte4Enb1od=iqVTA@mail.gmail.com>
 <1355342784.940.140661165251717.298B576B@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1355342784.940.140661165251717.298B576B@webmail.messagingengine.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

merc1984@f-m.fm wrote (ao):
> Oh pardon me, it's BTRFS RAID that's a no-go, which is just as critical
> to me as I have a 4 disk 8TB array.
> The FAQ goeth on to Say:
> -----------------------------------------------------------
> This pretty much forbids you to use btrfs' cool RAID features if you
> need encryption.

Forbids? That is just plain wrong.

I have one btrfs filesystem on top of two encrypted devices. Works just
fine.

	Sander
