Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:44200 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751296AbdHABgh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Jul 2017 21:36:37 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dcM6g-0000FD-9U
        for linux-btrfs@vger.kernel.org; Tue, 01 Aug 2017 03:36:22 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 4.11.6 / more corruption / root 15455 has a root item with a more
 recent gen (33682) compared to the found root node (0)
Date: Tue, 1 Aug 2017 01:36:09 +0000 (UTC)
Message-ID: <pan$3cfa0$3afe82cb$bc3321e6$72d33baa@cox.net>
References: <20170501170641.GG3516@merlins.org>
        <20170707163834.GA6083@merlins.org> <20170709043417.GE6704@merlins.org>
        <21425367.VGcO8ck7Vu@merkaba>
        <MEXPR01MB216863F67F4553F8564CC3CD9EA80@MEXPR01MB2168.ausprd01.prod.outlook.com>
        <pan$2b9aa$a4dca8a2$fc1e4ebe$a8fffbe3@cox.net>
        <CAK5rZE7sj+T8-x0q=wPXeHKN4zBZGc2Jhj9NYA7ZQcV+yk2XSA@mail.gmail.com>
        <pan$12269$5fb80e78$f5b26ca4$74a3427f@cox.net>
        <CAK5rZE6vMujb5KEqwUZD2-ZmZ4vi2T4+J2BzTLi9qqx8GeFKgg@mail.gmail.com>
        <pan$3b64a$a9b921fc$3e4651f5$627d0636@cox.net>
        <CAK5rZE6urkaR7B8MxA_MB_e9PfNwDHuu_APnKCBZ+EVJrDo7bw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Imran Geriskovan posted on Mon, 31 Jul 2017 22:32:39 +0200 as excerpted:

>>> Now the init on /boot is a "19 lines" shell script, including lines
>>> for keymap, hdparm, crytpsetup. And let's not forget this is possible
>>> by a custom kernel and its reliable buddy syslinux.
>>
>> FWIW...
>> And I'm using dracut for that, tho quite cut down from its default,
>> with a monolithic kernel and only installing necessary dracut modules.
> 
> Just create minimal bootable /boot for running below init.
> (Your initramfs/rd is a bloated and packaged version of this anyway.)
> Kick the rest. Since you a have your own kernel you are not far away
> from it.

Thanks.  You just solved my primary problem of needing to take the time 
to actually research all the steps and in what order I needed to do them, 
for a hand-rolled script. =:^)

Unfortunately, while I've been laid-up the last ~5 days due to a twisted 
knee and have been spending more time on the lists, etc, and would have 
loved to spend a day or so testing and setting this up, I'm back to work 
tomorrow, so I've no idea when I'll actually get to play with this.

But meanwhile, I'm saving your message for reference when the time 
comes.  It should be /very/ useful!  =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

