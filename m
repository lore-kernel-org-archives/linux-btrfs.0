Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:52311 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab3EZJfq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 May 2013 05:35:46 -0400
Received: by mail-ie0-f175.google.com with SMTP id s9so15587288iec.6
        for <linux-btrfs@vger.kernel.org>; Sun, 26 May 2013 02:35:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51363CE6.1010807@sgi.com>
References: <512DB284.1090806@gmail.com>
	<51363CE6.1010807@sgi.com>
Date: Sun, 26 May 2013 17:35:45 +0800
Message-ID: <CAEH94LhbYShu5Q7K=G=10G6X3jUM68VL4rBBuS4zvdQsifsKGw@mail.gmail.com>
Subject: Re: [PATCH] xfstests 276: fix error 'FIBMAP: Invalid argument'
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: Rich Johnston <rjohnston@sgi.com>
Cc: Wang Sheng-Hui <shhuiw@gmail.com>, list.btrfs@jan-o-sch.net,
        linux-btrfs@vger.kernel.org, xfstests <xfs@oss.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

HI,

  This issue still exists when xfstests is run on debian although
xfstests has contained this patch.

root@debian-i386:/home/zwu/xfstests# git describe
linux-v3.8-122-gdc75401
root@debian-i386:/home/zwu/xfstests# uname -a
Linux debian-i386 3.10.0-rc2+ #3 SMP Sun May 26 14:04:13 CST 2013
x86_64 GNU/Linux
root@debian-i386:/home/zwu/xfstests#

 - output mismatch (see /home/zwu/xfstests/results/btrfs/276.out.bad)
    --- tests/btrfs/276.out    2013-05-25 15:09:01.000000000 +0000
    +++ /home/zwu/xfstests/results/btrfs/276.out.bad    2013-05-26
09:31:49.962876905 +0000
    @@ -1,3 +1,32393 @@
     QA output created by 276
     *** test backref walking
    +FIBMAP: Invalid argument
    +FIBMAP: Invalid argument
    +FIBMAP: Invalid argument
    +FIBMAP: Invalid argument
    +FIBMAP: Invalid argument
     ...
     (Run 'diff -u tests/btrfs/276.out
/home/zwu/xfstests/results/btrfs/276.out.bad' to see the entire diff)
[ 3877.215268] device fsid 8367602a-14fa-49eb-aff0-44da1faa3b45 devid
1 transid 239 /dev/vdb
[ 3877.218417] btrfs: disk space caching is enabled
Ran: btrfs/276
Failures: btrfs/276
Failed 1 of 1 tests

On Wed, Mar 6, 2013 at 2:43 AM, Rich Johnston <rjohnston@sgi.com> wrote:
> This patch has been committed.
>
> --Rich
>
> commit eba3a5206cd7f8df73d6e6dbf2bb0afca677fca8
> Author: Wang Sheng-Hui <shhuiw@gmail.com>
> Date:   Thu Feb 28 02:05:56 2013 +0000
>
>     xfstests 276: fix error 'FIBMAP: Invalid argument'
>
>
>     Commit 05dadc0 ("Btrfs: add fiemap's flag check") added validity
>     checks to the fiemap flags and hence invalid flags are now being
>     rejected. Test 276 passes an invalid fiemap flag to btrfs, and so
>     that test fails since this commit was added.
>
>     Btrfs doesn't support FIEMAP_FLAG_XATTR, which is enabled by -x option
>     of filefrag, and will fail with
>         'FIBMAP: Invalid argument'
>     for 'filefrag -vx'. 'filefrag -vx' fails on btrfs with
>          'FIEMAP failed with unsupported flags 2'
>     Remove the '-x' option.
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



-- 
Regards,

Zhi Yong Wu
