Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47296 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756400Ab2EQJTK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 May 2012 05:19:10 -0400
Received: by bkcji2 with SMTP id ji2so1341737bkc.19
        for <linux-btrfs@vger.kernel.org>; Thu, 17 May 2012 02:19:09 -0700 (PDT)
Message-ID: <1337246300.28385.13.camel@ierdnac-hp>
Subject: Re: [PATCH v3 0/3] Btrfs-progs: support get/reset device stats via
 ioctl
From: Andrei Popa <ierdnah@gmail.com>
Reply-To: ierdnah@gmail.com
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Date: Thu, 17 May 2012 12:18:20 +0300
In-Reply-To: <4FB4BA87.7090709@giantdisaster.de>
References: <1337187058-560-1-git-send-email-sbehrens@giantdisaster.de>
	 <1337187784.1525.6.camel@ierdnac-hp> <4FB4BA87.7090709@giantdisaster.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2012-05-17 at 10:44 +0200, Stefan Behrens wrote: 
> On 05/16/2012 19:03, Andrei Popa wrote:
> > It would be nice if this function could show the file names affected by
> > errors, in case of a single, non-redundant drive, btrfs-progs should
> > show what files are affected by errors.
> > Then, an admin could restore only those files from backup.
> >
> > On Wed, 2012-05-16 at 18:50 +0200, Stefan Behrens wrote:
> >> "btrfs device stats" is used to retrieve and print the device stats.
> >> "btrfs device stats -z" is used to atomically retrieve, reset and
> >> print the stats.
> 
> 
> In case of disk errors, it is recommended to run scrub on that disk. It 
> checks the in-use disk contents for errors, repairs errors where 
> possible, and the scrub tool does print the paths and filenames of 
> errored files into the kernel log.

In an automated script or for the usual user it would be easier to get
the output from btrfs-progs scrub command with the affected files,
instead from kernel log. 

