Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from oc.oops.co.at ([85.90.244.114]:38508 "EHLO oc.oops.co.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751207AbdFGI4S (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Jun 2017 04:56:18 -0400
Received: from localhost (localhost [127.0.0.1])
        by oc.oops.co.at (Postfix) with ESMTP id C232489134
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Jun 2017 10:48:03 +0200 (CEST)
Received: from oc.oops.co.at ([127.0.0.1])
        by localhost (oc.oops.co.at [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id Xa-HnrGW76k4 for <linux-btrfs@vger.kernel.org>;
        Wed,  7 Jun 2017 10:48:03 +0200 (CEST)
Received: from [172.32.99.12] (h062040171237.moe.cm.kabsi.at [62.40.171.237])
        by oc.oops.co.at (Postfix) with ESMTPSA id 41CCC89133
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Jun 2017 10:48:03 +0200 (CEST)
To: linux-btrfs@vger.kernel.org
From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: getting rid of "csum failed" on a hw raid
Message-ID: <5693147c-befc-da58-cb20-6af31e9aa9cb@xunil.at>
Date: Wed, 7 Jun 2017 10:48:02 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


greets

I have a customer server that was set up with a hardware raid and on top
of that /dev/sda exists a btrfs filesystem.

Yes, I know, that is stupid (can't change that easily).

In dmesg I get flooding:

[2329426.792480] BTRFS warning (device sda): csum failed ino 7454384 off
81708052480 csum 3746940842 expected csum 3305376500
[2329427.844757] BTRFS warning (device sda): csum failed ino 7454384 off
81708052480 csum 3746940842 expected csum 3305376500
[2329428.929354] BTRFS warning (device sda): csum failed ino 7454384 off
81708052480 csum 3746940842 expected csum 3305376500

...

I googled how to spot the file containing that problematic block(?):

find / -type f -exec cp {} /dev/null \;

I have that running within tmux now, are there any other ways to find
that file and somehow fix it?

That btrfs contains the root-fs of the server ... so I would maybe have
to driver there, boot from stick or so and btrfsck the unmounted fs?

thanks, Stefan
