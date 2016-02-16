Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:32956 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbcBPHYZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Feb 2016 02:24:25 -0500
Received: by mail-ob0-f180.google.com with SMTP id jq7so61143775obb.0
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Feb 2016 23:24:25 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 16 Feb 2016 08:24:24 +0100
Message-ID: <CAPLCSGCBYLyxRU+SYpJCcJBWu=X=u0QFept0nV+0Oq4igc_rAw@mail.gmail.com>
Subject: Unable to mount BTRFS home dir anymore
From: Bhasker C V <bhasker@unixindia.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

 Help with recovery of BTRFS home directory data.
 I have been using BTRFS happily for an year now. It has worked across
power failures and many such situations.

 Last week, however, the filesystem could not be mounted after a power failure.
None of the following methods were helpful

1) I tried ro,recovery,nospace_cache,nospace_cache option of mount
2) I tried btrfs-zero-log -y -v
3) btrfsck  --repair --init-csum-tree

btrfsck does a SIGSEGV in the end.

Please can someone help me by telling me how to proceed ?

Kernel: 4.2.0
Disto: Debian sid


The errors are below:

-------  This is the dmesg for ro,recovery,nospace_cache,nospace_cache

[21680.563023] BTRFS info (device dm-12): enabling auto recovery
[21680.563044] BTRFS info (device dm-12): disabling disk space caching
[21680.563059] BTRFS: has skinny extents
[21680.583128] BTRFS: bdev /dev/mapper/ee errs: wr 18, rd 0, flush 0,
corrupt 0, gen 0
[21680.588884] BTRFS (device dm-12): parent transid verify failed on
59162624 wanted 134868 found 54964
[21680.591339] BTRFS (device dm-12): parent transid verify failed on
59162624 wanted 134868 found 54964
[21680.591358] BTRFS: Failed to read block groups: -5
[21680.620285] BTRFS: open_ctree failed


a subsequent  btrfs rescue zero-log gave this

sudo btrfs rescue zero-log /dev/mapper/jj
parent transid verify failed on 59162624 wanted 134868 found 54964
parent transid verify failed on 59162624 wanted 134868 found 54964
parent transid verify failed on 59162624 wanted 134868 found 54964
parent transid verify failed on 59162624 wanted 134868 found 54964
Ignoring transid failure
leaf parent key incorrect 59162624
parent transid verify failed on 408584192 wanted 130813 found 53737
parent transid verify failed on 408584192 wanted 130813 found 53737
parent transid verify failed on 408584192 wanted 130813 found 53737
parent transid verify failed on 408584192 wanted 130813 found 53737
Ignoring transid failure
Clearing log on /dev/mapper/jj, previous log_root 0, level 0
parent transid verify failed on 59162624 wanted 134868 found 54964
Ignoring transid failure
parent transid verify failed on 59162624 wanted 134868 found 54964
Ignoring transid failure
parent transid verify failed on 87556096 wanted 134922 found 54980
parent transid verify failed on 87556096 wanted 134922 found 54980
parent transid verify failed on 87556096 wanted 134922 found 54980
parent transid verify failed on 87556096 wanted 134922 found 54980
Ignoring transid failure
parent transid verify failed on 59162624 wanted 134868 found 54964
Ignoring transid failure
parent transid verify failed on 466993152 wanted 135739 found 53864
parent transid verify failed on 466993152 wanted 135739 found 53864
parent transid verify failed on 466993152 wanted 135739 found 53864
parent transid verify failed on 466993152 wanted 135739 found 53864
Ignoring transid failure
parent transid verify failed on 59162624 wanted 134868 found 54964
Ignoring transid failure
parent transid verify failed on 262455296 wanted 135295 found 53548
parent transid verify failed on 262455296 wanted 135295 found 53548
parent transid verify failed on 262455296 wanted 135295 found 53548
parent transid verify failed on 262455296 wanted 135295 found 53548
Ignoring transid failure
parent transid verify failed on 59162624 wanted 134868 found 54964
Ignoring transid failure
parent transid verify failed on 45613056 wanted 134843 found 54949
parent transid verify failed on 45613056 wanted 134843 found 54949
parent transid verify failed on 45613056 wanted 134843 found 54949
parent transid verify failed on 45613056 wanted 134843 found 54949
Ignoring transid failure
parent transid verify failed on 59162624 wanted 134868 found 54964
Ignoring transid failure
parent transid verify failed on 522469376 wanted 135880 found 53946
parent transid verify failed on 522469376 wanted 135880 found 53946
parent transid verify failed on 522469376 wanted 135880 found 53946
parent transid verify failed on 522469376 wanted 135880 found 53946
Ignoring transid failure
