Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp01.belwue.de ([129.143.71.86]:53853 "EHLO smtp01.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750872AbdHaHGA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Aug 2017 03:06:00 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp01.belwue.de (Postfix) with SMTP id C6BC189BB
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Aug 2017 09:05:58 +0200 (MEST)
Date: Thu, 31 Aug 2017 09:05:58 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: btrfs filesystem defragment -r -- does it affect subvolumes?
Message-ID: <20170831070558.GB5783@rus.uni-stuttgart.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When I do a 
btrfs filesystem defragment -r /directory
does it defragment really all files in this directory tree, even if it
contains subvolumes?
The man page does not mention subvolumes on this topic.

I have an older script (written by myself) which does a 
"btrfs filesystem defragment -r" on all subvolumes recursivly:

  btrfs filesystem defragment -r $m
  for s in $(btrfs subvolume list $m | awk '{ print $NF }'); do
    [[ "$s" =~ ^@ ]] && continue
    [[ $(btrfs subvolume show $m/$s) =~ Flags:.*readonly ]] && continue
    btrfs filesystem defragment -r $m/$s
  done

I wonder why I have done it that way :-}


-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<20170831070558.GB5783@rus.uni-stuttgart.de>
