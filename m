Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:36912 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab3L2ACQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Dec 2013 19:02:16 -0500
Received: by mail-ig0-f176.google.com with SMTP id k19so32716059igc.3
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Dec 2013 16:02:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <EF26DC97-2362-4C53-8B5F-4763A33375EC@colorremedies.com>
References: <20131228171943.GE19863@merlins.org>
	<20131228173730.GA7234@carfax.org.uk>
	<CAELSAVa=oVzrLnSSk+vnKQF46F7U5n6o8Nw9VGXkPQNCR2SVsA@mail.gmail.com>
	<CABR0jES_40xmVxi21+VUMzT_2ZuFWs9kUPfZAPZODq0rWrB0ug@mail.gmail.com>
	<CAELSAVY+J1GYuRDHwUZ882OVchqXk9ES9EJp89HQofC8m00uaQ@mail.gmail.com>
	<CABR0jERWpte3DAk+JCaybeGYRBtmUKEOoUzfAe=uC+k7KfdeQg@mail.gmail.com>
	<EF26DC97-2362-4C53-8B5F-4763A33375EC@colorremedies.com>
Date: Sun, 29 Dec 2013 01:55:15 +0200
Message-ID: <CAELSAVbwcwcQKEjBA6NhYxTRjC3D=pEPF+fJiyz=xfG0w5wBCg@mail.gmail.com>
Subject: Re: Is anyone using btrfs send/receive for backups instead of rsync?
From: Emil Karlson <jekarlson@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> In my case, I'm unable to reproduce the problem. I get the same sha256sum of an existing 16M journal file (in the read only snapshot) as I do in the send/received snapshot. The difference is the original is compromised of 1976 extents, while the received is in a single extent.

Was the send incremental? Did the files have actual changes? Did you
check more than one file?

I use rsync -cvan --delete "/.../${new}/" "/.../${new}/" to check the
full filesystem on every send (and sha1sum to confirm failures). Most
of the time at least one new file fails. My default time interval
between sends is about 16 days.
