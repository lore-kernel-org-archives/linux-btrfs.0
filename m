Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:52778 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751266AbdKDEql (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Nov 2017 00:46:41 -0400
Date: Sat, 4 Nov 2017 05:46:34 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: Chris Murphy <lists@colorremedies.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, Marat Khalili <mkh@rqc.ru>,
        Dave <davestechshop@gmail.com>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>,
        Fred Van Andel <vanandel@gmail.com>
Subject: Re: Problem with file system
Message-ID: <20171104044634.thg7mnchm4hvzdic@angband.pl>
References: <CAJyZh6S4f=6W+oA6DT1zu2FRuCgO7w8TfRzC96rPWNzUszvRmg@mail.gmail.com>
 <9871a669-141b-ac64-9da6-9050bcad7640@cn.fujitsu.com>
 <f6428a81-6fc8-1a73-0151-d13dd550c277@rqc.ru>
 <bb12a331-1fec-448a-cbf8-881b434766e7@cn.fujitsu.com>
 <CAJyZh6RxKuMukM-vCd=_u_8y38MJO_oUG1nYFpaxBroeK8xpAQ@mail.gmail.com>
 <CAH=dxU4OV6tQ0hCy_0Ug7eqkOM7HTUWTKjAr4qg+uO2gVxk2Jw@mail.gmail.com>
 <CAJCQCtS9BPZn-hnS+wP7Eu3oHQP_tS8EEM4j4FQDwRmzcFH+_A@mail.gmail.com>
 <10fb0b92-bc93-a217-0608-5284ac1a05cd@rqc.ru>
 <b32358ec-781e-aff6-439b-3fc6fe02a25c@gmail.com>
 <CAJCQCtTT7_pfx5yn--We-kq0XWd38H_Lw1Prbmo5ytkTZWapYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAJCQCtTT7_pfx5yn--We-kq0XWd38H_Lw1Prbmo5ytkTZWapYQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 03, 2017 at 04:03:44PM -0600, Chris Murphy wrote:
> On Tue, Oct 31, 2017 at 5:28 AM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
> 
> > If you're running on an SSD (or thinly provisioned storage, or something
> > else which supports discards) and have the 'discard' mount option enabled,
> > then there is no backup metadata tree (this issue was mentioned on the list
> > a while ago, but nobody ever replied),
> 
> 
> This is a really good point. I've been running discard mount option
> for some time now without problems, in a laptop with Samsung
> Electronics Co Ltd NVMe SSD Controller SM951/PM951.
> 
> However, just trying btrfs-debug-tree -b on a specific block address
> for any of the backup root trees listed in the super, only the current
> one returns a valid result.  All others fail with checksum errors. And
> even the good one fails with checksum errors within seconds as a new
> tree is created, the super updated, and Btrfs considers the old root
> tree disposable and subject to discard.
> 
> So absolutely if I were to have a problem, probably no rollback for
> me. This seems to totally obviate a fundamental part of Btrfs design.

How is this an issue?  Discard is issued only once we're positive there's no
reference to the freed blocks anywhere.  At that point, they're also open
for reuse, thus they can be arbitrarily scribbled upon.

Unless your hardware is seriously broken (such as lying about barriers,
which is nearly-guaranteed data loss on btrfs anyway), there's no way the
filesystem will ever reference such blocks.  The corpses of old trees that
are left lying around with no discard can at most be used for manual
forensics, but whether a given block will have been overwritten or not is
a matter of pure luck.

For rollbacks, there are snapshots.  Once a transaction has been fully
committed, the old version is considered gone.

>  because it's already been discarded.
> > This is ideally something which should be addressed (we need some sort of
> > discard queue for handling in-line discards), but it's not easy to address.
> 
> Discard data extents, don't discard metadata extents? Or put them on a
> substantial delay.

Why would you special-case metadata?  Metadata that points to overwritten or
discarded blocks is of no use either.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ Laws we want back: Poland, Dz.U. 1921 nr.30 poz.177 (also Dz.U. 
⣾⠁⢰⠒⠀⣿⡁ 1920 nr.11 poz.61): Art.2: An official, guilty of accepting a gift
⢿⡄⠘⠷⠚⠋⠀ or another material benefit, or a promise thereof, [in matters
⠈⠳⣄⠀⠀⠀⠀ relevant to duties], shall be punished by death by shooting.
