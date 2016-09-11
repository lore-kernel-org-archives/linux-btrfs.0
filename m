Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:34814 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753693AbcIKU1e (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Sep 2016 16:27:34 -0400
Received: by mail-oi0-f48.google.com with SMTP id m11so267666777oif.1
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Sep 2016 13:27:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160911200635.GA19703@angband.pl>
References: <15415597-7f29-396e-8425-8cbbeb32e897@crc.id.au>
 <pan$e8a2$15460093$3bb59e30$70ebaf89@cox.net> <21b8852b-fba6-6f8f-feed-7bbfa12312d2@crc.id.au>
 <4096253.hu8ZAHGEqT@merkaba> <20160911200635.GA19703@angband.pl>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 11 Sep 2016 14:27:33 -0600
Message-ID: <CAJCQCtSH-eeohtGVZrgHrUkHRUqoc-y0g5OUNbpFQeK2ji+gWw@mail.gmail.com>
Subject: Re: compress=lzo safe to use? (was: Re: Trying to rescue my data :()
To: Adam Borowski <kilobyte@angband.pl>
Cc: Martin Steigerwald <martin@lichtvoll.de>, Steven Haigh <netwiz@crc.id.au>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 11, 2016 at 2:06 PM, Adam Borowski <kilobyte@angband.pl> wrote:
> On Sun, Sep 11, 2016 at 09:48:35PM +0200, Martin Steigerwald wrote:
>> Hmm… I found this from being referred to by reading Debian wiki page on
>> BTRFS¹.
>>
>> I use compress=lzo on BTRFS RAID 1 since April 2014 and I never found an
>> issue. Steven, your filesystem wasn´t RAID 1 but RAID 5 or 6?
>>
>> I just want to assess whether using compress=lzo might be dangerous to use in
>> my setup. Actually right now I like to keep using it, since I think at least
>> one of the SSDs does not compress. And… well… /home and / where I use it are
>> both quite full already.
>>
>> [1] https://wiki.debian.org/Btrfs#WARNINGS
>
> I have used compress=lzo for years, kernels 3.8, 3.13 and 3.14 (a bunch of
> machines), without a single glitch; heavy snapshotting, single dev only, no
> quota.  Until recently I did never balanced.
>
> I did have a case of ENOSPC with <80% full on 4.7 which might or might not
> be related to compress=lzo.

I'm not finding it off hand, but Duncan has some experience with this
issue, where he'd occasionally have some sort of problem (hand wave),
I don't know how serious it was, maybe just scary warnings like a call
trace or something, but no actual problem? My recollection is that
compression might be making certain edge case problems more difficult
to recover from. I don't know why that would be, as metadata itself
isn't compressed (the inline data saved in metadata nodes can be
compressed). But there you go, if things start going wonky compression
might make it more difficult. But that's speculative. And I also don't
know if there's any difference between lzo and zlib in this regard
either.


-- 
Chris Murphy
