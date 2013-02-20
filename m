Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:37996 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934944Ab3BTPfb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Feb 2013 10:35:31 -0500
Received: by mail-we0-f172.google.com with SMTP id x10so6864198wey.17
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Feb 2013 07:35:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130220151227.GA27541@twin.jikos.cz>
References: <20130220142612.GA2062@localhost.localdomain>
	<20130220151227.GA27541@twin.jikos.cz>
Date: Wed, 20 Feb 2013 17:35:30 +0200
Message-ID: <CAOcd+r3Qk+bAAS3ZVzF826MPpSEFHe5Z1U8vMFKwPJyVUw-qTA@mail.gmail.com>
Subject: Re: LAST CALL FOR BTRFS-NEXT
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,
can you please consider including these two patches from Jan 28:
https://patchwork.kernel.org/patch/2057051/
https://patchwork.kernel.org/patch/2057071/

I realize they have "V2" label, although the cover letter had "V3",
this was my bad. However, they both apply to what you have now in
btrfs-next.

Thanks,
Alex.


On Wed, Feb 20, 2013 at 5:12 PM, David Sterba <dsterba@suse.cz> wrote:
> Please add this patch to next queue
>
> btrfs: limit fallocate extent reservation to 256MB
> https://patchwork.kernel.org/patch/1752311/
>
> Tested-by: David Sterba <dsterba@suse.cz>
>
> thanks,
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
