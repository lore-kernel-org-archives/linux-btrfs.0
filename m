Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f48.google.com ([209.85.216.48]:40257 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726AbaKASAr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Nov 2014 14:00:47 -0400
Received: by mail-qa0-f48.google.com with SMTP id x12so6496084qac.7
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Nov 2014 11:00:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <m2sqkg$l5p$1@ger.gmane.org>
References: <544FC921.2090900@tevsa.net>
	<CAPL5yKfQ1s4w9LbXwxGrJ-coSy8G1p=hpkkwhPT8oU8cqWS1eg@mail.gmail.com>
	<54517726.5070507@tevsa.net>
	<CAPL5yKcYT7Nv0u3=6arGwxVk46HG4mSGf0b1po-euUGcWQJGEA@mail.gmail.com>
	<m2sqkg$l5p$1@ger.gmane.org>
Date: Sat, 1 Nov 2014 14:00:46 -0400
Message-ID: <CAPL5yKeMFzAeURE7XKHivrP55tWLuLBL=P=8wAZPni51hG1NeQ@mail.gmail.com>
Subject: Re: Btrfs raid1 array has issues with rtorrent usage pattern.
From: Dan Merillat <dan.merillat@gmail.com>
To: Koen Kooi <koen@dominion.thruhere.net>
Cc: BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 30, 2014 at 3:50 AM, Koen Kooi <koen@dominion.thruhere.net> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Dan Merillat schreef op 30-10-14 04:17:
>> It's specifically BTRFS related, I was able to reproduce it on a bare
>> drive (no lvm, no md, no bcache).  It's not bad RAM, I was able to
>> reproduce it on multiple machines running either 3.17 or late RCs.
>>
>> I've tested 3.18-rc2 for about 2 hours now, can't get any failures, so
>> that's good.  If anyone else can reproduce this it'll probably need to be
>> sent to 3.17-stable.
>
> 3.17.2 has a lot of btrfs backports queued[1] already, could you see if the
> fix for your problem is already present?
>

Sorry about all the top-posting, I dislike the way gmail makes it the default.

Yes, the patches queued for 3.17.2 appear to have fixed it.  I didn't
have time to run a bisection to see where it broke between .16 and
.17, though.
