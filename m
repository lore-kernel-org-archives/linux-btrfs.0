Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33634 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbbFYQht (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jun 2015 12:37:49 -0400
Date: Thu, 25 Jun 2015 18:37:47 +0200
From: David Sterba <dsterba@suse.cz>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs filesystem show confused when label is same as mountpoint
Message-ID: <20150625163747.GM726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <557ADBAE.9040407@oracle.com>
 <1791793.W1h8pBaUgj@hoefnix>
 <pan$1585f$f9669c8c$f28f170$ac1741de@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$1585f$f9669c8c$f28f170$ac1741de@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 13, 2015 at 09:51:41AM +0000, Duncan wrote:
> Sjoerd posted on Sat, 13 Jun 2015 09:20:12 +0200 as excerpted:
> 
> > versus for label:
> > btrfs fi show MULTIMEDIA
> > Label: 'MULTIMEDIA'  uuid: ce5d23cd-73a4-4f7c-83cd-2c40d12f6697
> 
> Hmm... I wasn't even aware that you could /use/ label!  But sure enough, 
> it works here, too:
> 
> btrfs fi show rt0238gcnx+35l0
> Label: 'rt0238gcnx+35l0'  uuid: 8f8d79ef-a86f-4306-a255-e0519e0f6132
>         Total devices 2 FS bytes used 1.94GiB
>         devid    1 size 8.00GiB used 3.78GiB path /dev/sda5
>         devid    2 size 8.00GiB used 3.78GiB path /dev/sdb5
> 
> btrfs-progs v4.0.1
> 
> 
> It works for UUID as well...
> 
> btrfs fi show 8f8d79ef-a86f-4306-a255-e0519e0f6132
> Label: 'rt0238gcnx+35l0'  uuid: 8f8d79ef-a86f-4306-a255-e0519e0f6132
>         Total devices 2 FS bytes used 1.94GiB
>         devid    1 size 8.00GiB used 3.78GiB path /dev/sda5
>         devid    2 size 8.00GiB used 3.78GiB path /dev/sdb5
> 
> btrfs-progs v4.0.1
> 
> ... but that's a lot of arbitrary typing.
> 
> Doesn't work with partlabel or id (see /dev/disk/by-*), however. =:^(

The commandline tries to guess if it's label/uuid/path. If we want to
add support for partlabel and/or partuuid, we can't use the bare string,
but possibly the blkid tags, like

 $ btrfs fi show PARTUUID="8f8d79ef-a86f-4306-a255-e0519e0f6132"

