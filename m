Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zlom.siedziba.pl ([85.222.100.130]:35459 "EHLO zlom.siedziba.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963Ab3BDJQK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Feb 2013 04:16:10 -0500
Received: from lampka.siedziba.pl (localhost.graciarnia [127.0.0.1])
	by zlom.siedziba.pl (Postfix) with ESMTPA id A3A78887ADE
	for <linux-btrfs@vger.kernel.org>; Mon,  4 Feb 2013 10:16:02 +0100 (CET)
Message-ID: <072778be6e5d13614eddce7132834608.squirrel@lampka.siedziba.pl>
In-Reply-To: <69d32024cba2f7912082b19a18e0d49f.squirrel@lampka.siedziba.pl>
References: <55e4fbbdada4ee37bdccac2537683d83.squirrel@lampka.siedziba.pl>
    <69d32024cba2f7912082b19a18e0d49f.squirrel@lampka.siedziba.pl>
Date: Mon, 4 Feb 2013 10:16:02 +0100
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:1755 (was: 1772)
From: =?utf-8?B?IlBpb3RyIFBhd8WCb3ci?= <pp@siedziba.pl>
To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

situation update: I realized I haven't tried "nospace_cache" yet, even
though I tried "clear_cache". "clear cache" doesn't help at all. On the
other hand, with "nospace_cache":

# mount /dev/hdb -odevice=/dev/hdc,nospace_cache /mnt/test
device label root devid 2 transid 56099 /dev/hdc
device label root devid 1 transid 56099 /dev/hdb
btrfs: disabling disk space caching
btrfs: unlinked 1 orphans
/ # btrfs: continuing balance
btrfs: relocating block group 776713797632 flags 4

It successfully mounts rw and continues the balance.

I'm still doing it all on qemu with "-snapshot" option, to keep HD
contents unmodified. Now the question is: should I try to mount it
"nospace_cache" for real, try to keep using it and see what happens, or is
anyone interested in debugging this problem further before I potentially
destroy the "evidence"?

Regards


