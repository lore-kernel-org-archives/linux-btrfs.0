Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:33806 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121Ab2GDNxg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Jul 2012 09:53:36 -0400
Message-ID: <4FF44ADE.8000207@jan-o-sch.net>
Date: Wed, 04 Jul 2012 15:53:34 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: ziegler@uni-freiburg.de
CC: Josef Bacik <jbacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: kmem_cache_destroy called for cache that still has objects
References: <E1Slh32-0005X2-JH@tux00.mathematik.uni-freiburg.de> <4FF1C140.3070705@jan-o-sch.net>
In-Reply-To: <4FF1C140.3070705@jan-o-sch.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Martin,

On 02.07.2012 17:41, Jan Schmidt wrote:
> I'm recently seeing such buffer leaks as well. It's always about tree blocks,
> and it's always just two or three refs left for a buffer. I can somehow
> reproduce it and will be looking into it probably tomorrow. (May still be
> unrelated, of course.)

Okay, I've tracked my buffer leak down. It's most likely unrelated to yours, as
you need Chris' current for-linus for that to occur. Second, you need to trigger
a lot of tree mod log operations (i.e. by calling "btrfs inspect-internal" while
modifying the trees).

I'm sending a fix for the problem I found. However, there's no obvious
reproducer for your problem yet. Can you reproduce it?

-Jan
