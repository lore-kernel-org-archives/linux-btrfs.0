Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:54424 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107Ab2JBNQI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Oct 2012 09:16:08 -0400
Date: Tue, 2 Oct 2012 09:16:03 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Gordon Ng <gfng1@student.monash.edu>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [Btrfs-next] bulid failure at fs/btrfs/ctree.h
Message-ID: <20121002131603.GC2370@localhost.localdomain>
References: <CAJ09SM8fTkek=jN1QY1SHOs0uRiuUf4ug4+DRwJBYd0Yj3axfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <CAJ09SM8fTkek=jN1QY1SHOs0uRiuUf4ug4+DRwJBYd0Yj3axfg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 02, 2012 at 06:50:26AM -0600, Gordon Ng wrote:
> Hello Josef,
> 
> FYI build failure occured in fs/btrfs/ctree.h.
>   CC      fs/btrfs/super.o
> In file included from fs/btrfs/delayed-inode.h:30:0,
>                  from fs/btrfs/super.c:45:
> fs/btrfs/ctree.h:3235:1: error: expected identifier or ‘(’ before ‘<<’ token
> make[3]: *** [fs/btrfs/super.o] Error 1
> make[2]: *** [fs/btrfs] Error 2
> make[1]: *** [fs] Error 2
> make[1]: Leaving directory `
> make: *** [debian/stamp/build/kernel] Error 2
> 
> Kernel version: 3.6.0
> build environment: Debian Wheezy/Sid x86-64 (Kernel Version 3.6.0-rc7)

Hrm, builds fine for me, my top commit is

fcf8891f51729a1d2660437f67795c03af7a7f8c

is it the same for you?  Thanks,

Josef
