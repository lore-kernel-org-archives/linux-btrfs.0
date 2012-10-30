Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:36400 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932930Ab2J3MNt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Oct 2012 08:13:49 -0400
Received: by mail-oa0-f46.google.com with SMTP id h16so156706oag.19
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Oct 2012 05:13:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <508FB45B.9040101@gmail.com>
References: <508FB45B.9040101@gmail.com>
Date: Tue, 30 Oct 2012 07:13:48 -0500
Message-ID: <CAKcLGm9_ih1tm-HqZ4+6ReXWJ5934Z8twauadUeDAuMXdJf=MQ@mail.gmail.com>
Subject: Re: Why btrfs inline small file by default?
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: ching <lsching17@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 30, 2012 at 6:04 AM, ching <lsching17@gmail.com> wrote:
> Hi all,
>
> I am testing my btrfs root partition with "max_inline=0", and 64k leaf size for weeks and it seems that it is fine.
>
>
> AFAIK btrfs inline small files into metadata by default, I am curious why?
>
> If there is only a few small files, then there will be neither effect nor benefit at all
> If there is a lot of small files, then the size of metadata will be undesirable due to deduplication
>
> there are also some email threads related to problem of metadata inline (i don't know whether they are fixed in recent kernel):
> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg16295.html
> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg05265.html
>
> How about turning off inline so that btrfs works better "out of the box"?
>
> ching
>

I did some rough benchmarking around this a few weeks ago.  I'll try
to clean up my method and post the results.

I was working with multiple copies and rsyncs of kernel sources, which
have many candidate files for inlining.

To my surprise, my btrfs benchmarks were always the same or faster
when I let btrfs inline the files, even though metadata was much
larger.
