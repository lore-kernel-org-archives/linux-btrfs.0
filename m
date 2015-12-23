Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:36720 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbbLWU7t (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Dec 2015 15:59:49 -0500
Received: by mail-io0-f178.google.com with SMTP id o67so226379559iof.3
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Dec 2015 12:59:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <n5evuc$9j3$1@ger.gmane.org>
References: <n5du09$9rn$1@ger.gmane.org>
	<n5evuc$9j3$1@ger.gmane.org>
Date: Wed, 23 Dec 2015 13:59:49 -0700
Message-ID: <CAJCQCtR1uO2OfHH4Dwd3KxxGi9TxXS0zAAYuu5qi2B_5HWiA3Q@mail.gmail.com>
Subject: Re: btrfs und lvm-cache?
From: Chris Murphy <lists@colorremedies.com>
To: Neuer User <auslands-kv@gmx.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 23, 2015 at 1:24 PM, Neuer User <auslands-kv@gmx.de> wrote:
> One other thing:
>
> I read that btrfs has some options that are turned off for SSDs as they
> might be harmful or so. In my case btrfs, however, would not know about
> the SSD and probably use its HDD optimized settings. The result,
> however, would be forwared also to the SSD via lvmcache. Do I see that
> right? Would that give any serious problems?

No, Btrfs is fine for SSD with or without the optimization. And with
optimization is OK for hard drives also. I think you're unlikely to
notice any difference, but you can test it if you want with mount
options ssd or nossd, depending on how the cache LV is detected (I'd
guess it's detected as non rotational so ssd option is default).


-- 
Chris Murphy
