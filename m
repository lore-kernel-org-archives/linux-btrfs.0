Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39549 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932930Ab2J3MIK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Oct 2012 08:08:10 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so139007pbb.19
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Oct 2012 05:08:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <508FBE50.6070300@gmail.com>
References: <508FBE50.6070300@gmail.com>
Date: Tue, 30 Oct 2012 06:08:09 -0600
Message-ID: <CAE5mzvgEFt7qJOt_zrUwNuons3Ku_PDBLpV0oX7cqy9aU=RjsA@mail.gmail.com>
Subject: Re: btrfs defrag problem
From: cwillu <cwillu@cwillu.com>
To: ching <lsching17@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 30, 2012 at 5:47 AM, ching <lsching17@gmail.com> wrote:
> Hi all,
>
> I try to defrag my btrfs root partition (run by root privilege)
>
> find / -type f -o -type d -print0 | xargs --null --no-run-if-empty btrfs filesystem defragment -t $((32*1024*1024))
>
>
> 1. This kind of error messages is prompted:
>
>     failed to open /bin/bash
>     open:: Text file busy
>     total 1 failures
>     failed to open /lib64/ld-2.15.so
>     open:: Text file busy
>     total 1 failures
>     failed to open /sbin/agetty
>     open:: Text file busy
>     failed to open /sbin/btrfs
>     open:: Text file busy
>     failed to open /sbin/dhclient
>     open:: Text file busy
>     failed to open /sbin/init
>     open:: Text file busy
>     failed to open /sbin/udevd
>
>     It seems that locked files cannot be defragged, is it expected behaviour?

I can't reproduce that behaviour here, although maybe you're running
an older kernel with some bug that's since been fixed?

> 2. Btrfs Wiki mentions that defrag directory will defrag metadata, is symlink/hardlink considered as metadata?
>
>     P.S. inline data is already disabled by "max_inline=0"

Well, that's a silly thing to do, causing every small file to take up
a separate 4kb block rather than its size * 2, and requiring extra
seeks to read/write them (i.e., if you have a million 10 byte files,
they'll now take up 4GB instead of 20MB).

> 3. Is any possible to online defrag a btrfs partition without hindered by mount point/polyinstantied directories?

If you're asking if you can defrag an unmounted btrfs, not at this
time.  It's possible in principle, nobody has cared enough to
implement it yet.
