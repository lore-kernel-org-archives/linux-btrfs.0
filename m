Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:14195 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757521Ab3KHVtj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Nov 2013 16:49:39 -0500
Date: Fri, 08 Nov 2013 22:49:36 +0100
From: yzb3@wp.pl
To: Shridhar Daithankar <ghodechhap@ghodechhap.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Odp: Re: Btrfs might be gradually slowing the boot process
Message-ID: <527d5c70932ee4.70951641@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, November 08, 2013 07:35:18 PM yzb3@wp.pl wrote:
> Hello,
> 
> I recently noticed that my boot has become slower - it took around 29s,
> while at the beginning it was ~6s. I thought it was an issue with systemd,
> because it failed to properly indicate at which stage the slowdown occurred
> and how long it took. I rolled back to a pretty fresh root subvolume and
> the boot was fast again. However, after several reboots it started lagging
> again (10s? preposterous!). I decided to try the *clear_cache* mount
> option; it was only a guess, but it did speed the boot to the proper ~6s.
> 
> The question is - why? My filesystem is really small - I see no reason 
for a
> 5x boot slowdown. Is this a known issue? I will be glad to give any
> additional details about my fs.

>> Have you tried defragmenting everything, including directory objects? despite 
>> of small amount of data, it could be massively fragmented, slowing down 
>> everything.
>> 
>> HTH

Would the problem have disappeared by just clearing the cache if there were so many extents? I remember that the defrag is not recursive - can you tell me how to make it process everything? Or to just list the number of extents? In the meantime this is the output of btrfs fi df /:

Data: total=49.01GB, used=48.53GB
System, DUP: total=8.00MB, used=12.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=1.00GB, used=515.11MB
Metadata: total=8.00MB, used=0.00

and df -h

Filesystem      Size  Used Avail Use% Mounted on
/dev/sda2       932G   50G  881G   6% /
dev             3,9G     0  3,9G   0% /dev
run             3,9G  560K  3,9G   1% /run
tmpfs           3,9G  136K  3,9G   1% /dev/shm
tmpfs           3,9G     0  3,9G   0% /sys/fs/cgroup
tmpfs           3,9G  8,0K  3,9G   1% /tmp
/dev/sda2       932G   50G  881G   6% /home


