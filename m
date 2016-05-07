Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f194.google.com ([209.85.214.194]:34346 "EHLO
	mail-ob0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbcEGXfS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 7 May 2016 19:35:18 -0400
Received: by mail-ob0-f194.google.com with SMTP id n2so8575386obo.1
        for <linux-btrfs@vger.kernel.org>; Sat, 07 May 2016 16:35:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2cd5aca36f853f3c9cf1d46c2f133aa3@linuxsystems.it>
References: <3bf4a554-e3b8-44e2-b8e7-d08889dcffed@linuxsystems.it>
	<CAJCQCtRAqxREr8ToorSkbsnYKKk_NPy+1oSHP6WMOnpLe=9T1g@mail.gmail.com>
	<c9bde2c9-c0f3-4bd2-a9ac-81fe0250edcc@linuxsystems.it>
	<20160505174854.GA1012@vader.dhcp.thefacebook.com>
	<585760e0-7d18-4fa0-9974-62a3d7561aee@linuxsystems.it>
	<2cd5aca36f853f3c9cf1d46c2f133aa3@linuxsystems.it>
Date: Sat, 7 May 2016 17:35:16 -0600
Message-ID: <CAJCQCtSO2mbtUxW=d+hvEWrPhbMhNEK70ndAno-+jMgDUrpQeA@mail.gmail.com>
Subject: Re: btrfs ate my data in just two days, after a fresh install. ram
 and disk are ok. it still mounts, but I cannot repair
From: Chris Murphy <lists@colorremedies.com>
To: =?UTF-8?Q?Niccol=C3=B2_Belli?= <darkbasic@linuxsystems.it>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Chris Murphy <lists@colorremedies.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Omar Sandoval <osandov@osandov.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 7, 2016 at 9:45 AM, Niccolò Belli <darkbasic@linuxsystems.it> wrote:
> btrfs + dmcrypt + compress=lzo + autodefrag = corruption at first boot
> So discard is not the culprit. Will try to remove compress=lzo and
> autodefrag and see if it still happens.

You're making the troubleshooting unnecessarily difficult by
continuing to use non-default options. *shrug*

Every single layer you add complicates the setup and troubleshooting.
Of course all of it should work together, many people do. But you're
the one having the problem so in order to demonstrate whether this is
a software bug or hardware problem, you need to test it with the most
basic setup possible --> btrfs on plain partitions and default mount
options.



-- 
Chris Murphy
