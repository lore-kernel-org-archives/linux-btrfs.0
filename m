Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from web4.novatel.si ([46.23.1.13]:44375 "EHLO web4.novatel.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933838AbaEFHAD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 May 2014 03:00:03 -0400
Received: from [192.168.200.152] (unknown [46.23.0.66])
	(Authenticated sender: blist@bss.si)
	by web4.novatel.si (Postfix) with ESMTPSA id D631342004D
	for <linux-btrfs@vger.kernel.org>; Tue,  6 May 2014 08:50:50 +0200 (CEST)
Message-ID: <5368860E.2010107@bss.si>
Date: Tue, 06 May 2014 08:49:50 +0200
From: Blaz Repas <blist@bss.si>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: 3.14.0rc3: did not find backref in send_root
References: <20140225063652.GD3521@merlins.org> <20140506061053.GA17689@davidb.org>
In-Reply-To: <20140506061053.GA17689@davidb.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/06/2014 08:10 AM, David Brown wrote:
> On Mon, Feb 24, 2014 at 10:36:52PM -0800, Marc MERLIN wrote:
>> I got this during a btrfs send:
>> BTRFS error (device dm-2): did not find backref in send_root. 
>> inode=22672, offset=524288, disk_byte=1490517954560 found 
>> extent=1490517954560
>>
>> I'll try a scrub when I've finished my backup, but is there anything I
>> can run on the file I've found from the inode?
>>
>> gargamel:/mnt/dshelf1/Sound# btrfs inspect-internal inode-resolve  -v 
>> 22672 file.mp3
>> ioctl ret=0, bytes_left=3998, bytes_missing=0, cnt=1, missed=0
>> file.mp3
>
> I've just seen this error:
>
>   BTRFS error (device sda4): did not find backref in send_root. 
> inode=411890, offset=307200, disk_byte=48100618240 found 
> extent=48100618240
>
> during a send between two snapshots I have.
>
> after moving to 3.14.2.  I've seen it on two filesystems now since
> moving to 3.14.  I have the two readonly snapshots if there is
> anything helpful I can figure out from them.
>
> Scrub reports no errors, but I don't seem to be able to back up
> anything now.
>
> David
> -- 

I am also seeing this on 3.14.1 (on ArchLinux). Scrub also reports no 
errors.
I could also not do a ful send. Balancing made it better for a while (I 
was able to send a full snapshot of one subvolume, but not another), but 
it did not help. Offline repairing the fs with btrfsck --repair also did 
not affect it.

Blaz

