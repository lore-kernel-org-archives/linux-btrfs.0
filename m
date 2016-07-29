Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40604 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbcG2Mlv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jul 2016 08:41:51 -0400
Date: Fri, 29 Jul 2016 14:41:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Anatoly Pugachev <matorola@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        debian-sparc <debian-sparc@lists.debian.org>
Subject: Re: [sparc64] mkfs.btrfs bus error / align issue?
Message-ID: <20160729124129.GA30795@suse.cz>
Reply-To: dsterba@suse.cz
References: <20160727195609.GN30795@twin.jikos.cz>
 <20160728094441.GO30795@twin.jikos.cz>
 <CADxRZqwTUaZyDipvmGcfk8Q9P2X_NLQ=9svtc8BbKeFqoFVPdw@mail.gmail.com>
 <5cef3bff-a0bf-e4f9-7906-1b784171e266@physik.fu-berlin.de>
 <20160728122439.GW30795@twin.jikos.cz>
 <CADxRZqyzOtHmpaO9FHhvi0DJjmabRYL0eGYBXBPXSaYa0WcWEw@mail.gmail.com>
 <f56a1b71-cd68-3d83-0650-a10df01f5d5c@physik.fu-berlin.de>
 <b2ac0d76-f2e3-81d7-0ab1-35960426d412@physik.fu-berlin.de>
 <20160728180413.GY30795@suse.cz>
 <CADxRZqzt8m6j_GktpKYYmDar=hDYy07DhyiuPJ-gMgtGfiGhXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CADxRZqzt8m6j_GktpKYYmDar=hDYy07DhyiuPJ-gMgtGfiGhXQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 28, 2016 at 11:34:58PM +0300, Anatoly Pugachev wrote:
> well, I think mkfs.btrfs is fixed, since I just tested it with :

Good news, thanks.

> Not sure what we need to do with sparc64 btrfs module TPC messages.
> Probably fill kernel bugzilla report?

Yes please.

> [1] http://u163.east.ru/btrfs/xfstests-btrfs-06x-results.tar.gz
> [2] http://u163.east.ru/btrfs/kernel-4.7.0+-logs-xfstests-06x.txt.gz

quick stats of the TPC messages:

     23 __btrfs_map_block+0x36c/0x1180
      9 __remove_rbio_from_cache+0x38/0x140
      6 lock_stripe_add+0xb0/0x360
      4 __btrfs_map_block+0x3d4/0x1180
      3 __btrfs_map_block+0xca0/0x1180

running in 'gdb btrfs.ko' for each of the addresses should tell us what are the
locations:

gdb> l *(__btrfs_map_block+0x36c)
...

Thanks.
