Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:33817 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932594AbbIYRA2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 13:00:28 -0400
Received: by iofb144 with SMTP id b144so117604258iof.1
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2015 10:00:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEp_DRB7zaHmJnghJzVR++_OO+4mrM_+jCjrYAQJcNUXpM=bAQ@mail.gmail.com>
References: <4362384.AA8xu4anSN@hoefnix>
	<56052E0D.3090702@gmail.com>
	<CAGfcS_nFn=AH6Y-4dFQEmy42KVJLBvLuaEHRtoYrBDUtNategw@mail.gmail.com>
	<CAEp_DRB7zaHmJnghJzVR++_OO+4mrM_+jCjrYAQJcNUXpM=bAQ@mail.gmail.com>
Date: Fri, 25 Sep 2015 13:00:28 -0400
Message-ID: <CAGfcS_nnhJ5m4gcz=APY7boNj1d+oxGyKOedUxSWOgV0MH65dw@mail.gmail.com>
Subject: Re: Latest kernel to use?
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Bostjan Skufca <bostjan@a2o.si>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>, Sjoerd <sjoerd@sjomar.eu>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 25, 2015 at 9:25 AM, Bostjan Skufca <bostjan@a2o.si> wrote:
>
> Similar here: I am sticking with 3.19.2 which has proven to work fine for me

I'd recommend still tracking SOME stable series.  I'm sure there were
fixes in 3.19 for btrfs (to say nothing of other subsystems) that
you're missing with that version.  3.19 is also unsupported at this
time.  You might want to consider moving to either 3.18.21 or 4.1.8
and tracking those series instead.  I doubt you'd give up much moving
back to 3.18 and there have been a bunch of btrfs fixes in that series
(though it seems to me that 3.18 has been slower to receive btrfs
patches than some of the other series).

I'm on the fence right now about making the move to 4.1.  Maybe in a
few releases I'll be there, depending on what the noise on the lists
sounds like.

There was a time when you were better off on bleeding-edge linux for
btrfs.  If you REALLY want to run btrfs raid5 or something like that
then I'd say that is still your best strategy.  However, if you stick
with features that have been around for a year the longterm kernels
seem a lot less likely to hit you with a regression, as long as you
don't switch to a new one the day it is declared as such.

--
Rich
