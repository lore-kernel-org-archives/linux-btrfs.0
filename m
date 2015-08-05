Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f50.google.com ([209.85.213.50]:36386 "EHLO
	mail-vk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbbHEQx4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Aug 2015 12:53:56 -0400
Received: by vkci6 with SMTP id i6so18179894vkc.3
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Aug 2015 09:53:55 -0700 (PDT)
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
Date: Wed, 5 Aug 2015 10:53:55 -0600
Message-ID: <CAJCQCtSFcXhC9xBLia0uns64PdLPQXwEPin=sxSOsdhW+tD2Yg@mail.gmail.com>
Subject: Re: BTRFS disaster (of my own making). Is this recoverable?
From: Chris Murphy <lists@colorremedies.com>
To: Sonic <sonicsmith@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Hugo Mills <hugo@carfax.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 5, 2015 at 6:31 AM, Sonic <sonicsmith@gmail.com> wrote:
> On Tue, Aug 4, 2015 at 4:23 PM, Sonic <sonicsmith@gmail.com> wrote:
>> Seems that if there was someway to edit something in those first
>> overwritten 32MB of disc 2 to say "hey, I'm really here, just a bit
>> screwed up" maybe some of the recovery tools could actually work.
>
> Just want to reiterate this thought.
>
> The basic error in most cases with the tools at hand is that Disc 2 is
> missing so there's little the tools can do. Somewhere in those first
> 32MB should be something to properly identify the disc as part of the
> array.

Yes but it was probably  uniquely only on that disk, because there's
no redundancy for metadata or system chunks. Therefore there's no copy
on the other disk to use as a model. The btrfs check command has an
option to use other superblocks, so you could try that switch and see
if it makes a difference but it sounds like it's finding backup
superblocks automatically. That's the one thing that is pretty much
always duplicated on the same disk; for sure the first superblock is
munged and would need repair. But there's still other chunks
missing... so I don't think it'll help.


>
> If the btrfs tools can't fix it maybe dd can. Is there anything can be
> gained from the beginning of disc 1 (can dd this to a file) in order
> to create the necessary bits needed at the beginning of disc2?

Not if there's no metadata or system redundancy profile like raid1.

> Or some
> other way to overwrite the beginning of disc 2 (using dd again) with
> some identification information so that the automated btrfs tools can
> take it from there?

I think to have a viable reference, you need two disks (virtual or
real) and you need to exactly replicate how you got to this two disk
setup to find out what's in those 32MB that might get the file system
to mount even if it complaints of some corrupt files. That's work
that's way beyond my skill level. The tools don't do this right now as
far as I'm aware. You'd be making byte by byte insertions to multiple
sectors. Tedious. But I can't even guess how many steps it is. It
might be 10. It might be 10000.


-- 
Chris Murphy
