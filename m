Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:34109 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbcHLUed (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Aug 2016 16:34:33 -0400
Received: by mail-oi0-f42.google.com with SMTP id l203so49124605oib.1
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Aug 2016 13:34:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTrEqR=UNpHp7ApbdBkwRRT6U5tiSHcs2y4N-P_G5u=Fw@mail.gmail.com>
References: <1471023419.16857.9.camel@gmail.com> <CAJCQCtSwHCkW_nUNp4-R=S+ExZMk97i2qr6MwSuRU540c6xtfg@mail.gmail.com>
 <1471028417.16857.12.camel@gmail.com> <CAJCQCtTrEqR=UNpHp7ApbdBkwRRT6U5tiSHcs2y4N-P_G5u=Fw@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 12 Aug 2016 14:34:31 -0600
Message-ID: <CAJCQCtS51syrzxvpZXGzS=Ge=rW1iEfZDj6VrVmON39ww-Hmdg@mail.gmail.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
Cc: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 12, 2016 at 1:37 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Fri, Aug 12, 2016 at 1:00 PM, Ronan Arraes Jardim Chagas
> <ronisbr@gmail.com> wrote:

>
> d. Run journalctl -f from a 2nd computer.

Hopefully it's obvious I mean run journalctl -f on the affected
computer remotely via ssh.

>
>> Do you
>> think that if I reinstall my openSUSE it will be fixed?
>
> Probably but the nature of this probem isn't well understood as far as
> I know. It's not that common or it'd be easy for a dev to reproduce
> and then figure out what's going on.

Since this file system has relatively small metadata size, just under
2GiB, it might be useful to take a btrfs-image of it and put it up
somewhere like a google drive, or wherever it can remain for a while.
Options -t 4 -c9 -s are fairly standard and sanitize file names. Data
itself is not included in the image. From this I think a dev might be
able to figure out what's unique about this file system that results
in the bogus enospc. If you do this, I recommend filing a
bugzilla.kernel.org bug and include URL to the image and URL to this
thread, and then the bugzilla URL in a post on this thread that way
everything is cross referenced.


-- 
Chris Murphy
