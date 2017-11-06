Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:53287 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753652AbdKFSpJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Nov 2017 13:45:09 -0500
Received: by mail-oi0-f49.google.com with SMTP id h6so8265779oia.10
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Nov 2017 10:45:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <6833d956-05c6-ee7b-ba80-b0a29c2772c6@gmail.com>
References: <CAJyZh6S4f=6W+oA6DT1zu2FRuCgO7w8TfRzC96rPWNzUszvRmg@mail.gmail.com>
 <9871a669-141b-ac64-9da6-9050bcad7640@cn.fujitsu.com> <f6428a81-6fc8-1a73-0151-d13dd550c277@rqc.ru>
 <bb12a331-1fec-448a-cbf8-881b434766e7@cn.fujitsu.com> <CAJyZh6RxKuMukM-vCd=_u_8y38MJO_oUG1nYFpaxBroeK8xpAQ@mail.gmail.com>
 <CAH=dxU4OV6tQ0hCy_0Ug7eqkOM7HTUWTKjAr4qg+uO2gVxk2Jw@mail.gmail.com>
 <CAJCQCtS9BPZn-hnS+wP7Eu3oHQP_tS8EEM4j4FQDwRmzcFH+_A@mail.gmail.com>
 <10fb0b92-bc93-a217-0608-5284ac1a05cd@rqc.ru> <b32358ec-781e-aff6-439b-3fc6fe02a25c@gmail.com>
 <CAJCQCtTT7_pfx5yn--We-kq0XWd38H_Lw1Prbmo5ytkTZWapYQ@mail.gmail.com>
 <20171104044634.thg7mnchm4hvzdic@angband.pl> <CAJCQCtReVi8k+OoitBBUZm_T+mj9dkV6GCVs7JMSG1myR78AGw@mail.gmail.com>
 <6833d956-05c6-ee7b-ba80-b0a29c2772c6@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 6 Nov 2017 11:45:08 -0700
Message-ID: <CAJCQCtS80P2Fa80162xMdYO3+JfkqX9YX75i+H8gLUkteVvYAQ@mail.gmail.com>
Subject: Re: Problem with file system
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Adam Borowski <kilobyte@angband.pl>, Marat Khalili <mkh@rqc.ru>,
        Dave <davestechshop@gmail.com>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>,
        Fred Van Andel <vanandel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 6, 2017 at 6:29 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:

>
> With ATA devices (including SATA), except on newer SSD's, TRIM commands
> can't be queued,

SATA spec 3.1 includes queued trim. There are SATA spec 3.1 products
on the market claiming to do queued trim. Some of them fuck up, and
have been black listed in the kernel for queued trim.








>>
>>
>> Anyway right now I consider discard mount option fundamentally broken
>> on Btrfs for SSDs. I haven't tested this on LVM thinp, maybe it's
>> broken there too.
>
> For LVM thinp, discard there deallocates the blocks, and unallocated regions
> read back as zeroes, just like in a sparse file (in fact, if you just think
> of LVM thinp as a sparse file with reflinking for snapshots, you get
> remarkably close to how it's actually implemented from a semantic
> perspective), so it is broken there.  In fact, it's guaranteed broken on any
> block device that has the discard_zeroes_data flag set, and theoretically
> broken on many things that don't have that flag (although block devices that
> don't have that flag are inherently broken from a security perspective
> anyway, but that's orthogonal to this discussion).

So this is really only solvable by having Btrfs delay, possibly
substantially, the discarding of metadata blocks. Aside from physical
device trim, there are benefits in thin provisioning for trim and some
use cases will require file system discard, being unable to rely on
periodic fstrim.



-- 
Chris Murphy
