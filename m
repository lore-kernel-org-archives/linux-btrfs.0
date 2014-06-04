Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:53227 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbaFDW1e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jun 2014 18:27:34 -0400
Received: by mail-pd0-f178.google.com with SMTP id v10so134656pde.23
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Jun 2014 15:27:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEezp7uMXA3t8-GDVcVzx9An+hPBZmynYZ-wUXzhJuP93czs1w@mail.gmail.com>
References: <CAEezp7uMXA3t8-GDVcVzx9An+hPBZmynYZ-wUXzhJuP93czs1w@mail.gmail.com>
Date: Thu, 5 Jun 2014 05:27:33 +0700
Message-ID: <CAG1y0sfrmSD31iKfqyR9jMJSBNvs=dihiHtd8nMwiawkhykUQw@mail.gmail.com>
Subject: Re: Very slow filesystem
From: "Fajar A. Nugraha" <list@fajar.net>
To: Igor M <igork20@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 5, 2014 at 5:15 AM, Igor M <igork20@gmail.com> wrote:
> Hello,
>
> Why btrfs becames EXTREMELY slow after some time (months) of usage ?

> # btrfs fi show
> Label: none  uuid: b367812a-b91a-4fb2-a839-a3a153312eba
>         Total devices 1 FS bytes used 2.36TiB
>         devid    1 size 2.73TiB used 2.38TiB path /dev/sde

> # btrfs fi df /mnt/old
> Data, single: total=2.36TiB, used=2.35TiB

Is that the fs that is slow?

It's almost full. Most filesystems would exhibit really bad
performance when close to full due to fragmentation issue (threshold
vary, but 80-90% full usually means you need to start adding space).
You should free up some space (e.g. add a new disk so it becomes
multi-device, or delete some files) and rebalance/defrag.

-- 
Fajar
