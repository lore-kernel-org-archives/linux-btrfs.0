Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:36073 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751678AbcLBFJo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Dec 2016 00:09:44 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cCg6M-0000UO-Dc
        for linux-btrfs@vger.kernel.org; Fri, 02 Dec 2016 06:09:38 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH] btrfs-progs: doc: Update docs about RAID profiles
Date: Fri, 2 Dec 2016 05:09:29 +0000 (UTC)
Message-ID: <pan$eefb3$ec5cb11a$a6a72bcd$61cd518@cox.net>
References: <20161201200117.6743-1-ahferroin7@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Thu, 01 Dec 2016 15:01:17 -0500 as
excerpted:

> This adds some more info about chunk profiles in the mkfs manpage,
> specifically providing better info about raid1 and raid10 profiles and
> the fact that they can't survive more than one device failing.
> 
> This should hopefully make it less likely that people hit unexpected
> behavior when using these profiles.
> 
> Signed-off-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
> ---
> This should work to cover most of the issues brought up on the mailing
> list recently regarding this particular aspect of documentation.
> 
>  Documentation/mkfs.btrfs.asciidoc | 44
>  ++++++++++++++++++++++++++++++++-------
>  1 file changed, 36 insertions(+), 8 deletions(-)

FWIW, LGTM as a btrfs user and list regular.  Thanks. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

