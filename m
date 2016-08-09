Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from trent.utfs.org ([94.185.90.103]:54132 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932395AbcHIXcC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Aug 2016 19:32:02 -0400
Date: Tue, 9 Aug 2016 16:24:23 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Ivan Sizov <sivan606@gmail.com>
cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Strange behavior after "rm -rf //"
In-Reply-To: <CAMG9ccwK93opLn=qOcceDjExwDHHRaxO=juvcXz4TuWKt_qXeg@mail.gmail.com>
Message-ID: <alpine.DEB.2.20.14.1608091420150.8131@trent.utfs.org>
References: <CAMG9ccwK93opLn=qOcceDjExwDHHRaxO=juvcXz4TuWKt_qXeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 8 Aug 2016, Ivan Sizov wrote:
> I'd ran "rm -rf //" by mistake two days ago. I'd stopped it after five

Out of curiosity, what version of coreutils is this? The --preserve-root 
option is the default for quite some time now:

> Don't include dirname.h, since system.h does it now.
> (usage, main): --preserve-root is now the default.
> 2006-09-03 02:53:58 +0000
http://git.savannah.gnu.org/cgit/coreutils.git/commit/src/rm.c?id=89ffaa19909d31dffbcf12fb4498afb72666f6c9

Even coreutils-6.10 from Debian/5 refuses to remove "/":

$ sudo rm -rf /
rm: cannot remove root directory `/'

Christian.
-- 
BOFH excuse #243:

The computer fleetly, mouse and all.
