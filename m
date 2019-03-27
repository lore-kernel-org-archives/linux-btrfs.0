Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 298D8C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 20:11:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89BE92087C
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 20:11:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="x7fzQtmN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729096AbfC0ULI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Mar 2019 16:11:08 -0400
Received: from mail-40133.protonmail.ch ([185.70.40.133]:62394 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727802AbfC0ULH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Mar 2019 16:11:07 -0400
Date:   Wed, 27 Mar 2019 20:10:55 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1553717463;
        bh=tnMg/kqknM8/JOBYgZhx0VAoncJL3WsM70MzgjoLi78=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:
         Feedback-ID:From;
        b=x7fzQtmNiYcmaJaCWHQoA3Y+xsis9rN8dbwygQMO29ApLBRaXvuy4Kx418CTE2iXO
         KHHVCHb4u+mVLOnkgv6MOeYfxr5Swu8I9k5sovbYlJDlPOeWR6jpY1R6wOJQK3qAJA
         FsX7Icv8zwHGOVWZyZPGtTdMBzPn0zlr5ObTdbiM=
To:     Chris Murphy <lists@colorremedies.com>
From:   berodual_xyz <berodual_xyz@protonmail.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Reply-To: berodual_xyz <berodual_xyz@protonmail.com>
Subject: =?UTF-8?Q?Re:_backup_uuid=5Ftree_generation_not_consistent_across_multi_d?=
 =?UTF-8?Q?evice_(raid0)_btrfs_-_won=C2=B4t_mount?=
Message-ID: <MIsWt9JcrTbL8FZ1KIkcPBO4t0v4IsOhCJJ11gU5RiqpawOAfiv25uyGduOp4DD9g47GPxwPwI51cUH-geOU72sAC7TnHLTeIovDltOYHs0=@protonmail.com>
In-Reply-To: <CAJCQCtQouqH=CEF-EWmNTzrosnS9jwQSwv9Hx10dbmSeXwAdqA@mail.gmail.com>
References: <ZYHmunh2bnI4vOU0LDX4lb1DXvOSPtcjyj7EAns2xBKGaQmIH0amXJKJjKuERK8ygPphnq5hOn4DyprjS9VNgd8ediqxsJOi9lLNYVYGnCA=@protonmail.com>
 <5b21fff4-0515-5577-0ab6-03f452469ef3@gmx.com>
 <CAA91j0VZkER8SV_TH=V75oHs5mST+D_k8TJ0gOJQsnaZfF4BJQ@mail.gmail.com>
 <CAJCQCtTqnqxvFJ3xwHiYFfWThqAL2apxqT=q0PJMv37UPCHGew@mail.gmail.com>
 <CAJCQCtTZ1iP6dxL+E0Q7Ssa_zEikqWVkZsqHO7H429E0yV67PA@mail.gmail.com>
 <DCcsgRDYyXTQg-tb_c9lhjSkEpt42ZH7R--Ln36pZpkNgAiQr54J8xLiGURKXVYv5fuQrAZA8xSD65ykmwyjCmPJYwAnAQFCU1uQWlZo6H4=@protonmail.com>
 <CAJCQCtREkeL3ANoYnar+viosPxzvKenPNAxSw10ov=R-pJNp3g@mail.gmail.com>
 <CAJCQCtQouqH=CEF-EWmNTzrosnS9jwQSwv9Hx10dbmSeXwAdqA@mail.gmail.com>
Feedback-ID: I1q2L7VvFsdXESkLE1a2aLBALpN2HWsXO5F205qEARYXtg94zW3HdiV9HI52kzHEEqfcUdbqlfVMVRPA6rJltg==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Thanks for the extensive answer, Chris!


> a. Check with the manufacturer of the hardware raid for firmware
> updates for all the controllers. Also check if the new version is
> backward compatible with an array made with the version you have, and
> if not, if downgrade is possible. That way you have the option of
> pulling the drives you have, putting them on a shelf, buying new
> drives, and creating a new array with new hardware raid controller
> firmware without having to blow away this broken Btrfs file system
> just yet.

Yes, this is what I am preparing to do and absolutely agree. The HW control=
lers are part of the issue, for sure. Analysing the logs shows that right a=
t the time where the system became unavailable from user point of view the =
following happened:

* HW bus reset by kernel module due to IO timeout towards the controller
* unresponsive scsi devices logged by kernel
* btrfs kernel module logging IO in flight being dropped

A few minutes (!) later, the hw controller dropped a disk from one of the a=
rrays and logged IO timeouts towards this (probably faulty) disk. The raid =
itself always stayed "consistent" but "degraded". There has still not been =
any issue with the array, also the rebuild went fine.

I have extensive experience with exactly this controller / disk / firmware =
/ kernel combo (on other filesystems) and unfortunately have to say that pa=
rt of the issue seems to be how BTRFS has (not?) handled the IO timeouts / =
drops from the lower layer.

Happy to provide insight into the timeline and messages of these events if =
of interest to anyone.

> b. If you go with Btrfs again, I suggest using metadata raid1. It's
> speculation whether that would help recovery in this failure case. But
> it probably wouldn't have made it any worse, and wouldn't meaningfully
> impact performance.

Point taken!

> For first mount after mkfs, use mount option
> 'space_cache=3Dv2' to create the free space tree, it's soon to be the
> default anyway, and for large file systems it offers improved
> performance and the same reliability.

The system was already on v2.

> If you don't care about
> performance you could just always use `nospace_cache` mount option in
> addition to `noatime,notreelog` and optionally a compression option
> like `compress=3Dzstd`. I would not use the nodatacow or nodatasum
> options. If you're considering those mount options you should just
> consider using ext4 or XFS at the next go around.

Reason for these mount options was to prevent fragmentation of large files =
(due to COW) and nodatasum due to (supposed to exist) stability issues with=
 the checksumming. Advantage of BTRFS over XFS for me was multi-device capa=
bility (without LVM), snapshots and directory (subvolume) based quota.

>
> c. If it turns out the current Btrfs can be repaired, of course update
> backups ASAP. But then I'd personally consider the file system still
> suspect for anything other than short term use, and you'll want to
> rebuild it from scratch eventually anyway, which lands you back at a.)
> and b.) above.

