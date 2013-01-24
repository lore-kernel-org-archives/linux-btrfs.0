Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:28486 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934Ab3AXPO1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jan 2013 10:14:27 -0500
Message-ID: <51014FCF.7080202@gmx.net>
Date: Thu, 24 Jan 2013 16:14:23 +0100
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Jerome M <jmwdev38@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Quota reached: can't delete
References: <CAEgy6-3jQ3nkFqY-eJj86vDSsfZQ2naiA-VoMw-U-TPaBd3Pew@mail.gmail.com>
In-Reply-To: <CAEgy6-3jQ3nkFqY-eJj86vDSsfZQ2naiA-VoMw-U-TPaBd3Pew@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 24.01.2013 16:12, Jerome M wrote:
> Hi,
> 
> With the current btrfs quota implementation, when you reach a
> subvolume quota limit, you can't delete anything without first
> removing the limit or enlarge it:
> 
> rm: cannot remove `testfile.bin': Disk quota exceeded
> 
> 
> Is there any plan to change that?

Yes, there is. The problem is that even deletion needs space.
So we need to allow remove to go over quota. The current implementation
doesn't make this distinction.

-Arne

> 
> Thanks,
> Jerome
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

