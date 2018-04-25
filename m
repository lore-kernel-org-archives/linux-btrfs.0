Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:39005 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750841AbeDYGdi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Apr 2018 02:33:38 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1fBDxd-0003GJ-T7
        for linux-btrfs@vger.kernel.org; Wed, 25 Apr 2018 08:31:25 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs progs release 4.16.1
Date: Wed, 25 Apr 2018 06:31:20 +0000 (UTC)
Message-ID: <pan$3f697$9cfd5cd2$6e9f2dc3$73937e71@cox.net>
References: <20180424115857.25174-1-dsterba@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba posted on Tue, 24 Apr 2018 13:58:57 +0200 as excerpted:

> btrfs-progs version 4.16.1 have been released.  This is a bugfix
> release.
> 
> Changes:
> 
>   * remove obsolete tools: btrfs-debug-tree, btrfs-zero-log,
>   btrfs-show-super, btrfs-calc-size

Cue the admin-side gripes about developer definitions of micro-upgrade 
explicit "bugfix release" that allow disappearance of "obsolete tools".

Arguably such removals can be expected in a "feature release", but 
shouldn't surprise unsuspecting admins doing a micro-version upgrade 
that's specifically billed as a "bugfix release".

(Further support for btrfs being "still stabilizing, not yet fully stable 
and mature."  But development mode habits need to end /sometime/, if 
stability is indeed a goal.) 

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

