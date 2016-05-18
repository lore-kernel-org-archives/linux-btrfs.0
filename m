Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60026 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbcERJPT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 May 2016 05:15:19 -0400
Date: Wed, 18 May 2016 11:14:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Ivan P <chrnosphered@gmail.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/4] Add support to clear v1 free space cache for btrfs
 check
Message-ID: <20160518091451.GX511@suse.cz>
Reply-To: dsterba@suse.cz
References: <1463456878-17550-1-git-send-email-quwenruo@cn.fujitsu.com>
 <d2ae6dd2-13e0-eb5e-f1a9-9260dc8188c7@cn.fujitsu.com>
 <CADzmB21LFX+qMsVSiCOk9mPg_+42po01Vsw1iPFxuCT2UA8yTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CADzmB21LFX+qMsVSiCOk9mPg_+42po01Vsw1iPFxuCT2UA8yTA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 17, 2016 at 08:12:20PM +0200, Ivan P wrote:
> Thank you, however I can't seem to be able to compile that snapshot, I'm getting
> 
> ===========================
> /usr/bin/install -c -m644 -d 64-btrfs-dm.rules
> /home/myuser/aur/btrfs-progs-git/pkg/btrfs-progs-git/usr/lib/udev/rules.d
> /usr/bin/install: cannot create directory ‘64-btrfs-dm.rules’: File exists
> Makefile:400: recipe for target 'install' failed
> make: *** [install] Error 1
> ==> ERROR: A failure occurred in package()
> ===========================
> 
> Just to make sure I wasn't screwing up somewhere, I tried the
> btrfs-progs-git AUR package and I'm getting the same thing.
> It's not only me, however: according to [1] it could be that this
> commit has introduced it: [2]
> 
> Regards,
> Ivan.
> 
> [1] https://aur.archlinux.org/packages/btrfs-progs-git/
> [2] http://repo.or.cz/btrfs-progs-unstable/devel.git?a=commit;h=ebe5b1cc7885027521db3c1d16d84bd54cc1321b

I'll look into it, thanks for the report.
