Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lb1.pop2.wanet.net ([65.244.248.2]:49687 "EHLO
	serv004.pop2.wanet.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751029AbaLHGUu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Dec 2014 01:20:50 -0500
Message-ID: <9e9315cd115a893c07723a2993ef660d.squirrel@webmail.wanet.net>
In-Reply-To: <548537D1.7070602@pobox.com>
References: <CAH-HCWU9GEjvZLH=rwYev_O0S4_Cs9FJvRiJgBiOK8gdxqK5CQ@mail.gmail.com>
    <44320137.fRRuR6EFMP@merkaba> <1610909.CxuY1Bb9iL@merkaba>
    <548537D1.7070602@pobox.com>
Date: Sun, 7 Dec 2014 22:20:49 -0800
Subject: Re: Why is the actual disk usage of btrfs considered unknowable?
From: ashford@whisperpc.com
To: "Robert White" <rwhite@pobox.com>
Cc: "Martin Steigerwald" <martin@lichtvoll.de>,
        "Shriramana Sharma" <samjnaa@gmail.com>,
        "linux-btrfs" <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin,

Excellent analysis.

> On 12/07/2014 07:40 AM, Martin Steigerwald wrote:
>
> So while the core problem isn't insoluble, in real life it is _not_
> _worth_ _solving_.

I agree.  There is inadequate return on the investment.  In addition, the
number of corner cases increases dramatically, making testing
significantly more complex.

> On a nearly empty filesystem, it's going to fit.
>
> In a reasonably empty filesystem, it's going to fit.
>
> On a nearly full filesystem, it may or may not fit.
>
> On a filesystem that is so close to full that you have reason to doubt
> it will fit, you are going to have a very bad time even if it fits.
>
> If you did manage to invent and implement an fallocate algorythm that
> could make this promise and make it stick, then some other running
> program is what's going to crash when you use up that last byte anyway.
>
> Almost full filesystems are their own reward.

In other words, BTRFS acts like any other filesystem with compression. 
This is reasonable.

Peter Ashford

