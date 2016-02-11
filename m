Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7096 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751058AbcBKHQx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Feb 2016 02:16:53 -0500
Subject: Re: btrfs-image failure (btrfs-tools 4.4)
To: Marc MERLIN <marc@merlins.org>
References: <20160123170354.GA10113@merlins.org>
 <56A57C59.1040203@cn.fujitsu.com> <20160125205500.GK23751@merlins.org>
 <56A6C5CB.5060406@cn.fujitsu.com> <20160211063132.GX13969@merlins.org>
CC: David Sterba <dsterba@suse.cz>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56BC355F.1080305@cn.fujitsu.com>
Date: Thu, 11 Feb 2016 15:16:47 +0800
MIME-Version: 1.0
In-Reply-To: <20160211063132.GX13969@merlins.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Marc MERLIN wrote on 2016/02/10 22:31 -0800:
> On Tue, Jan 26, 2016 at 09:03:07AM +0800, Qu Wenruo wrote:
>> If the fs is small enough, would you please do a btrfs-image dump?
>> That would help a lot to locate the direct cause.
>
> I started making a dump, image was growing past 3GB, and then it failed
> and the image got deleted:
>
> gargamel:~# btrfs-image -s -c 9 /dev/mapper/dshelf1old /mnt/dshelf1/ds1old.dump
> Error adding space cache blocks -5

It seems that btrfs-image failed to read space cache, in 
read_data_extent() function.

And since there is no "Couldn't map the block XXXX" error message, 
either some device is missing or pread64 failed to read the desired data.

> Error flushing pending -5
> create failed (Success)
>
> gargamel:~# dpkg --status btrfs-tools
> Package: btrfs-tools
> Status: install ok installed
> Priority: optional
> Section: admin
> Installed-Size: 3605
> Maintainer: Dimitri John Ledkov <xnox@debian.org>
> Architecture: amd64
> Version: 4.4-1
>
> Is there a 4G file size limit, or did I hit another problem?

For the 4G file size limit, did you mean the limit from old filesystem 
like FAT32?

I didn't think there is such limit for modern Linux filesystem, or 
normal read/write operation won't has such limit either.

Thanks,
Qu

>
> Thanks,
> Marc
>


