Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:34135 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbbJOFvR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Oct 2015 01:51:17 -0400
Received: by wicgb1 with SMTP id gb1so12309782wic.1
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2015 22:51:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20151015102502.5d0b4353@natsu>
References: <CA+LE0jzBX8kN1NmQ-+8zUpxrB79oMEmpmzUGABYfeA_tX47jBA@mail.gmail.com>
	<20151015102502.5d0b4353@natsu>
Date: Thu, 15 Oct 2015 07:51:15 +0200
Message-ID: <CA+LE0jwfoa5eQf4O-zrr2VX+cOJtrDxQEGD-1fWkoXxXhc0ndA@mail.gmail.com>
Subject: Re: BTRFS raid 5/6 status
From: audio muze <audiomuze@gmail.com>
To: Roman Mamedov <rm@romanrm.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks Roman, but I don't have the appetite to use mdadm and have the
array take forever to build or get yet another set of risks to
ultimately migrate from mdadm to btrfs when raid6 is stable.  It seems
to me that the simplest option at present is probably to use each disk
separately, formatted btrfs, and backed up to other drives.  The data
to be stored on these drives is largely static - video and audio
library.

On Thu, Oct 15, 2015 at 7:25 AM, Roman Mamedov <rm@romanrm.net> wrote:

> I would suggest going with Btrfs on top of mdadm RAID6, Btrfs still does have
> a number of "you what"-grade showstoppers in its native multi-device modes,
> but a single device mode Btrfs (on top of some other multi-device system such
> as Linux software RAID and/or LVM) in my experience works very well.
>
> --
> With respect,
> Roman
