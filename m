Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:40378 "EHLO
        torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751805AbdEBHFH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 May 2017 03:05:07 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.84_2)
        (envelope-from <mh+linux-btrfs@zugschlus.de>)
        id 1d5Rrs-0002kk-Kt
        for linux-btrfs@vger.kernel.org; Tue, 02 May 2017 09:05:04 +0200
Date: Tue, 2 May 2017 09:05:04 +0200
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs won't mount any more
Message-ID: <20170502070504.GU2481@torres.zugschlus.de>
References: <20170411071531.GK3699@torres.zugschlus.de>
 <20170411161502.ol4tjl3agqnlerab@angband.pl>
 <20170413084509.GH3699@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170413084509.GH3699@torres.zugschlus.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 13, 2017 at 10:45:09AM +0200, Marc Haber wrote:
> I do have a dd copy of the device now.
> 
> $ sudo losetup --find --show ./dropbtr0.btrfs
> $ sudo mount -o skip_balance -t btrfs /dev/loop0 /mnt/tempdisk
> 
> does immediately result in:
> 
> Apr 12 22:37:48 fan kernel: [  124.742104] loop: module loaded
> Apr 12 22:37:48 fan kernel: [  124.784727] BTRFS: device label dropbtr0 devid 1 transid 1530529 /dev/loop0
> Apr 12 22:38:07 fan kernel: [  143.120268] BTRFS info (device loop0): disk space caching is enabled
> Apr 12 22:38:07 fan kernel: [  143.207872] BUG: unable to handle kernel NULL pointer dereference at 00000000000001f0

This is now https://bugzilla.kernel.org/show_bug.cgi?id=195631

Greetings
Marc
-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
