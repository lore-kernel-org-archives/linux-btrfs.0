Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f171.google.com ([209.85.220.171]:33325 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbaJMUmO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Oct 2014 16:42:14 -0400
Received: by mail-vc0-f171.google.com with SMTP id hy10so6509051vcb.30
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Oct 2014 13:42:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <543C35C3.9070002@prnet.org>
References: <543450DC.90504@prnet.org>
	<1412714780.2374.0@mail.thefacebook.com>
	<543A61EE.7070200@prnet.org>
	<CAGfcS_k7Y2-j3moyFw3j0gzb6Xuj-AutfjvZzEnpMem-z0KPRA@mail.gmail.com>
	<543C35C3.9070002@prnet.org>
Date: Mon, 13 Oct 2014 16:42:14 -0400
Message-ID: <CAGfcS_n5+ToT6kM5+J9TLjdwpriC3uu7hg2HVZXTmTSo-URO9Q@mail.gmail.com>
Subject: Re: btrfs random filesystem corruption in kernel 3.17
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: David Arendt <admin@prnet.org>
Cc: Chris Mason <clm@fb.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 13, 2014 at 4:27 PM, David Arendt <admin@prnet.org> wrote:
> From my own experience and based on what other people are saying, I
> think there is a random btrfs filesystem corruption problem in kernel
> 3.17 at least related to snapshots, therefore I decided to post using
> another subject to draw attention from people not concerned about btrfs
> send to it. More information can be found in the brtfs send posts.
>
> Did the filesystem you tried to balance contain snapshots ? Read only ones ?

The filesystem contains numerous subvolumes and snapshots, many of
which are read-only.  I'm managing many with snapper.

The similarity of the transid verify errors made me think this issue
is related, and the root cause may have nothing to do with btrfs send.

As far as I can tell these errors aren't having any affect on my data
- hopefully the system is catching the problems before there are
actual disk writes/etc.

--
Rich
