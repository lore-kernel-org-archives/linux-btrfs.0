Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:32976 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423AbbJUU0X (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 16:26:23 -0400
Received: by igbkq10 with SMTP id kq10so947020igb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2015 13:26:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANznX5FS+sT3Pay+iLdA5TmP6NX-di3fm0K_yCHs4sac_OhndA@mail.gmail.com>
References: <CANznX5GOKcDMFTV2E-yDdvHWWf7Sn4o0PeX3vk0CZd2xmZo9mg@mail.gmail.com>
	<CANznX5FS+sT3Pay+iLdA5TmP6NX-di3fm0K_yCHs4sac_OhndA@mail.gmail.com>
Date: Wed, 21 Oct 2015 22:26:22 +0200
Message-ID: <CAJCQCtSoAyVodd6uOhChCN98=Q0pmKzwbTZJ4YTT8C0JCNygRg@mail.gmail.com>
Subject: Re: Btrfs/RAID5 became unmountable after SATA cable fault
From: Chris Murphy <lists@colorremedies.com>
To: "Janos Toth F." <toth.f.janos@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

https://btrfs.wiki.kernel.org/index.php/Restore

This should still be possible with even a degraded/unmounted raid5. It
is a bit tedious to figure out how to use it but if you've got some
things you want off the volume, it's not so difficult to prevent
trying it.


Chris Murphy
