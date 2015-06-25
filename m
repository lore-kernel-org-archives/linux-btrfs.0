Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:42664 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbbFYVJP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jun 2015 17:09:15 -0400
Date: Thu, 25 Jun 2015 14:09:12 -0700
From: Marc MERLIN <marc@merlins.org>
To: Ruslanas =?utf-8?Q?G=C5=BEibovskis?= <ruslanas@lpic.lt>
Cc: Vytautas D <vytdau@gmail.com>, Robert Munteanu <robert.munteanu@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs partition converted from ext4 becomes read-only minutes after booting: WARNING: CPU: 2 PID: 2777 at ../fs/btrfs/super.c:260 __btrfs_abort_transaction+0x4b/0x120
Message-ID: <20150625210912.GD16565@merlins.org>
References: <CAC8ULPYHuqsZN1Lm_2TxGMw7z6n=4zAprqYr9uoi=3kjoiSxQw@mail.gmail.com> <20150617174630.GM16468@merlins.org> <CAC8ULPb2XCniELiuJtEajf=8usGTW14xzyfZLP9kxo3-fQ01dA@mail.gmail.com> <20150625041620.GK16468@merlins.org> <CAO5K3OeQTi4U02uJu+Df-00ci+P7E4HLw3x8CH3j0Uq937tQ6w@mail.gmail.com> <CABE5tBasBsycy_+q=RZj1dpqsLTREJTA72F-ZwNLt=kLX6wXhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CABE5tBasBsycy_+q=RZj1dpqsLTREJTA72F-ZwNLt=kLX6wXhg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 25, 2015 at 08:17:12PM +0000, Ruslanas Gžibovskis wrote:
> nope. started from scratch! never upgrade from old running fs. Better to
> move 1 file and extend , move another files, extend and so on then just
> convert... It's like moving from windows and only boot partition to have on
> ext2 and other system on ntfs... all my friends do the same. And by the way
> does anyone still use ext3/4? isn't it dead?  Even rhel now goes with
> default xfs...

Yes, plenty of people use ext4, it's not dead :)
It also just added built in encryption in the filesystem, which no other
filesystem has AFAIK.

Due to how btrfs works with block layouts, it shouldn't be hard to encrypt
blocks as they are written just like they can be compressed currently, but
no one has sponsored that work yet.
Because Google uses ext4 and they (we) care about encrypting data to
protect user data from things like possible hardware theft or maybe even
a datacenter being raided in some country, that's how ext4 got encryption
built in.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
