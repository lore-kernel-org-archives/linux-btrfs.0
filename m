Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from oc.oops.co.at ([85.90.244.114]:39014 "EHLO oc.oops.co.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751494AbdFGKGB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Jun 2017 06:06:01 -0400
Received: from localhost (localhost [127.0.0.1])
        by oc.oops.co.at (Postfix) with ESMTP id E363D89134
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Jun 2017 12:05:59 +0200 (CEST)
Received: from oc.oops.co.at ([127.0.0.1])
        by localhost (oc.oops.co.at [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id azVmtU5VScnl for <linux-btrfs@vger.kernel.org>;
        Wed,  7 Jun 2017 12:05:59 +0200 (CEST)
Received: from [172.32.99.12] (h062040171237.moe.cm.kabsi.at [62.40.171.237])
        by oc.oops.co.at (Postfix) with ESMTPSA id A26C189133
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Jun 2017 12:05:59 +0200 (CEST)
Subject: Re: getting rid of "csum failed" on a hw raid
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <5693147c-befc-da58-cb20-6af31e9aa9cb@xunil.at>
 <CAGqmi76XY0+sYZb3XaDs3rHKzZa=t2kzaGCE+uq_K4vz7PK5_A@mail.gmail.com>
From: "Stefan G. Weichinger" <lists@xunil.at>
Message-ID: <b8195f2f-adf8-4eb6-2d48-ac6bb5f182fd@xunil.at>
Date: Wed, 7 Jun 2017 12:05:59 +0200
MIME-Version: 1.0
In-Reply-To: <CAGqmi76XY0+sYZb3XaDs3rHKzZa=t2kzaGCE+uq_K4vz7PK5_A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 2017-06-07 um 11:37 schrieb Timofey Titovets:

> btrfs scrub start /mnt_path do this trick
> 
> After, you can find info with paths in dmesg

thank you, I think I have the file, it's a qemu-img-file.
I try cp-ing it to another fs first, but assume this will fail, right?



