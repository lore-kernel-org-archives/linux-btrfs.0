Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:62525 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbaFEOvY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jun 2014 10:51:24 -0400
Received: by mail-pd0-f170.google.com with SMTP id g10so1186633pdj.15
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Jun 2014 07:51:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140605144146.GC14713@merlins.org>
References: <0f2f49c05a626f2f2e635a6db818e302@admin.virtall.com>
	<20140605144146.GC14713@merlins.org>
Date: Thu, 5 Jun 2014 21:51:23 +0700
Message-ID: <CAG1y0sf8nGuhww7h4P+yGxOBVOV9aQRmLrUV3ZzZ2__5d3UYmw@mail.gmail.com>
Subject: Re: latest btrfs-progs and asciidoc dependency
From: "Fajar A. Nugraha" <list@fajar.net>
To: Tomasz Chmielewski <tch@virtall.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 5, 2014 at 9:41 PM, Marc MERLIN <marc@merlins.org> wrote:
> On Thu, Jun 05, 2014 at 12:52:04PM +0100, Tomasz Chmielewski wrote:
>> And it looks the dependency is ~1 GB of new packages? O_o
>
> That seems painful, but at the same time, the alternative, nroff/troff sucks.
>
> Part ofyour problem however seems to be runaway dependencies.
> You are getting x11 and stuff like libdrm which clearly you shouldn't need.
> If your disk space is more valuable than your time, I recommend you build
> asciidoc yourself and you should hopefully end up with less.
>
> Or you can also remove asciidoc from the makefile and read the raw files
> which are readable.


... or try this

# apt-get install --no-install-recommends asciidoc

If that still doesn't work, AND you have lost of free time, AND
familiar with debian packaging, then you can use latest available
debian source, adapt it for latest version, and use opensuse build
service to compile it.

-- 
Fajar
