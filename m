Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:49337 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753978AbdIDW2Y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Sep 2017 18:28:24 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dozqb-000272-JL
        for linux-btrfs@vger.kernel.org; Tue, 05 Sep 2017 00:28:01 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Is autodefrag recommended?
Date: Mon, 4 Sep 2017 22:27:45 +0000 (UTC)
Message-ID: <pan$901c4$d132d63e$15fedc9c$216210f8@cox.net>
References: <710ec5d1-adbf-4ce5-50a5-8b8266ccb672@rqc.ru>
        <pan$75cde$b9b6710$ed24172a$22c271cc@cox.net>
        <CAPmG0jaQL5PcRWUrTBkboLxhmfpQ5-W8h3toPasSK1nvk42e3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Henk Slager posted on Mon, 04 Sep 2017 13:09:24 +0200 as excerpted:

> On Mon, Sep 4, 2017 at 12:34 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> 
>> * Autodefrag works very well when these internal-rewrite-pattern files
>> are relatively small, say a quarter GiB or less, but, again with near-
>> capacity throughput, not necessarily so well with larger databases or
>> VM images of a GiB or larger.  (The quarter-gig to gig size is
>> intermediate,
>> not as often a problem and not a problem for many, but it can be for
>> slower devices, while those on fast ssds may not see a problem until
>> sizes reach multiple GiB.)
> 
> I have seen you stating this before about some quarter GiB filesize or
> so, but it is irrelevant, it is simply not how it works. See explanation
> of Hugo for how it works. I can post/store an actual filefrag output of
> a vm image that is around for 2 years on the one of my btrfs fs, then
> you can do some statistics on it and see from there how it works.

FWIW...

I believe it did work that way (whole-file autodefrag) at one point.  
Because back in the early kernel 3.x era at least, we had complaints 
about autodefrag performance with larger internal-rewrite-pattern files 
where the larger the file the worse the performance, and the 
documentation mentioned something about being appropriate for small files 
but less so far large files as well.

But I also believe you're correct that it no longer works that way (if it 
ever did, maybe the complaints were due to some unrelated side effect, in 
any case I've not seen any for quite some time now), and hasn't since 
before anything we're still trying to reasonably support on this list 
(IOW, back two LTS kernel series ago, so to 4.4).

So I should drop the size factor, or mention that it's not nearly the 
problem it once was, at least.

Thanks for forcing the reckoning. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

