Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:47479 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753817AbaHMWt6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Aug 2014 18:49:58 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:59672 helo=ming.hsd1.co.comcast.net)
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XHhMj-001XaY-6T
	for linux-btrfs@vger.kernel.org; Wed, 13 Aug 2014 16:49:57 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [BUG] kernel BUG at fs/btrfs/extent_io.c:2124! oops when reading corrupt file on btrfs raid5
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <E7CC2628-F28A-4431-86D7-0572F6C9F296@colorremedies.com>
Date: Wed, 13 Aug 2014 16:49:56 -0600
Message-Id: <D3417AF1-C87C-493C-9D58-6A81CDA13333@colorremedies.com>
References: <E7CC2628-F28A-4431-86D7-0572F6C9F296@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm unable to reproduce this with kernel and progs built from integration branch (I think, anyway); this is what I built:

git clone git://repo.or.cz/btrfs-progs-unstable/devel.git
cd devel
git checkout integration-20140729

git clone git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git
cd linux-btrfs
git checkout integration


After corrupting a file, the only difference from 3.16.0 is when reading the corrupt file is I get __readpage_endio_check in dmesg. 

If I understand correctly, corruption is detected, data is correctly rebuilt from parity and sent up to sha1sum but the corrected data is not written back to disk (expected). A balance also causes corruption to be detected but this time the fix is written to disk, the corruption isn't detected after this.


[   82.798368] BTRFS info (device sdd): disk space caching is enabled
[   82.875705] SELinux: initialized (dev sdd, type btrfs), uses xattr
[   92.699491] BTRFS info (device sdd): csum failed ino 257 off 0 csum 2566472073 expected csum 2759032090
[   92.791565] BTRFS info (device sdd): csum failed ino 257 off 4096 csum 3231022384 expected csum 2759032090
[   92.791862] BTRFS info (device sdd): csum failed ino 257 off 0 csum 2566472073 expected csum 2759032090
[   92.850708] BTRFS info (device sdd): csum failed ino 257 off 8192 csum 3303363542 expected csum 2759032090
[   92.873660] BTRFS info (device sdd): csum failed ino 257 off 12288 csum 2295875483 expected csum 2759032090
[   92.921120] BTRFS info (device sdd): csum failed ino 257 off 16384 csum 1837874343 expected csum 2759032090
[   93.022287] BTRFS info (device sdd): csum failed ino 257 off 20480 csum 4011747594 expected csum 2759032090
[   93.303243] BTRFS info (device sdd): csum failed ino 257 off 24576 csum 199417701 expected csum 2759032090
[   93.475170] BTRFS info (device sdd): csum failed ino 257 off 28672 csum 802473067 expected csum 2759032090
[   93.559571] BTRFS info (device sdd): csum failed ino 257 off 32768 csum 2190845313 expected csum 2759032090
[  282.402413] BTRFS info (device sdd): disk space caching is enabled
[  282.487717] SELinux: initialized (dev sdd, type btrfs), uses xattr
[  286.119979] __readpage_endio_check: 7 callbacks suppressed
[  286.121279] BTRFS info (device sdd): csum failed ino 257 off 0 csum 2566472073 expected csum 2759032090
[  286.284266] BTRFS info (device sdd): csum failed ino 257 off 4096 csum 3231022384 expected csum 2759032090
[  286.383582] BTRFS info (device sdd): csum failed ino 257 off 8192 csum 3303363542 expected csum 2759032090
[  286.383592] BTRFS info (device sdd): csum failed ino 257 off 0 csum 2566472073 expected csum 2759032090
[  286.693884] BTRFS info (device sdd): csum failed ino 257 off 12288 csum 2295875483 expected csum 2759032090
[  286.983491] BTRFS info (device sdd): csum failed ino 257 off 16384 csum 1837874343 expected csum 2759032090
[  287.233004] BTRFS info (device sdd): csum failed ino 257 off 20480 csum 4011747594 expected csum 2759032090
[  287.279199] BTRFS info (device sdd): csum failed ino 257 off 24576 csum 199417701 expected csum 2759032090
[  287.505774] BTRFS info (device sdd): csum failed ino 257 off 28672 csum 802473067 expected csum 2759032090
[  287.601100] BTRFS info (device sdd): csum failed ino 257 off 32768 csum 2190845313 expected csum 2759032090


Chris Murphy