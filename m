Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:33214 "EHLO
	mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbbHKEV3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Aug 2015 00:21:29 -0400
Received: by vkbc123 with SMTP id c123so17808862vkb.0
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2015 21:21:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK7bmU_d3RTU4HZVHB9Z7ZAOpQ8C-wZn7WpvYsJaXiGDJki7fg@mail.gmail.com>
References: <CAK7bmU97q-oz8aSTQijHJR1MQRgOs+F9nHx2hMuqgPO6G5et9g@mail.gmail.com>
	<CAJCQCtS=v+T-qGFLeaELn7Bt+Mb8ViK+8+YgontAE=1ucAnWZg@mail.gmail.com>
	<CAK7bmU_d3RTU4HZVHB9Z7ZAOpQ8C-wZn7WpvYsJaXiGDJki7fg@mail.gmail.com>
Date: Mon, 10 Aug 2015 22:21:28 -0600
Message-ID: <CAJCQCtQ9kxpuQD3k-rO84O+0jRpiWbCJAUdog+2_Da6EK5yGsQ@mail.gmail.com>
Subject: Re: Damaged filesystem, can read, can't repair, error says to contact devs
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 10, 2015 at 7:23 PM, Timothy Normand Miller
<theosib@gmail.com> wrote:
> On Mon, Aug 10, 2015 at 6:52 PM, Chris Murphy <lists@colorremedies.com> wrote:

>> - complete dmesg for the failed mount
>
> It really doesn't say much.  I have things like this:
> [    8.643535] BTRFS info (device sdc): disk space caching is enabled
> [    8.643789] BTRFS: failed to read the system array on sdc
> [    8.706062] BTRFS: open_ctree failed
> [    8.707124] BTRFS info (device sdc): disk space caching is enabled
> [    8.710924] BTRFS: failed to read the system array on sdc
> [    8.766080] BTRFS: open_ctree failed
> [    8.766903] BTRFS info (device sdc): setting nodatacow, compression disabled
> [    8.766905] BTRFS info (device sdc): disk space caching is enabled
> [    8.767152] BTRFS: failed to read the system array on sdc
> [    8.936019] BTRFS: open_ctree failed
> [    8.936906] BTRFS info (device sdc): disk space caching is enabled
> [    8.939922] BTRFS: failed to read the system array on sdc
> [    8.995984] BTRFS: open_ctree failed
> [    8.996796] BTRFS info (device sdc): disk space caching is enabled
> [    8.997093] BTRFS: failed to read the system array on sdc
> [    9.125936] BTRFS: open_ctree failed

It looks like there's not enough redundancy remaining to mount and in
such a case there's really not much to be done.

I don't see nodatacow in your fstab, so I don't know why that's
happening. That means no checksumming for data.


>
> Also, when I manually try to mount, I get things like this:
>
> # mount /mnt/btrfs
> mount: wrong fs type, bad option, bad superblock on /dev/sdc,
>        missing codepage or helper program, or other error

Have you tried to mount with -o degraded?



> Well, if I get something lengthy, I'll attach it to my bug report.
> Did the information I reported help at all?

The entire dmesg is still useful because it should show libata errors
if these aren't fully failed drives. So you should file a bug and
include, literally, the entire unedited dmesg.


-- 
Chris Murphy
