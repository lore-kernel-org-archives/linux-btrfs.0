Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:48279 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab3ACUSD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jan 2013 15:18:03 -0500
Subject: Re: fsck.btrfs
References: <50D5B92D.105@czarc.net> <20121222142733.GR19051@carfax.org.uk> <20130103190757.GK9195@lenny.home.zabbo.net>
From: Eric Sandeen <esandeen@redhat.com>
Content-Type: text/plain;
	charset=us-ascii
In-Reply-To: <20130103190757.GK9195@lenny.home.zabbo.net>
Message-Id: <8CE888D2-CF85-4145-B3CF-A033EE62F88A@redhat.com>
Date: Thu, 3 Jan 2013 15:17:50 -0500 (EST)
To: Zach Brown <zab@zabbo.net>
Cc: Hugo Mills <hugo@carfax.org.uk>, Gene Czarcinski <gene@czarc.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Jan 3, 2013, at 1:08 PM, Zach Brown <zab@zabbo.net> wrote:

>>> 1. Would btrfsck be the appropriate program to run at bootup?  If it
>>> is, with what parameters?
>> 
>>   No, it's not necessary to run an fs checker on every boot. You can
>> either turn off the checks in fstab, or symlink /sbin/fsck.btrfs to
>> /bin/true.
> 
> For what it's worth, I gather that the XFS guys used to do the latter
> and that it broke something.  Somewhere.  I have no idea what.
> 

Yeah, lost in the mists of time by now.

Seems like maybe by now system installers should set up fstab correctly for a journaling ds, but since ext[34] wants boot-time fsck despite journaling, maybe it's best to provide a fsck.$FS even if it's a no-op.

> Hence fsck.xfs(8) which has perhaps the greatest description in its man
> page. 
> 
\o/ 

-Eric

> - z
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
