Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from postler.lichtfels.com ([78.46.92.195]:59818 "EHLO
	postler.lichtfels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbaGHUwq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jul 2014 16:52:46 -0400
Received: from localhost (localhost [127.0.0.1])
	by postler.lichtfels.com (Postfix) with ESMTP id DAA84110F3
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Jul 2014 22:52:44 +0200 (CEST)
Received: from postler.lichtfels.com ([127.0.0.1])
 by localhost (postler.lichtfels.com [127.0.0.1]) (amavisd-maia, port 10024)
 with LMTP id 29198-04 for <linux-btrfs@vger.kernel.org>;
 Tue,  8 Jul 2014 22:52:43 +0200 (CEST)
Received: from [IPv6:2001:15c0:65ff:8742:b1a7:4d02:67f6:580e] (unknown [IPv6:2001:15c0:65ff:8742:b1a7:4d02:67f6:580e])
	(using TLSv1 with cipher ECDHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by postler.lichtfels.com (Postfix) with ESMTPSA id ED837110F1
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Jul 2014 22:52:42 +0200 (CEST)
Message-ID: <53BC5A1A.7020403@xunil.at>
Date: Tue, 08 Jul 2014 22:52:42 +0200
From: "Stefan G. Weichinger" <lists@xunil.at>
Reply-To: lists@xunil.at
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs and mount in gentoo linux
References: <53BC4172.8080300@xunil.at> <pan.2014.07.08.20.19.04@googlemail.com>
In-Reply-To: <pan.2014.07.08.20.19.04@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 08.07.2014 22:19, schrieb Holger Hoffstätte:
> 
> On Tue, 08 Jul 2014 21:07:30 +0200, Stefan G. Weichinger wrote:
> 
>> I am a happy btrfs-user with gentoo linux for some time now and noticed
>> that the command "mount" does not show me which subvolid is mounted where.
> 
> Interestingly I just found that this came up in Fedora some time ago:
> https://bugzilla.redhat.com/show_bug.cgi?id=743118
> 
> findmnt seems to do the trick, so the underlying functionality in
> libmnt seems to work. Maybe Debian's mount does something differently?

findmnt does not fully show the subvolids or names:


# findmnt  | grep btrfs
/                                /dev/sda3[/rootfs]    btrfs
rw,noatime,compress=lzo,ssd,space_cache
├─/mnt/uncow                     /dev/sda3             btrfs
rw,noatime,compress=lzo,ssd,space_cache
└─/home/sgw                      /dev/mapper/_dev_sda4 btrfs
rw,noatime,compress=lzo,ssd,space_cache

The "[/rootfs]" is something in the right direction ...

S
