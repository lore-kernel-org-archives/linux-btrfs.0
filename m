Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f177.google.com ([209.85.161.177]:34331 "EHLO
        mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751327AbdC0TkO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Mar 2017 15:40:14 -0400
Received: by mail-yw0-f177.google.com with SMTP id p77so39168403ywg.1
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Mar 2017 12:40:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6e464739-5540-87ab-a46d-954a06086cba@gmail.com>
References: <4428fdc3-157a-a98e-8ca3-e3701c6c1c80@sichert.me>
 <279513f7-5297-cf2f-aa94-35bef1f674aa@cn.fujitsu.com> <2e816c46-7a6a-7db9-a2c3-663dc7d8e6c9@gmail.com>
 <8c55c034-27cc-e8b5-5317-b388cc6492f4@cn.fujitsu.com> <e57c6cc8-4943-a93a-f568-d3654d341b65@sichert.me>
 <6e464739-5540-87ab-a46d-954a06086cba@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 27 Mar 2017 13:32:47 -0600
Message-ID: <CAJCQCtRikr0CaYRj1rQid-UPukNm6NXem_8QD_e-VZYoZ3HPWA@mail.gmail.com>
Subject: Re: Qgroups are not applied when snapshotting a subvol?
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Moritz Sichert <moritz+linux@sichert.me>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Andrei Borzenkov <arvidjaar@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

How about if qgroups are enabled, then non-root user is prevented from
creating new subvolumes?

Or is there a way for a new nested subvolume to be included in its
parent's quota, rather than the new subvolume having a whole new quota
limit?

Tricky problem.


Chris Murphy
