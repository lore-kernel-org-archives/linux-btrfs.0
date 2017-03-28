Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57605 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754921AbdC1L1r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Mar 2017 07:27:47 -0400
Date: Tue, 28 Mar 2017 13:26:43 +0200
From: David Sterba <dsterba@suse.cz>
To: slyich@gmail.com
Cc: Sergei Trofimovich <slyfox@gentoo.org>, linux-btrfs@vger.kernel.org,
        Mike Gilbert <floppym@gentoo.org>
Subject: Re: [PATCH] btrfs-progs: fix missing __error symbol in libbtrfs.so.0
Message-ID: <20170328112643.GV4781@suse.cz>
Reply-To: dsterba@suse.cz
References: <20170327114740.GA4781@twin.jikos.cz>
 <20170327210720.10775-1-slyich@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170327210720.10775-1-slyich@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 27, 2017 at 10:07:20PM +0100, slyich@gmail.com wrote:
> From: Sergei Trofimovich <slyfox@gentoo.org>
> 
> The easiest way to reproduce the error is to try to build
> btrfs-progs with
>     $ make LDFLAGS=-Wl,--no-undefined
> 
>     btrfs-list.o: In function `lookup_ino_path':
>     btrfs-list.c:(.text+0x7d2): undefined reference to `__error'
> 
> Noticed by Denis Descheneaux when snapper tool
> stopped working after upgrade to btrfs-progs-4.10.
> 
> As soname didn't change in 4.9 -> 4.10 release
> I assume it's just an object file omission
> in library depends and not the API/ABI change
> of the library error printing.
> 
> Cc: linux-btrfs@vger.kernel.org
> Cc: Mike Gilbert <floppym@gentoo.org>
> Reported-by: Denis Descheneaux
> Bug: https://bugs.gentoo.org/show_bug.cgi?id=613890
> 
> Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>

I've replaced my patch with yours, thanks.
