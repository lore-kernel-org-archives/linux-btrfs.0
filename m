Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:47973 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750943AbdECNH0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 May 2017 09:07:26 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:45242)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1d5u03-004Ia2-SO
        for linux-btrfs@vger.kernel.org; Wed, 03 May 2017 14:07:23 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1d5tzw-0002lA-V2
        for <linux-btrfs@vger.kernel.org>; Wed, 03 May 2017 14:07:16 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22793.54788.614431.672269@tree.ty.sabi.co.uk>
Date: Wed, 3 May 2017 14:07:16 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Ded
In-Reply-To: <CANT5p=prE-Vm7mGLhQNDwWiJ3k8bRbj-M-rtwk-k6j+_Ad1pBQ@mail.gmail.com>
References: <CANT5p=prE-Vm7mGLhQNDwWiJ3k8bRbj-M-rtwk-k6j+_Ad1pBQ@mail.gmail.com>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I have a btrfs filesystem mounted at /btrfs_vol/ Every N
> minutes, I run bedup for deduplication of data in /btrfs_vol
> Inside /btrfs_vol, I have several subvolumes (consider this as
> home directories of several users) I have set individual
> qgroup limits for each of these subvolumes. [ ... ]

Let's hope that you have read the warnings about the potential
downsides of deduplication, quota groups, many subvolumes. Even
if "syntactically" every features works with every features
without downsides, and they all scale up without limit.
