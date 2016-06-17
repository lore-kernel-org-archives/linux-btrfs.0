Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:36413 "EHLO
	mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbcFQOpd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jun 2016 10:45:33 -0400
Received: by mail-io0-f195.google.com with SMTP id s63so9575070ioi.3
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Jun 2016 07:45:32 -0700 (PDT)
From: Tyson Whitehead <twhitehead@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Scrub aborts on newer kernels
Date: Fri, 17 Jun 2016 10:45:27 -0400
Message-ID: <25284905.4oL6MYjT0a@whitehead.beowulf.uwo.ca>
In-Reply-To: <CAJCQCtTcns_Oq=ku2zx_Dhm8hbfJBDzj57ybDLDZ2=fQ1W0Vow@mail.gmail.com>
References: <1970914.zjZ5YKPDft@whitehead.beowulf.uwo.ca> <CAJCQCtTcns_Oq=ku2zx_Dhm8hbfJBDzj57ybDLDZ2=fQ1W0Vow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On May 27, 2016 12:12:54 PM Chris Murphy wrote:
> On Thu, May 26, 2016 at 11:55 AM, Tyson Whitehead <twhitehead@gmail.com> wrote:
> > Under the last several kernels versions (4.6 and I believe 4.4 and, 4.5) btrfs scrub aborts before completing.
> 
> I can't reproduce this with btrfs-progs 4.5.2 and kernel 4.6.0.
> 
> I think the bigger issue is the lack of information why a scrub is aborted.

Thanks for checking into this Chris.

Any advice on how to get some more information out of the scrub process?

Cheers!  -Tyson
