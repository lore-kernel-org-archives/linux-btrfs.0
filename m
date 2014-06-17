Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30883 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755296AbaFQSab (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Jun 2014 14:30:31 -0400
Message-ID: <53A08925.8020700@fb.com>
Date: Tue, 17 Jun 2014 11:29:57 -0700
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>, <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>
CC: <takeuchi_satoru@jp.fujitsu.com>
Subject: Re: btrfs balance crash BUG ON fs/btrfs/relocation.c:1062 or RIP
 build_backref_tree+0x9fc/0xcc4
References: <20140609234007.GD19071@merlins.org>
In-Reply-To: <20140609234007.GD19071@merlins.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/09/2014 04:40 PM, Marc MERLIN wrote:
> I did a balance on a system that had 3.11 (yes, I know, it's old). It hung.
> So, I rebooted with 3.13, and it failed in fs/btrfs/relocation
>
> Problem #1: I cannot stop the relocation. It starts on its own as soon as I
> mount the FS, and I can't stop it.
> Is there a bug to fix that?
>
> Problem #2: I rebooted with 3.15rc5, and now it's worse.
> [ 1569.598026] kernel BUG at fs/btrfs/relocation.c:1064!
> then leads to
> [ 1569.613240] RIP  [<ffffffff81267ef0>] build_backref_tree+0x9fc/0xcc4
> [ 1569.613491]  RSP <ffff880fde599ad8>
> [ 1569.614119] ---[ end trace da0f24875bbde960 ]---
> [ 1569.614398] Kernel panic - not syncing: Fatal exception
> (full trace below)
>
> I'm sure that filesystem is damaged in some way, but the kernel of course
> should not crash.
>

I don't have this mail client setup right to send patches, can you just 
go into relocation.c in build_backref_tree and remove the need_check = 
false; statement and see if that fixes it.  Thanks,

Josef
