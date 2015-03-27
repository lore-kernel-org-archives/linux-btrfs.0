Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:35546 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbbC0DVk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Mar 2015 23:21:40 -0400
Received: by igcau2 with SMTP id au2so9923268igc.0
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Mar 2015 20:21:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87wq23ff57.fsf@vostro.rath.org>
References: <87wq23ff57.fsf@vostro.rath.org>
Date: Thu, 26 Mar 2015 21:21:36 -0600
Message-ID: <CAJCQCtTJ9wPfpLXtC+SQdpfcDww+H1_u=kjcmGe=CZtJSAkEmA@mail.gmail.com>
Subject: Re: Kernel warning at fs/btrfs/inode.c:8693 btrfs_destroy_inode+0x1fa/0x2a0
 [btrfs]()
From: Chris Murphy <lists@colorremedies.com>
To: Nikolaus@rath.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 26, 2015 at 6:38 PM, Nikolaus Rath <Nikolaus@rath.org> wrote:

> I'm running 4.0-rc3, and I'm regularly getting these warnings in my
> kernel log:

> Mar 26 17:31:13 vostro kernel: [21480.088682] WARNING: CPU: 0 PID: 28958 at fs/btrfs/inode.c:8693 btrfs_destroy_inode+0x1fa/0x2a0 [btrfs]()


It's known.
https://lkml.org/lkml/2015/3/7/41



-- 
Chris Murphy
