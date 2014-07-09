Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ore.jhcloos.com ([198.147.23.85]:45201 "EHLO ore.jhcloos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755868AbaGIRan (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Jul 2014 13:30:43 -0400
From: James Cloos <cloos@jhcloos.com>
To: Chris Mason <clm@fb.com>
Cc: Tsutomu Itoh <t-itoh@jp.fujitsu.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [3.16-rc1] BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u25:4:5189]
In-Reply-To: <539FC896.5010909@fb.com> (Chris Mason's message of "Tue, 17 Jun
	2014 00:48:22 -0400")
References: <539E9026.1020406@jp.fujitsu.com> <539F2FEA.1060809@fb.com>
	<539F7D8E.9010608@jp.fujitsu.com> <539F8351.3010700@fb.com>
	<539F846A.4080608@jp.fujitsu.com> <539F9006.4090109@fb.com>
	<539FA395.5050704@jp.fujitsu.com> <539FB0AE.7010404@jp.fujitsu.com>
	<539FC896.5010909@fb.com>
Date: Wed, 09 Jul 2014 13:14:53 -0400
Message-ID: <m3egxu314i.fsf@carbon.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It looks like I just hit this on rc4.  (I compiled the earlier rc
versions, but hadn't rebooted until yesterday.)

I don't think I see anything in the git log since rc1 which is relevant,
but just in case one of those tried to fix this, its still there.

The stuck processes are:

]btrfs-transacti] btrfs_wait_and_free_delalloc_work
rsync             writeback_inodes_sb_nr
rsync             reserve_metadata_bytes
git-merge         sleep_on_page_killable
/bin/sync         sync_inodes_sb

(The two rsync processes are separate; each to its one directory.)

The fs with those processes is mounted with noatime,compress.

Interestingly, I also use btrfs /var/log, also with noatime,compress,
but that one is fine.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 0x997A9F17ED7DAEA6
