Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vn0-f47.google.com ([209.85.216.47]:34675 "EHLO
	mail-vn0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbbGIDJh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jul 2015 23:09:37 -0400
Received: by vnbf7 with SMTP id f7so26807364vnb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Jul 2015 20:09:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <558CB404.8050300@cn.fujitsu.com>
References: <CAC8ULPYHuqsZN1Lm_2TxGMw7z6n=4zAprqYr9uoi=3kjoiSxQw@mail.gmail.com>
	<558CB0D4.8060401@cn.fujitsu.com>
	<558CB404.8050300@cn.fujitsu.com>
Date: Wed, 8 Jul 2015 21:09:34 -0600
Message-ID: <CAJCQCtTMdQG4EB8dNAYPq8H3V68TCb2YQztoXXYMkCYA3GBCXw@mail.gmail.com>
Subject: Re: btrfs partition converted from ext4 becomes read-only minutes
 after booting: WARNING: CPU: 2 PID: 2777 at ../fs/btrfs/super.c:260 __btrfs_abort_transaction+0x4b/0x120
From: Chris Murphy <lists@colorremedies.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Robert Munteanu <robert.munteanu@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 25, 2015 at 8:08 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:

> A quite code search leads me to inline extent.
>
> So, if you still have the original ext* image,
> would you please try revert to ext* and then convert it to btrfs again?
>
> But this time, please convert with --no-inline option, and see if this
> remove the problem.

Using -n at convert time does not make a difference for the
btrfs-convert bugs I've opened:
https://bugzilla.kernel.org/show_bug.cgi?id=101191
https://bugzilla.kernel.org/show_bug.cgi?id=101181
https://bugzilla.kernel.org/show_bug.cgi?id=101221
https://bugzilla.kernel.org/show_bug.cgi?id=101231

The last one I just discovered happens much sooner, is easier to
reproduce than the other two. It's a scrub right after a successful
btrfs-convert that btrfs check says is OK. But the scrub ends with two
separate oopses and multiple call traces and a spectacularly hard
kernic panic (ssh and even the console dies).

So I think btrfs-convert has a bug, but then the kernel code is not
gracefully handling it at all either and crashes badly with a scrub;
and less badly with balance. However, the file system is still OK
despite scrub crash. With balance failure, the file system is too
badly damaged and btrfs check and btrfs-image fail.



-- 
Chris Murphy
