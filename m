Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f173.google.com ([209.85.160.173]:34464 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499AbbHDCUj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Aug 2015 22:20:39 -0400
Received: by ykax123 with SMTP id x123so126934560yka.1
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Aug 2015 19:20:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAP5+4qfLEqvGQhCkzQWPLy-dtAS7GjSfDy5Oo=6OXL1zohrc=Q@mail.gmail.com>
References: <CAP5+4qewgAhZ=1qKyDMMAsHC39CH36VmuaEuyaaaTAWHeqzmYw@mail.gmail.com>
	<pan$73c92$81fb65b9$3c60e540$cb422e6a@cox.net>
	<CAP5+4qfi4UdfMmNdC2XizTG0au-btnKBqSmg1rUaW=EJApZkmA@mail.gmail.com>
	<CAP5+4qdmjkniaoY6+FCL4OTAYQjpU=DOWBRv-3FkEvFN=TAeRw@mail.gmail.com>
	<20150803152835.GF14352@carfax.org.uk>
	<CAP5+4qfmXdMvBaVK1KqUfBRfM447ASJ4U0OqRxhsOw2r4WE1fQ@mail.gmail.com>
	<CAP5+4qd2-kKEG5y2gEphQ=5A4+B+=2teMxiZJc-vDHZ1_-t8OQ@mail.gmail.com>
	<CAP5+4qceVW2JbAteuRQUK+5mdwWcp8fF0QUk6Q87nqCw5P5wRw@mail.gmail.com>
	<CAP5+4qfLEqvGQhCkzQWPLy-dtAS7GjSfDy5Oo=6OXL1zohrc=Q@mail.gmail.com>
Date: Mon, 3 Aug 2015 22:20:38 -0400
Message-ID: <CAP5+4qcdn9eeHk=EgpUjNC2T+fxwimRit+BRsxQDv6k1Bb=Gqg@mail.gmail.com>
Subject: Re: BTRFS disaster (of my own making). Is this recoverable?
From: Sonic <sonicsmith@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>, Sonic <sonicsmith@gmail.com>,
        Duncan <1i5t5.duncan@cox.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 3, 2015 at 12:32 PM, Sonic <sonicsmith@gmail.com> wrote:
> btrfs rescue chunk-recover

Ran this:
btrfs rescue chunk-recover -v /dev/sde |tee brcr.txt

Got this (very end of output):
==================================
Unrecoverable Chunks:

Total Chunks:           3292
  Recoverable:          3292
  Unrecoverable:        0

Orphan Block Groups:

Orphan Device Extents:

Fail to recover the chunk tree.
==================================
If earlier output of this process might be helpful I can provide it
(used tee to create a file).

Didn't work - seems all chunks found were recoverable - it's
apparently the missing chunks that are the problem.

I'm thinking this is a lost cause. Also thinking I need to provide for
some redundancy in the future :-)

Any other suggestions before I give up the ghost on this?

Thanks,

Chris
