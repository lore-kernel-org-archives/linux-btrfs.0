Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:63479 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab3EIVbR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 May 2013 17:31:17 -0400
Received: by mail-wg0-f49.google.com with SMTP id j13so3374367wgh.28
        for <linux-btrfs@vger.kernel.org>; Thu, 09 May 2013 14:31:16 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8a2c:b230:7d7c:5d77:6fe1:1d71? ([2a01:e35:8a2c:b230:7d7c:5d77:6fe1:1d71])
        by mx.google.com with ESMTPSA id ed20sm12856wic.0.2013.05.09.14.31.14
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Thu, 09 May 2013 14:31:15 -0700 (PDT)
Message-ID: <518C15A0.2000006@gmail.com>
Date: Thu, 09 May 2013 23:31:12 +0200
From: Gabriel de Perthuis <g2p.code@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/4] btrfs: Introduce extent_read_full_page_nolock()
References: <1366150535-18750-1-git-send-email-mfasheh@suse.de>
In-Reply-To: <1366150535-18750-1-git-send-email-mfasheh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> We want this for btrfs_extent_same. Basically readpage and friends do their
>> own extent locking but for the purposes of dedupe, we want to have both
>> files locked down across a set of readpage operations (so that we can
>> compare data). Introduce this variant and a flag which can be set for
>> extent_read_full_page() to indicate that we are already locked.
> 
> This one can get stuck in TASK_UNINTERRUPTIBLE:
> 
> [32129.522257] SysRq : Show Blocked State
> [32129.524337]   task                        PC stack   pid father
> [32129.526515] python          D ffff88021f394280     0 16281      1 0x00000004
> [32129.528656]  ffff88020e079a48 0000000000000082 ffff88013d3cdd40 ffff88020e079fd8
> [32129.530840]  ffff88020e079fd8 ffff88020e079fd8 ffff8802138dc5f0 ffff88013d3cdd40
> [32129.533044]  0000000000000000 0000000000001fff ffff88015286f440 0000000000000008
> [32129.535285] Call Trace:
> [32129.537522]  [<ffffffff816dcca9>] schedule+0x29/0x70
> [32129.539829]  [<ffffffffa02b4908>] wait_extent_bit+0xf8/0x150 [btrfs]
> [32129.542130]  [<ffffffff8107ea00>] ? finish_wait+0x80/0x80
> [32129.544463]  [<ffffffffa02b4f84>] lock_extent_bits+0x44/0xa0 [btrfs]
> [32129.546824]  [<ffffffffa02b4ff3>] lock_extent+0x13/0x20 [btrfs]
> [32129.549198]  [<ffffffffa02dc0cf>] add_ra_bio_pages.isra.8+0x17f/0x2d0 [btrfs]
> [32129.551602]  [<ffffffffa02dccfc>] btrfs_submit_compressed_read+0x25c/0x4c0 [btrfs]
> [32129.554028]  [<ffffffffa029d131>] btrfs_submit_bio_hook+0x1d1/0x1e0 [btrfs]
> [32129.556457]  [<ffffffffa02b2d07>] submit_one_bio+0x67/0xa0 [btrfs]
> [32129.558899]  [<ffffffffa02b7ecd>] extent_read_full_page_nolock+0x4d/0x60 [btrfs]
> [32129.561290]  [<ffffffffa02c8052>] fill_data+0xb2/0x230 [btrfs]
> [32129.563623]  [<ffffffffa02cd57e>] btrfs_ioctl+0x1f7e/0x2560 [btrfs]
> [32129.565924]  [<ffffffff816ddbae>] ? _raw_spin_lock+0xe/0x20
> [32129.568207]  [<ffffffff8119b907>] ? inode_get_bytes+0x47/0x60
> [32129.570472]  [<ffffffff811a8297>] do_vfs_ioctl+0x97/0x560
> [32129.572700]  [<ffffffff8119bb5a>] ? sys_newfstat+0x2a/0x40
> [32129.574882]  [<ffffffff811a87f1>] sys_ioctl+0x91/0xb0
> [32129.577008]  [<ffffffff816e64dd>] system_call_fastpath+0x1a/0x1f

For anyone trying those patches, there's a fix here:
https://github.com/g2p/linux/tree/v3.9%2Bbtrfs-extent-same