Yes, the FS will in any case only be used to recover and then be rebuild. N=
ot sure if on BTRFS to be honest.
But then, I know people who have lost data due to XFS not handling power fa=
ilures or lower-layer HW issues well. So maybe it is just what it is and an=
 up2date backup is required in any case (what if a user deletes everything =
accidentally...the best FS wont safe you from this).


> The most recent ext4 and XFS upstream work enables
> metadata checksumming so you'd be in the same boat as you were with
> Btrfs using nodatacow; there are still some older tools that create
> those file systems without metadata checksumming, so I'd watch out for
> that. And I'd say it's a coin toss which one to pick; I'm not really
> sure off hand which one has a greater chance of surviving a hard reset
> with inflight data.

True.

> d. Back to the hardware raid6 controller: you should make sure it's
> really configured per manufacturer's expectations with respect to
> drive write caching. Something got lost in the hard reset. Should the
> individual drive write caches be disabled? Possible that the hardware
> raid vendor expects this, if they're doing controller caching, and
> they ensure the proper flushing to disk in the order expected by the
> file system, where individual drive write caches can thwart that
> ordering.

As per above, it is now clear that the issue was in fact triggered when the=
 controller timed out and in-flight data "had to" be dropped by upper layer=
s.

> If the controller has a write cache, is it battery backed?

Yes!


> If not, does the manufacturer recommend disabling write caching?
> Something didn't work, and these are just some of the questions to try
> and find out the optimal settings to avoid this happening in the
> future, because even with a backup, restoring this much data is a
> PITA.


Thank you very much again for taking the time to reply. I really appreciate=
 it!

Kind regards,

Marcel

> -------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
-----------------------
>
> Chris Murphy


