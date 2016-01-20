Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:33332 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445AbcATUqk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jan 2016 15:46:40 -0500
Received: by mail-io0-f178.google.com with SMTP id q21so32890893iod.0
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jan 2016 12:46:40 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20160120202909.4a804707@natsu>
References: <20160120202909.4a804707@natsu>
Date: Wed, 20 Jan 2016 20:46:39 +0000
Message-ID: <CAL3q7H6y3-8PhZOiBVxszZV5DN-c81EsQ_NjMaHmgGmJrc9aQA@mail.gmail.com>
Subject: Re: Kernel 4.4.0 intermittent ENOSPC during heavy data write and
 concurrent snapshotting
From: Filipe Manana <fdmanana@gmail.com>
To: Roman Mamedov <rm@romanrm.net>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 20, 2016 at 3:29 PM, Roman Mamedov <rm@romanrm.net> wrote:
> Hello,
>
> To reproduce...
>
> *) in one terminal window:
>
>     btrfs sub create test
>     chattr +C test
>     cd test/
>     while true; do dd if=/dev/zero of=zerofile bs=1M count=1024; sync; done
>
> *) in another terminal window start repeatedly snapshotting 'test', at random
>   1-3-5 second intervals:
>
>     mkdir snaps
>     btrfs sub snap test snaps/test-`date +%Y-%m-%dT%H:%M:%S`
>
> The 'dd' output of first window then looks like this for me:
>
> 1024+0 records in
> 1024+0 records out
> 1073741824 bytes (1.1 GB) copied, 0.49982 s, 2.1 GB/s
> 1024+0 records in
> 1024+0 records out
> 1073741824 bytes (1.1 GB) copied, 0.541291 s, 2.0 GB/s
> 1024+0 records in
> 1024+0 records out
> 1073741824 bytes (1.1 GB) copied, 4.88021 s, 220 MB/s
> 1024+0 records in
> 1024+0 records out
> 1073741824 bytes (1.1 GB) copied, 4.56427 s, 235 MB/s
> 1024+0 records in
> 1024+0 records out
> 1073741824 bytes (1.1 GB) copied, 0.530991 s, 2.0 GB/s
> 1024+0 records in
> 1024+0 records out
> 1073741824 bytes (1.1 GB) copied, 5.68497 s, 189 MB/s
> dd: writing `zerofile': No space left on device
> 1+0 records in
> 0+0 records out
> 0 bytes (0 B) copied, 0.000591943 s, 0.0 kB/s
> 1024+0 records in
> 1024+0 records out
> 1073741824 bytes (1.1 GB) copied, 4.25015 s, 253 MB/s
> 1024+0 records in
> 1024+0 records out
> 1073741824 bytes (1.1 GB) copied, 4.66459 s, 230 MB/s
> dd: writing `zerofile': No space left on device
> 1015+0 records in
> 1014+0 records out
> 1063489536 bytes (1.1 GB) copied, 3.0433 s, 349 MB/s
> 1024+0 records in
> 1024+0 records out
> 1073741824 bytes (1.1 GB) copied, 4.24264 s, 253 MB/s
> dd: writing `zerofile': No space left on device
> 1+0 records in
> 0+0 records out
> 0 bytes (0 B) copied, 0.000647234 s, 0.0 kB/s
> 1024+0 records in
> 1024+0 records out
> 1073741824 bytes (1.1 GB) copied, 3.56673 s, 301 MB/s
> 1024+0 records in
> 1024+0 records out
> 1073741824 bytes (1.1 GB) copied, 3.71281 s, 289 MB/s
> 1024+0 records in
> 1024+0 records out
> 1073741824 bytes (1.1 GB) copied, 0.551317 s, 1.9 GB/s
> ^C
> -----
>
> This also causes my KVM VMs to fail with a high probability during
> snapshotting of their backing subvolume (as described in the previous thread).

Try this: https://patchwork.kernel.org/patch/7967161/

(It's not a regression in 4.4 however, it has been there for a long time)

>
> --
> With respect,
> Roman



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
