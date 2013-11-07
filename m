Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38306 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753596Ab3KGXkF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Nov 2013 18:40:05 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VeZBD-0001NT-IN
	for linux-btrfs@vger.kernel.org; Fri, 08 Nov 2013 00:40:03 +0100
Received: from gw.stenroth.fi ([188.127.202.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Nov 2013 00:40:03 +0100
Received: from ilari.stenroth by gw.stenroth.fi with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Nov 2013 00:40:03 +0100
To: linux-btrfs@vger.kernel.org
From: Ilari Stenroth <ilari.stenroth@gmail.com>
Subject: Re: kernel BUG at fs/btrfs/ctree.c:2964!
Date: Fri, 08 Nov 2013 01:35:07 +0200
Message-ID: <l5h830$qog$1@ger.gmane.org>
References: <9373586.6792.1377013412620.JavaMail.root@mail.placs.net> <22207009.1532.1383352121296.JavaMail.root@mail.placs.net> <20131102013433.GF16855@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <20131102013433.GF16855@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2.11.2013 3.34, Josef Bacik wrote:
> 
> On this box can you run
> 
> gdb btrfs.ko
> list *(__btrfs_drop_extents+0x59d)
> 
> I want to know where exactly this is coming from so I can start trying to figure
> out how it's happening.  Thanks,

Hi,

I've got the same issue. Btrfs FS crashes on my box running Linux 3.11.7.

It seems that the crash happens when I start collectd daemon. Maybe a
corrupted RRD file somewhere.
I don't have time for debugging this issue further so I'm going to
re-format this box to ext4. Btrfs is statically compiled in kernel so
I'm unable to gdb btrfs.ko. No debug info in kernel image. Sorry not
being able to help.

/dev/sda2 on / type btrfs (rw,noatime,nodiratime,ssd,space_cache)

Mount options used to have also autodefrag but I removed it while hoping
it would make the box more stable.

# btrfs fi show
Label: 'root'  uuid: 87943e37-a134-4b8d-bcf2-989334d23b75
	Total devices 2 FS bytes used 6.22GB
	devid    2 size 10.00GB used 9.98GB path /dev/sdb2
	devid    1 size 10.00GB used 10.00GB path /dev/sda2


# btrfs fi df /
Data, RAID1: total=8.97GB, used=5.99GB
Data: total=8.00MB, used=0.00
System, RAID1: total=8.00MB, used=4.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=1.00GB, used=234.92MB
Metadata: total=8.00MB, used=0.00

A screen grab from the console after the crash happened:
http://s3-eu-west-1.amazonaws.com/ilari.stenroth/btrfs-crash-201311/Screen+Shot+2013-11-07+at+9.19.27.png

--
Ilari Stenroth


