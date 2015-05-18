Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46541 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751459AbbERBcb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 May 2015 21:32:31 -0400
Message-ID: <5559412B.3040102@cn.fujitsu.com>
Date: Mon, 18 May 2015 09:32:27 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>, <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs and integration with GNU ++
References: <1761734734.45679.1431891207641.JavaMail.zimbra@karlsbakk.net>
In-Reply-To: <1761734734.45679.1431891207641.JavaMail.zimbra@karlsbakk.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



-------- Original Message  --------
Subject: Btrfs and integration with GNU ++
From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
To: <linux-btrfs@vger.kernel.org>
Date: 2015年05月18日 03:33

> Hi all
>
> First of all, thanks for the good work. I first started looking into btrfs some six years back, and things are a lot better now. I just wonder about a few things…
>
> For btrfs to be accepted as a primary filesystem in major distros, I'd think it should integrate with existing tools. Currently, df seems to show good data, while du doesn't. I've been working with ZFS for some time, and there du will show data on disk and du --apparent-size will show how much apparently is on disk according to file sizes. I beleive this only acconuts for compression (not dedup, which I don't use), but still it's neat. Also, lsblk works well with md, showing which md device each device belongs to, while in btrfs land, it only shows the device from /proc/mounts that appear to be mounted. Again, mount should IMHO show btrfs information and not just the some device in the btrfs filesystem.
>
> Lastly - I just did a small test on a 6 drive RAID-6, turned on compression and started cat /proc/zero > testfile - let this run until the filesize was 500GB and stopped it. Made some other test files and a copy of these with --reflink=auto just for kicks. rm test* and waited. While waiting, did a 'echo b > /proc/sysrq-trigger' and fsck started on bootup and took a minute or so to complete. Since the filesystem is rather small (6x8GB VDEVs on top of ZFS with SSD caching, kvm as hypervisor), I wonder how long this fsck job would take if it were on a system with, say, 6 4TB drives. RHEL/CentOS7 just moved to XFS to allow for system crashes without this hour-long fsck job, and I somewhat doubt that btrfs will be the chosen one if it requires the same amount of time as of ext4.
First, Btrfs, at least in theory, has no need to do fsck.
As the COW design makes it quite safe to sudden power lose.
You can explore your fsck.btrfs and will find that will do nothing, for 
the reason explained above.

Second, Btrfsck is not things like xfs/ext* fsck.
As btrfs is not based on journal, no dirty flag or things like that, 
btrfsck will *always* check all metadata.
So, at least for me, 1 minute is already quite fast for your 6X8TB.
You should compare the time with "fsck.ext* -f".

Thanks,
Qu
>
> Vennlig hilsen / Best regards
>
> roy
> --
> Roy Sigurd Karlsbakk
> (+47) 98013356
> http://blogg.karlsbakk.net/
> GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt
> --
> I all pedagogikk er det essensielt at pensum presenteres intelligibelt. Det er et elementært imperativ for alle pedagoger å unngå eksessiv anvendelse av idiomer med xenotyp etymologi. I de fleste tilfeller eksisterer adekvate og relevante synonymer på norsk.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
