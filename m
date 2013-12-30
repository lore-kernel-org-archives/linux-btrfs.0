Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32651 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755986Ab3L3QFS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Dec 2013 11:05:18 -0500
From: Chris Mason <clm@fb.com>
To: "marc@merlins.org" <marc@merlins.org>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "hugo@carfax.org.uk" <hugo@carfax.org.uk>
Subject: Re: Is anyone using btrfs send/receive for backups instead of rsync?
Date: Mon, 30 Dec 2013 16:05:03 +0000
Message-ID: <1388419531.11341.6.camel@ret.masoncoding.com>
References: <20131228171943.GE19863@merlins.org>
	 <20131228173730.GA7234@carfax.org.uk> <20131228180758.GF19863@merlins.org>
	 <20131228182023.GG19863@merlins.org>
In-Reply-To: <20131228182023.GG19863@merlins.org>
Content-Type: text/plain; charset="utf-7"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2013-12-28 at 10:20 -0800, Marc MERLIN wrote:
+AD4- On Sat, Dec 28, 2013 at 10:07:58AM -0800, Marc MERLIN wrote:
+AD4- +AD4- For instance, if I use an existing rsync destination to start syncing
+AD4- +AD4- btrfs snapshots to after that, and one file operation can't be applied
+AD4- +AD4- because let's say the destination file it's supposed to be applied to,
+AD4- +AD4- isn't there?
+AD4- 
+AD4- I should have written more: I'm guessing what happens is that the btrfs
+AD4- receive fails/aborts, I get an error, I then run a manual rsync to reset
+AD4- everything to a good known state, and then continue the btrfs
+AD4- send/receive after that?

Btrfs send/receive works by matching state between snapshots on the
sending and receiving end.  If you update the files manually on the
receiving end (say with rsync), it can't merge the states anymore.

-chris

