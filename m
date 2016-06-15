Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f42.google.com ([209.85.214.42]:33468 "EHLO
	mail-it0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbcFOGmn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jun 2016 02:42:43 -0400
Received: by mail-it0-f42.google.com with SMTP id i6so18276681ith.0
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jun 2016 23:42:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK9QOu=yjjPtq0DMDF_JG3qsjs4pJjCzHhrRDwx8QPkDT_xxaA@mail.gmail.com>
References: <CAK9QOun4rHcd6om7ZXaiv=ZGMCSufcZTJAFs2Sop=vBhcnxHJQ@mail.gmail.com>
 <CAK9QOu=yjjPtq0DMDF_JG3qsjs4pJjCzHhrRDwx8QPkDT_xxaA@mail.gmail.com>
From: "Fajar A. Nugraha" <list@fajar.net>
Date: Wed, 15 Jun 2016 13:42:41 +0700
Message-ID: <CAG1y0scWA4vQ9ZZcxaUo42qy1c8r7d1xaeajNjYn2Rfrj-rAGA@mail.gmail.com>
Subject: Re: BTRFS, remarkable problem: filesystem turns to read-only caused
 by firefox download
To: Paul Verreth <paul@verreth.be>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 15, 2016 at 1:29 PM, Paul Verreth <paul@verreth.be> wrote:
> Dear all.
>
> When I download a video using  Firefox DownloadHelper addon, the
> filesystem suddenly turns read only. Not a coincedence, I tried it
> several times, and it happened every time again
>
> Info:
> Linux wolfgang 4.2.0-35-generic #40-Ubuntu SMP Tue Mar 15 22:15:45 UTC
> 2016 x86_64 x86_64 x86_64 GNU/Linux

> Segmentation fault
>
> Jun  5 15:03:15 ubuntu kernel: [ 2062.544303] BTRFS info (device
> sdb5): relocating block group 383447465984 flags 17


> What can I do to repair this problem?

The usual starting advice would be "try with latest kernel and see if
you can still reproduce the problem". Is it ubuntu wily? It'd go end
of in July anyway, so you might want to upgrade to xenial (or at
least, just the kernel, for the purpose of troubleshooting your
problem).

Or even try http://kernel.ubuntu.com/~kernel-ppa/mainline/daily/current/
(should be usable, but might report some errors/warning due to missing
ubuntu patches)

-- 
Fajar
