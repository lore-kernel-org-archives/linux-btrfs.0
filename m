Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:36753 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbcEWSea (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 May 2016 14:34:30 -0400
Received: by mail-wm0-f48.google.com with SMTP id n129so93199915wmn.1
        for <linux-btrfs@vger.kernel.org>; Mon, 23 May 2016 11:34:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <574306CC.3070906@prismatelecomtesting.com>
References: <574306CC.3070906@prismatelecomtesting.com>
Date: Mon, 23 May 2016 14:34:28 -0400
Message-ID: <CAD=QJKjyDc1Pct5PvAXtDLWea05BjRwL4r=pPuQ+hgfdxkpYSA@mail.gmail.com>
Subject: Re: btrfs filesystem usage - Wrong Unallocated indications - RAID10
From: Nicholas D Steeves <nsteeves@gmail.com>
To: Marco Lorenzo Crociani <marcoc@prismatelecomtesting.com>,
        Ivan Pilipenko <chrnosphered@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 23 May 2016 at 09:34, Marco Lorenzo Crociani
<marcoc@prismatelecomtesting.com> wrote:
> Hi,
> as I wrote today in IRCI experienced an issue with 'btrfs filesystem usage'.
> I have a 4 partitions RAID10 btrfs filesystem almost full.
> 'btrfs filesystem usage' reports wrong "Unallocated" indications.
>
> Linux 4.5.3
> btrfs-progs v4.5.3
>
>
> # btrfs fi usage /data/
>
> Overall:
>     Device size:                       13.93TiB
>     Device allocated:               13.77TiB
>     Device unallocated:         167.54GiB

I wonder if this is related to whatever caused the free space cache
bug for Ivan Pilipenko and myself (linux 4.4.10, btrfs-progs 4.4.1)?

Cheers,
Nicholas
