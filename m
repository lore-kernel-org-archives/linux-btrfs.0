Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:35853 "EHLO
        mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750816AbdC1EFM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Mar 2017 00:05:12 -0400
Received: by mail-lf0-f46.google.com with SMTP id x137so31559163lff.3
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Mar 2017 21:05:11 -0700 (PDT)
Subject: Re: Qgroups are not applied when snapshotting a subvol?
To: Chris Murphy <lists@colorremedies.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
References: <4428fdc3-157a-a98e-8ca3-e3701c6c1c80@sichert.me>
 <279513f7-5297-cf2f-aa94-35bef1f674aa@cn.fujitsu.com>
 <2e816c46-7a6a-7db9-a2c3-663dc7d8e6c9@gmail.com>
 <8c55c034-27cc-e8b5-5317-b388cc6492f4@cn.fujitsu.com>
 <e57c6cc8-4943-a93a-f568-d3654d341b65@sichert.me>
 <6e464739-5540-87ab-a46d-954a06086cba@gmail.com>
 <CAJCQCtRikr0CaYRj1rQid-UPukNm6NXem_8QD_e-VZYoZ3HPWA@mail.gmail.com>
Cc: Moritz Sichert <moritz+linux@sichert.me>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <6946290d-1b60-a84b-b53d-88b703fb83b9@gmail.com>
Date: Tue, 28 Mar 2017 06:56:47 +0300
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRikr0CaYRj1rQid-UPukNm6NXem_8QD_e-VZYoZ3HPWA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

27.03.2017 22:32, Chris Murphy пишет:
> How about if qgroups are enabled, then non-root user is prevented from
> creating new subvolumes?
> 
> Or is there a way for a new nested subvolume to be included in its
> parent's quota, rather than the new subvolume having a whole new quota
> limit?
> 

They are not even nested in any sense.

btrfs sub create /some/parent/A /other/parent/B

There is no direct relation between A and B except that B is clone of A
(but I do not know whether this fact is recorded somewhere in subvolume
properties).
