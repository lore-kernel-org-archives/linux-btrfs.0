Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:33337 "EHLO
	mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932534AbcFJWKG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jun 2016 18:10:06 -0400
Received: by mail-vk0-f46.google.com with SMTP id d64so115154085vkb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Jun 2016 15:10:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <575B378E.8050304@mendix.com>
References: <CAKzrAgRQOvpy3ZVrLHHaRQt-JcjiFSFz6HPGr1vnvBK0xy5xGg@mail.gmail.com>
 <CAPmG0jZUx+V+1eyw1cDpHDkudXqfLQFL9+53Lzb3f0_PGXw+Xw@mail.gmail.com>
 <CAKzrAgTngBtK+eRGFh75GZ3MmuBKYyjbQXjD_LBhE8J-TuN0yg@mail.gmail.com> <575B378E.8050304@mendix.com>
From: "ojab //" <ojab@ojab.ru>
Date: Fri, 10 Jun 2016 22:10:03 +0000
Message-ID: <CAKzrAgTSnSyNV7KO4ERkH1BohdPEzzwbqGVSx3UhET+5PwUH2g@mail.gmail.com>
Subject: Re: Cannot balance FS (No space left on device)
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: Henk Slager <eye1tm@gmail.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 10, 2016 at 9:56 PM, Hans van Kranenburg
<hans.van.kranenburg@mendix.com> wrote:
> You can work around it by either adding two disks (like Henk said), or by
> temporarily converting some chunks to single. Just enough to get some free
> space on the first two disks to get a balance going that can fill the third
> one. You don't have to convert all of your data or metadata to single!
>
> Something like:
>
> btrfs balance start -v -dconvert=single,limit=10 /mnt/xxx/

Unfortunately it fails even if I set limit=1:
>$ sudo btrfs balance start -v -dconvert=single,limit=1 /mnt/xxx/
>Dumping filters: flags 0x1, state 0x0, force is off
>  DATA (flags 0x120): converting, target=281474976710656, soft is off, limit=1
>ERROR: error during balancing '/mnt/xxx/': No space left on device
>There may be more info in syslog - try dmesg | tail

//wbr ojab
