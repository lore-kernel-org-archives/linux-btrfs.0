Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54038 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837Ab2EXKlb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 May 2012 06:41:31 -0400
Received: by yhmm54 with SMTP id m54so7584190yhm.19
        for <linux-btrfs@vger.kernel.org>; Thu, 24 May 2012 03:41:30 -0700 (PDT)
Message-ID: <1337856087.3958.5.camel@ayu>
Subject: Re: Preparing single-disk setup for future multi-disk usage
From: Calvin Walton <calvin.walton@kepstin.ca>
To: =?ISO-8859-1?Q?Bj=F6rn_W=FCst?= <Bjoern.Wuest@iteratec.de>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Thu, 24 May 2012 06:41:27 -0400
In-Reply-To: <5A83377DACA90F4896A338250D088E8F14B35F09@HMEXMBCLUS01.ci04.de>
References: <5A83377DACA90F4896A338250D088E8F14B35F09@HMEXMBCLUS01.ci04.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2012-05-24 at 08:05 +0200, Björn Wüst wrote:
> Good morning,
> 
> 
> I currently have a single-disk setup where I want to use btrfs
> filesystem. Yet, I expect to add additional disks to this system in
> the future. Those disks shall be visible to the OS like a single disk,
> i.e. using multi-disk feature in btrfs. While data shall be striped
> among those disks in the future, meta data shall be mirrored for
> better fault tolerance (loss of some data is acceptable, while loss of
> all data is not acceptable).

If you're using the "RAID 0" (striping) mode, you will not be able to
recover any data in a useful form after a disk failure, because each
file will have been broken into small chunks and spread over both disks.
If you use the 'single' allocation mode instead, it is more likely that
individual files will be mostly on one disk, but there are no
guarantees.

If you want data to be recoverable, you should use a redundant raid
mode; otherwise don't expect that you'll be able to save much after a
disk failure.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

