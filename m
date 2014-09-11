Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18336 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbaIKCdQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Sep 2014 22:33:16 -0400
Message-ID: <54110AEC.6040301@oracle.com>
Date: Thu, 11 Sep 2014 10:37:32 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Johannes Hirte <johannes.hirte@datenkhaos.de>, linux-btrfs@vger.kernel.org
Subject: Re: "Btrfs: device_list_add() should not update list when mounted"
 breaks subvol mount
References: <20140911002241.201bc6c2@datenkhaos.de>
In-Reply-To: <20140911002241.201bc6c2@datenkhaos.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi Johannes,

> I've two more systems with kernel version >3.17-rc3
> running and no problem like this.

  Does this 3.17-rc3 also has the same type of subvol config
  and it mount operation/sequence as you mentioned ?

 > - one hdd with btrfs
 > - default subvolume (rootfs) is different from subovlid=0
 > - at boot, several subvols are mounted at /home/$DIR

  I ran a few tests, on our mainline
  ----
  mount -o subvol=sv1 /dev/sdh1 /btrfs
  mount /dev/sdh1 /btrfs
   mount: /dev/sdh1 already mounted or /btrfs busy [*]
  mount /dev/sdh1 /btrfs1
  echo $?
  0
  -----

  [*] hope this isn't the problem you are mentioning.

Thanks, Anand
