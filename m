Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:34012 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbcF1AKV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 20:10:21 -0400
Received: by mail-oi0-f48.google.com with SMTP id s66so1187984oif.1
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jun 2016 17:10:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRoPcYQyHmkXT6yBQ31YTXLWeC+097=x0SVp+FeQ8M04w@mail.gmail.com>
References: <20160627233612.662d2a9a@system> <CAJCQCtT_vbOzbvMOuV6wgvz4iMHcpQmAhX-y1-dkOi6F323KRg@mail.gmail.com>
 <20160628002602.022258bf@system> <CAJCQCtR3FQ-Pe40dOcKGgd+8paraHuCoNCw5Kk+2G7bOOJF1rw@mail.gmail.com>
 <CAJCQCtRm3=7fkBcTA4o4r10cLqC-bzcsKunb5k+uA-siyZmMnQ@mail.gmail.com>
 <20160628010618.58e235fa@system> <CAJCQCtRoPcYQyHmkXT6yBQ31YTXLWeC+097=x0SVp+FeQ8M04w@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 27 Jun 2016 18:10:19 -0600
Message-ID: <CAJCQCtQgsnAGbGmHxuHbJHybr3r9uwE6RpxNjgkrnUyuqed8Kg@mail.gmail.com>
Subject: Re: Kernel bug during RAID1 replace
To: Chris Murphy <lists@colorremedies.com>
Cc: Saint Germain <saintger@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 27, 2016 at 6:00 PM, Chris Murphy <lists@colorremedies.com> wrote:

> There are two options since your drives support SCT ERC.
>
> 1.
> smartctl -l scterc,70,70 /dev/sdX  ## done for both drives
>
> That will make sure the drive reports a read error in 7 seconds, well
> under the kernel's command timer of 7 seconds.

correction: "well under the kernel's command timer default of 30 seconds"



-- 
Chris Murphy
