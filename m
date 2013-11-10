Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:41750 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab3KJNKj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Nov 2013 08:10:39 -0500
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: Bartosz Kulicki <bartosz.kulicki@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Fwd: unable to delete files after kernel upgrade from 3.8.10 to 3.12
Date: Mon, 11 Nov 2013 00:10:36 +1100
References: <CAMajw1N4bqFyHA4V8SkEzQFZF8adN0xQDShRq7bC2Of+nxsJGA@mail.gmail.com> <CAMajw1MVmO5dbkDB7Wj1J-O0mTE-q6xyo1Do83gQk8RLX2dnpQ@mail.gmail.com> <CAMajw1O4-zrfxYgxeZaTNwtgY-_zTUpBbiLSExkcmwuyU5x+mw@mail.gmail.com>
In-Reply-To: <CAMajw1O4-zrfxYgxeZaTNwtgY-_zTUpBbiLSExkcmwuyU5x+mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201311110010.36848.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 7 Nov 2013, Bartosz Kulicki <bartosz.kulicki@gmail.com> wrote:
> FWIW - just before nuking the fs I have added a 3GB loopback device to
> btrfs.
> 
> This restored ability to delete the files but I could not remove the
> loopback after deleting some large files (if I remember correctly
> error I got was "block device required")

I once had a problem where I added a second block device and started a 
balance.  But for some reason the balance decided to make metadata a RAID-1 
and even when there was enough space I couldn't remove it (you must have 2 
devices for RAID-1).

So I added a third device, that allowed me to delete the second device which 
made the meta-data no longer RAID-1 and I could then delete the third device 
and have the single-device BTRFS filesystem I wanted.

That was a while ago, maybe running kernel 3.10 or 3.8.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
