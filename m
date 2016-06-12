Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55158 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932391AbcFLPrs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jun 2016 11:47:48 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bC7c1-0005Fw-1k
	for linux-btrfs@vger.kernel.org; Sun, 12 Jun 2016 17:47:45 +0200
Received: from ipbcc01ae2.dynamic.kabel-deutschland.de ([188.192.26.226])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Jun 2016 17:47:45 +0200
Received: from eye1tm by ipbcc01ae2.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Jun 2016 17:47:45 +0200
To: linux-btrfs@vger.kernel.org
From: Henk Slager <eye1tm@gmail.com>
Subject: Re: Files seen by some apps and not others
Date: Sun, 12 Jun 2016 15:47:38 +0000 (UTC)
Message-ID: <loom.20160612T172707-790@post.gmane.org>
References: <CAMPo9spCUSEwMBhGWcr1iX0ny28e52GYMO4D=eug-MZaWB0iEQ@mail.gmail.com> <pan$dc991$bc4b5712$73c16333$5c108126@cox.net> <CAMPo9srkVgJkBqmH6LoTuEyBj6yP-=HX6QR6HTFrfr+zQPyLvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Bearcat ÅÃ¡ndor <bearcatsandor <at> gmail.com> writes:

> Is there a fix for the bad tree block error, which seems to be the
> root (pun intended) of all this?

I think the root cause is some memory corruption. It might be known case, 
maybe someone else recognizes something.

Anyhow, if you can't and won't reproduce it, best is to test 
memory/hardware, check any software that might have overwritten something in 
memory, use a recent (mainline/stable) kernel and see if it runs stable.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
