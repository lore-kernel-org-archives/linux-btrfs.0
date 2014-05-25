Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:36712 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbaEYMgH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 25 May 2014 08:36:07 -0400
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id 74B5040F50
	for <linux-btrfs@vger.kernel.org>; Sun, 25 May 2014 22:36:06 +1000 (EST)
Received: from csamuel.org ([127.0.0.1])
 by localhost (csamuel.org [127.0.0.1]) (amavisd-maia, port 10024) with LMTP
 id 15533-03 for <linux-btrfs@vger.kernel.org>;
 Sun, 25 May 2014 22:36:06 +1000 (EST)
Received: from quad.localnet (2001-44b8-41dd-d500-99f6-8f5a-a01e-32fa.static.ipv6.internode.on.net [IPv6:2001:44b8:41dd:d500:99f6:8f5a:a01e:32fa])
	by csamuel.org (Postfix) with ESMTPSA id EAADE40F4F
	for <linux-btrfs@vger.kernel.org>; Sun, 25 May 2014 22:36:05 +1000 (EST)
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS hangs - possibly NFS related?
Date: Sun, 25 May 2014 22:36 +1000
Message-ID: <1414589.yRqiue0P7g@quad>
In-Reply-To: <058b01cf780e$6ae065c0$40a13140$@bluemoose.org.uk>
References: <019301cf4da9$bf837930$3e8a6b90$@bluemoose.org.uk> <pan$1bfd3$d8184f3c$26ab13aa$2e81c88f@cox.net> <058b01cf780e$6ae065c0$40a13140$@bluemoose.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Sun, 25 May 2014 12:42:32 PM kim-btrfs@bluemoose.org.uk wrote:

> Any ideas of what I can do to help debug it...?

Looking at that output it seems that all those blocked processes are in 
congestion_wait() in mm/backing-dev.c, the comments for which say:

/**
 * congestion_wait - wait for a backing_dev to become uncongested
 * @sync: SYNC or ASYNC IO
 * @timeout: timeout in jiffies
 *
 * Waits for up to @timeout jiffies for a backing_dev (any backing_dev) to exit
 * write congestion.  If no backing_devs are congested then just wait for the
 * next write to be completed.
 */

The blocked tasks are:

kswapd0
smbd (which correlates with what you've said before)
ShFolders  (is this something local?)
ATA-0 (I suspect a kernel process handling that device)

Interestingly there are no calls to congestion_wait() in fs/btrfs so those 
blocked tasks are blocked accessing other filesystems.

One thing that would be interesting is to see the wchan of processes blocked 
in device wait state when you're in that situation.

Something like this should do it:

ps -eo pid,user,stat,wchan:30,comm | fgrep -w D

Is this system under memory pressure at the time these happen?

All the best,
Chris
- -- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEVAwUBU4HjtI1yjaOTJg85AQKPYAgAlI7elWEx0YxPqABFmS3cUVIgTskxFL6/
ha7G1wxIxeqxhx1x1cLE3oKsCAhJlrwXd6cB8e0Kmu2280fCa/N9uqdJaMq+E8ha
VU0K0D6lAd2lJP9L1XVI2hlAO8YEwuFpe5ebYk//1LERsZxkPVJSrIntVKvG8aCR
9fHLa9W7Pscn9oOyC2Nvh/z4FAAHu0/QWj/uuA8cOUX0FRyHrsqhhi3a+zHNJkOo
vB6nfd/TWJXXDTRO6Og9ozW8InvAvpuG0NNOVSVQd10xc09qLMaP98cBBhisFji/
r3RZ0GiyW4SlYjQWhfxP9eBtZlsQD8lZMGEXHPyzlHZrJzMfjQjJvw==
=h6xh
-----END PGP SIGNATURE-----

