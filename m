Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f196.google.com ([209.85.213.196]:34569 "EHLO
        mail-yb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754449AbdA3Uva (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jan 2017 15:51:30 -0500
Received: by mail-yb0-f196.google.com with SMTP id w194so27500670ybe.1
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Jan 2017 12:51:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5e29c839-6519-acb2-c094-54600a6c0102@aei.mpg.de>
References: <5e29c839-6519-acb2-c094-54600a6c0102@aei.mpg.de>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 30 Jan 2017 13:51:29 -0700
Message-ID: <CAJCQCtTqBaG5AhtbokOkfREStK8XC+ZAsQ-aNOtYe2Y2Nv-4jA@mail.gmail.com>
Subject: Re: btrfs recovery
To: Michael Born <Michael.Born@aei.mpg.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 30, 2017 at 1:02 PM, Michael Born <Michael.Born@aei.mpg.de> wrote:
> Hi btrfs experts.
>
> Hereby I apply for the stupidity of the month award.

There's still another day :-D



>
> Before switching from Suse 13.2 to 42.2, I copied my / partition with dd
> to an image file - while the system was online/running.
> Now, I can't mount the image.

That won't ever work for any file system. It must be unmounted.


> Could you give me some instructions how to repair the file system or
> extract some files from it?

Not possible. The file system was being modified while dd was
happening, so the image you've taken is inconsistent.



-- 
Chris Murphy
