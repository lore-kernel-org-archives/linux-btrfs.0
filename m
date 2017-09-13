Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:45703 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751019AbdIMNXi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Sep 2017 09:23:38 -0400
Received: by mail-oi0-f53.google.com with SMTP id z73so1272524oia.2
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Sep 2017 06:23:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2ee9f15b-a11a-886e-2460-557bb9f8d41d@rqc.ru>
References: <2ee9f15b-a11a-886e-2460-557bb9f8d41d@rqc.ru>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 13 Sep 2017 15:23:37 +0200
Message-ID: <CAJCQCtTEJXvTS=YzUrwYvg7KCisgwLVYqu_Jb9-95sYswAspXg@mail.gmail.com>
Subject: Re: qemu-kvm VM died during partial raid1 problems of btrfs
To: Marat Khalili <mkh@rqc.ru>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 12, 2017 at 10:02 AM, Marat Khalili <mkh@rqc.ru> wrote:

> (3) it is possible that it uses O_DIRECT or something, and btrfs raid1 does
> not fully protect this kind of access.

Right, known problem. To use o_direct implies also using nodatacow (or
at least nodatasum), e.g. xattr +C is set, done by qemu-img -o
nocow=on
https://www.spinics.net/lists/linux-btrfs/msg68244.html


-- 
Chris Murphy
