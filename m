Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:33574 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619Ab2IZNAm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Sep 2012 09:00:42 -0400
Date: Wed, 26 Sep 2012 09:00:39 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Ahmet Inan <ainan@mathematik.uni-freiburg.de>
CC: Josef Bacik <JBacik@fusionio.com>, David Sterba <dave@jikos.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: ENOSPC design issues
Message-ID: <20120926130039.GB2328@localhost.localdomain>
References: <20120920190306.GG2272@localhost.localdomain>
 <20120925164335.GZ14582@twin.jikos.cz>
 <20120925170239.GA2328@localhost.localdomain>
 <CAFDW0jLuvH9rMisDz-Y=Y_nwxzzO5K64uixd6mAiaQRmja3izA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAFDW0jLuvH9rMisDz-Y=Y_nwxzzO5K64uixd6mAiaQRmja3izA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 26, 2012 at 01:55:47AM -0600, Ahmet Inan wrote:
> when testing, please also do something like this:
> 
> # create big squashfs image somewhere:
> # mksquashfs / /big.img -noappend -no-sparse -e big.img
> 
> # then unpack into fresh filesystem with (and no) compression:
> # unsquashfs -f -d /subvol /big.img
> 
> this is how i was always able to trigger ENOSPC while trying to
> make a full system installation from squashfs image.
> 
> you should also try different compression algos (i only use lzo)
> 
> btw: i was able to trigger ENOSPC with for-linus on 3.5.4 on a
> i686 Pentium M Notebook with only 1GB of Memory and
> fresh FSthis way, otherwise havent seen ENOSPC for long time.
> 

Thanks I will try that now,

Josef
