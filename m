Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:43779 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750964AbdDAJFf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Apr 2017 05:05:35 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cuEyF-0004b7-GI
        for linux-btrfs@vger.kernel.org; Sat, 01 Apr 2017 11:05:19 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Shrinking a device - performance?
Date: Sat, 1 Apr 2017 11:05:05 +0200
Message-ID: <20170401110505.4c3baa6e@jupiter.sol.kaishome.de>
References: <1CCB3887-A88C-41C1-A8EA-514146828A42@flyingcircus.io>
        <20170327130730.GN11714@carfax.org.uk>
        <3558CE2F-0B8F-437B-966C-11C1392B81F2@flyingcircus.io>
        <20170327132404.GO11714@carfax.org.uk>
        <c2b19e0a-b345-5d72-2a60-ff86cde7cfca@gmail.com>
        <D3C6181C-2485-4CBC-AD13-A367DD6665F2@flyingcircus.io>
        <333BD058-6365-43C3-8070-E6267936D98D@flyingcircus.io>
        <bf772a48-5181-d1ea-f7a7-5dffc524e2de@gmail.com>
        <CDED0C65-B382-4EFF-90C6-140F5C8DFC0E@flyingcircus.io>
        <20170327200646.41e82280@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mon, 27 Mar 2017 20:06:46 +0500
schrieb Roman Mamedov <rm@romanrm.net>:

> On Mon, 27 Mar 2017 16:49:47 +0200
> Christian Theune <ct@flyingcircus.io> wrote:
> 
> > Also: the idea of migrating on btrfs also has its downside - the
> > performance of “mkdir” and “fsync” is abysmal at the moment. I’m
> > waiting for the current shrinking job to finish but this is likely
> > limited to the “find free space” algorithm. We’re talking about a
> > few megabytes converted per second. Sigh.  
> 
> Btw since this is all on LVM already, you could set up lvmcache with
> a small SSD-based cache volume. Even some old 60GB SSD would work
> wonders for performance, and with the cache policy of "writethrough"
> you don't have to worry about its reliability (much).

That's maybe the best recommendation to speed things up. I'm using
bcache here for the same reasons (speeding up random workloads) and it
works wonders.

Tho, for such big storage I'd maybe recommend a bigger SSD and a new
one. Bigger SSDs tend to last much longer. Just don't use the whole of
it to allow for better wear leveling and you'll get a final setup that
can serve the system much longer than for the period of migration.

-- 
Regards,
Kai

Replies to list-only preferred.


