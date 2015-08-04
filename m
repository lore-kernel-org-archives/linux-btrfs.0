Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f169.google.com ([209.85.160.169]:35239 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbbHDUXV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Aug 2015 16:23:21 -0400
Received: by ykcq64 with SMTP id q64so13311637ykc.2
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Aug 2015 13:23:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$f64e$1c059550$ef240e25$d6d81c77@cox.net>
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
Date: Tue, 4 Aug 2015 16:23:21 -0400
Message-ID: <CAP5+4qcfn_nPwD0eeMGJGuB5nEkSg0rbjnV6AUnCmEnJ5qu20w@mail.gmail.com>
Subject: Re: BTRFS disaster (of my own making). Is this recoverable?
From: Sonic <sonicsmith@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 4, 2015 at 1:10 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> I don't remember you saying anything about trying btrfs restore.

I did try it earlier in dry-run mode and it can't do anything:
=========================================
btrfs restore -D /dev/sdc /mnt/saved/
warning, device 2 is missing
bytenr mismatch, want=20971520, have=0
Couldn't read chunk root
Could not open root, trying backup super
warning, device 2 is missing
bytenr mismatch, want=20971520, have=0
Couldn't read chunk root
Could not open root, trying backup super
warning, device 2 is missing
bytenr mismatch, want=20971520, have=0
Couldn't read chunk root
Could not open root, trying backup super
=========================================

Find-roots, list-roots, none of it works.
=========================================
btrfs restore --list-roots /dev/sde
checksum verify failed on 20971520 found 8B1D9672 wanted 2F8A4238
checksum verify failed on 20971520 found 8B1D9672 wanted 2F8A4238
bytenr mismatch, want=20971520, have=8330001001141004672
Couldn't read chunk root
Could not open root, trying backup super
warning, device 1 is missing
checksum verify failed on 20971520 found 8B1D9672 wanted 2F8A4238
checksum verify failed on 20971520 found 8B1D9672 wanted 2F8A4238
bytenr mismatch, want=20971520, have=8330001001141004672
Couldn't read chunk root
Could not open root, trying backup super
warning, device 1 is missing
checksum verify failed on 20971520 found 8B1D9672 wanted 2F8A4238
checksum verify failed on 20971520 found 8B1D9672 wanted 2F8A4238
bytenr mismatch, want=20971520, have=8330001001141004672
Couldn't read chunk root
Could not open root, trying backup super
=========================================
btrfs-find-root -a /dev/sdc
warning, device 2 is missing
Couldn't read chunk root

btrfs-find-root -a /dev/sde
Couldn't read chunk root
Open ctree failed
=========================================

In defense of BTRFS it's been absolutely trouble free keeping my data
through many power outages, etc. and I plan to keep using it. It was
my own doing that caused the problem.

Seems that if there was someway to edit something in those first
overwritten 32MB of disc 2 to say "hey, I'm really here, just a bit
screwed up" maybe some of the recovery tools could actually work.

Thanks to all.

Chris
