Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f176.google.com ([74.125.82.176]:42091 "EHLO
        mail-ot0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751283AbeBVXuv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Feb 2018 18:50:51 -0500
Received: by mail-ot0-f176.google.com with SMTP id a7so6265845otk.9
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Feb 2018 15:50:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ef59f4ee-f54d-81ea-c218-1dd4378e1ceb@web.de>
References: <ef59f4ee-f54d-81ea-c218-1dd4378e1ceb@web.de>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 22 Feb 2018 16:50:50 -0700
Message-ID: <CAJCQCtT_5+NiULdJh_7qMff6U=VQGsj-bBS-Fg5W7v=dGbWs5Q@mail.gmail.com>
Subject: Re: lots of data written, but no space occupied
To: =?UTF-8?Q?Andr=C3=A9_Weidemann?= <Andre.Weidemann@web.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The only thing I can think of is something's updating metadata due to
relatime mount option. Maybe try noatime? At 9GiB, really it's 4.5GiB
because whatever is being written is being doubled by raid1 profile
and multiple devices. There is a case of wandering trees where a
little bit of change can get amplified, but this requires an
instigator, the file system won't do it on its own.

What were the mkfs options? Are you using the default 16KiB nodesize?


---
Chris Murphy
