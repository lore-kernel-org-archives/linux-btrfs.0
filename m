Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:58467 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558AbbDJHzR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Apr 2015 03:55:17 -0400
Received: from athena.localnet (ns-local [10.10.10.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 68E3EEC4B
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Apr 2015 17:55:11 +1000 (AEST)
From: Russell Coker <russell@coker.com.au>
To: BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: snapshot space use
Date: Fri, 10 Apr 2015 07:55:10 +0000
References: <201504091039.33442.russell@coker.com.au>
In-Reply-To: <201504091039.33442.russell@coker.com.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201504100755.10240.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 9 Apr 2015 12:39:33 AM Russell Coker wrote:
> # zfs list -t snapshot
> NAME                        USED  AVAIL  REFER  MOUNTPOINT
> hetz0/be0-mail@2015-03-10  2.88G      -   387G  -
> hetz0/be0-mail@2015-03-11  1.12G      -   388G  -
> hetz0/be0-mail@2015-03-12  1.11G      -   388G  -
> hetz0/be0-mail@2015-03-13  1.19G      -   388G  -
> hetz0/be0-mail@2015-03-14  1.02G      -   388G  -
> hetz0/be0-mail@2015-03-15   989M      -   386G  -
> 
> Is there any way to do something similar to the above ZFS command?  It's
> handy to know which snapshots are taking up the most space, especially
> when multiple subvols are being snapshotted.

Quota isn't really what I want.  What I don't want is to go to all the effort 
of creating quotas on snapshots (and the risk of using such features) just for 
the ability to see disk usage IF I want it.  What I want is to have it just 
work as it does in ZFS.  In the above example I can see that I can free 2.88G 
of disk space by removing the oldest snapshot, this is useful.

btrfs sub find-new $SNAPSHOT $LASTGEN | 
awk '{total = total + $7}END{print total}'

The above command gives a total of the lengths of extents that changed in a 
snapshot.  Of course the total length isn't going to be the total space used 
(it doesn't count metadata used or space saved through compression), but it 
does give an idea.  Thanks Hugo for the tip in another thread.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
