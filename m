Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:53806 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751344AbdGVUgB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 22 Jul 2017 16:36:01 -0400
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.89)
        (envelope-from <kilobyte@angband.pl>)
        id 1dZ184-0007sb-KL
        for linux-btrfs@vger.kernel.org; Sat, 22 Jul 2017 22:36:00 +0200
Date: Sat, 22 Jul 2017 22:36:00 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: degraded raid scribbling upon wrong device
Message-ID: <20170722203600.lfs2bbph3xc4apyg@angband.pl>
References: <20170713064011.gweixjxdrq3gjc23@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170713064011.gweixjxdrq3gjc23@angband.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 13, 2017 at 08:40:12AM +0200, Adam Borowski wrote:
> Here's a set of test cases, two of them in some cases seem to scribble upon
> the wrong device:
> 
> * deg-mid-missing
> * deg-last-replaced (not on the innocent "re")
> * but never deg-last-missing
> 
> When all goes ok, there are no errors other than wrong generation on the
> re-added disk (expected).   When it goes bad, there's a lot of corruption.
> In all cases, though, the "Device missing:" field is wrong.

I did not explore this adequately yet, in a good part because of ENOSPC
triggering a lot of time for an unrelated reason that Omar just fixed
(thanks!).  So, here's what I know so far:

* copying in, say, 2.2GB /usr/share is a lot more likely to trigger than
  dd-ing 2.2GB of /dev/null
* no "real" degrading is needed: in the original scripts, the missing device
  is empty so all blocks are doubled anyway.  It's not about degraded chunks
  but because of a bogus device.
* bogus output of "btrfs f u" is a sure predictor that, with enough tries,
  you'll get corruption -- if it shows something when it should say
  "missing", shit is likely to happen


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢠⠒⠀⣿⡁ A dumb species has no way to open a tuna can.
⢿⡄⠘⠷⠚⠋⠀ A smart species invents a can opener.
⠈⠳⣄⠀⠀⠀⠀ A master species delegates.
