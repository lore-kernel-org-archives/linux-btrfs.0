Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lmr1.uibk.ac.at ([138.232.1.142]:34726 "EHLO lmr1.uibk.ac.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751619AbdDLHBP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Apr 2017 03:01:15 -0400
Received: from [138.232.3.130] (c102-hs.uibk.ac.at [138.232.3.130])
        (authenticated bits=0)
        by smtp.uibk.ac.at (8.14.4/8.14.4/F1) with ESMTP id v3C6jpoS010754
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Apr 2017 08:45:51 +0200
Subject: Re: Unexpected: send/receive much slower than rsync ?
To: linux-btrfs@vger.kernel.org
References: <58ECF232.6010500@gmail.com>
From: =?UTF-8?Q?Hermann_Schw=c3=a4rzler?=
        <hermann.schwaerzler@freirad.at>
Message-ID: <645fd02d-f5e5-876c-ec80-898f30344b4c@freirad.at>
Date: Wed, 12 Apr 2017 08:45:51 +0200
MIME-Version: 1.0
In-Reply-To: <58ECF232.6010500@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I am not an expert just a btrfs user who uses send/receive quite
frequently but I am pretty sure your problem is not on the receive side
but on the send end.
Can you check with e.g. iotop if receive is writing anything to the disk
or if it's just waiting for send?
How much is send reading from disk and how much memory is it allocating?

I am asking this because I reckon your problem is caused by the way
clone detection is done in send. There is a proposed patch
https://patchwork.kernel.org/patch/9245287/
that addresses the problem. This did indeed help me when I had a similar
problem when trying to send a previously deduplicated filesystem!

Greetings
Hermann

On 04/11/2017 05:11 PM, J. Hart wrote:
> I'm trying to update from an old snapshot of a directory to a new one
> using send/receive. It seems a great deal slower than I was expecting,
> perhaps much slower than rsync and has been running for hours.
> Everything looks ok with how I set up the snapshots, and there are no
> error messages, but I don't think it should be running this long. The
> directory structure is rather complex, so that may have something to do
> with it. It contains reflinked incremental backups of root file systems
> from a number of machines. It should not actually be very large due to
> the reflinks.
> 
> Sending the old version of the snapshot for the directory did not seem
> to take this long, and I expected the "send -p <old> <new>" to be much
> faster than that.
> 
> I tried running the "send" and "receive" with "-vv" to get more detail
> on what was happening.
> 
> I had thought that btrfs send/receive purely dealt with block/extent
> level changes.
> 
> I could be mistaken, but it seems that btrfs receive actually does a
> great deal of manipulation at the level of individual files, and rather
> less efficiently than rsync at that. I am not sure whether it is using
> system calls to do this, or actual shell commands themselves. I see
> quite a bit of what looks like file level manipulation in the verbose
> output. It is indeed very fast for simple directory trees even with very
> large files. However, it seems to be far slower than rsync with
> moderately complex directory trees, even if no large files are present.
> 
> I hope I'm overlooking something, and that this is not actually the
> case. Any ideas on this ?
> 
> J. Hart
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
