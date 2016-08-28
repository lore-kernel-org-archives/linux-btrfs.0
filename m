Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:36481 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752371AbcH1NgC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Aug 2016 09:36:02 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1be0Es-0001ld-5B
        for linux-btrfs@vger.kernel.org; Sun, 28 Aug 2016 15:35:06 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: btrfstune settings
Date: Sun, 28 Aug 2016 15:30:55 +0200
Message-ID: <20160828153055.41ac2d39@jupiter.sol.kaishome.de>
References: <fac36170-075c-db45-5aff-afa55bcd9e34@googlemail.com>
        <pan$852e9$bd44e66c$65d119d9$c6922137@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sun, 28 Aug 2016 08:27:59 +0000 (UTC)
schrieb Duncan <1i5t5.duncan@cox.net>:

> > However, I miss two things:
> > - How do I see on an existing FS which of these features are on?
> >   btrfstune (it seems) can only "set", but not "get" the feature
> > flags.  
> 
> Try btrfs-show-super <device>.  The incompat_flags section enumerates
> the flags that are on (at least with a reasonably new btrfs-progs).

It's also in the sub directories of /sys/fs/btrfs...

-- 
Regards,
Kai

Replies to list-only preferred.

