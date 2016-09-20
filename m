Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:59138 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S932313AbcITIAF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 04:00:05 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bmFy8-0006Dy-15
        for linux-btrfs@vger.kernel.org; Tue, 20 Sep 2016 09:59:56 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: stability matrix (was: Is stability a joke?)
Date: Tue, 20 Sep 2016 07:59:44 +0000 (UTC)
Message-ID: <pan$9faa9$336f6d31$1fa59209$17e07862@cox.net>
References: <57D51BF9.2010907@online.no>
        <20160912142714.GE16983@twin.jikos.cz>
        <52304724-5bca-a1e6-527f-040085c7ab19@gmail.com>
        <20160912165107.GG16983@twin.jikos.cz>
        <58a954fc-bbd5-3fb5-9f23-008ed7f7121d@gmail.com>
        <20160915010759.GD32452@DigitalMercury.dynalias.net>
        <5dec6544a78a0301a8e0cd9086179f99@crc.id.au>
        <1473905644.8603.44.camel@scientia.net>
        <20160919152753.GG933@twin.jikos.cz>
        <1474314346.10189.19.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Mon, 19 Sep 2016 21:45:46 +0200 as
excerpted:

> On Mon, 2016-09-19 at 17:27 +0200, David Sterba wrote:
> 
>> > For specific features:
>> > - Autodefrag
>> >   - didn't that also cause reflinks to be broken up?
>> 
>> No and never had.
> 
> Absolutely sure? One year ago, I was told that at first too so I started
> using it, but later on some (IIRC) developer said auto-defrag would also
> suffer from it.

AFAIK it was Hugo that said he looked into that, and that (if I'm 
representing it correctly) autodefrag breaks reflinks and triggers space-
using duplication much as defrag does, but that it does it on a much 
smaller scale, since it (1) only triggers when some parts of a file are 
being rewritten anyway, thus breaking the reflink for those specific 
parts of the file due to COW (COW1 on otherwise NOCOW files) in any case, 
and (2) unlike defrag, doesn't rewrite and thus break the reflinks on 
entire files, just somewhat larger extents than the pure rewrite by 
itself without autodefrag would.

Thus making the reflink-breaking and duplication effect of autodefrag 
there, but relatively quite small compared to on-demand per-file defrag.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

