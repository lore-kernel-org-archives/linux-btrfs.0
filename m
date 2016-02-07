Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:34821 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbcBGOXl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Feb 2016 09:23:41 -0500
Received: by mail-lb0-f177.google.com with SMTP id bc4so71210222lbc.2
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Feb 2016 06:23:40 -0800 (PST)
MIME-Version: 1.0
Reply-To: a.t.hild@gmail.com
In-Reply-To: <56B74D01.9000008@gmx.com>
References: <CAEm4ggmjK8oH7PcN_-Jf3M-j=8Yewh6j3G2F+zUviaajY1wgow@mail.gmail.com>
	<56B74D01.9000008@gmx.com>
Date: Sun, 7 Feb 2016 21:23:39 +0700
Message-ID: <CAEm4gg=n0bib28HwEBGwzDMg3=O525s6p=YdDqubfPQ_LL-SPg@mail.gmail.com>
Subject: Re: Fi corruption on RAID1, generation doesn't match
From: Andreas Hild <a.t.hild@gmail.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 7 February 2016 at 20:56, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
> You are wondering why data is still 168G, but that's the allocated data
> chunk size.
>
> It means 168G space is allocated to store data, but only 42M is used.
> Matches with your vanilla df output.
>
> So it doesn't mean you data are still here.

I understand now. Thanks very much!


[...]
>
> That's the previous transaction's tree root.
> If you are in good luck, previous trans may has all your data.
> But if you are in bad luck, it may already after the remove.
>
> Normally, at least something should still be in previous trans.
>
> Now use btrfsck to check if previous trans is in good shape.
>
> # btrfsck --tree-root 647630028800
>
> If btrfsck only reports minor problems, like space cache tree mismatch, then
> it means previous trans are almost OK.
>
> Then let btrfsck to revert to previous trans:
>
> # btrfsck --tree-root 647630028800 --repair
>
> If you're really in good luck, then you can mount the fs and found something
> in it.


Great! I'll try this.

The 'tree-root' option must be a recent development. My 'stable'
Debian live disk does not recognize this option.

Could any one recommended a live disk that already includes this btrfsck option?

Many thanks!

Andreas
