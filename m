Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:60145 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbeHVHWe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Aug 2018 03:22:34 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1fsKGm-0000uN-Ui
        for linux-btrfs@vger.kernel.org; Wed, 22 Aug 2018 05:57:20 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: lazytime mount =?CP1251?Q?option=97no?= support in Btrfs
Date: Wed, 22 Aug 2018 03:57:14 +0000 (UTC)
Message-ID: <pan$4b9b5$2e5ff999$1d9fa649$483aa66c@cox.net>
References: <ompef3$sim$1@blaine.gmane.org>
        <a9037e77-5ea6-fadd-23a1-6cd1f2770220@dirtcellar.net>
        <2641568.fxl50hTsRH@merkaba>
        <E6FB1ABD-4C84-422B-BD9D-E46D96D03155@gmail.com>
        <088684be-c1ff-c144-6ff7-e41670669c7e@gmail.com>
        <20180821120636.fatftem5qbhv22m4@angband.pl>
        <d959efa3-4e45-c471-625d-c4ad747083ad@gmail.com>
        <CANznX5EwH-DSNzFwCiUrLgxA8P_nrNQoVfPQDQ=v6jM2_dEHAw@mail.gmail.com>
        <774d8406-d8c8-f26b-b176-8ac954c59722@gmail.com>
        <20180821160547.GF24025@twin.jikos.cz>
        <49b2ad81-256a-981e-cf6c-04e3bf32e932@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Tue, 21 Aug 2018 13:01:00 -0400 as
excerpted:

> Otherwise, the only option for people who want it set is to patch the
> kernel to get noatime as the default (instead of relatime).  I would
> look at pushing such a patch upstream myself actually, if it weren't for
> the fact that I'm fairly certain that it would be immediately NACK'ed by
> at least Linus, and probably a couple of other people too.

What about making default-noatime a kconfig option, presumably set to 
default-relatime by default?  That seems to be the way many legacy-
incompatible changes work.  Then for most it's up to the distro, which in 
fact it is already, only if the distro set noatime-default they'd at 
least be using an upstream option instead of patching it themselves, 
making it upstream code that could be accounted for instead of downstream 
code that... who knows?

Meanwhile, I'd be interested in seeing your local patch.  I'm local-
patching noatime-default here too, but not being a dev, I'm not entirely 
sure I'm doing it "correctly", tho AFAICT it does seem to work.  FWIW, 
here's what I'm doing (posting inline so may be white-space damaged, and 
IIRC I just recently manually updated the line numbers so they don't 
reflect the code at the 2014 date any more, but as I'm not sure of the 
"correctness" it's not intended to be applied in any case):

--- fs/namespace.c.orig	2014-04-18 23:54:42.167666098 -0700
+++ fs/namespace.c	2014-04-19 00:19:08.622741946 -0700
@@ -2823,8 +2823,9 @@ long do_mount(const char *dev_name, cons
 		goto dput_out;
 
 	/* Default to relatime unless overriden */
-	if (!(flags & MS_NOATIME))
-		mnt_flags |= MNT_RELATIME;
+	/* JED: Make that noatime */
+	if (!(flags & MS_RELATIME))
+		mnt_flags |= MNT_NOATIME;
 
 	/* Separate the per-mountpoint flags */
 	if (flags & MS_NOSUID)
@@ -2837,6 +2837,8 @@ long do_mount(const char *dev_name, cons
 		mnt_flags |= MNT_NOATIME;
 	if (flags & MS_NODIRATIME)
 		mnt_flags |= MNT_NODIRATIME;
+	if (flags & MS_RELATIME)
+		mnt_flags |= MNT_RELATIME;
 	if (flags & MS_STRICTATIME)
 	mnt_flags &= ~(MNT_RELATIME | MNT_NOATIME);
 	if (flags & MS_RDONLY)

Sane, or am I "doing it wrong!"(TM), or perhaps doing it correctly, but 
missing a chunk that should be applied elsewhere?


Meanwhile, since broken rootflags requiring an initr* came up let me take 
the opportunity to ask once again, does btrfs-raid1 root still require an 
initr*?  It'd be /so/ nice to be able to supply the appropriate 
rootflags=device=...,device=... and actually have it work so I didn't 
need the initr* any longer!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman
