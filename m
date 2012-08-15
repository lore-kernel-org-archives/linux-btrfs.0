Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50982 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab2HOBaQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Aug 2012 21:30:16 -0400
Received: by wgbdr13 with SMTP id dr13so921597wgb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Aug 2012 18:30:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACvadSXOQK4ASWbocfnZnOAHbLa-Mr=j_0Dhw-ez_awddQNjRA@mail.gmail.com>
References: <CACvadSXOQK4ASWbocfnZnOAHbLa-Mr=j_0Dhw-ez_awddQNjRA@mail.gmail.com>
From: Peter Marheine <peter@taricorp.net>
Date: Tue, 14 Aug 2012 20:29:54 -0500
Message-ID: <CACvadSUZUQ4HiCDRoBY7MSpbs+Ct6fih-AdeqRu-hZDG6QUoOA@mail.gmail.com>
Subject: Re: Hung I/O, Kernel BUG with corrupt leaf (bad key order)
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Is there some way to fix this corruption? I noticed what looks like
> the same problem in an earlier message on the list ("btrfs unmountable
> after failed suspend", February 7), but with no resolution. I have
> offline backups, but recovering those in their entirety will take some
> time, so a solution that doesn't require wiping the entire FS would be
> preferred.
I did some further investigation into the problem, and I have
determined the problematic directory (by seeing where `ls -R` hangs).
If I skip the corrupt directory, everything works properly, but
attempting to list its contents causes the entire volume to stop
responding.

At this point I'd like to simply unlink the corrupt directory (without
enumerating it). Is that possible, or should I just image the volume
minus the corrupt directory and recreate my fs?
