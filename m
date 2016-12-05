Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:33140 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751083AbcLEDuL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Dec 2016 22:50:11 -0500
Received: by mail-pg0-f41.google.com with SMTP id 3so131655038pgd.0
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Dec 2016 19:49:11 -0800 (PST)
Received: from [172.27.27.99] (122-59-45-101.jetstream.xtra.co.nz. [122.59.45.101])
        by smtp.gmail.com with ESMTPSA id a24sm22997714pfh.57.2016.12.04.19.49.08
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Dec 2016 19:49:10 -0800 (PST)
From: Calle Kabo <calle.kabo@gmail.com>
Subject: Re: Re: btrfs repair and zero-log doesn't seem to do anything
To: linux-btrfs@vger.kernel.org
Message-ID: <6dbdc042-6b05-8270-e869-fcf95a99157d@gmail.com>
Date: Mon, 5 Dec 2016 16:49:05 +1300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> IMHO there will be 2 alternative method to recover:
>
> 1) Btrfs restore
>    The safest method to recover files.
>    Although it may need a lot of space to restore recovered data.
>
> 2) Btrfs check --init-extent-tree
>    This will use fs tree to try to rebuild the extent tree.
>    I don't believe it's only extent tree corrupted, so this may make
>    things even *worse*, but at least it won't take several TBs to
>    recover data which you may already have backup.

Thanks! I tested restoring a small directory and it worked beautifully.
Is there any way to list the files/directories? I don't think I can
remember all of the paths that were on there...

/Calle
