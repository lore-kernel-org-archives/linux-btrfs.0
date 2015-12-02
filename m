Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:34964 "EHLO
	mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932301AbbLBODV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Dec 2015 09:03:21 -0500
Received: by lfdl133 with SMTP id l133so51394556lfd.2
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Dec 2015 06:03:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$101f2$e235cddd$fea951cb$dcf70182@cox.net>
References: <4082684905f25f921ae4564b1c8a892e@admin.virtall.com>
	<pan$101f2$e235cddd$fea951cb$dcf70182@cox.net>
Date: Wed, 2 Dec 2015 16:03:20 +0200
Message-ID: <CAK5rZE6-SMfseAfEu1GxLrgYNOBMhNbiQ8tqWVWUr6dFDL8OKw@mail.gmail.com>
Subject: Re: compression disk space saving - what are your results?
From: Imran Geriskovan <imran.geriskovan@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> What are your disk space savings when using btrfs with compression?

> * There's the compress vs. compress-force option and discussion.  A
> number of posters have reported that for mostly text, compress didn't
> give them expected compression results and they needed to use compress-
> force.

"compress-force" option compresses regardless of the "compressibility"
of the file.

"compress" option makes some inference about the "compressibility"
and decides to compress or not.

I wonder how that inference is done?
Can anyone provide some pseudo code for it?

Regards,
Imran
