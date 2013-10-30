Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:64803 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab3J3UMM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Oct 2013 16:12:12 -0400
Received: by mail-we0-f179.google.com with SMTP id w61so1766124wes.24
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Oct 2013 13:12:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20131030155453.GA8516@twin.jikos.cz>
References: <CAGqmi74OvQ=BFroP+QCf6eUtc61__LYRGtZJNcPz1XrSWX-q_w@mail.gmail.com>
 <CAGqmi74F9GurJL73qtU4JG+Fi4RbXE7tiaO1uEQqEY2ym278eA@mail.gmail.com> <20131030155453.GA8516@twin.jikos.cz>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Wed, 30 Oct 2013 23:11:50 +0300
Message-ID: <CAGqmi75GVPh1XonBzKzwTaDHW6mmBNCHuUWbBKtEmmc+RccV=Q@mail.gmail.com>
Subject: Re: swapfile on btrfs, temporary solution for wiki
To: Timofey Titovets <nefelim4ag@gmail.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I'd suggest to do full dd on that file and make it NOCOW first. That way
> it should minimize attempts to actually allocate the file blocks at the
> time they're needed for swap out.
I think this is good idea for HDD, on SSD this no make sence.

> https://btrfs.wiki.kernel.org/index.php/FAQ#Does_btrfs_support_swap_files.3F
> "A workaround, albeit with poor performance, is to mount a swap file via a loop device."
I did not pay attention to it, i think this is enough.
If nobody no want say addition comments, this thread can be closed.
Thanks to all, how answer.

With best regards,
Timofey
