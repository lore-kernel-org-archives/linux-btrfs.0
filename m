Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from stan.its.monash.edu.au ([130.194.13.165]:56986 "EHLO
	stan.its.monash.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab2JBMud convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Oct 2012 08:50:33 -0400
Received: from idle.its.monash.edu.au ([130.194.13.84])
 by stan.its.monash.edu.au
 (Sun Java System Messaging Server 6.2-4.03 (built Sep 22 2005))
 with ESMTP id <0MB900M5CNO7A880@stan.its.monash.edu.au> for
 linux-btrfs@vger.kernel.org; Tue, 02 Oct 2012 22:50:31 +1000 (EST)
Received: from idle.its.monash.edu.au (localhost.localdomain [127.0.0.1])
	by localhost (Postfix) with SMTP id ABE4F100D0	for
 <linux-btrfs@vger.kernel.org>; Tue, 02 Oct 2012 22:50:31 +1000 (EST)
Received: from mail-ie0-f174.google.com
 (mail-ie0-f174.google.com [209.85.223.174])
	(using TLSv1 with cipher RC4-SHA (128/128 bits))
	(No client certificate requested)	by idle.its.monash.edu.au (Postfix)
 with ESMTPS id 23ED3100C8	for <linux-btrfs@vger.kernel.org>; Tue,
 02 Oct 2012 22:50:30 +1000 (EST)
Received: by ieak13 with SMTP id k13so14493450iea.19 for
 <linux-btrfs@vger.kernel.org>; Tue, 02 Oct 2012 05:50:27 -0700 (PDT)
Date: Tue, 02 Oct 2012 22:50:26 +1000
From: Gordon Ng <gfng1@student.monash.edu>
Subject: [Btrfs-next] bulid failure at fs/btrfs/ctree.h
To: linux-btrfs@vger.kernel.org
Message-id: <CAJ09SM8fTkek=jN1QY1SHOs0uRiuUf4ug4+DRwJBYd0Yj3axfg@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Josef,

FYI build failure occured in fs/btrfs/ctree.h.
  CC      fs/btrfs/super.o
In file included from fs/btrfs/delayed-inode.h:30:0,
                 from fs/btrfs/super.c:45:
fs/btrfs/ctree.h:3235:1: error: expected identifier or ‘(’ before ‘<<’ token
make[3]: *** [fs/btrfs/super.o] Error 1
make[2]: *** [fs/btrfs] Error 2
make[1]: *** [fs] Error 2
make[1]: Leaving directory `
make: *** [debian/stamp/build/kernel] Error 2

Kernel version: 3.6.0
build environment: Debian Wheezy/Sid x86-64 (Kernel Version 3.6.0-rc7)

Thanks,
Gordon
