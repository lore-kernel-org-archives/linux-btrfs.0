Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay1.allsecuredomains.com ([78.47.251.4]:33124 "EHLO
        relay1.allsecuredomains.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753655AbcJFOcO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Oct 2016 10:32:14 -0400
Received: from [81.174.144.187] (helo=zebedee.buttersideup.com)
        by relay1.allsecuredomains.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <tim@seoss.co.uk>)
        id 1bs95b-0007Si-44
        for linux-btrfs@vger.kernel.org; Thu, 06 Oct 2016 15:51:59 +0200
Received: from [172.19.198.5] (rosalie.lan [172.19.198.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by zebedee.buttersideup.com (Postfix) with ESMTPSA id 95E85A3166
        for <linux-btrfs@vger.kernel.org>; Thu,  6 Oct 2016 14:51:58 +0100 (BST)
To: linux-btrfs@vger.kernel.org
From: Tim Small <tim@seoss.co.uk>
Subject: Making statfs return qgroup info (for container use case etc.)
Message-ID: <32dfef18-ca3b-6c29-252a-4fc9e36b373a@seoss.co.uk>
Date: Thu, 6 Oct 2016 14:51:58 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I use btrfs for containers (e.g. full OS style containers using lxc/lxd
etc. rather than application containers).  btrfs de-duplication and
send/receive are very useful features for this use-case.

Each container runs in its own subvolume, and I use quotas to stop one
container exhausting the disk space of the others.

df shows the total space + free space for the entire filesystem - which
is confusing for users within the containers.  Worse - they don't have
any way of knowing how much quota they actually have left (other than du
-xs / vs. whatever I've told them).

It'd be really nice if running e.g. statfs("/home", ...) within a
container could be made to return the qgroup usage + limit for the path
(e.g. by passing in an option at mount time - such as qgroup level
maybe?) , instead of the global filesystem data in f_bfree f_blocks etc.

A useful tweak might be to only return the qgroup info within non-root
user namespaces, or perhaps just if the root UID != 0 (since the normal
use case for this is unprivileged containers), but I've no idea how
viable that idea is.

Yet another idea - (since btrfs always returns 0 for f_files - used for
inodes by other FS), then perhaps having the option of returning quota
information there would be useful (or maybe return quota referenced size
info in f_blocks and f_bfree, and exclusive size info in f_files and
f_free)?

Googling shows that this question has come up briefly on the #btrfs IRC
channel in the past.

Does sound like something that could be added to btrfs?

What I need to do currently only works with zfs, but I don't really want
to go there if I can avoid it...

ref:  search for btrfs in this web page:

https://www.stgraber.org/2016/03/26/lxd-2-0-resource-control-412/

... the shown working example is on zfs...

Tim.
