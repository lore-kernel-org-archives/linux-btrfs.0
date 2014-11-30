Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f51.google.com ([209.85.192.51]:59043 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbaK3NFN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Nov 2014 08:05:13 -0500
Received: by mail-qg0-f51.google.com with SMTP id l89so6487441qgf.10
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Nov 2014 05:05:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAH-HCWXhm6a2jU-eO+YRV9EW-LV6Z-NQeNR5RL_cC91txQc6zw@mail.gmail.com>
References: <CAH-HCWUR4QPDn=M8nchdRedzGU3DYDHC8d6YRH8-FBm6trWCJg@mail.gmail.com>
 <20141129142813.GD32735@carfax.org.uk> <CAH-HCWWh02invDCdx4-bPORdg4r39efsW=buKXTVtfspSQ9sVA@mail.gmail.com>
 <5479FD39.6030208@pobox.com> <CAH-HCWXhm6a2jU-eO+YRV9EW-LV6Z-NQeNR5RL_cC91txQc6zw@mail.gmail.com>
From: Shriramana Sharma <samjnaa@gmail.com>
Date: Sun, 30 Nov 2014 18:34:52 +0530
Message-ID: <CAH-HCWVt=w0bvcfpTMBa=vAqCJGhEzoaZ+Q1QXF+vSFS21mVgw@mail.gmail.com>
Subject: Re: Moving contents from one subvol to another
To: Robert White <rwhite@pobox.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 30, 2014 at 9:23 AM, Shriramana Sharma <samjnaa@gmail.com> wrote:
>
>
> Why should noCoW affect cp --reflink anyhow? I just created a 500 MiB
> file from /dev/urandom under a chattr +C-ed dir, and copied to another
> subvol using cp --reflink, and fi df still shows 500 MiB, not 1 GiB.

Looks like I might have spoken too soon (because I've read that some
changes aren't visible until the next FS commit) so right now it
actually says 1 GiB used, which I can't grok because why should a
nocow file be physically copied (to new blocks) just because it's
nocow? Is it because it is possible that the two copies are
overwritten separately at the same time?

But still, it seems to me that mv should make it so that the nocow
attr is temporarily (atomically?) suspended/ignored just for the
duration of the relocation, since there aren't going to be any two
copies to be overwritten at the same time.

Comments?

-- 
Shriramana Sharma ஶ்ரீரமணஶர்மா श्रीरमणशर्मा
