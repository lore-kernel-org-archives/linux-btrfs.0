Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f171.google.com ([209.85.128.171]:44989 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab3C1IIG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Mar 2013 04:08:06 -0400
Received: by mail-ve0-f171.google.com with SMTP id b10so7721994vea.2
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Mar 2013 01:08:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPsrAuBg9Mv3Ai=ZPMMF413Jw0kqA9ET9e_jnBjrqPhmqoQY+A@mail.gmail.com>
References: <CAPsrAuBg9Mv3Ai=ZPMMF413Jw0kqA9ET9e_jnBjrqPhmqoQY+A@mail.gmail.com>
Date: Thu, 28 Mar 2013 02:08:05 -0600
Message-ID: <CAE5mzvgJi=bgtB=LTwNRs29W4P5RinK5xYKhPpBmD_BVDdixNQ@mail.gmail.com>
Subject: Re: question about replacing a drive in raid10
From: cwillu <cwillu@cwillu.com>
To: Joeri Vanthienen <mail@joerivanthienen.be>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 28, 2013 at 1:54 AM, Joeri Vanthienen
<mail@joerivanthienen.be> wrote:
> Hi all,
>
> I have a question about replacing a drive in raid10 (and linux kernel 3.8.4).
> A bad disk was physical removed from the server. After this a new disk
> was added with "btrfs device add /dev/sdg /btrfs" to the raid10 btrfs
> FS.
> After this the server was rebooted and I mounted the filesystem in
> degraded mode. It seems that a previous started balance continued.
>
> At this point I want to remove the missing device from the pooI (btrfs
> device delete missing /btrfs). Is this safe to do ?

Yep.

> The disk usage numbers look weird to me, also the limited amount of
> data written to the new disk after the balance.

You're not actually looking at the data on the disk, but the size of
the block groups allocated on that disk.  I expect the data got spread
across all of the remaining disks, including the new one.

Probably worth running a scrub anyway though.
