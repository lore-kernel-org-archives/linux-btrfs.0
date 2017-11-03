Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f179.google.com ([74.125.82.179]:48452 "EHLO
        mail-ot0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754284AbdKCWDp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Nov 2017 18:03:45 -0400
Received: by mail-ot0-f179.google.com with SMTP id f56so3863864otj.5
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Nov 2017 15:03:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b32358ec-781e-aff6-439b-3fc6fe02a25c@gmail.com>
References: <CAJyZh6S4f=6W+oA6DT1zu2FRuCgO7w8TfRzC96rPWNzUszvRmg@mail.gmail.com>
 <9871a669-141b-ac64-9da6-9050bcad7640@cn.fujitsu.com> <f6428a81-6fc8-1a73-0151-d13dd550c277@rqc.ru>
 <bb12a331-1fec-448a-cbf8-881b434766e7@cn.fujitsu.com> <CAJyZh6RxKuMukM-vCd=_u_8y38MJO_oUG1nYFpaxBroeK8xpAQ@mail.gmail.com>
 <CAH=dxU4OV6tQ0hCy_0Ug7eqkOM7HTUWTKjAr4qg+uO2gVxk2Jw@mail.gmail.com>
 <CAJCQCtS9BPZn-hnS+wP7Eu3oHQP_tS8EEM4j4FQDwRmzcFH+_A@mail.gmail.com>
 <10fb0b92-bc93-a217-0608-5284ac1a05cd@rqc.ru> <b32358ec-781e-aff6-439b-3fc6fe02a25c@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 3 Nov 2017 16:03:44 -0600
Message-ID: <CAJCQCtTT7_pfx5yn--We-kq0XWd38H_Lw1Prbmo5ytkTZWapYQ@mail.gmail.com>
Subject: Re: Problem with file system
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Marat Khalili <mkh@rqc.ru>, Chris Murphy <lists@colorremedies.com>,
        Dave <davestechshop@gmail.com>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>,
        Fred Van Andel <vanandel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 31, 2017 at 5:28 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:

> If you're running on an SSD (or thinly provisioned storage, or something
> else which supports discards) and have the 'discard' mount option enabled,
> then there is no backup metadata tree (this issue was mentioned on the list
> a while ago, but nobody ever replied),


This is a really good point. I've been running discard mount option
for some time now without problems, in a laptop with Samsung
Electronics Co Ltd NVMe SSD Controller SM951/PM951.

However, just trying btrfs-debug-tree -b on a specific block address
for any of the backup root trees listed in the super, only the current
one returns a valid result.  All others fail with checksum errors. And
even the good one fails with checksum errors within seconds as a new
tree is created, the super updated, and Btrfs considers the old root
tree disposable and subject to discard.

So absolutely if I were to have a problem, probably no rollback for
me. This seems to totally obviate a fundamental part of Btrfs design.


 because it's already been discarded.
> This is ideally something which should be addressed (we need some sort of
> discard queue for handling in-line discards), but it's not easy to address.

Discard data extents, don't discard metadata extents? Or put them on a
substantial delay.


-- 
Chris Murphy
