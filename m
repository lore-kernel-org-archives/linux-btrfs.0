Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:35694 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbcCRXbw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 19:31:52 -0400
Received: by mail-io0-f170.google.com with SMTP id o5so70664862iod.2
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Mar 2016 16:31:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160318180207.GA1802@carfax.org.uk>
References: <56EC3DCC.6060101@alfazone.pl>
	<20160318180207.GA1802@carfax.org.uk>
Date: Fri, 18 Mar 2016 17:31:51 -0600
Message-ID: <CAJCQCtQyyk3XnyCBW0vij1RSypYXF7yEAhBqaztzmXMvMU=0ng@mail.gmail.com>
Subject: Re: recovery problem raid5
From: Chris Murphy <lists@colorremedies.com>
To: Hugo Mills <hugo@carfax.org.uk>, Marcin Solecki <solo@alfazone.pl>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 18, 2016 at 12:02 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>    The main thing you haven't tried here is mount -o degraded, which
> is the thing to do if you have a missing device in your array.
>
>    Also, that kernel's not really all that good for a parity RAID
> array -- it's the very first one that had the scrub and replace
> implementation, so it's rather less stable with parity RAID than the
> later 4.x kernels. That's probably not the issue here, though.


It's a 4.5.0 kernel with 3.19 progs. I'd update the progs even though
that's unlikely the problem.



-- 
Chris Murphy
