Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:17284 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab3FJHln (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Jun 2013 03:41:43 -0400
Message-ID: <51B58333.3050901@gmx.net>
Date: Mon, 10 Jun 2013 09:41:39 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Tomasz Chmielewski <tch@virtall.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfs quota examples?
References: <20130610152127.38fb8a50@virtall.com>
In-Reply-To: <20130610152127.38fb8a50@virtall.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10.06.2013 08:21, Tomasz Chmielewski wrote:
> I'm trying to use btrfs quotas, but I'm unable to find reliable
> documentation on its usage.
> 
> Let's start with an empty subvolume:
> 
> - assign 200 MB space to it:
> 
> # btrfs qgroup limit 200m /mnt/btrfs-backup/tester/
> 
> 
> - see the usage:
> 
> # btrfs qgroup show /mnt/btrfs-backup/tester/
> 0/803 0 0
> 
> 
> - let's add a 100 MB file:
> 
> # dd if=/dev/urandom of=bigfile bs=1M count=100
> 
> 
> - sync the FS to make sure quota is updated:
> 
> # btrfs filesystem
> sync /mnt/btrfs-backup/ FSSync '/mnt/btrfs-backup/'
> 
> 
> - see current quota usage:
> 
> # btrfs qgroup show /mnt/btrfs-backup/backuppc/tester/
> 0/803 104882176 104882176
> 
> 
> Now, my questions:
> 
> - what do both 104882176 104882176 numbers represent?

The first number represents the amount of data in that subvolume,
regardless whether that data is shared with other subvolumes or
not.
The second number shows the amount of data that is unique to this
subvolume and not shared with others, i.e. the amount of space
that will get freed if you delete this subvolume.
For how this extends to quota groups see http://sensille.com/qgroups.pdf

> 
> - how can I verify the quota assigned to any given subvolume? I've assigned 200 MB, but how can I verify that number?

The original patch set didn't include commands for that, but I
think I've seen patches for it on the mailing list, though I
can't find them right now.

-Arne

> 
> 

