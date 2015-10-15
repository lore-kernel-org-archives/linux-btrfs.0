Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:33741 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbbJOFjV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Oct 2015 01:39:21 -0400
Received: by wijp11 with SMTP id p11so12095205wij.0
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2015 22:39:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtT2zpaXRr+i3rqjwdPjmvfcVE-iG564Q6P_ZbY7MkLFqw@mail.gmail.com>
References: <CA+LE0jzBX8kN1NmQ-+8zUpxrB79oMEmpmzUGABYfeA_tX47jBA@mail.gmail.com>
	<CAJCQCtT2zpaXRr+i3rqjwdPjmvfcVE-iG564Q6P_ZbY7MkLFqw@mail.gmail.com>
Date: Thu, 15 Oct 2015 07:39:20 +0200
Message-ID: <CA+LE0jzQKu7Ujz6foYZL992W_R7HJdRS6_1gJ25DMUdQFy1=fA@mail.gmail.com>
Subject: Re: BTRFS raid 5/6 status
From: audio muze <audiomuze@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks Chris

I should've browsed recent threads, my apologies.  Terribly
frustrating though that the issues you refer to aren't documented in
the btrfs wiki.  Reading the wiki one is lead to believe that the only
real issue is the write hole that can occur as a result of a power
loss.  There I was thinking I've a UPS attached, no problem.
Notification and handling of device failures is fundamental to any
raid system, so it seems it's nowhere near ready.

On Thu, Oct 15, 2015 at 7:06 AM, Chris Murphy <lists@colorremedies.com> wrote:
> See the other recent thread on the list "RAID6 stable enough for production?"
>
> A lot of your questions have already been answered in recent previous threads.
>
> While there are advantages to Btrfs raid56, there are some missing
> parts that make it incomplete and possibly unworkable for certain use
> cases. For example there's no notification of device failures like md
> and LVM raid. If there's a device failure, and then also any other
> problem crops up, the whole file system can become unusable. So
> whatever your backup strategy is going to be, it needs to be even more
> bulletproof if you're going to depend on Btrfs for production.
>
>
> --
> Chris Murphy
