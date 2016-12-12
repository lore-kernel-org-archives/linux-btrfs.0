Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:38741 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751993AbcLLTr7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Dec 2016 14:47:59 -0500
Received: by mail-wm0-f51.google.com with SMTP id f82so85457018wmf.1
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Dec 2016 11:47:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtR+VTTj+fEVkWG4dBb-xykpuiHAwbERUknetFJA1toNAw@mail.gmail.com>
References: <CAKinxcV8tPF_y5HoU_DVy88rfHaGwzFrzQjSiQCcFM71H+a+Gw@mail.gmail.com>
 <CAJCQCtQ1az+PeyAw=7nTasajqNskttiF1LoTQ_UJEeLc_LhkNw@mail.gmail.com>
 <CAKinxcWE2RWdb2GG+cX7Sp1LHyx5LNKJ--EAqWVD2HTwpyJ7eQ@mail.gmail.com> <CAJCQCtR+VTTj+fEVkWG4dBb-xykpuiHAwbERUknetFJA1toNAw@mail.gmail.com>
From: Tomasz Kusmierz <tom.kusmierz@gmail.com>
Date: Mon, 12 Dec 2016 19:47:57 +0000
Message-ID: <CAKinxcWkA=h=-znhiChemtCXR_ZHG4-Fy=jGRGe621bRV-U+Sw@mail.gmail.com>
Subject: Re: How to get back a deleted sub-volume.
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris,

the "btrfs-show-super -fa" gives me nothing useful to work with.

the "btrfs-find-root -a <dev>" is actually something that I was
already using (see original post), but the list of roots given had a
rather LARGE hole of 200 generations that is located between right
after I've had everything removed and 1 month before the whole
situation.

On 12 December 2016 at 04:14, Chris Murphy <lists@colorremedies.com> wrote:
> Tomasz - try using 'btrfs-find-root -a <dev>' I totally forgot about
> this option. It goes through the extent tree and might have a chance
> of finding additional generations that aren't otherwise being found.
> You can then plug those tree roots into 'btrfs restore -t <bytenr>'
> and do it with the -D and -v options so it's a verbose dry run, and
> see if the file listing it spits out is at all useful - if it has any
> of the data you're looking for.
>
>
> Chris Murphy
