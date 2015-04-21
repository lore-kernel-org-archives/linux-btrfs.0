Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:33219 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302AbbDUTHf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Apr 2015 15:07:35 -0400
Received: by iecrt8 with SMTP id rt8so21323540iec.0
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Apr 2015 12:07:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150420042731.GA20194@hungrycats.org>
References: <CAMsr+YEB2+vb3XirwNYe4y6mWOKJuZhKgekPvNQqQdcP4irPGw@mail.gmail.com>
	<49296740.rPqQP4vAjc@merkaba>
	<CAMsr+YH9jC-x57_fVv8N+DuhotYCZAibTE2ELQwN=DgK3qoL9w@mail.gmail.com>
	<20150420042731.GA20194@hungrycats.org>
Date: Tue, 21 Apr 2015 13:07:35 -0600
Message-ID: <CAJCQCtRjmk4qeuEhhDy6BKsvwUUtP1rpEsVuPSHO6Vu06tWK-A@mail.gmail.com>
Subject: Re: The FAQ on fsync/O_SYNC
From: Chris Murphy <lists@colorremedies.com>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: Craig Ringer <craig@2ndquadrant.com>,
        Martin Steigerwald <martin@lichtvoll.de>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 19, 2015 at 10:27 PM, Zygo Blaxell
<ce3g8jdj@umail.furryterror.org> wrote:
> On Sun, Apr 19, 2015 at 10:31:02PM +0800, Craig Ringer wrote:

>> I'm curious as to whether +C has any effect on BTRFS's durability, too.
>
> I would expect it to be strictly equal to or worse than the CoW
> durability.  It would have all the same general filesystem bugs as btrfs,
> plus extra bugs that are specific to the no-CoW btrfs code paths, and
> you lose write ordering and btrfs data integrity and repair capabilities,
> and you have to enable fsync and log tree replay and dodge the bugs.

Interesting. systemd-journald now uses +C by default on journal files.
I've had journals become corrupt, per its own journalctl --verify
command, but so far it happens infrequently enough I haven't
discovered the pattern - whether it's worse with +C. And it's even
possible there are bugs in systemd-journald causing the problem.

-- 
Chris Murphy
