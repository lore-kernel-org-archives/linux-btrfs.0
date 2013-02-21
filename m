Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:51110 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800Ab3BUPyX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Feb 2013 10:54:23 -0500
Received: by mail-ie0-f172.google.com with SMTP id c10so11554628ieb.31
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Feb 2013 07:54:21 -0800 (PST)
Message-ID: <1361462073.18057.23.camel@cwalton-XPS-8300>
Subject: Re: Another defrag question
From: Calvin Walton <calvin.walton@kepstin.ca>
To: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Cc: "BTRFS, Linux" <linux-btrfs@vger.kernel.org>
Date: Thu, 21 Feb 2013 10:54:33 -0500
In-Reply-To: <51264146.3070504@petaramesh.org>
References: <51264146.3070504@petaramesh.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2013-02-21 at 16:46 +0100, Swâmi Petaramesh wrote:
> Hi again,
> 
> Having numerous snapshots, I prefer to ask rather than take the risk of
> exploding my storage space, better safe than sorry ;-)
> 
> "man btrfs" states :
> 
> « NOTE: defragmenting with kernels up to 2.6.37 will unlink COW-ed
> copies of data, don't use it if  you  use  snapshots,  have 
> deduplicated  your  data  or  made  copies with cp --reflink. »
> 
> I use :
> # uname -r
> 3.5.0-24-generic
> 
> ...So should I expect that defraging my BTRFS will be smart enough not
> to uncow my snapshots ? Is it actually able to defrag both the file and
> its snapshots altogether, keeping all this as a single physical copy of
> the defragged data ?

The message in the btrfs man page is a bit out of date - defragmenting
files on btrfs will uncow files on all currently released kernels.

There's a patch available to fix this, but it hasn't been merged yet. It
might show up in 3.9 or 3.10.

You really should upgrade your kernel, however. 3.5.0 is rather old in
btrfs-years! Lots of fixes have gone into newer kernels.


-- 
Calvin Walton <calvin.walton@kepstin.ca>

