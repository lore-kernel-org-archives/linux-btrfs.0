Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f181.google.com ([209.85.160.181]:34100 "EHLO
	mail-yk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbbHEMjp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Aug 2015 08:39:45 -0400
Received: by ykax123 with SMTP id x123so33948809yka.1
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Aug 2015 05:39:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAP5+4qePXJuxv4FRdNSy-wsHTSr=iuJYrqdOwfYw4tOESiCCug@mail.gmail.com>
References: <CAP5+4qewgAhZ=1qKyDMMAsHC39CH36VmuaEuyaaaTAWHeqzmYw@mail.gmail.com>
	<pan$73c92$81fb65b9$3c60e540$cb422e6a@cox.net>
	<CAP5+4qfi4UdfMmNdC2XizTG0au-btnKBqSmg1rUaW=EJApZkmA@mail.gmail.com>
	<CAP5+4qdmjkniaoY6+FCL4OTAYQjpU=DOWBRv-3FkEvFN=TAeRw@mail.gmail.com>
	<20150803152835.GF14352@carfax.org.uk>
	<CAP5+4qfmXdMvBaVK1KqUfBRfM447ASJ4U0OqRxhsOw2r4WE1fQ@mail.gmail.com>
	<CAP5+4qd2-kKEG5y2gEphQ=5A4+B+=2teMxiZJc-vDHZ1_-t8OQ@mail.gmail.com>
	<CAP5+4qceVW2JbAteuRQUK+5mdwWcp8fF0QUk6Q87nqCw5P5wRw@mail.gmail.com>
	<CAP5+4qfLEqvGQhCkzQWPLy-dtAS7GjSfDy5Oo=6OXL1zohrc=Q@mail.gmail.com>
	<CAP5+4qcdn9eeHk=EgpUjNC2T+fxwimRit+BRsxQDv6k1Bb=Gqg@mail.gmail.com>
	<pan$f64e$1c059550$ef240e25$d6d81c77@cox.net>
	<CAP5+4qcfn_nPwD0eeMGJGuB5nEkSg0rbjnV6AUnCmEnJ5qu20w@mail.gmail.com>
	<CAP5+4qePXJuxv4FRdNSy-wsHTSr=iuJYrqdOwfYw4tOESiCCug@mail.gmail.com>
Date: Wed, 5 Aug 2015 08:39:44 -0400
Message-ID: <CAP5+4qckPtOjZ92RkyDGYFWzfdV5fkTagC9snymynGqp8vW9pw@mail.gmail.com>
Subject: Re: BTRFS disaster (of my own making). Is this recoverable?
From: Sonic <sonicsmith@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Chris Murphy <lists@colorremedies.com>,
        Hugo Mills <hugo@carfax.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 5, 2015 at 8:31 AM, Sonic <sonicsmith@gmail.com> wrote:
> The basic error in most cases with the tools at hand is that Disc 2 is
> missing so there's little the tools can do. Somewhere in those first
> 32MB should be something to properly identify the disc as part of the
> array.

Somehow manually create the missing "chunk root" if this is the core problem??
