Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13713 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756058Ab3L3Q04 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Dec 2013 11:26:56 -0500
From: Chris Mason <clm@fb.com>
To: "marc@merlins.org" <marc@merlins.org>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "hugo@carfax.org.uk" <hugo@carfax.org.uk>
Subject: Re: Is anyone using btrfs send/receive for backups instead of rsync?
Date: Mon, 30 Dec 2013 16:26:42 +0000
Message-ID: <1388420830.11341.12.camel@ret.masoncoding.com>
References: <20131228171943.GE19863@merlins.org>
	 <20131228173730.GA7234@carfax.org.uk> <20131228180758.GF19863@merlins.org>
	 <20131228182023.GG19863@merlins.org>
	 <1388419531.11341.6.camel@ret.masoncoding.com>
	 <20131230161729.GQ19863@merlins.org>
In-Reply-To: <20131230161729.GQ19863@merlins.org>
Content-Type: text/plain; charset="utf-7"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2013-12-30 at 08:17 -0800, Marc MERLIN wrote:
+AD4- On Mon, Dec 30, 2013 at 04:05:03PM +-0000, Chris Mason wrote:
+AD4- +AD4- On Sat, 2013-12-28 at 10:20 -0800, Marc MERLIN wrote:
+AD4- +AD4- +AD4- On Sat, Dec 28, 2013 at 10:07:58AM -0800, Marc MERLIN wrote:
+AD4- +AD4- +AD4- +AD4- For instance, if I use an existing rsync destination to start syncing
+AD4- +AD4- +AD4- +AD4- btrfs snapshots to after that, and one file operation can't be applied
+AD4- +AD4- +AD4- +AD4- because let's say the destination file it's supposed to be applied to,
+AD4- +AD4- +AD4- +AD4- isn't there?
+AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- I should have written more: I'm guessing what happens is that the btrfs
+AD4- +AD4- +AD4- receive fails/aborts, I get an error, I then run a manual rsync to reset
+AD4- +AD4- +AD4- everything to a good known state, and then continue the btrfs
+AD4- +AD4- +AD4- send/receive after that?
+AD4- +AD4- 
+AD4- +AD4- Btrfs send/receive works by matching state between snapshots on the
+AD4- +AD4- sending and receiving end.  If you update the files manually on the
+AD4- +AD4- receiving end (say with rsync), it can't merge the states anymore.
+AD4- 
+AD4- I got that, but it wasn't quite my question :)
+AD4- 
+AD4- I understand that btrfs receive cannot apply file changes if the
+AD4- destination filesystem isn't in a file state that's identical to the source
+AD4- one.
+AD4- 
+AD4- I'm just not too sure how the destination FS needs to be configured so
+AD4- that btrfs receive can work with it.
+AD4- 
+AD4- 1) Does it need to be an exact byte for byte copy of the block device the
+AD4- source was on?
+AD4- 
No, in fact this doesn't help.

+AD4- 2) Or can the destination be seeded with a full rsync or cp -a and can btrfs receive
+AD4- take over from there?
+AD4- 

No, it has to be created by btrfs receive.

+AD4- 3) Then, if I hit a bug where something doesn't get synced right, and I run
+AD4- rsync to fix or verify that the two FS are indeed identical file-wise
+AD4- like they're supposed to, if rsync fixes something, are you saying that
+AD4- it'll stop btrfs receive from working after that?
+AD4- 

Yes, today anyway it won't work.  Send converts the changed items into
an intermediate format (we don't send btree blocks directly over the
wire) and then receive modifies the destination from userland.

At the end of the stream we update the destination root to say +ACI-you're
now version xxyyzz of uuid aabbcc+ACI-.

We definitely could add a way to manually set this, but once a user does
it, it'll be very hard to debug any problems they might have had if
their copy wasn't actually up to date.

-chris

