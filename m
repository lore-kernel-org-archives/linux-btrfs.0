Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:11018 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751101AbdHXBUz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 21:20:55 -0400
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
        by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id E1801AC00BA
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Aug 2017 10:09:33 +0900 (JST)
Subject: Re: status of inline deduplication in btrfs
To: shally verma <shallyvermacavium@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAP9W88g3Pr=JYqj=QOKpeP=6uKaQkXsx9xegefeJsZ+wApiZ9g@mail.gmail.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Message-ID: <7e12fa55-d01a-6c02-f798-2b63cf3b4a6d@jp.fujitsu.com>
Date: Thu, 24 Aug 2017 10:09:16 +0900
MIME-Version: 1.0
In-Reply-To: <CAP9W88g3Pr=JYqj=QOKpeP=6uKaQkXsx9xegefeJsZ+wApiZ9g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017/08/23 23:52, shally verma wrote:
> HI
> 
> Through btrfs wiki, I got to know about inline patch and this git
> location https://github.com/adam900710/linux but I am not sure what's
> progress and status on this. Could any one please confirm what is the
> status of inline  deduplication into btrfs and if it is the correct
> location to see its support?

Lu Fengqi has posted the latest patchset (v14.4).
https://marc.info/?l=linux-btrfs&m=149984943031184&w=2

Unfortunately, it has not been committed yet.

Thanks,
Tsutomu

> 
> Thanks
> Shally
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


