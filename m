Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35287 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652Ab2GWFuk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jul 2012 01:50:40 -0400
Received: by pbbrp8 with SMTP id rp8so10314751pbb.19
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Jul 2012 22:50:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <500CD93E.9040207@petaramesh.org>
References: <500C16F0.6000205@petaramesh.org>
	<20120722213714.2b5be0e1@natsu>
	<500CD93E.9040207@petaramesh.org>
Date: Sun, 22 Jul 2012 23:50:40 -0600
Message-ID: <CAE5mzvgNy7XLbjmC5PTtiGCuyEWEC70mwxQ7dT9FYOgiD-ubgQ@mail.gmail.com>
Subject: Re: Change "small" filesystem to normal
From: cwillu <cwillu@cwillu.com>
To: =?UTF-8?Q?Sw=C3=A2mi_Petaramesh?= <swami@petaramesh.org>
Cc: Roman Mamedov <rm@romanrm.ru>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 22, 2012 at 10:55 PM, Swâmi Petaramesh <swami@petaramesh.org> wrote:
> You're painfully right Roman,
>
> A freshly formatted 1 GB BTRFS filesystem on which 81 MB of data has been
> put shows only ~260 MB of free space and reserves something like 2 x 380 MB
> of metadata.
>
> This is absolutely ridiculous of BTRFS... :-/

That's an artifact of the small size of that filesystem and the
default size of allocations, which is why mixed mode exists.

The metadata allocation is about 4% on most filesystems: I see 38gb of
allocated but unused metadata space on a 900gb fs and 70gb on a 1.7tb
fs, and the referenced threads reports 170gb on what appears to be a
4tb fs; while not ideal, it's not remotely as bad as the 25% overhead
of the minimum 256mb*2 metadata allocation on a small 1gb fs*.  The
behaviour of a small filesystem simply isn't the same as the behaviour
of a large filesystem.

* Note that 1gb is still considered a very rather btrfs filesystem,
for which mixed mode is recommended!
