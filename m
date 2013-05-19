Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f171.google.com ([209.85.128.171]:46598 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab3ESRjw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 May 2013 13:39:52 -0400
Received: by mail-ve0-f171.google.com with SMTP id m1so5087613ves.16
        for <linux-btrfs@vger.kernel.org>; Sun, 19 May 2013 10:39:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <knb28t$p9p$1@ger.gmane.org>
References: <knb28t$p9p$1@ger.gmane.org>
Date: Sun, 19 May 2013 19:39:51 +0200
Message-ID: <CAFvQSYQObGsKCf3iPtErfFvdQv6vqwc_KNAm5wt763ChrZWtUA@mail.gmail.com>
Subject: Re: btrfs (general) raid for other filesystems?
From: Clemens Eisserer <linuxhippy@gmail.com>
To: Martin <m_btrfs@ml1.co.uk>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Martin,

> So, an interesting variation could be to have filesystem level raid
> operating on ext4 or nilfs or whatever... Would that be a sensible idea?

Thats already supported by using LVM. What do you think you would gain
from layering in top of btrfs?

- Clemens
