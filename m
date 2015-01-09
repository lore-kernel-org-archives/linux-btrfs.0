Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:64880 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbbAILFO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Jan 2015 06:05:14 -0500
Received: by mail-we0-f175.google.com with SMTP id k11so7318982wes.6
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Jan 2015 03:05:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAFChkqsgJpA9N8K+CD=CnR-AXj1JeF89YvCvUBjG2C6uKTohWA@mail.gmail.com>
References: <CAFChkqsgJpA9N8K+CD=CnR-AXj1JeF89YvCvUBjG2C6uKTohWA@mail.gmail.com>
From: Peter Waller <peter@scraperwiki.com>
Date: Fri, 9 Jan 2015 11:04:32 +0000
Message-ID: <CAFChkqtY-3DHbiHzwPkbr1ahGqcki8iqfs-J_WVDmd7Vz6uc1g@mail.gmail.com>
Subject: Re: Regular rebalancing should be unnecessary? (Was: Re: BTRFS free
 space handling still needs more work: Hangs again)
To: Hugo Mills <hugo@carfax.org.uk>, Martin Steigerwald <Martin@lichtvoll.de>,
        Robert White <rwhite@pobox.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Apologies to those receiving this twice.

On 27 December 2014 at 09:30, Hugo Mills <hugo@carfax.org.uk> wrote:
>
> Now, since you're seeing lockups when the space on your disks is
>
> all allocated I'd say that's a bug. However, you're the *only* person
>
> who's reported this as a regular occurrence. Does this happen with all
> filesystems you have, or just this one?


I have experienced machine lockups on four separate cloud machines,
and reported it in a few venues. I think I even reported it on this
list in the past but I can't find that right now. Here's a bug report
to Ubuntu-Kernel:

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1349711

Regularly rebalancing the machines and ensuring they have >10% free
disk (filesystem) and I don't experience this. Yet I read in this
thread I read that regular rebalancing shouldn't be necessary?

FWIW, trying to sell BTRFS to my colleagues and they view it as a
stupid filesystem "like the bad old windows days when you had to
regularly defragment". They then go on to say they have never
experienced machine lockups on EXT* (over a fairly significant length
of time).

So what can I tell them? Are we just hitting a bug which is likely to
get fixed, or must we regularly rebalance?

.. or is regularly rebalancing incorrect and actually regular machine
lockups are the expected behaviour? :-)
