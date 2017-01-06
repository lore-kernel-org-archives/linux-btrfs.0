Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:54667 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1754196AbdAFDJu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jan 2017 22:09:50 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cPKuQ-0002vS-Ru
        for linux-btrfs@vger.kernel.org; Fri, 06 Jan 2017 04:09:38 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: kernel crash after upgrading to 4.9
Date: Fri, 6 Jan 2017 03:09:32 +0000 (UTC)
Message-ID: <pan$79bda$3b47e457$6b85eb6a$ae26fa79@cox.net>
References: <c0d145b6-6c81-ef52-4876-85eab927bae7@techsquare.com>
        <pan$bae57$81ae2edc$f6b8d81e$acf53525@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan posted on Thu, 05 Jan 2017 09:23:35 +0000 as excerpted:

> In his case the copying was from 7.2krpm to 5.6krpm drives, but not the
> reverse or when copying from slower to faster.

Ugh.  What I /meant/ was:

Slower to faster:	worked
Between same speeds:	worked
Faster to slower:	was broken

(I repeated the first case twice in different words instead of listing 
the second.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

