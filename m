Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:38190 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbaL2JGM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Dec 2014 04:06:12 -0500
Received: from merkaba.localnet (host-188-174-199-225.customer.m-online.net [188.174.199.225])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id E093119A
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Dec 2014 10:05:20 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: fstrim not working on one of three BTRFS filesystems
Date: Mon, 29 Dec 2014 10:06:09 +0100
Message-ID: <473294984.vKf8bAYoVi@merkaba>
In-Reply-To: <pan$e8b97$69faf00b$ca66e14d$c2effd06@cox.net>
References: <3979684.puYLD8DjTq@merkaba> <pan$e8b97$69faf00b$ca66e14d$c2effd06@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag, 29. Dezember 2014, 02:08:21 schrieb Duncan:
> Martin Steigerwald posted on Sun, 28 Dec 2014 17:58:17 +0100 as excerpted:
> 
> > The fstrim on /home returns immediately. It does not even seem to trim
> > anything. What could be the cause for that?
> 
> While I don't know your mapper layout, trim working on the others but not 
> on /home sounds to me like either one of the physical devices on which 
> /home is located doesn't support trim, or they all do, but somewhere 
> along the line that information is being lost, so it doesn't believe trim 
> can actually work on that filesystem.  Typical shortcut "the information 
> available says that can't work, simply return before trying" behavior.

Duncan, it did trim before. Its on two SSDs that definately support trim.

Anyway, I got an hint about it of list with a patch to test.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
