Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f49.google.com ([209.85.213.49]:36079 "EHLO
	mail-vk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbbHFCNQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Aug 2015 22:13:16 -0400
Received: by vkci6 with SMTP id i6so22812612vkc.3
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Aug 2015 19:13:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <B7F2379062E32745A8651FBDB20F64596115AB1F@Server.waterlogic.com.au>
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
	<CAJCQCtSFcXhC9xBLia0uns64PdLPQXwEPin=sxSOsdhW+tD2Yg@mail.gmail.com>
	<B7F2379062E32745A8651FBDB20F64596115AB1F@Server.waterlogic.com.au>
Date: Wed, 5 Aug 2015 20:13:15 -0600
Message-ID: <CAJCQCtTzV-YsBVRUAYqZVNP2M3QZfx9gGbOJ3ZY6ZrjEEWvvfQ@mail.gmail.com>
Subject: Re: BTRFS disaster (of my own making). Is this recoverable?
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc: Hugo Mills <hugo@carfax.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 5, 2015 at 6:45 PM, Paul Jones <paul@pauljones.id.au> wrote:
> Would it be possible to store this type of critical information twice on each disk, at the beginning and end? I thought BTRFS already did that, but I might be thinking of some other filesystem. I've had my share of these types of oops! moments as well.

That option is metadata profile raid1. To do an automatic
-mconvert=raid1 when the user does 'btrfs device add' breaks any use
case where you want to temporarily add a small device, maybe a USB
stick, and now hundreds of MiBs possibly GiBs of metadata have to be
copied over to this device without warning. It could be made smart,
autoconvert to raid1 when the added device is at least 4x the size of
metadata allocation, but then that makes it inconsistent. OK so it
could be made interactive, but now that breaks scripts. So... where do
you draw the line?

Maybe this would work if the system chunk only was raid1? I don't know
what the minimum necessary information is for such a case.

Possibly it make more sense if 'btrfs device add' always does
-dconvert=raid1 unless a --quick option is passed?

-- 
Chris Murphy
