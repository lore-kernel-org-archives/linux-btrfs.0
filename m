Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:49369 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753008AbcH1IG6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Aug 2016 04:06:58 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bdv7G-0005jW-Kv
        for linux-btrfs@vger.kernel.org; Sun, 28 Aug 2016 10:06:54 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Crush on btrfs device delete missing
Date: Sun, 28 Aug 2016 08:06:47 +0000 (UTC)
Message-ID: <pan$74431$bc836653$60152c18$c71d2df3@cox.net>
References: <20160828142252.0ded31f7@rose>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

MASAKI Yuhsuke posted on Sun, 28 Aug 2016 14:22:52 +0900 as excerpted:

> btrfs device delete missing always crushes and stop system.
> It log console only not STDOUT/STDERR or core file.

While I'm unlikely to be able to help with the problem, for those who 
can, you're missing some critical information, including kernel and btrfs-
progs versions (if they're old, please try a current 4.6 or 4.7 kernel if 
on current, or 4.4 if on LTS, and an appropriately matched or newer btrfs 
userspace as well), and btrfs filesystem usage or btrfs filesystem show 
and btrfs filesystem df outputs.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

