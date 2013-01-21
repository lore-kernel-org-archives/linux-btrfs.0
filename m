Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:40906 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab3AUHw0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Jan 2013 02:52:26 -0500
Received: by mail-ea0-f181.google.com with SMTP id i13so1416855eaa.40
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Jan 2013 23:52:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130121015157.GA10650@liubo.jp.oracle.com>
References: <CAEm3SNAW-oGtPQ5Fjf4P0qEeMU29MA8frnNekGfSQ3rWCLSvsw@mail.gmail.com>
	<20130121015157.GA10650@liubo.jp.oracle.com>
Date: Sun, 20 Jan 2013 23:52:23 -0800
Message-ID: <CAEm3SNBs-ym26TwqwWa7NjOsXsm9zii891m0z-gfZiVc5e+o2A@mail.gmail.com>
Subject: Re: A couple bugs with btrfs and 3.5.0 kernel
From: Elladan <elladan@eskimo.com>
To: bo.li.liu@oracle.com
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 20, 2013 at 5:51 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> On Sun, Jan 20, 2013 at 05:39:57PM -0800, Elladan wrote:
>> Any ideas?  I guess I could try to mount in degraded mode or try a 3.6
>> kernel or something, but this all seems like I should probably just
>> restore from backups and move on.
>
> Hi Elladan,
>
> For 'bio too big' issue, this patch is helpful,
>
> https://patchwork.kernel.org/patch/1619691/
>
> thanks,
> liubo

Hi,

After poking around, I determined that the 3.8 kernel is the first one
with this patch.  I installed it, and re-ran btrfs device delete.  The
delete ran to completion successfully.

However, "btrfs fi show" still indicated that the deleted device was
part of the filesystem.  I don't know if that was a bug in my older
btrfs binary or not.  It mounts fine without the deleted device.

Thanks!
