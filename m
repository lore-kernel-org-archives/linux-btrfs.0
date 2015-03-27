Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:36495 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbbC0DtV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Mar 2015 23:49:21 -0400
Received: by iedm5 with SMTP id m5so62208043ied.3
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Mar 2015 20:49:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87sicrf6sd.fsf@vostro.rath.org>
References: <87wq23ff57.fsf@vostro.rath.org>
	<CAJCQCtTJ9wPfpLXtC+SQdpfcDww+H1_u=kjcmGe=CZtJSAkEmA@mail.gmail.com>
	<87sicrf6sd.fsf@vostro.rath.org>
Date: Thu, 26 Mar 2015 21:49:20 -0600
Message-ID: <CAJCQCtRZxrR8yLM04oDKNhMbPUw4rN5dtMM2y245p6hM46mhUA@mail.gmail.com>
Subject: Re: Kernel warning at fs/btrfs/inode.c:8693 btrfs_destroy_inode+0x1fa/0x2a0
 [btrfs]()
From: Chris Murphy <lists@colorremedies.com>
To: Nikolaus Rath <Nikolaus@rath.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 26, 2015 at 9:39 PM, Nikolaus Rath <Nikolaus@rath.org> wrote:

> Thanks. Does this mean that I risk data corruption when using btrfs with
> 4.0-rc3, or is this relatively harmless?

I can't answer that. I'd say use 3.18.9 or 3.19.2 if you want reduced
risk of corruption, or use the current week's rc (which is rc5) if you
can accept a bit more risk for testing purposes.

-- 
Chris Murphy
