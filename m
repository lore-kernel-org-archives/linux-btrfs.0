Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:58208 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S932800AbdIXUkJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 24 Sep 2017 16:40:09 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dwDgy-0004LU-Ma
        for linux-btrfs@vger.kernel.org; Sun, 24 Sep 2017 22:39:56 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Btrfs performance with small blocksize on SSD
Date: Sun, 24 Sep 2017 22:39:55 +0200
Message-ID: <20170924223955.2dfda90f@jupiter.sol.kaishome.de>
References: <3321b3c199da4d378bbfa3dbac3c4059@rwth-aachen.de>
        <f05a6500-19d6-fc7c-7461-905417c855b7@gmx.com>
        <b9067303023a49158bae2cdc34393716@rwth-aachen.de>
        <ffd3bf37-3029-9f6e-5d57-6d8cca74fdad@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sun, 24 Sep 2017 19:43:05 +0300
schrieb Andrei Borzenkov <arvidjaar@gmail.com>:

> 24.09.2017 16:53, Fuhrmann, Carsten пишет:
> > Hello,
> > 
> > 1)
> > I used direct write (no page cache) but I didn't disable the Disk
> > cache of the HDD/SSD itself. In all tests I wrote 1GB and looked
> > for the runtime of that write process.  
> 
> So "latency" on your diagram means total time to write 1GiB file? That
> is highly unusual meaning for "latency" which normally means time to
> perform single IO. If so, you should better rename Y-axis to something
> like "total run time".

If you look closely it says "Laufzeit" which visually looks similar to
"latency" but really means "run time". ;-)


-- 
Regards,
Kai

Replies to list-only preferred.


