Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:52295 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab2F1NIH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jun 2012 09:08:07 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/5] introduce btrfs filesystem property command
Date: Thu, 28 Jun 2012 15:08:05 +0200
Cc: Alexander Block <ablock84@googlemail.com>
References: <1340572808-30281-1-git-send-email-ablock84@googlemail.com> (sfid-20120625_001408_888285_D9EDB3FF)
In-Reply-To: <1340572808-30281-1-git-send-email-ablock84@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201206281508.05594.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 24. Juni 2012 schrieb Alexander Block:
> This patchset introduces the btrfs filesystem property command. It is
> the result of a discussion we had on IRC. I tried to make the
> properties interface as generic and extensible as possible. Comments
> are welcome.
> 
> Currently the command looks like this:
> btrfs fi prop /path/to/object [name[=value]]
> 
> Some people may prefer other forms. For example I got suggestions for
> these forms:
> btrfs set/get /path/to/object [name [value]]
> btrfs prop /pach/to/object [name[=value]] (and also without the =)
> 
> I'm open to more suggestions and a discussion on this. I'm definitely

I wonder about a way to find out directly

1) size of node and leaf metadata blocks

2) whether inode cache is active

3) whether space cache is active

Would also be nice to be able to set this. I do not know whether this is 
possible re 1 during a balance for example. Re 2 and 3 it would be nice to 
be able to skip the mount options in /etc/fstab. AFAIK space cache is 
permanent anyway, but inode cache isn´t or vice versa.

Either way I find the current way BTRFS handles options via mount options a 
bit confusion.

I´d like some way to set attributes / flags permanently like in Ext4 via 
tune2fs or xfs_admin.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
