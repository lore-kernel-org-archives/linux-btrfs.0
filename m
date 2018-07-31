Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.mailbox.org ([80.241.60.215]:17636 "EHLO mx2.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732194AbeGaPaM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Jul 2018 11:30:12 -0400
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, lxc-devel@lists.linuxcontainers.org
From: Thomas Leister <thomas.leister@mailbox.org>
Subject: Report correct filesystem usage / limits on BTRFS subvolumes with
 quota
Message-ID: <0059606f-88bf-c919-450b-bf08e184b5a2@mailbox.org>
Date: Tue, 31 Jul 2018 15:49:42 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear David,
hello everyone,

during a recent project of mine involving LXD and BTRFS I found out that
quotas on BTRFS subvolumes are enforced, but file system usage and
limits set via quotas are not reported correctly in LXC containers.

I've found this discussion regarding my problem:
https://github.com/lxc/lxd/issues/2180

There was already a proposal to introduce subvolume quota support some
time ago:
https://marc.info/?l=linux-btrfs&m=147576434114415&w=2

@David as I've seen your response on that topic on the mailing list,
maybe you can tell me if there are any plans to support correct
subvolume quota reporting e.g. for "df -h" calls from within a
container? Maybe there's already something on your / SUSE's roadmap? :-)

As more and more container environments spin up these days, there might
be a growing demand on that :-) Personally I'd really appreciate if I
could read the current file system usage and limit from within a
container using BTRFS as storage backend.

Best regards,
Thomas


