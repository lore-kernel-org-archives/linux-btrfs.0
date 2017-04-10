Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:36607 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752894AbdDJMpr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Apr 2017 08:45:47 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cxYhN-0000JT-RV
        for linux-btrfs@vger.kernel.org; Mon, 10 Apr 2017 14:45:37 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: btrfs filesystem keeps allocating new chunks for no apparent
 reason
Date: Mon, 10 Apr 2017 14:45:33 +0200
Message-ID: <20170410144533.664fc304@jupiter.sol.kaishome.de>
References: <572D0C8B.8010404@mendix.com>
        <89a684c7-364e-f409-5348-bc0077fd438c@cn.fujitsu.com>
        <5b642448-951e-5b5e-1343-0299a950089c@mendix.com>
        <51778c0f-2720-1c2d-aba2-e22e5f4d3a3a@mendix.com>
        <4532f6ee-2a6e-412a-7230-edb76735d55f@mendix.com>
        <07a7f59e-64e0-4d09-5d32-01bc933fe38d@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mon, 10 Apr 2017 08:39:23 -0400
schrieb "Austin S. Hemmelgarn" <ahferroin7@gmail.com>:

> They've been running BTRFS 
> with LZO compression, the SSD allocator, atime disabled, and mtime 
> updates deferred (lazytime mount option) the whole time, so it may be
> a slightly different use case than the OP from this thread.

Does btrfs really support lazytime now?

-- 
Regards,
Kai

Replies to list-only preferred.

