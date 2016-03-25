Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:35930 "EHLO
	mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbcCYOQ0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Mar 2016 10:16:26 -0400
Received: by mail-lf0-f47.google.com with SMTP id d82so55861681lfe.3
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 07:16:25 -0700 (PDT)
MIME-Version: 1.0
From: Ivan P <chrnosphered@gmail.com>
Date: Fri, 25 Mar 2016 15:16:04 +0100
Message-ID: <CADzmB20WugZAaeOOBVKq6L+AuPr3Epr4WFG+LoQROaKj11r0Qg@mail.gmail.com>
Subject: scrub: Tree block spanning stripes, ignored
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

using kernel  4.4.5 and btrfs-progs 4.4.1, I today ran a scrub on my
2x1Tb btrfs raid1 array and it finished with 36 unrecoverable errors
[1], all blaming the treeblock 741942071296. Running "btrfs check
--readonly" on one of the devices lists that extent as corrupted [2].

How can I recover, how much did I really lose, and how can I prevent
it from happening again?
If you need me to provide more info, do tell.

[1] http://cwillu.com:8080/188.110.141.36/1
[2] http://pastebin.com/xA5zezqw

Regards,
Soukyuu

P.S.: please add me to CC when replying as I did not subscribe to the
mailing list. Majordomo won't let me use my hotmail address and I
don't want that much traffic on this address.
