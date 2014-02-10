Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f171.google.com ([209.85.220.171]:52445 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbaBJW41 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 17:56:27 -0500
Received: by mail-vc0-f171.google.com with SMTP id le5so5258863vcb.2
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Feb 2014 14:56:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52F95222.1010403@libero.it>
References: <52F9014F.6070901@fb.com>
	<52F95222.1010403@libero.it>
Date: Mon, 10 Feb 2014 16:56:26 -0600
Message-ID: <CAE5mzvgd51zAFuYn=gc30QBDQ_-gZfy7m+pJrV9kzLpT6y7a7A@mail.gmail.com>
Subject: Re: What to do about df and btrfs fi df
From: cwillu <cwillu@cwillu.com>
To: "kreijack@inwind.it" <kreijack@inwind.it>
Cc: Josef Bacik <jbacik@fb.com>,
        "lin >> linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> In the past [1] I proposed the following approach.
>
> $ sudo btrfs filesystem df /mnt/btrfs1/
> Disk size:               400.00GB
> Disk allocated:            8.04GB
> Disk unallocated:        391.97GB
> Used:                     11.29MB
> Free (Estimated):        250.45GB       (Max: 396.99GB, min: 201.00GB)
> Data to disk ratio:          63 %

Note that a big chunk of the problem is "what do we do with the
regular system df output".  I don't mind this as a btrfs fi df summary
though.
