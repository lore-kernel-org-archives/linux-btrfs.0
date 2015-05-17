Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [77.88.71.232] ([77.88.71.232]:48348 "EHLO zimbra.karlsbakk.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbbEQTdh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 May 2015 15:33:37 -0400
Received: from localhost (localhost [127.0.0.1])
	by zimbra.karlsbakk.net (Postfix) with ESMTP id 1C95B4EECC
	for <linux-btrfs@vger.kernel.org>; Sun, 17 May 2015 21:33:34 +0200 (CEST)
Received: from zimbra.karlsbakk.net ([127.0.0.1])
	by localhost (zimbra.karlsbakk.net [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id wvTVpe6efB8z for <linux-btrfs@vger.kernel.org>;
	Sun, 17 May 2015 21:33:31 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by zimbra.karlsbakk.net (Postfix) with ESMTP id A0B174EF5F
	for <linux-btrfs@vger.kernel.org>; Sun, 17 May 2015 21:33:31 +0200 (CEST)
Received: from zimbra.karlsbakk.net ([127.0.0.1])
	by localhost (zimbra.karlsbakk.net [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id nzAWPzH6LYuu for <linux-btrfs@vger.kernel.org>;
	Sun, 17 May 2015 21:33:31 +0200 (CEST)
Received: from zimbra.karlsbakk.net (zimbra.karlsbakk.net [77.88.71.232])
	by zimbra.karlsbakk.net (Postfix) with ESMTP id EB2414EED8
	for <linux-btrfs@vger.kernel.org>; Sun, 17 May 2015 21:33:28 +0200 (CEST)
Date: Sun, 17 May 2015 21:33:27 +0200 (CEST)
From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
To: linux-btrfs@vger.kernel.org
Message-ID: <1761734734.45679.1431891207641.JavaMail.zimbra@karlsbakk.net>
Subject: Btrfs and integration with GNU ++
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all

First of all, thanks for the good work. I first started looking into btrfs some six years back, and things are a lot better now. I just wonder about a few things…

For btrfs to be accepted as a primary filesystem in major distros, I'd think it should integrate with existing tools. Currently, df seems to show good data, while du doesn't. I've been working with ZFS for some time, and there du will show data on disk and du --apparent-size will show how much apparently is on disk according to file sizes. I beleive this only acconuts for compression (not dedup, which I don't use), but still it's neat. Also, lsblk works well with md, showing which md device each device belongs to, while in btrfs land, it only shows the device from /proc/mounts that appear to be mounted. Again, mount should IMHO show btrfs information and not just the some device in the btrfs filesystem.

Lastly - I just did a small test on a 6 drive RAID-6, turned on compression and started cat /proc/zero > testfile - let this run until the filesize was 500GB and stopped it. Made some other test files and a copy of these with --reflink=auto just for kicks. rm test* and waited. While waiting, did a 'echo b > /proc/sysrq-trigger' and fsck started on bootup and took a minute or so to complete. Since the filesystem is rather small (6x8GB VDEVs on top of ZFS with SSD caching, kvm as hypervisor), I wonder how long this fsck job would take if it were on a system with, say, 6 4TB drives. RHEL/CentOS7 just moved to XFS to allow for system crashes without this hour-long fsck job, and I somewhat doubt that btrfs will be the chosen one if it requires the same amount of time as of ext4.

Vennlig hilsen / Best regards

roy
--
Roy Sigurd Karlsbakk
(+47) 98013356
http://blogg.karlsbakk.net/
GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt
--
I all pedagogikk er det essensielt at pensum presenteres intelligibelt. Det er et elementært imperativ for alle pedagoger å unngå eksessiv anvendelse av idiomer med xenotyp etymologi. I de fleste tilfeller eksisterer adekvate og relevante synonymer på norsk.
