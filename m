Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:51314 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S932228AbdBGTzZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Feb 2017 14:55:25 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cbBbe-0001Ly-7k
        for linux-btrfs@vger.kernel.org; Tue, 07 Feb 2017 20:39:14 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: BTRFS for OLTP Databases
Date: Tue, 7 Feb 2017 20:39:13 +0100
Message-ID: <20170207203913.02ffd712@jupiter.sol.kaishome.de>
References: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>
        <4e91cc08-19a4-5433-c1d3-60918906b022@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Tue, 7 Feb 2017 10:06:34 -0500
schrieb "Austin S. Hemmelgarn" <ahferroin7@gmail.com>:

> 4. Try using in-line compression.  This can actually significantly 
> improve performance, especially if you have slow storage devices and
> a really nice CPU.

Just a side note: With nodatacow there'll be no compression, I think.
At least for files with "chattr +C" there'll be no compression. I thus
think "nodatacow" has the same effect.

-- 
Regards,
Kai

Replies to list-only preferred.

