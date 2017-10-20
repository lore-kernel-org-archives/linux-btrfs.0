Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:45505 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750944AbdJTGdU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Oct 2017 02:33:20 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1e5Qrf-0000mo-1K
        for linux-btrfs@vger.kernel.org; Fri, 20 Oct 2017 08:33:03 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: SLES 11 SP4: can't mount btrfs
Date: Fri, 20 Oct 2017 06:32:49 +0000 (UTC)
Message-ID: <pan$fadb$8e7e93ec$490dcb14$141c17d2@cox.net>
References: <1844960059.7648040.1508435017395.JavaMail.zimbra@helmholtz-muenchen.de>
        <CAJCQCtQkp2cLi=8NSHLe6WXwgqBdydAgeCO5NF=g33g8jv7qZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Thu, 19 Oct 2017 21:04:26 +0100 as excerpted:

> On Thu, Oct 19, 2017 at 6:43 PM, Lentes, Bernd
> <bernd.lentes@helmholtz-muenchen.de> wrote:
>> Hi,
>>
>> this is the continuation of a thread i started on a SLES forum
>> (https://forums.suse.com/showthread.php?10109-lv-with-btrfs-corrupt-
some-tips-please),
>> but i think this is the more appropriate place.
> 
> Maybe, but as this is SLES, you're effectively paying for support, and
> it's actually better to open a support instance, in my opinion.

This is what I'd recommend as well.

That 3.0.x kernel is well out of the range this list tends to support, 
given that it's a forward-focused development list, not a stability-
focused enterprise release support list.  We generally go back a couple 
release series each in the mainline current and LTS release series, which 
means 4.13 and 4.12 on current, and 4.9 and 4.4 on LTS, but even 4.4 is 
getting pretty long in the tooth for this list, so it's fortunate that 
the coming 4.14 is going to be an LTS as well.

While your knoppix had kernel 4.12.x which is list-reasonable for runtime, 
where the kernel code is primary, once something's going wrong and you 
can't mount, it's the userspace code that is responsible for check/rescue/
restore, and there your knoppix was a bit behind at 4.7.x.

So your choices are to go really current and build a 4.13.x btrfs-progs 
to try, or to go with the SLES support you're paying for anyway, in which 
case you run what they say they'll support.  Given that you were running 
that old code (plus backports we don't track as we're focused on mainline 
and forward development) already, and a 3.0 kernel really is scary-
ancient in btrfs terms, they really are best positioned to support it, 
and given that you're presumably paying good money for that support 
already, you might as well use what you're paying for.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

