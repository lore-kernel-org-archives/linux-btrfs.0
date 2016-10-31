Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:56714 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758994AbcJaFrU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Oct 2016 01:47:20 -0400
Date: Sun, 30 Oct 2016 22:47:19 -0700
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs check --repair: ERROR: cannot read chunk root
Message-ID: <20161031054719.GN28648@merlins.org>
References: <20161030183437.GA3287@merlins.org> <062d36da-197f-6a58-0b6e-208a5ca9fef3@cn.fujitsu.com> <20161031020616.GH28648@merlins.org> <60a0ce1f-7b2f-325e-51f7-ccad054fab8b@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <60a0ce1f-7b2f-325e-51f7-ccad054fab8b@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 31, 2016 at 01:27:56PM +0800, Qu Wenruo wrote:
> Would you please dump the following bytes?
> That's the chunk root tree block on your disk.
> 
> offset: 13500329066496 length: 16384
> offset: 13500330213376 length: 16384
 
Sorry for asking, am I doing this wrong?
myth:~# dd if=/dev/mapper/crypt_bcache0 of=/tmp/dump1 bs=512 count=32
skip=26367830208
dd: reading `/dev/mapper/crypt_bcache0': Invalid argument
0+0 records in
0+0 records out
0 bytes (0 B) copied, 0.000401393 s, 0.0 kB/s

> According to your fsck error output, I assume btrfs-progs fails to read 
> the first copy of chunk root, and due to a bug, it doesn't continue to 
> read 2nd copy.
> 
> While kernel continues to read the 2nd copy and everything goes on.
 
Ah, that would make sense.
But from what you're saying, I should be able to do recovery by pointing
to the 2nd copy of the chunk root, but somehow I haven't typed the right
command to do so yet, correct?

Should I try another command offset than 
btrfs check -p --repair --chunk-root 13835462344704 /dev/mapper/crypt_bcache0 
?

Or are you saying the btrfs progs bug causes it to fail to even try to read
the 2nd copy of the chunk root even though it was given on the command line?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
