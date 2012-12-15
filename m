Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36263 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab2LOX6X (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Dec 2012 18:58:23 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so3194687pbc.19
        for <linux-btrfs@vger.kernel.org>; Sat, 15 Dec 2012 15:58:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201212161023.59380.russell+btrfs@coker.com.au>
References: <201212161023.59380.russell+btrfs@coker.com.au>
Date: Sat, 15 Dec 2012 17:58:23 -0600
Message-ID: <CAE5mzvjVT2Wp5FOiAFeULWU6uWka3kcJaV4mLmjZ1YLzx4M7Pw@mail.gmail.com>
Subject: Re: Intel 120G SSD write performance with 3.2.0-4-amd64
From: cwillu <cwillu@cwillu.com>
To: russell+btrfs@coker.com.au
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 15, 2012 at 5:23 PM, Russell Coker
<russell+btrfs@coker.com.au> wrote:
> I've got a system running Debian kernel 3.2.0-4-amd64 with root on a SSD that
> identifies itself as "INTEL SSDSC2CT12 300i" (it's an Intel 120G device).

3.2 is massively old in btrfs terms, with lots of fun little stability
and performance bugs.

> Here is the /proc/mounts entry which shows that ssd and discard options are
> enabled.
>
> /dev/disk/by-uuid/7939c405-c656-4e85-a6a0-29f17be09585 / btrfs
> rw,seclabel,nodev,noatime,ssd,discard,space_cache 0 0

Don't use discard; it's a non-queuing command, which means your
performance will suck unless your device is _really_ terrible at
garbage collection (in which case, it's just the lesser of two evils).
