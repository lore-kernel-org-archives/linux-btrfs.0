Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tango.0pointer.de ([85.214.72.216]:55135 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060AbaFPKOw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Jun 2014 06:14:52 -0400
Date: Mon, 16 Jun 2014 12:14:49 +0200
From: Lennart Poettering <lennart@poettering.net>
To: Russell Coker <russell@coker.com.au>
Cc: kreijack@inwind.it, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org, systemd-devel@lists.freedesktop.org
Subject: Re: [systemd-devel] Slow startup of systemd-journal on BTRFS
Message-ID: <20140616101448.GB18016@tango.0pointer.de>
References: <1346098950.2730051402571606829.JavaMail.defaultUser@defaultHost>
 <539BFF47.8060006@libero.it>
 <20140615221307.GE24386@tango.0pointer.de>
 <1709025.rRUgx5gMp1@xev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1709025.rRUgx5gMp1@xev>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 16.06.14 10:17, Russell Coker (russell@coker.com.au) wrote:

> > I am not really following though why this trips up btrfs though. I am
> > not sure I understand why this breaks btrfs COW behaviour. I mean,
> > fallocate() isn't necessarily supposed to write anything really, it's
> > mostly about allocating disk space in advance. I would claim that
> > journald's usage of it is very much within the entire reason why it
> > exists...
> 
> I don't believe that fallocate() makes any difference to fragmentation on 
> BTRFS.  Blocks will be allocated when writes occur so regardless of an 
> fallocate() call the usage pattern in systemd-journald will cause 
> fragmentation.

journald's write pattern looks something like this: append something to
the end, make sure it is written, then update a few offsets stored at
the beginning of the file to point to the newly appended data. This is
of course not easy to handle for COW file systems. But then again, it's
probably not too different from access patterns of other database or
database-like engines...

Lennart

-- 
Lennart Poettering, Red Hat
