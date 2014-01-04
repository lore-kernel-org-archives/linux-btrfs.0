Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:44521 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbaADF5D (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Jan 2014 00:57:03 -0500
Received: by mail-ob0-f178.google.com with SMTP id uz6so16299532obc.37
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jan 2014 21:57:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52C77903.9060408@jrs-s.net>
References: <52C73987.7000106@jrs-s.net>
	<52C73D1A.8060805@gmail.com>
	<52C7402A.7050605@jrs-s.net>
	<CAOjFWZ7zC3=4oH6=SBZA+PhZMrSK1KjxoRN6L2vqd=GTBKKTQA@mail.gmail.com>
	<52C74B00.7080906@jrs-s.net>
	<03E88FCB-C473-4978-B682-076B90039E0E@colorremedies.com>
	<52C77903.9060408@jrs-s.net>
Date: Sat, 4 Jan 2014 00:57:02 -0500
Message-ID: <CAAVQaYBZS87S7XNdDpUv5pBMvqF0+th34H8PjSLVLtZV9LOR=Q@mail.gmail.com>
Subject: Re: btrfs raid1 and btrfs raid10 arrays NOT REDUNDANT
From: Dave <dave@thekilempire.com>
To: Jim Salter <jim@jrs-s.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 3, 2014 at 9:59 PM, Jim Salter <jim@jrs-s.net> wrote:
> You're suggesting the wrong alternatives here (mdraid, LVM, etc) - they
> don't provide the features that I need or are accustomed to (true snapshots,
> copy on write, self-correcting redundant arrays, and on down the line). If
> you're going to shoo me off, the correct way to do it is to wave me in the
> direction of ZFS, in which case I can tell you I've been a happy user of ZFS
> for 5+ years now on hundreds of systems. ZFS and btrfs are literally the
> *only* options available that do what I want to do, and have been doing for
> years now. (At least aside from six-figure-and-up proprietary systems, which
> I have neither the budget nor the inclination for.)

Jim, there's nothing stopping you from creating a Btrfs filesystem on
top of an mdraid array.  I'm currently running three WD Red 3TB drives
in a raid5 configuration under a Btrfs filesystem.  This configuration
works pretty well and fills the feature gap you're describing.

I will say, though, that the whole tone of your email chain leaves a
bad taste in my mouth; kind of like a poorly adjusted relative who
shows up once a year for Thanksgiving and makes everyone feel
uncomfortable.  I find myself annoyed by the constant disclaimers I
read on this list, about the experimental status of Btrfs, but it's
apparent that this hasn't sunk in for everyone.  Your poor budget
doesn't a production filesytem make.

I and many others on this list who have been using Btrfs, will tell
you with no hesitation, that due to the maturity of the code, Btrfs
should be making NO assumptions in the event of a failure, and
everything should come to a screeching halt.  I've seen it all: the
infamous 120 second process hangs, csum errors, multiple separate
catastrophic failures (search me on this list).  Things are MOSTLY
stable but you simply have to glance at a few weeks of history on this
list to see the experimental status is fully justified.  I use Btrfs
because of its intoxicating feature set.  As an IT director though,
I'd never subject my company to these rigors.  If Btrfs on mdraid
isn't an acceptable solution for you, then ZFS is the only responsible
alternative.
-- 
-=[dave]=-

Entropy isn't what it used to be.
