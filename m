Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:34371 "EHLO
	mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbbG3RzR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jul 2015 13:55:17 -0400
Received: by vkca124 with SMTP id a124so12704470vkc.1
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Jul 2015 10:55:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRvEU+2vt9vvkUSwPnEyP9ej_mxNOiY4wkWHSYHH1DM9Q@mail.gmail.com>
References: <CA+X5Wn57HuJEzp_iOMnsi7R5AHBvsCBDbAS0+gv4O2BP-+G4VQ@mail.gmail.com>
	<CAJCQCtRvEU+2vt9vvkUSwPnEyP9ej_mxNOiY4wkWHSYHH1DM9Q@mail.gmail.com>
Date: Thu, 30 Jul 2015 11:55:16 -0600
Message-ID: <CAJCQCtToYh22BYqFTaccL86zx_WArO79dsEyR-eixYPrZpUY1g@mail.gmail.com>
Subject: Re: INFO: task btrfs-transacti:204 blocked for more than 120 seconds.
 (more like 8+min)
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 30, 2015 at 11:51 AM, Chris Murphy <lists@colorremedies.com> wrote:

> I can't tell what actually instigates this, as there are several blocked tasks.
>
> INFO: task btrfs-cleaner:203 blocked for more than 120 seconds.
>  INFO: task btrfs-transacti:204 blocked for more than 120 seconds.
>
> My suggestion, is to file a bug.

It's fine to file the bug against 4.1.2.

If you have the time it might be helpful for developers if you were to
also test against 4.2.0rc4 since that's what they're actively working
on. But even odds with clear reproduce steps and proper attachments
for a reasonably current kernel, and they can replicate the problem
and figure it out.


-- 
Chris Murphy
