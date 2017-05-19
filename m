Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42109 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755355AbdESPRV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 May 2017 11:17:21 -0400
Message-Id: <1495207039.1914347.982172864.5F2F81AA@webmail.messagingengine.com>
From: Colin Walters <walters@verbum.org>
To: Anand Jain <anand.jain@oracle.com>, linux-fsdevel@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com, quwenruo@cn.fujitsu.com
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
References: <20170518100804.25538-1-anand.jain@oracle.com>
Subject: Re: [PATCH RFC] vfs: add mount umount logs
Date: Fri, 19 May 2017 11:17:19 -0400
In-Reply-To: <20170518100804.25538-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 18, 2017, at 06:08 AM, Anand Jain wrote:
> By looking at the logs we should be able to know when was the FS
> mounted and unmounted and the options used, so to help forensic
> investigations.

Worth noting here that systemd already tracks mounts (via monitoring /proc/self/mountinfo) and logs
them to the journal, and for mounts it initiates, logs both start and completion.
It doesn't log the options right now, but that wouldn't be hard to add (particularly
since systemd has structured logging).

On the flip side of course that's only for mount namespaces where systemd is
used, and given user namespaces, a lot of use cases don't involve a systemd-per-container.

But that said, I find the log spam today from e.g. docker + devicemapper + xfs
annoying, and switching to overlay2 fixed that as a side effect which is nice.
Having overlay2 log would reintroduce that problem.
