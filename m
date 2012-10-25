Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40070 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760230Ab2JYUtb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 16:49:31 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so1438543pad.19
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2012 13:49:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <38F223BF-9890-4854-B622-62738235F022@colorremedies.com>
References: <50899151.1070503@inwind.it>
	<CAE5mzvgem05HN1QTFb6FkhHv0U=e1PTo7idPy06SR97cMbpFLg@mail.gmail.com>
	<38F223BF-9890-4854-B622-62738235F022@colorremedies.com>
Date: Thu, 25 Oct 2012 14:49:30 -0600
Message-ID: <CAE5mzviL33L=V6Wu+ugiLiHKzQxg446ZKEk7hqx9VEiCj5ByTQ@mail.gmail.com>
Subject: Re: [RFC] New attempt to a better "btrfs fi df"
From: cwillu <cwillu@cwillu.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 25, 2012 at 2:36 PM, Chris Murphy <lists@colorremedies.com> wrote:
> My suggestion is that by default a summary similar to the existing df command be mimicked, where it makes sense, for btrfs fi df.
>
>  - I like the Capacity %. If there is a reliable equivalent, it need not be inode based, that would be great.
>
> -  I care far less about the actual physical device information, more about the btrfs volume(s) as a whole. How big is the volume, how much of that is used, and how much is available?
>
> I understand the challenges behind estimating the amount available. So if the value for available/free is precided by a ~ in each case, or as a heading "~Avail" or "~Free" I'd be OK with that disclaimer.
>
> I think the examples so far are reporting too much information and it's difficult to get just what I want.

Plain old "/bin/df" is adequate for that though, and in the mean time
one _does_ need _all_ of that information to work with the filesystem.
 However, the detailed breakdown is vital to answer many questions:

"Why can't I write to my filesystem with 80gb free?  <btrfs fi df>
Oh, because metadata is raid1 and the one disk is 80gb smaller than
the other."

"How much data is on this disk that started giving SMART errors?"

"How many GB of vm image files (or other large files) can I probably
fit on this fs?"

"How many GB of mail (or other tiny files) can I probably fit on this fs?"

"Is there enough space to remove this disk from the fs, and how much
free space will I have then?"

And the all-important "Could you please run btrfs fi df and pastebin
the output so we can tell what the hell is going on?" :)
