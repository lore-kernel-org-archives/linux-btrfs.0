Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f172.google.com ([209.85.160.172]:33905 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbbHCQDv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Aug 2015 12:03:51 -0400
Received: by ykax123 with SMTP id x123so114419001yka.1
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Aug 2015 09:03:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150803152835.GF14352@carfax.org.uk>
References: <CAP5+4qewgAhZ=1qKyDMMAsHC39CH36VmuaEuyaaaTAWHeqzmYw@mail.gmail.com>
	<pan$73c92$81fb65b9$3c60e540$cb422e6a@cox.net>
	<CAP5+4qfi4UdfMmNdC2XizTG0au-btnKBqSmg1rUaW=EJApZkmA@mail.gmail.com>
	<CAP5+4qdmjkniaoY6+FCL4OTAYQjpU=DOWBRv-3FkEvFN=TAeRw@mail.gmail.com>
	<20150803152835.GF14352@carfax.org.uk>
Date: Mon, 3 Aug 2015 12:03:51 -0400
Message-ID: <CAP5+4qfmXdMvBaVK1KqUfBRfM447ASJ4U0OqRxhsOw2r4WE1fQ@mail.gmail.com>
Subject: Re: BTRFS disaster (of my own making). Is this recoverable?
From: Sonic <sonicsmith@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>, Sonic <sonicsmith@gmail.com>,
        Duncan <1i5t5.duncan@cox.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 3, 2015 at 11:28 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
>    Very unlikely and definitely not, respectively. There's nothing at
> all here to indicate that you've got a broken log, so dropping it
> would be at best pointless. The chunk tree is also most likely
> undamaged on both copies.

Will it hurt to try a chunk-recover? I'm guessing it wont do anything
unless I answer Y to some prompt.

Is there anything else you would suggest?

Thanks,

Chris
