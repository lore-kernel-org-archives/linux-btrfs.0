Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:45847 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751036AbdIEIzk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Sep 2017 04:55:40 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dp9da-0001vf-PA
        for linux-btrfs@vger.kernel.org; Tue, 05 Sep 2017 10:55:14 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs check --repair now runs in minutes instead of hours?
 aborting
Date: Tue, 5 Sep 2017 08:54:44 +0000 (UTC)
Message-ID: <pan$ab2ea$1e2cfcc0$b183d655$79c920da@cox.net>
References: <20170905010531.rfvun5isjwrb5ur5@merlins.org>
        <75b0ebd3-41ea-7f45-bec4-f7d9ec6efee1@gmx.com>
        <20170905025556.GA6392@merlins.org>
        <92e0486d-a7b5-01f8-5ef4-6773f8939bec@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qu Wenruo posted on Tue, 05 Sep 2017 16:05:04 +0800 as excerpted:

> On 2017年09月05日 10:55, Marc MERLIN wrote:
>> 
>> gargamel:~# btrfs fi df /mnt/btrfs_pool1
>> Data, single: total.60TiB, used.54TiB
>> System, DUP: total2.00MiB, used=1.19MiB
>> Metadata, DUP: totalX.00GiB, used.69GiB
> 
> Wait for a minute.
> 
> Is that .69GiB means 706 MiB? Or my email client/GMX screwed up the
> format (again)?

It appears to be your end.  Based on the fact that I'm seeing a a bunch 
of weird characters in your quote of the message that I didn't see in the 
original, I'm guessing it's charset related, very possibly due to the 
"equal" sign being an escape character for mime/quoted-printable (tho his 
post was text/plain; charset equals utf-8, full 8-bit, so not quoted-
printable encoded at all) and I believe various i18n escapes as well, 
with the latter being an issue if the client assumes local charset 
despite the utf8 specified in the header.

See if these numbers, copied and reformatted from his post with spaces 
inserted either side of the numbers and the equals signs deleted, arrive 
any less garbled:

Data, single: total 10.60 TiB, used 10.54 TiB
System, DUP: total 32.00 MiB, used 1.19 MiB
Metadata, DUP: total 58.00 GiB, used 12.69 GiB
GlobalReserve, single: total 512.00 MiB, used 0.00 B

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

