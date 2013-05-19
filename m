Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40804 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950Ab3ESRTP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 May 2013 13:19:15 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Ue7GI-00051j-5g
	for linux-btrfs@vger.kernel.org; Sun, 19 May 2013 19:19:10 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 19 May 2013 19:19:10 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 19 May 2013 19:19:10 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: Virtual Device Support
Date: Sun, 19 May 2013 18:18:59 +0100
Message-ID: <knb1hu$iur$1@ger.gmane.org>
References: <518CFE3A.3080900@chinilu.com> <knabiu$akg$1@ger.gmane.org> <5198E688.30402@chinilu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <5198E688.30402@chinilu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

OK, so to summarise:


On 19/05/13 15:49, George Mitchell wrote:
> In reply to both of these comments in one message, let me give you an
> example.
> 
> I use shell scripts to mount and unmount btrfs volumes for backup
> purposes.  Most of these volumes are not listed in fstab simply because
> I do not want to have to clutter my fstab with volumes that are used
> only for backup.  So the only way I can mount them is either by LABEL or
> by UUID.  But I can't unmount them by either LABEL or UUID because that
> is not supported by util-linux and they have no intention of supporting
> it in the future.  So I have to resort to unmounting by directory ...

Which all comes to a way of working...

Likewise, I have some old and long used backups scripts that mount a
one-of-many backups disk pack. My solution is to use filesystem labels
and to use 'sed' to update just the one line in /etc/fstab for the
backups mount point label so that the backups are then mounted/unmounted
by the mount point.

I've never been able to use the /dev/sdXX numbering because the multiple
physical drives can be detected in a different order.

Agreed, that for the sake of good consistency, being able to unmount by
filesystem label is a nice/good idea. But is there any interest for that
to be picked up? Put in a bug/feature request onto bugzilla?


I would guess that most developers focus on mount point and let
fstab/mtab sort out the detail...

Regards,
Martin

