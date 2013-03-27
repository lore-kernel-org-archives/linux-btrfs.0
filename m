Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:55309 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab3C0I1U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Mar 2013 04:27:20 -0400
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: cwillu <cwillu@cwillu.com>
Subject: Re: multiple btrfsck runs
Date: Wed, 27 Mar 2013 19:27:11 +1100
Cc: linux-btrfs@vger.kernel.org
References: <201303162302.14746.russell@coker.com.au> <201303162346.40534.russell@coker.com.au> <CAE5mzvgqkeB2qox4hi7JZ0cOQkwNA0WrMC2+k4bXDDGWuD+5OA@mail.gmail.com>
In-Reply-To: <CAE5mzvgqkeB2qox4hi7JZ0cOQkwNA0WrMC2+k4bXDDGWuD+5OA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201303271927.12379.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 17 Mar 2013, cwillu <cwillu@cwillu.com> wrote:
> On Sat, Mar 16, 2013 at 6:46 AM, Russell Coker <russell@coker.com.au> wrote:
> > On Sat, 16 Mar 2013, cwillu <cwillu@cwillu.com> wrote:
> >> On Sat, Mar 16, 2013 at 6:02 AM, Russell Coker <russell@coker.com.au> 
wrote:
> >> > Is it expected that running btrfsck more than once will keep reporting
> >> > errors?
> >> 
> >> Without options, btrfsck does not write to the disk.
> > 
> > The man page for the version in Debian doesn't document any options.
> > 
> > The source indicates that --repair might be the one that's desired, is
> > that correct?
> 
> Yes.  However, unless something is actually broken, or you've been
> advised by a developer, I'd stick with btrfs scrub.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I've got a filesystem that causes a kernel panic and can't even get to the 
scrub stage, so btrfsck is necessary.

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=703211

While this is an upstream bug, I've filed the above Debian bug report about it.  
Sometimes in such situations the DD will fix the bug and send the patch 
upstream.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
