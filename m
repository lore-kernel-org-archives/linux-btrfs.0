Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:35799 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751836AbdHASFu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2017 14:05:50 -0400
Received: by mail-wm0-f48.google.com with SMTP id m85so21891127wma.0
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Aug 2017 11:05:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMG9ccxPHHwEYBYZddTaX96kEnan5NtDvhUW=gw+NoUe7amyiA@mail.gmail.com>
References: <CAMG9ccwAaWtK=VqNcB9z9Q2qLNHr3q0QmWR0hg=RoG1ynZB-ng@mail.gmail.com>
 <CAMG9ccxPHHwEYBYZddTaX96kEnan5NtDvhUW=gw+NoUe7amyiA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 1 Aug 2017 12:05:48 -0600
Message-ID: <CAJCQCtQuYrzYEyHn9LRVUhLZ_mw6hcS-s55cJD=g9h=hXEbq7A@mail.gmail.com>
Subject: Re: What are the typical usecase of "btrfs check --init-extent-tree"?
To: Ivan Sizov <sivan606@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 27, 2017 at 9:33 AM, Ivan Sizov <sivan606@gmail.com> wrote:
> I've just noticed a huge number of errors on one of the RAID's disks.
> "btrfs dev stats" gives:
>
> [/dev/sdc1].write_io_errs    0
> [/dev/sdc1].read_io_errs     305
> [/dev/sdc1].flush_io_errs    0
> [/dev/sdc1].corruption_errs  429
> [/dev/sdc1].generation_errs  0
>
> [/dev/sda1].write_io_errs    58331
> [/dev/sda1].read_io_errs     57438
> [/dev/sda1].flush_io_errs    37
> [/dev/sda1].corruption_errs  10110
> [/dev/sda1].generation_errs  0


You'll need to translate the sda device to ata device, and then do a
search for kernel messages. I suspect persistent bad sector on this
drive, and write failures are always disqualifying but Btrfs won't
eject this device.

Read errors are not a big problem. Read errors along with corruptions
aren't necessarily a big problem. Write errors are a big problem.



-- 
Chris Murphy
