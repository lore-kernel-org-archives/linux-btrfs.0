Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C342EC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 19:21:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DDB82075C
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 19:21:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="VH0u4+Di"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387882AbfC0TVs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Mar 2019 15:21:48 -0400
Received: from mail-lf1-f46.google.com ([209.85.167.46]:41984 "EHLO
        mail-lf1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732699AbfC0TVr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Mar 2019 15:21:47 -0400
Received: by mail-lf1-f46.google.com with SMTP id b7so7672811lfg.9
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2019 12:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MdEbf0u1aI8llKvr7UfSwBs1ZDHuzo+7RhTYQGHbx/E=;
        b=VH0u4+DifFA+aekbWrsuUVUG89T4+eHlQI+dWajnXAMVqOv3Ar9onUIVkXhwGceRXM
         OtWKoWMJeDUYw1mcuAm2kMI/8cB4uEBSWqXb10YT4uPqKSjNNkE6/uofkAnNz089hUh6
         qLoYlfoI/k4tL73FRBY0dumYzXalUSRGmXo3misO/TLuHrej6vMZq+wqN/6edpnWIys4
         znGP5vLf1X3yNAQiQ5482rdzeY4DYnQDJW4zzsFSkuUo2GpU2GUNkxJUoyJyrxiFR1Ql
         Q5z5P+vTTj/vCQTKsVXitGMbsaQe+y2gg1Tz3WiOZO1r2psUfIPNAboqoAPzo+ubEqTC
         Zsdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MdEbf0u1aI8llKvr7UfSwBs1ZDHuzo+7RhTYQGHbx/E=;
        b=TUWkwW9z7yNLgG+VcPYbH6BGHbTwP1QSfBn3viu0rz8VNPwm6+o3L3p8pBRLo4D8nV
         0TyPtUJ8FM3QpVu5Q3tOTgLz3m/sfN2L17BulqhS1SA9WbXu11qrb6CX2jo5gJDebmAr
         SHWOyuM9ZK+5wIKyHBAQvEI7MLItPCzGtcqb9STTLC4YsWo0GSNbJc0IwKDx8qkEJyf1
         xG0H3NhLjEyke89yB/HyyJrxMuWVzOnxLgddffWaBogFG+H8EYvOZD1yoNH2U40Uom9b
         tYystycRQWXTF3Aze8StRDAO8NU8x2aUDj4LBbQllWmdplyE0kh/P9YFuNN8nEV6cFsT
         uMrA==
X-Gm-Message-State: APjAAAX0h3oyunqMkv1Dw0z95HxMndINjKKcZLOXmVn3uGyjDWmrl47R
        gekOJFd6ofWPaAePKnmtSwfVJx6eGEuMexzEIvAHfuCzPso=
X-Google-Smtp-Source: APXvYqwWy94b2kQlJLG3MfwjuR4gprOQUS6MZV6QDujHf8/8aJC375hXO4q/NLWKPENGcTudMExhr8WGntpHZYHceKY=
X-Received: by 2002:a19:7d84:: with SMTP id y126mr19005113lfc.124.1553714504917;
 Wed, 27 Mar 2019 12:21:44 -0700 (PDT)
MIME-Version: 1.0
References: <ZYHmunh2bnI4vOU0LDX4lb1DXvOSPtcjyj7EAns2xBKGaQmIH0amXJKJjKuERK8ygPphnq5hOn4DyprjS9VNgd8ediqxsJOi9lLNYVYGnCA=@protonmail.com>
 <5b21fff4-0515-5577-0ab6-03f452469ef3@gmx.com> <CAA91j0VZkER8SV_TH=V75oHs5mST+D_k8TJ0gOJQsnaZfF4BJQ@mail.gmail.com>
 <CAJCQCtTqnqxvFJ3xwHiYFfWThqAL2apxqT=q0PJMv37UPCHGew@mail.gmail.com>
 <CAJCQCtTZ1iP6dxL+E0Q7Ssa_zEikqWVkZsqHO7H429E0yV67PA@mail.gmail.com>
 <DCcsgRDYyXTQg-tb_c9lhjSkEpt42ZH7R--Ln36pZpkNgAiQr54J8xLiGURKXVYv5fuQrAZA8xSD65ykmwyjCmPJYwAnAQFCU1uQWlZo6H4=@protonmail.com>
 <CAJCQCtREkeL3ANoYnar+viosPxzvKenPNAxSw10ov=R-pJNp3g@mail.gmail.com>
In-Reply-To: <CAJCQCtREkeL3ANoYnar+viosPxzvKenPNAxSw10ov=R-pJNp3g@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Wed, 27 Mar 2019 13:21:31 -0600
Message-ID: <CAJCQCtQouqH=CEF-EWmNTzrosnS9jwQSwv9Hx10dbmSeXwAdqA@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_backup_uuid=5Ftree_generation_not_consistent_acros?=
        =?UTF-8?Q?s_multi_device_=28raid0=29_btrfs_=2D_won=C2=B4t_mount?=
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Cc:     berodual_xyz <berodual_xyz@protonmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Removing Andrei and Qu.

On Wed, Mar 27, 2019 at 12:52 PM Chris Murphy <lists@colorremedies.com> wrote:
>
> And then also in the meantime, prepare for having to rebuild this array.

a. Check with the manufacturer of the hardware raid for firmware
updates for all the controllers. Also check if the new version is
backward compatible with an array made with the version you have, and
if not, if downgrade is possible. That way you have the option of
pulling the drives you have, putting them on a shelf, buying new
drives, and creating a new array with new hardware raid controller
firmware without having to blow away this broken Btrfs file system
just yet.

b. If you go with Btrfs again, I suggest using metadata raid1. It's
speculation whether that would help recovery in this failure case. But
it probably wouldn't have made it any worse, and wouldn't meaningfully
impact performance. For first mount after mkfs, use mount option
'space_cache=v2' to create the free space tree, it's soon to be the
default anyway, and for large file systems it offers improved
performance and the same reliability. If you don't care about
performance you could just always use `nospace_cache` mount option in
addition to `noatime,notreelog` and optionally a compression option
like `compress=zstd`. I would not use the nodatacow or nodatasum
options. If you're considering those mount options you should just
consider using ext4 or XFS at the next go around.

c. If it turns out the current Btrfs can be repaired, of course update
backups ASAP. But then I'd personally consider the file system still
suspect for anything other than short term use, and you'll want to
rebuild it from scratch eventually anyway, which lands you back at a.)
and b.) above. The most recent ext4 and XFS upstream work enables
metadata checksumming so you'd be in the same boat as you were with
Btrfs using nodatacow; there are still some older tools that create
those file systems without metadata checksumming, so I'd watch out for
that. And I'd say it's a coin toss which one to pick; I'm not really
sure off hand which one has a greater chance of surviving a hard reset
with inflight data.

d. Back to the hardware raid6 controller: you should make sure it's
really configured per manufacturer's expectations with respect to
drive write caching. Something got lost in the hard reset. Should the
individual drive write caches be disabled? Possible that the hardware
raid vendor expects this, if they're doing controller caching, and
they ensure the proper flushing to disk in the order expected by the
file system, where individual drive write caches can thwart that
ordering. If the controller has a write cache, is it battery backed?
If not, does the manufacturer recommend disabling write caching?
Something didn't work, and these are just some of the questions to try
and find out the optimal settings to avoid this happening in the
future, because even with a backup, restoring this much data is a
PITA.

-- 
Chris Murphy
