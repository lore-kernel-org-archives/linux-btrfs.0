Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:48049 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbaDAT1Y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Apr 2014 15:27:24 -0400
Received: by mail-wg0-f47.google.com with SMTP id x12so8022966wgg.30
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Apr 2014 12:27:23 -0700 (PDT)
Subject: Re: [Help] Errors found in extent allocation tree or chunk allocation
Date: Tue, 01 Apr 2014 19:26:26 -0000
From: Michael Witten <mfwitten@gmail.com>
To: Shilong Wang <wangshilong1991@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <5a201e76eb0545a290305d2e62bfcd28-mfwitten@gmail.com>
In-Reply-To: <CAP9B-Qmy4NgzRPpApM+Pn7tjhu6Z-cBtz99kgC+2rYu9+o9PCQ@mail.gmail.com>
References: <ac786c9023364c699d8212b42da536f2-mfwitten@gmail.com>
            <CAP9B-Qmy4NgzRPpApM+Pn7tjhu6Z-cBtz99kgC+2rYu9+o9PCQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 1 Apr 2014 07:15:47 +0800, Shilong Wang wrote:

> hello, recently, i was working on btrfsck repair. i post some
> patches to make btrfsck to rebuild extent tree with snapshots.
> you can pull code from david latest branch and have a try with
> btrfsck --init-extent-tree.

Fortunately, the `btrfs balance' command solved the issue for me:

  http://mid.gmane.org/<8e4932bb29f743419660da1846c2363b-mfwitten@gmail.com>

However, I did notice `--init-extent-tree' when trying to figure
out what I might do to fix my troubles; however, I was uncertain
about exactly what it would do.

According to `man btrfsck':

  --init-csum-tree
       create a new CRC tree.

  --init-extent-tree
       create a new extent tree.

These sound potentially destructive, so I was afraid to use them;
what exactly does it mean to create a new tree? After your email,
I assume each action creates a new tree that is populated from the
data in the corresponding old tree.

Also, you wrote:

> rebuild extent tree with snapshots

Do you mean to say that your patches handle the previously unhandled
case in which both of the following are true?

  * There are snapshots in the file system.
  * The extent tree needs to be rebuilt.

Thanks!
