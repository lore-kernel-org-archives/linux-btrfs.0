Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:35606 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751095AbcJKX6Y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Oct 2016 19:58:24 -0400
Received: by mail-oi0-f41.google.com with SMTP id d132so43284655oib.2
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Oct 2016 16:58:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20161011160601.GI7683@carfax.org.uk>
References: <D379E551-1272-4548-9601-0CE4C1A8C012@unige.ch> <20161011160601.GI7683@carfax.org.uk>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 11 Oct 2016 17:58:22 -0600
Message-ID: <CAJCQCtSY2Y5AsW2FC5FGP3x3Vaz6Y10=EbAE-0FKFQAqg0oGkg@mail.gmail.com>
Subject: Re: RAID system with adaption to changed number of disks
To: Hugo Mills <hugo@carfax.org.uk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Austin Hemmelgarn <ahferroin7@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

https://btrfs.wiki.kernel.org/index.php/Status
Scrub + RAID56 Unstable will verify but not repair

This doesn't seem quite accurate. It does repair the vast majority of
the time. On scrub though, there's maybe a 1 in 3 or 1 in 4 chance bad
data strip results in a.) fixed up data strip from parity b.) wrong
recomputation of replacement parity c.) good parity is overwritten
with bad, silently, d.) if parity reconstruction is needed in the
future e.g. device or sector failure, it results in EIO, a kind of
data loss.

Bad bug. For sure.

But consider the identical scenario with md or LVM raid5, or any
conventional hardware raid5. A scrub check simply reports a mismatch.
It's unknown whether data or parity is bad, so the bad data strip is
propagated upward to user space without error. On a scrub repair, the
data strip is assumed to be good, and good parity is overwritten with
bad.

So while I agree in total that Btrfs raid56 isn't mature or tested
enough to consider it production ready, I think that's because of the
UNKNOWN causes for problems we've seen with raid56. Not the parity
scrub bug which - yeah NOT good, not least of which is the data
integrity guarantees Btrfs is purported to make are substantially
negated by this bug. I think the bark is worse than the bite. It is
not the bark we'd like Btrfs to have though, for sure.


-- 
Chris Murphy
