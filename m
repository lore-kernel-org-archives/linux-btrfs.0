Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f54.google.com ([209.85.192.54]:36618 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaK2PP4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Nov 2014 10:15:56 -0500
Received: by mail-qg0-f54.google.com with SMTP id q107so5829803qgd.13
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Nov 2014 07:15:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141129142813.GD32735@carfax.org.uk>
References: <CAH-HCWUR4QPDn=M8nchdRedzGU3DYDHC8d6YRH8-FBm6trWCJg@mail.gmail.com>
 <20141129142813.GD32735@carfax.org.uk>
From: Shriramana Sharma <samjnaa@gmail.com>
Date: Sat, 29 Nov 2014 20:45:34 +0530
Message-ID: <CAH-HCWWh02invDCdx4-bPORdg4r39efsW=buKXTVtfspSQ9sVA@mail.gmail.com>
Subject: Re: Moving contents from one subvol to another
To: Hugo Mills <hugo@carfax.org.uk>, Shriramana Sharma <samjnaa@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 29, 2014 at 7:58 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>    The latest version of mv should be able to use CoW copies to make
> it more efficient. It has a --reflink option, the same as cp. Note
> that you can't make reflinks crossing a mount boundary, but you can do
> so crossing a subvolume boundary (as you're doing here).

Hi thanks for this. I suppose you are referring to the commit:

http://git.savannah.gnu.org/cgit/coreutils.git/commit/?id=b47231be6813e6cb5305266e391b4bb745f27f13

>From http://git.savannah.gnu.org/cgit/coreutils.git/log/?qt=grep&q=mv%3A,
http://git.savannah.gnu.org/cgit/coreutils.git/plain/NEWS?id=b47231be6813e6cb5305266e391b4bb745f27f13
and finally http://git.savannah.gnu.org/cgit/coreutils.git/tree/src/mv.c?id=b47231be6813e6cb5305266e391b4bb745f27f13
it doesn't seem as if there was any earlier commit actually adding a
--reflink option so it seems the improvement is in-built.

That's nice to know!

Any idea when the next coreutils point release with this will be out?

-- 
Shriramana Sharma ஶ்ரீரமணஶர்மா श्रीरमणशर्मा
