Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54926 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754204AbdEIPl3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 May 2017 11:41:29 -0400
Date: Tue, 9 May 2017 17:41:21 +0200
From: David Sterba <dsterba@suse.cz>
To: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
Cc: quwenruo@cn.fujitsu.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: btrfs-convert: Add larger device support
Message-ID: <20170509154120.GG5491@suse.cz>
Reply-To: dsterba@suse.cz
References: <20170427100534.GA10404@giis.co.in>
 <20170502150601.GK23260@twin.jikos.cz>
 <20170502153556.GM23260@twin.jikos.cz>
 <20170503163819.GA10030@giis.co.in>
 <CAKuJGC8SndPLuVDVtJZLEzYg-Vfh0U1Y-wF4pr093yTnjJfkXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKuJGC8SndPLuVDVtJZLEzYg-Vfh0U1Y-wF4pr093yTnjJfkXg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 09, 2017 at 07:46:08PM +0530, Lakshmipathi.G wrote:
> created a test script but it fail to detect mk2fs. Test script 009
> also produces:
> 
> # ./convert-tests/009-common-inode-flags/test.sh
>     [TEST/conv]     common inode flags test, btrfs defaults
> failed: mke2fs -t ext4 -b 4096 -F
> /home/laks/centos/laks/BTRFS/btrfs-progs/tests/test.img
> 
> Seems like run_check fails to detect mke2fs command. Something wrong
> with my setup or issue with run_check?

Does the mke2fs command exist on your system? We maybe want to use
mkfs.ext4 directly.
