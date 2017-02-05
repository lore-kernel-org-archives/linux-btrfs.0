Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:55407 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752547AbdBEW1f (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Feb 2017 17:27:35 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1caVHJ-0006Rr-Ge
        for linux-btrfs@vger.kernel.org; Sun, 05 Feb 2017 23:27:25 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Is it possible to have metadata-only device with no data?
Date: Sun, 5 Feb 2017 23:27:21 +0100
Message-ID: <20170205232721.165e96f3@jupiter.sol.kaishome.de>
References: <14453691486330921@web21h.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mon, 06 Feb 2017 00:42:01 +0300
schrieb Alexander Tomokhov <alexoundos@ya.ru>:

> Is it possible, having two drives to do raid1 for metadata but keep
> data on a single drive only? --

No, but you could take a look into bcache which should get you
something similar if used in write-around mode.

Random access will become cached in bcache, which should most of the
time be metadata, plus of course randomly accessed data from HDD. If
you reduce the sequential cutoff trigger in bcache, it should cache
mostly metadata only.

-- 
Regards,
Kai

Replies to list-only preferred.

