Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f45.google.com ([209.85.216.45]:51528 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaJ1OCI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Oct 2014 10:02:08 -0400
Received: by mail-qa0-f45.google.com with SMTP id dc16so483132qab.4
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Oct 2014 07:02:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJtFHUTDf8HvbeGqi14NJ_3ZhEAPxc6NCnOcyZ06ZGJiVoDWMw@mail.gmail.com>
References: <trinity-814e9704-84ce-4a27-a187-439cc5a13f06-1414401999856@3capp-mailcom-bs01>
	<5DD6D691-A067-4937-A5B4-545A0DFB9B1E@colorremedies.com>
	<pan$98595$5149a38a$2d53014$f3ac0c62@cox.net>
	<trinity-1f0ee155-d845-40b5-844d-77270be4d58e-1414495992747@3capp-mailcom-bs04>
	<CAJtFHUTDf8HvbeGqi14NJ_3ZhEAPxc6NCnOcyZ06ZGJiVoDWMw@mail.gmail.com>
Date: Tue, 28 Oct 2014 10:02:07 -0400
Message-ID: <CAGfcS_m7ct-M-n_eCcD27Pw-R63-C-VtPeqLOxOe4SHnb7HTTg@mail.gmail.com>
Subject: Re: BTRFS balance segfault, where to go from here
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: E V <eliventer@gmail.com>
Cc: Stephan Alz <stephan008@gmx.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 28, 2014 at 9:12 AM, E V <eliventer@gmail.com> wrote:
> I've seen dead locks on 3.16.3. Personally, I'm staying with 3.14
> until something newer stabilizes, haven't had any issues with it. You
> might want to try the latest 3.14, though I think there should be a
> new one pretty soon with quite a few btrfs patches.

Yeah, I forget what drove me to switch to a newer kernel, but I'm
wishing I had stuck with 3.14.  The last set of stable kernels has
been a pretty rough ride.  :)

My sense browsing the list is that the activity level has picked up a
bit, and that might be why 3.15-17 have been a bit more bug-ridden
than is normal.  For the long-term it is actually a good sign for the
vitality of btrfs.

But, I'll probably track 3.17 until a new longterm is announced and be
a bit more conservative.

--
Rich
