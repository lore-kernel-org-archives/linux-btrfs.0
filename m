Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:53066 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbeIVLwV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 22 Sep 2018 07:52:21 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1g3avO-0003nQ-CZ
        for linux-btrfs@vger.kernel.org; Sat, 22 Sep 2018 07:57:50 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [RFC PATCH v2 0/4] btrfs-progs: build distinct binaries for
 specific btrfs subcommands
Date: Sat, 22 Sep 2018 05:57:44 +0000 (UTC)
Message-ID: <pan$687fd$ec9c9bfb$3382466c$134cec49@cox.net>
References: <20180912144604.6178-1-axel@tty0.ch>
        <3ceee37e-66f5-e2f8-dbc9-fde2452a6447@tty0.ch>
        <pan$1f31c$d7f59d13$3b6f50b9$200a6f62@cox.net>
        <de48e007-451e-6094-c4c6-ee1662ff3836@tty0.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Axel Burri posted on Fri, 21 Sep 2018 11:46:37 +0200 as excerpted:

> I think you got me wrong here: There will not be binaries with the same
> filename. I totally agree that this would be a bad thing, no matter if
> you have bin/sbin merged or not, you'll end up in either having a
> collision or (even worse) rely on the order in $PATH.
> 
> With this "separated" patchset, you can install a binary
> "btrfs-subvolume-show", which has the same functionality as "btrfs
> subvolume show" (note the whitespace/dash), ending up with:
> 
>     /sbin/btrfs
>     /usr/bin/btrfs-subvolume-show
>     /usr/bin/btrfs-subvolume-list

I did get you wrong (and had even understood the separately named 
binaries from an earlier post, too, but forgot).

Thanks. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman
