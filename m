Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from postler.lichtfels.com ([78.46.92.195]:59768 "EHLO
	postler.lichtfels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbaGHUuJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jul 2014 16:50:09 -0400
Received: from localhost (localhost [127.0.0.1])
	by postler.lichtfels.com (Postfix) with ESMTP id 250EB110F3
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Jul 2014 22:50:08 +0200 (CEST)
Received: from postler.lichtfels.com ([127.0.0.1])
 by localhost (postler.lichtfels.com [127.0.0.1]) (amavisd-maia, port 10024)
 with LMTP id 29369-02 for <linux-btrfs@vger.kernel.org>;
 Tue,  8 Jul 2014 22:50:07 +0200 (CEST)
Received: from [IPv6:2001:15c0:65ff:8742:b1a7:4d02:67f6:580e] (unknown [IPv6:2001:15c0:65ff:8742:b1a7:4d02:67f6:580e])
	(using TLSv1 with cipher ECDHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by postler.lichtfels.com (Postfix) with ESMTPSA id CD9B5110F1
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Jul 2014 22:50:06 +0200 (CEST)
Message-ID: <53BC597D.3030107@xunil.at>
Date: Tue, 08 Jul 2014 22:50:05 +0200
From: "Stefan G. Weichinger" <lists@xunil.at>
Reply-To: lists@xunil.at
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs and mount in gentoo linux
References: <53BC4172.8080300@xunil.at> <A8D31CAA-14AC-407E-96BB-34E0ACF7F452@colorremedies.com>
In-Reply-To: <A8D31CAA-14AC-407E-96BB-34E0ACF7F452@colorremedies.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 08.07.2014 22:20, schrieb Chris Murphy:
> 
> On Jul 8, 2014, at 1:07 PM, Stefan G. Weichinger <lists@xunil.at> wrote:
>>
>> Can you tell me where the problem/solution might be located?
>> Is it a known behavior in a way … ?
> 
> It's known. Ubuntu has a patch so that mount shows subvolume names. 
> This information is probably available on Gentoo with cat /proc/self/mountinfo.


Unfortunately no.

See example from my laptop:

# grep btrfs /proc/self/mountinfo
14 0 0:14 /rootfs / rw,noatime shared:1 - btrfs /dev/sda3
rw,compress=lzo,ssd,space_cache

51 14 0:14 / /mnt/uncow rw,noatime shared:19 - btrfs /dev/sda3
rw,compress=lzo,ssd,space_cache

156 14 0:35 / /home/sgw rw,noatime shared:117 - btrfs
/dev/mapper/_dev_sda4 rw,compress=lzo,ssd,space_cache


for reference: the subvols are:

# btrfs su list /
ID 256 gen 7982 top level 5 path rootfs
ID 275 gen 3972 top level 5 path __snapshots
ID 283 gen 3274 top level 275 path __snapshots/rootfs_2014_06_14
ID 288 gen 7465 top level 5 path uncow


What does the Ubuntu patch apply to? util-linux?

Thanks! Stefan

