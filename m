Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:37155 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbcDCTD2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Apr 2016 15:03:28 -0400
Received: by mail-ig0-f176.google.com with SMTP id l20so50645116igf.0
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Apr 2016 12:03:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160403060202.03e67651@jupiter.sol.kaishome.de>
References: <20160331224452.0753d5c7@jupiter.sol.kaishome.de>
	<CAPmG0jZ6hs4TA_0ozNEP4x6ucn971Nj-6+uempGi1VwTWAdCYQ@mail.gmail.com>
	<20160402110001.0ec354b5@jupiter.sol.kaishome.de>
	<CAPmG0jaJdS26ABbC3Rz_D_FDfCKq8mYMHhmFwqhWYpDRdyFQhw@mail.gmail.com>
	<20160402221634.2e3dc71c@jupiter.sol.kaishome.de>
	<CAJCQCtQ+RnQqghDs060hrLJ850e0n=FiKNn9W8UuUP3DQV9u5g@mail.gmail.com>
	<20160403060202.03e67651@jupiter.sol.kaishome.de>
Date: Sun, 3 Apr 2016 13:03:27 -0600
Message-ID: <CAJCQCtS=bWjd086nhNNLo72aUk-=c0JmWGn_T706ratovAKrTg@mail.gmail.com>
Subject: Re: btrfsck: backpointer mismatch (and multiple other errors)
From: Chris Murphy <lists@colorremedies.com>
To: Kai Krakow <hurikhan77@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 2, 2016 at 10:02 PM, Kai Krakow <hurikhan77@gmail.com> wrote:
> Am Sat, 2 Apr 2016 18:14:17 -0600

> Also I think, having options nossd+autodefrag+lzo shouldn't be an
> exotic or unsupported option. Having this on top of bcache should just
> work.

I'm not suggesting it shouldn't work. But in fact something isn't
working. Bugs happen. Regressions happen. This is a process of
elimination project to find out either why, or under what
condition(s), it doesn't work.


> Does it make sense while I still have the corruptions in the FS? I'd
> like to wait for Qu whether I should recreate the FS or whether I
> should take some image, or send info to improve btrfsck...

It's up to you. I think it's fair to say the file system should not be
corrupting files so long as it's willing to write to the volume. So
that's a problem in and of itself; it should sooner go read only.

It's completely reasonable to take a btrfs-image, back everything up,
and then try a 'btrfs check --repair' and see if it can fix things up.
If not, that makes the btrfs-image more valuable.



> I think the latter two are easily the least probable sort of bugs. But
> I'll give it a try. For the time being, I could switch bcache to
> write-around mode - so it could at least not corrupt btrfs during
> writes.

I don't know enough about bcache to speculate what can happen if there
are already fs corruptions. Is it possible bcache makes things worse?
No idea.


-- 
Chris Murphy
