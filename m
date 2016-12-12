Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f180.google.com ([209.85.161.180]:34165 "EHLO
        mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751677AbcLLEO5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Dec 2016 23:14:57 -0500
Received: by mail-yw0-f180.google.com with SMTP id t125so56135032ywc.1
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Dec 2016 20:14:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKinxcWE2RWdb2GG+cX7Sp1LHyx5LNKJ--EAqWVD2HTwpyJ7eQ@mail.gmail.com>
References: <CAKinxcV8tPF_y5HoU_DVy88rfHaGwzFrzQjSiQCcFM71H+a+Gw@mail.gmail.com>
 <CAJCQCtQ1az+PeyAw=7nTasajqNskttiF1LoTQ_UJEeLc_LhkNw@mail.gmail.com> <CAKinxcWE2RWdb2GG+cX7Sp1LHyx5LNKJ--EAqWVD2HTwpyJ7eQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 11 Dec 2016 21:14:56 -0700
Message-ID: <CAJCQCtR+VTTj+fEVkWG4dBb-xykpuiHAwbERUknetFJA1toNAw@mail.gmail.com>
Subject: Re: How to get back a deleted sub-volume.
To: Tomasz Kusmierz <tom.kusmierz@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz - try using 'btrfs-find-root -a <dev>' I totally forgot about
this option. It goes through the extent tree and might have a chance
of finding additional generations that aren't otherwise being found.
You can then plug those tree roots into 'btrfs restore -t <bytenr>'
and do it with the -D and -v options so it's a verbose dry run, and
see if the file listing it spits out is at all useful - if it has any
of the data you're looking for.


Chris Murphy
