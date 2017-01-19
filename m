Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:37304 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753863AbdASQlC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jan 2017 11:41:02 -0500
Received: by mail-wm0-f53.google.com with SMTP id c206so1612119wme.0
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jan 2017 08:40:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACNDjuzntG5Saq5HHNeDUmq-=28riKAerkO=CD=zAW-QofbKSg@mail.gmail.com>
References: <CACNDjuzntG5Saq5HHNeDUmq-=28riKAerkO=CD=zAW-QofbKSg@mail.gmail.com>
From: "Alejandro R. Mosteo" <alejandro@mosteo.com>
Date: Thu, 19 Jan 2017 17:39:37 +0100
Message-ID: <CACNDjuw3GqkCggUqim==Y+xj=bnL93wwdx26denvQaD4tFf7yw@mail.gmail.com>
Subject: Fwd: dup vs raid1 in single disk
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello list,

I was wondering, from a point of view of data safety, if there is any
difference between using dup or making a raid1 from two partitions in
the same disk. This is thinking on having some protection against the
typical aging HDD that starts to have bad sectors.

On a related note, I see this caveat about dup in the manpage:

"For example, a SSD drive can remap the blocks internally to a single
copy thus deduplicating them. This negates the purpose of increased
redunancy (sic) and just wastes space"

SSDs failure modes are different (more an all or nothing thing, I'm
told) so it wouldn't apply to the use case above, but I'm curious for
curiosity's sake if there would be any difference too.

Thanks,
Alex.
