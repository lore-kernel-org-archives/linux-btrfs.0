Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:50101 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752852AbdERGPP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 May 2017 02:15:15 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dBEiH-0005Z7-Gs
        for linux-btrfs@vger.kernel.org; Thu, 18 May 2017 08:15:05 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID 6 corrupted
Date: Thu, 18 May 2017 06:12:22 +0000 (UTC)
Message-ID: <pan$24de$e527cbb7$733b205c$f2415b2@cox.net>
References: <CA+M=Xp3+YQkeVNLkSZw77zMdia2LwSiaEaR=6Ejs0z2TvW2xwg@mail.gmail.com>
        <pan$3156f$ad60295$88e5604$e6cc7e68@cox.net>
        <20170517101523.ylmw4qo2wjsnibfh@angband.pl>
        <CA+M=Xp0o6uz6uBv41ygpFBiWyw1x6ucg38BtG3V-XdOJ9azvxA@mail.gmail.com>
        <20170518101719.6c9feabe@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Roman Mamedov posted on Thu, 18 May 2017 10:17:19 +0500 as excerpted:

> On Thu, 18 May 2017 04:09:38 +0200 Łukasz Wróblewski <lw@nri.pl> wrote:
> 
>> I will try when stable 4.12 comes out.
>> Unfortunately I do not have a backup.
>> Fortunately, these data are not so critical.
>> Some private photos and videos of youth.
>> However, I would be very happy if I could get it back.
> 
> Try saving your data with "btrfs restore" first 

First post, he tried that.  No luck.  Tho that was with 4.4 userspace.  
It might be worth trying with the 4.11-rc or soon to be released 4.11 
userspace, tho...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

