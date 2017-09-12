Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-33-wd.italiaonline.it ([212.48.13.167]:55747 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751546AbdILRuX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Sep 2017 13:50:23 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH v2 7/7] btrfs-progs: Doc/mkfs: Add extra condition for
 rootdir option
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        Austin S Hemmelgarn <ahferroin7@gmail.com>
References: <20170911063612.32114-1-quwenruo.btrfs@gmx.com>
 <20170911063612.32114-8-quwenruo.btrfs@gmx.com>
 <20170912170304.GD29043@twin.jikos.cz>
From: Goffredo Baroncelli <kreijack@libero.it>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <0a949fd9-f0cf-22c5-4e91-ebb1bfad1355@libero.it>
Date: Tue, 12 Sep 2017 19:50:19 +0200
MIME-Version: 1.0
In-Reply-To: <20170912170304.GD29043@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/12/2017 07:03 PM, David Sterba wrote:
> Say I want to prepare a minimal image but will provide a large file 
                                                ^^^^^^^^^^^^^^^^^^^^^^

I think that if the target is a file AND --minimize is passed, it is a reasonable expectation that the file is created "on the fly" and grown up to what needed.  

What I mean is that "--minimize" is passed (and a file is passed), mkfs.btrfs should 
a) create the file if it doesn't exist, and avoid any check about its length
b) truncate the file at the end

unfortunately the checks are in more places, so removing these checks is a quite intrusive change...

> at
> the beginning because I don't know what's the resulting size going to
> be. In this case, something like
> 
> $ mkfs.btrfs --rootdir dir/ --minimize image

BR
G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
