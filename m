Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:57311 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab3HAVSw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Aug 2013 17:18:52 -0400
Received: by mail-wg0-f53.google.com with SMTP id c11so2129645wgh.20
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Aug 2013 14:18:50 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 1 Aug 2013 17:18:50 -0400
Message-ID: <CAPs0BihZNQ1fY4syh-=Pqm_ekVwd7Fw+YhGuVgz0fcO=VUZrFw@mail.gmail.com>
Subject: filefrag and btrfs filesystem defragment and maybe snapshots
From: Sandy McArthur <sandymac@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While exploring some btrfs maintenance with respect to defragmenting I
ran the following commands:

# filefrag /path/to/34G.file /path/to/5.7G.file
/path/to/34G.file: 2406 extents found
/path/to/5.7G.file: 572 extents found

Thinking those mostly static files could be less fragmented I ran:
# btrfs filesystem defragment -c /path/to/34G.file
# btrfs filesystem defragment -c /path/to/5.7G.file

and to my surprise the number of fragments/extends doubled:

# filefrag /path/to/34G.file /path/to/5.7G.file
/path/to/34G.file: 6324 extents found
/path/to/5.7G.file: 1079 extents found

Did I actually improve these files?

I do have a number rolling readonly snapshots on the subvolume these
files are on. I can imagine how that might be related but I'm not
sure. When the pre-defrag snapshots are purged will the filefrag
extents count drop.

-- 
Sandy McArthur

"He who dares not offend cannot be honest."
- Thomas Paine
