Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:34751 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259AbaAGFnn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Jan 2014 00:43:43 -0500
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id C2F1640E2D
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Jan 2014 16:43:42 +1100 (EST)
Received: from csamuel.org ([127.0.0.1])
 by localhost (csamuel.org [127.0.0.1]) (amavisd-maia, port 10024) with LMTP
 id 31133-02 for <linux-btrfs@vger.kernel.org>;
 Tue,  7 Jan 2014 16:43:42 +1100 (EST)
Received: from [128.250.103.244] (unknown [128.250.103.244])
	by csamuel.org (Postfix) with ESMTPSA id 41D9240E28
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Jan 2014 16:43:42 +1100 (EST)
Message-ID: <52CB940C.9010203@csamuel.org>
Date: Tue, 07 Jan 2014 16:43:40 +1100
From: Chris Samuel <chris@csamuel.org>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs raid1 and btrfs raid10 arrays NOT REDUNDANT
References: <52C73987.7000106@jrs-s.net> <52C87A41.9030701@jrs-s.net> <05C97109-682D-4A62-B074-4EDCF8E9CE1E@colorremedies.com> <1416119.lWHlh5idGF@quad> <C7E0F781-5F46-4C76-BCC9-0DE416553046@colorremedies.com> <52CB031C.7060403@jrs-s.net>
In-Reply-To: <52CB031C.7060403@jrs-s.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/01/14 06:25, Jim Salter wrote:

> FWIW, Ubuntu (and I presume Debian) will work just fine with a single /
> on btrfs, single or multi disk.
> 
> I currently have two machines booting to a btrfs-raid10 / with no
> separate /boot, one booting to a btrfs single disk / with no /boot, and
> one booting to a btrfs-raid10 / with an ext4-on-mdraid1 /boot.

Actually I've run into a problem with grub where a fresh install cannot
boot from a btrfs /boot if your first partition is not 1MB aligned
(sector 2048) then there is then not enough space for it to store its
btrfs code. :-(

https://bugs.launchpad.net/ubuntu/+source/grub-installer/+bug/1266195

I don't want to move my first partition as it's a Dell special (type
'de') and I'm not sure what the impact would be, so I just created an
ext4 /boot and the install then worked.

Regarding RAID, yes I realise it's easy to do post-fact, in fact on the
same test system I added an external USB2 drive to the root filesystem
and rebalanced as RAID-1, worked nicely.

I'm planning on adding dual SSDs as my OS disks to my desktop and this
experiment was to learn whether the Kubuntu installer handled it yet and
if not to do a quick practice of setting it up by hand. :-)

All the best,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
