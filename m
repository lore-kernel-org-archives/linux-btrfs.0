Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:39081 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753606AbdAKT0i (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Jan 2017 14:26:38 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cROXJ-00056S-FN
        for linux-btrfs@vger.kernel.org; Wed, 11 Jan 2017 20:26:17 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: mkfs.btrfs/balance small-btrfs chunk size RFC
Date: Wed, 11 Jan 2017 19:25:57 +0000 (UTC)
Message-ID: <pan$d5335$4c7aeed6$8086366b$7bb695a1@cox.net>
References: <pan$cb31b$a126bd1f$577e9db8$38b890f5@cox.net>
        <db8aff8c-44a5-f488-56de-4a9ec87e44e0@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Tue, 10 Jan 2017 09:57:52 -0500 as
excerpted:

> I can't personally comment on the code itself right now (I've actually
> never looked at the mkfs code, or any of the stuff that deals with the
> System chunk), but I can make a few general comments on this:
> 1. This behavior is still the case as of a Git build from yesterday (I
> just verified this myself with the locally built copy of btrfs-progs on
> my laptop).

Thanks.  After posting and seeing Qu W's response I was thinking I needed 
to test current behavior, and you just saved me the trouble (tho I do 
need to freshen my backup /boot one of these days, likely testing 
mkfs.btrfs on this in the process, but that can wait until 4.10).

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

