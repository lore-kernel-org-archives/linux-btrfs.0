Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:34430 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598AbbK3VJv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 16:09:51 -0500
Received: by igvg19 with SMTP id g19so79926806igv.1
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Nov 2015 13:09:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <565CB3A2.30705@gmail.com>
References: <565C01F1.5030108@oracle.com>
	<565C625C.7060503@gmail.com>
	<CAJCQCtQPdzQG0She3yjxAmDmXSAphdMriW11Pe=BMrBRXYTh6Q@mail.gmail.com>
	<565CB3A2.30705@gmail.com>
Date: Mon, 30 Nov 2015 14:09:51 -0700
Message-ID: <CAJCQCtS1VTsTEzgf6Qx6zvdv3AR8UnUWZc-esn3skpYS2=VVDg@mail.gmail.com>
Subject: Re: [RFC] Btrfs device and pool management (wip)
From: Chris Murphy <lists@colorremedies.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Anand Jain <anand.jain@oracle.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 30, 2015 at 1:37 PM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:

> I've had multiple cases of disks that got one write error then were fine for
> more than a year before any further issues.  My thought is add an option to
> retry that single write after some short delay (1-2s maybe), and if it still
> fails, then mark the disk as failed.

Seems reasonable.

>> Agreed. Maybe it would be an error rate (set by ratio)?
>>
> I was thinking of either:
> a. A running count, using the current error counting mechanisms, with some
> max number allowed before the device gets kicked.
> b. A count that decays over time, this would need two tunables (how long an
> error is considered, and how many are allowed).


OK.



-- 
Chris Murphy
