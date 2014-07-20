Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lb1.pop2.wanet.net ([65.244.248.2]:49242 "EHLO
	serv004.pop2.wanet.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753010AbaGTT70 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jul 2014 15:59:26 -0400
Message-ID: <37e3a8cf8b7439d5cd2745b5efb9d37f.squirrel@webmail.wanet.net>
In-Reply-To: <20140721013609.6d99c399@natsu>
References: <loom.20140720T102642-239@post.gmane.org>
    <53CC1553.1020908@shiftmail.org> <20140721013609.6d99c399@natsu>
Date: Sun, 20 Jul 2014 12:59:21 -0700
Subject: Re: 1 week to rebuid 4x 3TB raid10 is a long time!
From: ashford@whisperpc.com
To: "Roman Mamedov" <rm@romanrm.net>
Cc: "Bob Marley" <bobmarley@shiftmail.org>, "TM" <tmjuju@yahoo.com>,
        linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is the cause for the slow reconstruct.

> I believe the problem here might be that a Btrfs rebuild *is* a strenuous
> random read (+ random-ish write) just by itself.

If you assume a 12ms average seek time (normal for 7200RPM SATA drives),
an 8.3ms rotational latency (half a rotation), an average 64kb write and a
100MB/S streaming write speed, each write comes in at ~21ms, which gives
us ~47 IOPS.  With the 64KB write size, this comes out to ~3MB/S, DISK
LIMITED.

The on-disk cache helps a bit during the startup, but once the cache is
full, it's back to writes at disk speed, with some small gains if the
on-disk controller can schedule the writes efficiently.

Based on the single-threaded I/O that BTRFS uses during a reconstruct, I
expect that the average write size is somewhere around 200KB. 
Multi-threading the reconstruct disk I/O (possibly adding look-ahead),
would double the reconstruct speed for this array, but that's not a
trivial task.

The 5MB/S that TM is seeing is fine, considering the small files he says
he has.

Peter Ashford

