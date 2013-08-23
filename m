Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:58573 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002Ab3HWI5Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Aug 2013 04:57:25 -0400
Received: by mail-we0-f172.google.com with SMTP id t60so286927wes.31
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Aug 2013 01:57:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <521710A7.3050401@giantdisaster.de>
References: <1376307184-7175-1-git-send-email-idryomov@gmail.com>
	<1376307184-7175-3-git-send-email-idryomov@gmail.com>
	<521710A7.3050401@giantdisaster.de>
Date: Fri, 23 Aug 2013 11:57:24 +0300
Message-ID: <CAOi1vP95FxWXL=ZJCA-JAN_+M3JZn+08ehaBbuWfJHdhdVbOjQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] Btrfs: add btrfs_alloc_device and switch to it
From: Ilya Dryomov <idryomov@gmail.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 23, 2013 at 10:35 AM, Stefan Behrens
<sbehrens@giantdisaster.de> wrote:
> This WARN_ON(1) is triggered with the device replace procedure because
> BTRFS_DEV_REPLACE_DEVID is zero.

Ah, a dreaded 0 in C.  What a screw up.  This came from my rebuild
branch where btrfs_init_dev_replace_tgtdev is a bit different, and I
just auto-merged it.  I'll fix it up.

Thanks,

                Ilya
