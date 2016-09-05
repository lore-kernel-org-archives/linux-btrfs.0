Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zaphod.cobb.me.uk ([213.138.97.131]:58902 "EHLO
        zaphod.cobb.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933253AbcIEJ7d (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Sep 2016 05:59:33 -0400
Received: from black.home.cobb.me.uk (unknown [192.168.0.205])
        by zaphod.cobb.me.uk (Postfix) with ESMTP id 9A0499B96E
        for <linux-btrfs@vger.kernel.org>; Mon,  5 Sep 2016 10:59:30 +0100 (BST)
Received: from [192.168.0.211] (novatech.home.cobb.me.uk [192.168.0.211])
        by black.home.cobb.me.uk (Postfix) with ESMTPS id 4B8D35FB5B
        for <linux-btrfs@vger.kernel.org>; Mon,  5 Sep 2016 10:59:30 +0100 (BST)
To: linux-btrfs@vger.kernel.org
From: Graham Cobb <g.btrfs@cobb.uk.net>
Subject: Security implications of btrfs receive?
Message-ID: <c04c596d-4cb9-ed98-513a-c550b1be18b2@cobb.uk.net>
Date: Mon, 5 Sep 2016 10:59:30 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Does anyone know of a security analysis of btrfs receive?

I assume that just using btrfs receive requires root (is that so?).  But
I was thinking of setting up a backup server which would receive
snapshots from various client systems, each in their own path, and I
wondered how much the security of the backup server (and other clients'
backups) was dependent on the security of the client.

Does the "path" argument of btrfs-receive mean that *all* operations are
confined to that path?  For example, if a UUID or transid is sent which
refers to an entity outside the path will that other entity be affected
or used? Is it possible for a file to be created containing shared
extents from outside the path? Is it possible to confuse/affect
filesystem metadata which would affect the integrity of subvolumes or
files outside the path or prevent other clients from doing something
legitimate?

Do the answers change if the --chroot option is given?  I am confused
about the -m option -- does that mean that the root mount point has to
be visible in the chroot?

Lastly, even if receive is designed to be very secure, it is possible
that it could trigger/use code paths in the btrfs kernel code which are
not normally used during normal file operations and so could trigger
bugs not normally seen.  Has any work been done on testing for that (for
example tests using malicious streams, including ones which btrfs-send
cannot generate)?

I am just wondering whether any work has been done/published on this area.

Regards
Graham
