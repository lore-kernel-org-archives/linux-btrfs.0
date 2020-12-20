Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC621C4361B
	for <linux-btrfs@archiver.kernel.org>; Sun, 20 Dec 2020 09:23:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E94D22DFA
	for <linux-btrfs@archiver.kernel.org>; Sun, 20 Dec 2020 09:23:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgLTJXg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 20 Dec 2020 04:23:36 -0500
Received: from rin.romanrm.net ([51.158.148.128]:53650 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727001AbgLTJXf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 20 Dec 2020 04:23:35 -0500
Received: from natsu (unknown [IPv6:fd39::e99e:8f1b:cfc9:ccb8])
        by rin.romanrm.net (Postfix) with SMTP id 5478A7C2;
        Sun, 20 Dec 2020 09:22:52 +0000 (UTC)
Date:   Sun, 20 Dec 2020 14:22:52 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Ulli Horlacher <framstag@rus.uni-stuttgart.de>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: how to extend a btrfs disk image?
Message-ID: <20201220142252.01cf4140@natsu>
In-Reply-To: <20201219225945.GA3591@tik.uni-stuttgart.de>
References: <20201217123008.GA22831@tik.uni-stuttgart.de>
        <20201217191207.17243c40@natsu>
        <20201219225945.GA3591@tik.uni-stuttgart.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, 19 Dec 2020 23:59:45 +0100
Ulli Horlacher <framstag@rus.uni-stuttgart.de> wrote:

> Ok, I was able to extend the btrfs filesystem via a loopback devive.
> 
> What is the suggested way to do this at boot time?
> 
> For now I have in /etc/rc.local:
> 
> cd /nfs/rusnas/fex
> for d in spool_[1-9].btrfs; do
>   echo -n "$d ==> "
>   losetup -fP --show $d
> done
> sync
> sleep 2 # without this sleep the mount will fail!

You could try replacing the sleep with "btrfs device scan", certainly more
elegant (assuming it helps). Maybe even narrow it down to
"btrfs device scan /dev/loop*", or even scan each added device.

> mount -v spool_1.btrfs /mnt/spool

Better mount one of the loop devices, not the file, lest mount will probably
make one more, a dupe of one that your script has already added, and who knows
what side effects this could have.

> This works, but is there a more elegant way?
> Using /etc/fstab seems not to be possible?

There doesn't seem to be "/etc/looptab" or such, that would set these up on
boot. So your approach seems fine to me.

-- 
With respect,
Roman
