Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:36642 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750831AbcJALEe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Oct 2016 07:04:34 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bqI5l-00025e-0O
        for linux-btrfs@vger.kernel.org; Sat, 01 Oct 2016 13:04:29 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Resize a btrfs File System : no enough free space... why ?!?
Date: Sat, 1 Oct 2016 11:04:20 +0000 (UTC)
Message-ID: <pan$e7a51$3d126d61$672be7e8$f3a5b36f@cox.net>
References: <CAOf5Se5C+6Y+=uz=Lkv-wrPhHZOMD94hzrtLHwDR3D78UHiSSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nicolas Pujol posted on Sat, 01 Oct 2016 10:42:32 +0200 as excerpted:

> Like I don't understand the error, do you know why I can not resize the
> BTRFS partition while 2TB are free?
> 
> For information:
> # uname -a Linux PC-NPL 4.6.4-1-ARCH #1 SMP PREEMPT Mon Jul 11 19:12:32
> CEST 2016 x86_64 GNU/Linux

You might try 4.7 or the very close 4.8 or its last rc.  Some ENOSPC fix 
patches went in recently and may well fix your problem.  I know they're 
in mainline now, but IDR whether it made 4.7 or not.

Hopefully that eliminates your problem; they've been reported to do it 
for others running into ENOSPC issues. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

