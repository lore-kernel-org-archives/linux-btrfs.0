Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:37402 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751704AbdIOVHj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 17:07:39 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:61256)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <postmaster@root.t00.sabi.co.uk>)
        id 1dsxpp-0034Qv-9f
        for linux-btrfs@vger.kernel.org; Fri, 15 Sep 2017 22:07:37 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1dsxpk-0002c7-Ap
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Sep 2017 22:07:32 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22972.16657.822204.646994@tree.ty.sabi.co.uk>
Date: Fri, 15 Sep 2017 22:07:29 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: A user cannot remove his readonly snapshots?!
In-Reply-To: <20170915163736.GD32347@rus.uni-stuttgart.de>
References: <20170915163736.GD32347@rus.uni-stuttgart.de>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>  [ ... ] mounted with option user_subvol_rm_allowed [ ... ]
> root can delete this snapshot, but not the user. Why? [ ... ]

Ordinary permissions still apply both to 'create' and 'delete':

  tree$  sudo mkdir /fs/sda7/dir
  tree$  btrfs sub create /fs/sda7/dir/sub
  ERROR: cannot access /fs/sda7/dir/sub: Permission denied

  tree$  sudo chmod a+rwx /fs/sda7/dir
  tree$  btrfs sub create /fs/sda7/dir/sub
  Create subvolume '/fs/sda7/dir/sub'

  tree$  btrfs sub delete /fs/sda7/dir/sub
  Delete subvolume (no-commit): '/fs/sda7/dir/sub'
  ERROR: cannot delete '/fs/sda7/dir/sub': Operation not permitted
  tree$  sudo mount -o remount,user_subvol_rm_allowed /fs/sda7
  tree$  btrfs sub delete /fs/sda7/dir/sub
  Delete subvolume (no-commit): '/fs/sda7/dir/sub'

  tree$  btrfs sub create /fs/sda7/dir/sub
  Create subvolume '/fs/sda7/dir/sub'

  tree$  sudo chmod a-w /fs/sda7/dir
  tree$  btrfs sub delete /fs/sda7/dir/sub
  Delete subvolume (no-commit): '/fs/sda7/dir/sub'
  ERROR: cannot delete '/fs/sda7/dir/sub': Permission denied

  tree$  sudo chmod a+w /fs/sda7/dir
  tree$  btrfs sub delete /fs/sda7/dir/sub
  Delete subvolume (no-commit): '/fs/sda7/dir/sub'
  tree$  sudo rmdir /fs/sda7/dir
