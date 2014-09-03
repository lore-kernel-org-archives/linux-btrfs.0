Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932411AbaICMZZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Sep 2014 08:25:25 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s83CPPma031195
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Sep 2014 08:25:25 -0400
Received: from [10.36.4.187] (vpn1-4-187.ams2.redhat.com [10.36.4.187])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s83CPNxs001416
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Sep 2014 08:25:24 -0400
Message-ID: <540708B2.9090109@redhat.com>
Date: Wed, 03 Sep 2014 14:25:22 +0200
From: Harald Hoyer <harald@redhat.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Problem with applying incremental btrfs-send
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

maybe someone can enlighten me. I am doing btrfs send & receive with full
snapshots and incremental updates.

It basically looks like this:

vol-0 and vol-1 are full subvolume image sends.
inc-1 and inc-2 are incremental images with:
# btrfs send -f inc-1 -p vol vol'
# btrfs send -f inc-2 -p vol' vol''

Case A:

vol---send----> vol-0 --receive--> avol  --send&rec--> bvol
|-----send----> inc-1 --receive-->  |                   | <--receive-- inc-1
vol' -send----> vol-1              avol'               bvol'
|-----send----> inc-2 --receive-->  |                   | <--receive-- inc-2
vol''                              avol''              bvol''

which, works for bvol and which even works, if bvol is removed before inc-2 is
applied to bvol'.

Case B:

vol---send----> vol-0 --receive--> avol
|-----send----> inc-1 --receive-->  |
vol' -send----> vol-1              avol' --send&rec--> bvol'
|-----send----> inc-2 --receive-->  |                   | <--receive-- inc-2
vol''                              avol''              ERROR


trying to apply inc-2 to bvol' fails with:

ERROR: could not find parent subvolume

What's the problem here?
