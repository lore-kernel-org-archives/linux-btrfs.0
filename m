Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:43314 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751182AbdIPJQw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Sep 2017 05:16:52 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:61748)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <postmaster@root.t00.sabi.co.uk>)
        id 1dt9DW-003OxO-8L
        for linux-btrfs@vger.kernel.org; Sat, 16 Sep 2017 10:16:50 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1dt9DP-0003O6-KY
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Sep 2017 10:16:43 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22972.60410.628544.360730@tree.ty.sabi.co.uk>
Date: Sat, 16 Sep 2017 10:16:42 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: A user cannot remove his readonly snapshots?!
In-Reply-To: <20170915220201.GH32347@rus.uni-stuttgart.de>
References: <20170915163736.GD32347@rus.uni-stuttgart.de>
        <22972.16657.822204.646994@tree.ty.sabi.co.uk>
        <20170915214434.GG32347@rus.uni-stuttgart.de>
        <20170915220201.GH32347@rus.uni-stuttgart.de>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[ ... ]

> I can delete normal subvolumes but not the readonly snapshots:

It is because of ordinary permissions for both subvolumes and
snapshots:

  tree$  btrfs sub create /fs/sda7/sub
  Create subvolume '/fs/sda7/sub'

  tree$  chmod a-w /fs/sda7/sub
  tree$  btrfs sub del /fs/sda7/sub
  Delete subvolume (no-commit): '/fs/sda7/sub'
  ERROR: cannot delete '/fs/sda7/sub': Permission denied

  tree$  chmod u+w /fs/sda7/sub
  tree$  btrfs sub del /fs/sda7/sub
  Delete subvolume (no-commit): '/fs/sda7/sub'

It is however possible to remove an ordinary read-only
directory, *as long as its parent directory is not read-only
too*:

  tree$  mkdir /fs/sda7/sub
  tree$  chmod a-w /fs/sda7/sub
  tree$  rmdir /fs/sda7/sub; echo $?
  0

IIRC this came up before, and the reason for the difference is
that a subvolume root directory is "special" because its '..'
entry points to itself (inode 256), that is if it is read-only
its parent directory (itself) then is read-only too.
