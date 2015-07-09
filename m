Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:37555 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbbGIKwy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jul 2015 06:52:54 -0400
Received: by igau2 with SMTP id u2so86289351iga.0
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jul 2015 03:52:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTMdQG4EB8dNAYPq8H3V68TCb2YQztoXXYMkCYA3GBCXw@mail.gmail.com>
References: <CAC8ULPYHuqsZN1Lm_2TxGMw7z6n=4zAprqYr9uoi=3kjoiSxQw@mail.gmail.com>
	<558CB0D4.8060401@cn.fujitsu.com>
	<558CB404.8050300@cn.fujitsu.com>
	<CAJCQCtTMdQG4EB8dNAYPq8H3V68TCb2YQztoXXYMkCYA3GBCXw@mail.gmail.com>
Date: Thu, 9 Jul 2015 11:52:53 +0100
Message-ID: <CAO5K3Odab6nk54LpoDUJNJO-jA5x1+cc2dUOPeefH4d0Nt5L8g@mail.gmail.com>
Subject: Re: btrfs partition converted from ext4 becomes read-only minutes
 after booting: WARNING: CPU: 2 PID: 2777 at ../fs/btrfs/super.c:260 __btrfs_abort_transaction+0x4b/0x120
From: Vytautas D <vytdau@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Robert Munteanu <robert.munteanu@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

<Slightly off topic>

does these bugs exist in systems that converted from ext4 to btrfs
using kernel 3.13 and then upgraded to kernel 4.1 ?

On Thu, Jul 9, 2015 at 4:09 AM, Chris Murphy <lists@colorremedies.com> wrote:
> On Thu, Jun 25, 2015 at 8:08 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>> A quite code search leads me to inline extent.
>>
>> So, if you still have the original ext* image,
>> would you please try revert to ext* and then convert it to btrfs again?
>>
>> But this time, please convert with --no-inline option, and see if this
>> remove the problem.
>
> Using -n at convert time does not make a difference for the
> btrfs-convert bugs I've opened:
> https://bugzilla.kernel.org/show_bug.cgi?id=101191
> https://bugzilla.kernel.org/show_bug.cgi?id=101181
> https://bugzilla.kernel.org/show_bug.cgi?id=101221
> https://bugzilla.kernel.org/show_bug.cgi?id=101231
>
> The last one I just discovered happens much sooner, is easier to
> reproduce than the other two. It's a scrub right after a successful
> btrfs-convert that btrfs check says is OK. But the scrub ends with two
> separate oopses and multiple call traces and a spectacularly hard
> kernic panic (ssh and even the console dies).
>
> So I think btrfs-convert has a bug, but then the kernel code is not
> gracefully handling it at all either and crashes badly with a scrub;
> and less badly with balance. However, the file system is still OK
> despite scrub crash. With balance failure, the file system is too
> badly damaged and btrfs check and btrfs-image fail.
>
>
>
> --
> Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
