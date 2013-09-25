Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814Ab3IYP3a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Sep 2013 11:29:30 -0400
Message-ID: <52430154.8080304@redhat.com>
Date: Wed, 25 Sep 2013 10:29:24 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: vgrvelu <vgrajan2005@gmail.com>
CC: Chris Murphy <lists@colorremedies.com>, linux-btrfs@vger.kernel.org
Subject: Re: hi
References: <CALe5Emw4u1g2XPet5goM5V3YFbb4isqA4OTecR9RxnD7gxZr7g@mail.gmail.com> <A06B4AF5-710F-44F9-B793-1F417A99BF72@colorremedies.com> <CALe5EmwjQowFK9aggAV5LQjK1FhYM13StutosGjLkd0giwvmAA@mail.gmail.com>
In-Reply-To: <CALe5EmwjQowFK9aggAV5LQjK1FhYM13StutosGjLkd0giwvmAA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 9/25/13 8:00 AM, vgrvelu wrote:
> Hi
> 
> after doing mofprobe btrfs I could see btrfs entry in proc file
> system. But still mount command is failing. It looks like super block
> is corrupted

Seems doubtful if you *just* ran mkfs.btrfs.

Can you paste the exact commands you issued, from mkfs to mount,
and the resulting kernel messages?

-Eric

> thanks
> rajan

