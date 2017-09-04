Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:47847 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753411AbdIDKsD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Sep 2017 06:48:03 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1doour-0008C1-PV
        for linux-btrfs@vger.kernel.org; Mon, 04 Sep 2017 12:47:41 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH 5/5] btrfs-progs: Doc/mkfs: Add explanation for rootdir
 parameter
Date: Mon, 4 Sep 2017 10:47:19 +0000 (UTC)
Message-ID: <pan$d6ecf$22d097ca$4cb2dd48$57a81ef5@cox.net>
References: <20170904064110.25951-1-quwenruo.btrfs@gmx.com>
        <20170904064110.25951-6-quwenruo.btrfs@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qu Wenruo posted on Mon, 04 Sep 2017 15:41:10 +0900 as excerpted:

> +NOTE: Result btrfs will be shrink to it minimal size, exceeding space will not
> +be accessible unless resized.

s/exceeding/additional/

(Exceeding could be used if reworded, but the results I came up with were
much less concise than the above with the single substitution, so...)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

