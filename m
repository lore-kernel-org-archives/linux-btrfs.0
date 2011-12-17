From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: speeding up slow btrfs filesystem
Date: Sat, 17 Dec 2011 13:00:29 +0100
Message-ID: <201112171300.29833.Martin@lichtvoll.de>
References: <201112161851.52011.Martin@lichtvoll.de> <201112172211.25456.chris@csamuel.org> (sfid-20111217_121719_705910_719A3D83)
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Cc: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201112172211.25456.chris@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 17. Dezember 2011 schrieb Chris Samuel:
> On Sat, 17 Dec 2011 04:51:51 AM Martin Steigerwald wrote:
> > Currently I have:
> > 
> > deepdance:~> cat /proc/version
> > Linux version 3.0.0-2-686-pae (Debian 3.0.0-6)
> 
> You are using a fairly old kernel btrfs-wise, I believe there's been
> work done in the 3.2 rc's to improve performance so I'd suggest it's
> well worth testing with 3.2-rc6 to see whether that helps.

I am now using 3.2-rc4 from Debian package already. Currently I do not 
build own kernels.

I have the subjective impression that after the initial rebuild of the 
inode cache it became faster.

I have the following mount options:

deepdance:~> grep btrfs /proc/mounts
/dev/mapper/deepdance-debian / btrfs rw,relatime,space_cache,inode_cache 0 
0
/dev/mapper/deepdance-home /home btrfs rw,relatime,space_cache,inode_cache 
0 0

Might be good to use noatime for harddisks as well.

BTW on my ThinkPad T520 I do not perceive performance issues for BTRFS as 
/. But then thats located on an Intel SSD 320 where seeks should not 
matter much.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
