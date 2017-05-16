Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:34689 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750836AbdEPEsx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 May 2017 00:48:53 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dAUPd-0006rj-8R
        for linux-btrfs@vger.kernel.org; Tue, 16 May 2017 06:48:45 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs/SSD
Date: Tue, 16 May 2017 04:48:39 +0000 (UTC)
Message-ID: <pan$7903c$57ad474c$640ec3d9$4cf73ffe@cox.net>
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
        <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com>
        <pan$9df5c$36e00209$7c238f6d$c2c19c0f@cox.net>
        <CAK5rZE7H_qXh7TOU=N3JTocqjVitsAMNtxMCDfbJHTNJz0jF5A@mail.gmail.com>
        <20170512203644.26e068e5@jupiter.sol.kaishome.de>
        <beb7f0b0-b84a-dfa1-12c2-256fe967af1d@gmail.com>
        <FA7013B1-621B-405F-B65C-236A4A33F022@gmail.com>
        <20170515211206.29c5c132@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kai Krakow posted on Mon, 15 May 2017 21:12:06 +0200 as excerpted:

> Am Mon, 15 May 2017 14:09:20 +0100
> schrieb Tomasz Kusmierz <tom.kusmierz@gmail.com>:
>> 
>> Not true. When HDD uses 10% (10% is just for easy example) of space
>> as spare than aligment on disk is (US - used sector, SS - spare
>> sector, BS - bad sector)
>> 
>> US US US US US US US US US SS
>> US US US US US US US US US SS
>> US US US US US US US US US SS
>> US US US US US US US US US SS
>> US US US US US US US US US SS
>> US US US US US US US US US SS
>> US US US US US US US US US SS
>> 
>> if failure occurs - drive actually shifts sectors up:
>> 
>> US US US US US US US US US SS
>> US US US BS BS BS US US US US
>> US US US US US US US US US US
>> US US US US US US US US US US
>> US US US US US US US US US SS
>> US US US BS US US US US US US
>> US US US US US US US US US SS
>> US US US US US US US US US SS
> 
> This makes sense... Reserve area somehow implies it is continuous and
> as such located at one far end of the platter. But your image totally
> makes sense.

Thanks Tomasz.  It makes a lot of sense indeed, and had I thought about
it I think I already "knew" it, but I simply hadn't stopped to think about
it that hard, so you disabused me of the vague idea of spares all at one
end of the disk, too. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

