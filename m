Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:42073 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbbJORyN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Oct 2015 13:54:13 -0400
Date: Thu, 15 Oct 2015 20:54:11 +0300
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: audio muze <audiomuze@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS raid 5/6 status
Message-ID: <20151015175410.GD23835@reaktio.net>
References: <CA+LE0jzBX8kN1NmQ-+8zUpxrB79oMEmpmzUGABYfeA_tX47jBA@mail.gmail.com>
 <CAJCQCtT2zpaXRr+i3rqjwdPjmvfcVE-iG564Q6P_ZbY7MkLFqw@mail.gmail.com>
 <CA+LE0jzQKu7Ujz6foYZL992W_R7HJdRS6_1gJ25DMUdQFy1=fA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+LE0jzQKu7Ujz6foYZL992W_R7HJdRS6_1gJ25DMUdQFy1=fA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 15, 2015 at 07:39:20AM +0200, audio muze wrote:
> Thanks Chris
> 
> I should've browsed recent threads, my apologies.  Terribly
> frustrating though that the issues you refer to aren't documented in
> the btrfs wiki.  Reading the wiki one is lead to believe that the only
> real issue is the write hole that can occur as a result of a power
> loss.  There I was thinking I've a UPS attached, no problem.
> Notification and handling of device failures is fundamental to any
> raid system, so it seems it's nowhere near ready.
>

Remember UPS does NOT protect against PSU failure, or a kernel crash..


-- Pasi
 
> On Thu, Oct 15, 2015 at 7:06 AM, Chris Murphy <lists@colorremedies.com> wrote:
> > See the other recent thread on the list "RAID6 stable enough for production?"
> >
> > A lot of your questions have already been answered in recent previous threads.
> >
> > While there are advantages to Btrfs raid56, there are some missing
> > parts that make it incomplete and possibly unworkable for certain use
> > cases. For example there's no notification of device failures like md
> > and LVM raid. If there's a device failure, and then also any other
> > problem crops up, the whole file system can become unusable. So
> > whatever your backup strategy is going to be, it needs to be even more
> > bulletproof if you're going to depend on Btrfs for production.
> >
> >
> > --
> > Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
