Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:54042 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751845AbdKWJZz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Nov 2017 04:25:55 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eHnlP-0000HI-W4
        for linux-btrfs@vger.kernel.org; Thu, 23 Nov 2017 10:25:43 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs restore corrupt file
Date: Thu, 23 Nov 2017 09:25:35 +0000 (UTC)
Message-ID: <pan$c3b20$cd07d7e1$4b1a8f6a$c2ecab66@cox.net>
References: <CAHzMYBQ7tsHFuHkJ5zjK6Wx0bD0XHp0TGti_uJNV5pz4ak7wJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jorge Bastos posted on Wed, 22 Nov 2017 19:18:59 +0000 as excerpted:

> Hello,
> 
> While doing btrfs checksum testing I purposely corrupted a file and got
> the expect I/O error when trying to copy it, I also tested btrfs restore
> to see if I could recover a known corrupt file and it did copy it but
> there was no checksum error or warning. I used btrfs restore -v
> 
> Is this expect behavior or should restore warn about checksum failures?
> 
> Kernel used was 4.13.13,  btrfs-progs v4.13.2

AFAIK it's expected.  The purpose of btrfs restore, after all, is to try 
to get at least some files back from a filesystem that is generally 
damaged and unable to mount, so acceptance of some possible damage to 
restored files as a tradeoff for being able to restore them *at* *all* is 
assumed.  It's not /supposed/ to be a substitute for having a proper 
backup in the first place, only something to try in case there was no 
backup and getting back a damaged file is better than getting back no 
file, or in case there was a backup, but it wasn't current, in which case 
the restored files can be verified against the backup, and those that 
differ can be examined to see if the difference is due to legitimate 
change, or corruption.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

