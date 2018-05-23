Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:58978 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1754416AbeEWJLu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 May 2018 05:11:50 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1fLPm1-0007CY-DU
        for linux-btrfs@vger.kernel.org; Wed, 23 May 2018 11:09:33 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: csum failed root raveled during balance
Date: Wed, 23 May 2018 09:09:26 +0000 (UTC)
Message-ID: <pan$d9d06$238f0899$805884d5$1c7cb19b@cox.net>
References: <5B047817.3040106@gmail.com>
        <e04ab862-abe3-7187-1519-b89776df9362@suse.com> <5B052068.5000608@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

ein posted on Wed, 23 May 2018 10:03:52 +0200 as excerpted:

>> IMHO the best course of action would be to disable checksumming for you
>> vm files.
>> 
>> 
> Do you mean '-o nodatasum' mount flag? Is it possible to disable
> checksumming for singe file by setting some magical chattr? Google
> thinks it's not possible to disable csums for a single file.

You can use nocow (-C), but of course that has other restrictions (like 
setting it on the files when they're zero-length, easiest done for 
existing data by setting it on the containing dir and copying files (no 
reflink) in) as well as the nocow effects, and nocow becomes cow1 after a 
snapshot (which locks the existing copy in place so changes written to a 
block /must/ be written elsewhere, thus the cow1, aka cow the first time 
written after the snapshot but retain the nocow for repeated writes 
between snapshots).

But if you're disabling checksumming anyway, nocow's likely the way to go.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

