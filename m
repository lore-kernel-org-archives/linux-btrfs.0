Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:56460 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab3HVOJP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Aug 2013 10:09:15 -0400
Received: by mail-ob0-f179.google.com with SMTP id fb19so3734450obc.10
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Aug 2013 07:09:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <79471CD1-CDDD-4EDD-B255-40568B8446E2@nickle.es>
References: <79471CD1-CDDD-4EDD-B255-40568B8446E2@nickle.es>
Date: Thu, 22 Aug 2013 09:09:14 -0500
Message-ID: <CAKcLGm_QXTjN3e-HtogM+XXygymG+1kjhuOAMNfj=ngSHx5T5Q@mail.gmail.com>
Subject: Re: Question: How can I recover this partition? (unable to find
 logical $hugenum len 4096)
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Nicholas Lee <email@nickle.es>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 22, 2013 at 1:47 AM, Nicholas Lee <email@nickle.es> wrote:

> [   45.914275] ------------[ cut here ]------------
> [   45.914406] kernel BUG at fs/btrfs/volumes.c:4417!
> [   45.914489] invalid opcode: 0000 [#1] PREEMPT SMP

I can't say if this will fix your problem or not, but the 3.10.x
kernel has a patch to pass this error back instead of halting with a
BUG() at this point.
