Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:56076 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1754303AbcIIKSx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Sep 2016 06:18:53 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1biItV-0006du-0E
        for linux-btrfs@vger.kernel.org; Fri, 09 Sep 2016 12:18:49 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
        <holger@applied-asynchrony.com>
Subject: Re: [PATCH v3] btrfs: should block unused block groups deletion
 work when allocating data space
Date: Fri, 9 Sep 2016 10:18:39 +0000 (UTC)
Message-ID: <pan$db9b8$41125892$42517798$e874738e@applied-asynchrony.com>
References: <20160909081748.26540-1-wangxg.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 09 Sep 2016 16:17:48 +0800, Wang Xiaoguang wrote:

> cleaner_kthread() may run at any time, in which it'll call btrfs_delete_unused_bgs()
> to delete unused block groups. Because this work is asynchronous, it may also result
> in false ENOSPC error. 
<snip>

With this v3 I can now no longer balance (tested only with metadata).
New chunks are allocated (as balance does) but nothing ever shrinks, until
after unmount/remount, when the cleaner eventually kicks in.

This might be related to the recent patch by Naohiro Aota:
"btrfs: let btrfs_delete_unused_bgs() to clean relocated bgs"

which by itself doesn't seem to do any harm (i.e. everything still seems
to work as expected).

-h

