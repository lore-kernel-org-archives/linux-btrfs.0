Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:47460 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754394AbaLHXOI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Dec 2014 18:14:08 -0500
Date: Mon, 8 Dec 2014 18:14:07 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: Robert White <rwhite@pobox.com>, Shriramana Sharma <samjnaa@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Why is the actual disk usage of btrfs considered unknowable?
Message-ID: <20141208231406.GB22023@hungrycats.org>
References: <CAH-HCWU9GEjvZLH=rwYev_O0S4_Cs9FJvRiJgBiOK8gdxqK5CQ@mail.gmail.com>
 <1610909.CxuY1Bb9iL@merkaba>
 <548537D1.7070602@pobox.com>
 <1447188.5moEuATfqD@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1447188.5moEuATfqD@merkaba>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 08, 2014 at 03:47:23PM +0100, Martin Steigerwald wrote:
> Am Sonntag, 7. Dezember 2014, 21:32:01 schrieb Robert White:
> > On 12/07/2014 07:40 AM, Martin Steigerwald wrote:
> > Almost full filesystems are their own reward.
> 
> So you basically say that BTRFS with compression  does not meet the fallocate 
> guarantee. Now thats interesting, cause it basically violates the 
> documentation for the system call:
> 
> DESCRIPTION
>        The function posix_fallocate() ensures that disk space  is  allo‐
>        cated for the file referred to by the descriptor fd for the bytes
>        in the range starting at offset and  continuing  for  len  bytes.
>        After  a  successful call to posix_fallocate(), subsequent writes
>        to bytes in the  specified  range  are  guaranteed  not  to  fail
>        because of lack of disk space.
> 
> So in order to be standard compliant there, BTRFS would need to write 
> fallocated files uncompressed… wow this is getting complex.

...and nodatacow and no snapshots, since those require more space that
was never anticipated by fallocate.

Given the choice, I'd just let fallocate fail.  Usually when I come
across a program using fallocate, I end up patching it so it doesn't use
fallocate any more.

