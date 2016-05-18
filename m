Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35100 "EHLO
	mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbcERFJJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 May 2016 01:09:09 -0400
Received: by mail-oi0-f66.google.com with SMTP id w198so7574413oiw.2
        for <linux-btrfs@vger.kernel.org>; Tue, 17 May 2016 22:09:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABt16=EDFKFj4duaWJ0qCS_SO9TE2jn8UMCx5e_u+X+M328yeA@mail.gmail.com>
References: <CABt16=EDFKFj4duaWJ0qCS_SO9TE2jn8UMCx5e_u+X+M328yeA@mail.gmail.com>
Date: Tue, 17 May 2016 23:09:08 -0600
Message-ID: <CAJCQCtROTVzeXKkuqEMONbhDjiMXdbJFTzmg=whDOUjczi1RSw@mail.gmail.com>
Subject: Re: Corrupted system due to imbalanced metadata chunks
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 17, 2016 at 9:45 AM, Peter Kese <peter.kese@viidea.com> wrote:

> Then I tried a software upgrade (Ubuntu 15.10 -> 16.04) and it turned
> out that while there was more than 100 GB (45%) of free disk space,
> the upgrade process broke down somewhere in the middle reporting IO
> errors and lack of free disk space.

Kinda interesting, this appears in kernel 4.4.4

    btrfs: statfs: report zero available if metadata are exhausted
http://lkml.iu.edu/hypermail/linux/kernel/1603.0/01148.html

I think the OS upgrade case may still fail because there was probably
a lot of small files written inline in metadata chunks. So unless
there were a constant statfs check by the upgrader (like a per package
install check) then the first statfs check probably still overstates
the free space because it has no way of knowing there's about to be a
pile of small file writes.

And I've seen the reverse happen where it was metadata chunks with
free space, the data chunks were full and the enospc happened because
no data chunk could be allocated. So it's not so simple like adjusting
the data/metadata allocation ratio.

Huh. I wonder if after say, 90 or 95% full, Btrfs just switches to
creating a mixed-bg?

-- 
Chris Murphy
