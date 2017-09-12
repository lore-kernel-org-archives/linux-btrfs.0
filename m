Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp02.belwue.de ([129.143.71.87]:60257 "EHLO smtp02.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751054AbdILQ2p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Sep 2017 12:28:45 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp02.belwue.de (Postfix) with SMTP id 8182C873C
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Sep 2017 18:28:43 +0200 (MEST)
Date: Tue, 12 Sep 2017 18:28:43 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: defragmenting best practice?
Message-ID: <20170912162843.GA32233@rus.uni-stuttgart.de>
References: <20170831070558.GB5783@rus.uni-stuttgart.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170831070558.GB5783@rus.uni-stuttgart.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu 2017-08-31 (09:05), Ulli Horlacher wrote:
> When I do a 
> btrfs filesystem defragment -r /directory
> does it defragment really all files in this directory tree, even if it
> contains subvolumes?
> The man page does not mention subvolumes on this topic.

No answer so far :-(

But I found another problem in the man-page:

  Defragmenting with Linux kernel versions < 3.9 or >= 3.14-rc2 as well as
  with Linux stable kernel versions >= 3.10.31, >= 3.12.12 or >= 3.13.4
  will break up the ref-links of COW data (for example files copied with
  cp --reflink, snapshots or de-duplicated data). This may cause
  considerable increase of space usage depending on the broken up
  ref-links.

I am running Ubuntu 16.04 with Linux kernel 4.10 and I have several
snapshots.
Therefore, I better should avoid calling "btrfs filesystem defragment -r"?

What is the defragmenting best practice?
Avoid it completly?



-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<20170831070558.GB5783@rus.uni-stuttgart.de>
