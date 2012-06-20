Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:58554 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757423Ab2FTRR7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jun 2012 13:17:59 -0400
Message-ID: <4FE205CF.9020509@libero.it>
Date: Wed, 20 Jun 2012 19:18:07 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Alexander Block <ablock84@googlemail.com>
CC: linux-btrfs@vger.kernel.org, dave@jikos.cz, hch@infradead.org,
        linux-fsdevel@vger.kernel.org, chris.mason@fusionio.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow cross subvolume reflinks (2nd attempt)
References: <1340188512-5761-1-git-send-email-ablock84@googlemail.com>
In-Reply-To: <1340188512-5761-1-git-send-email-ablock84@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Alexander,

On 06/20/2012 12:35 PM, Alexander Block wrote:
> The patch also does proper vfs mount checks, so cross mount 
> point reflinks are not possible with this patch. It only allows cross 
> reflinks between two subvolumes which are in the same mount point.

Thanks for working on that. What happens if two subvolumes of the same
filesystem are mounted on two different places ?

I usually do:
 mount -o subvol=__active /dev/sdX /
 mount -o subvol=.        /dev/sdX /var/btrfs

So two different subvolumes of the same filesystem (the one on /dev/sdX)
are mounted on two different places.

Is it possible to do
 cp --reflink /tmp/foo /var/btrfs/tmp/foo2

Thanks
G.Baroncelli

