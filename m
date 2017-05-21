Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:33841 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932268AbdEUWdD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 May 2017 18:33:03 -0400
Received: by mail-qt0-f196.google.com with SMTP id l39so16171933qtb.1
        for <linux-btrfs@vger.kernel.org>; Sun, 21 May 2017 15:33:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170521223041.4aa7d0f6@natsu>
References: <20170520164953.7344-1-nefelim4ag@gmail.com> <20170520164953.7344-3-nefelim4ag@gmail.com>
 <20170520191400.25202d75@jupiter.sol.kaishome.de> <CAGqmi76cLmXOj=P7qeR58n1aHNB-6e1R0yo+PjuMVLLgnWaryg@mail.gmail.com>
 <pan$42cee$29ae88fa$3ea3d443$c10a99e5@cox.net> <CAGqmi77_iaZC0f0BsGWVAzgZnNRvWTHkxvnP=risHa33NGPhGA@mail.gmail.com>
 <20170521223041.4aa7d0f6@natsu>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Mon, 22 May 2017 01:32:21 +0300
Message-ID: <CAGqmi76reKuyeOmmkjqpJdekjySN8rkE332aC5A4BgD0WHnJUw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] Btrfs: compression must free at least PAGE_SIZE
To: Roman Mamedov <rm@romanrm.net>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-05-21 20:30 GMT+03:00 Roman Mamedov <rm@romanrm.net>:
> On Sun, 21 May 2017 19:54:05 +0300
> Timofey Titovets <nefelim4ag@gmail.com> wrote:
>
>> Sorry, but i know about subpagesize-blocksize patch set, but i don't
>> understand where you see conflict?
>>
>> Can you explain what you mean?
>>
>> By PAGE_SIZE i mean fs cluster size in my patch set.
>
> This appears to be exactly the conflict. Subpagesize blocksize patchset would
> make it possible to use e.g. Btrfs with 4K block (cluster) size on a MIPS
> machine with 64K-sized pages. Would your checking for PAGE_SIZE still be
> correct then?

Nope, logic will be incorrect, logic does not allow compress blocks,
even if this will lead to profit, but btrfs at now and from 2009 can't
be mounted with different cluster size.

IMHO, so as i work with code from latest stable this not a big issue
(see below).

>> So if and when subpage patch set would merged, PAGE_SIZE should be
>> replaced with sector size, and all continue work correctly.
>
> I guess Duncan's question was why not compare against block size from the get
> go, rather than create more places for Chandan to scour through to eliminate
> all "blocksize = pagesize" assumptions...
> --
> With respect,
> Roman

I did not want to hurt anyone, but:
- I do it like this because:
  it's easy and safe for all other code and btrfs stability
  (Also i doesn't have enough Kernel/C expirience to make complex rework)
- If I try to export sector size to compression code,
  i should rework many code around, not just fix 2 lines of code,
  it's complex, it's unsafe, it's will break Chandan patches
  (because subpage block size do same things),
  it's convert small patch in a big patch series, and you know whats
happens with big patch series...
- I want make compression better now for all, not after several years,
if possible.
  (subpage patches didn't finished and merged from 2012, i.e. around five years)
- It's should not make a problem for merge Chandan patch set, IMHO,
because this not touch how btrfs work with disk and memory.
- AFAIK in V21 subpage patch set compression on machines with 64KiB
doesn't work as expected [1].
  So, subpage patch series for compression code should reworked,
doesn't matter will my patches merged or not.

1. https://www.spinics.net/lists/linux-btrfs/msg59393.html

Thanks.
-- 
Have a nice day,
Timofey.
