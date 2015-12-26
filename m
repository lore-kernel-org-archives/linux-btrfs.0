Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:33936 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbbLZStp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Dec 2015 13:49:45 -0500
Received: by mail-ig0-f179.google.com with SMTP id m11so102552429igk.1
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Dec 2015 10:49:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50B1AB1702491A47883230E9A266A9880CD1FEE6@ITCIMEXCH02.uc.ucalgary.ca>
References: <CAD=LdFREn-jTEXTHw_Q+zbnva3dSWtb_aKcYS+6paidBjH7U8A@mail.gmail.com>
	<CAJCQCtStfVppb-NU0EjeAVf6cs08cdcWCEDYLx4zMoOzbG0W+A@mail.gmail.com>
	<CAC=t97Ac07=ZFZ1nShfWc0ik50D90hBJM3bSEiLmHbKK36G9Xw@mail.gmail.com>
	<pan$9b1ad$a377a340$8346d054$a731dd54@cox.net>
	<CAC=t97BW6vYgi7edM=PknJDep9nJxDbOYpgPKi6L2u-J3hMwqQ@mail.gmail.com>
	<pan$82f3e$e3af006a$d15f1d6c$4b07b3ba@cox.net>
	<CAC=t97BsV1FJr+icGLY8XKyLjejG-k0frSuPWZtRu=N5znfXEw@mail.gmail.com>
	<CAJCQCtRXBPBsiAH65JKFy7+5sFM7fnrAKg-7ESaoeUTsmMqdrg@mail.gmail.com>
	<pan$88899$a0c696db$cb878db4$9a294bbd@cox.net>
	<50B1AB1702491A47883230E9A266A9880CD1FEE6@ITCIMEXCH02.uc.ucalgary.ca>
Date: Sat, 26 Dec 2015 11:49:44 -0700
Message-ID: <CAJCQCtTUnoQ5fBT-H+XHirg-Cs6zSN4RNwexqQdUdsaOtXqtPQ@mail.gmail.com>
Subject: Re: Loss of connection to Half of the drives
From: Chris Murphy <lists@colorremedies.com>
To: David Schulz <dschulz@ucalgary.ca>, Duncan <1i5t5.duncan@cox.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 25, 2015, 11:28 PM David Schulz <dschulz@ucalgary.ca> wrote:
>
>
> I mentioned the btrfs rescue command with the mismatching fsid message.  After dd'ing /dev/zero to all but the boot drive, the fsid mismatch went away, but the tool still segfaults on the filesystem after losing 1/2 of the drives, so at best, the fsid mismatch error was just cosmetic.
>
>

Are you running btrfs rescue on all drives? Or just 1/2?

Because while rescue shouldn't crash, I also don't expect it to scrape
any files. It's probably worth submitting a bug and a strace.


---
Chris Murphy
