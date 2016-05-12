Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:60155 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751402AbcELRl7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 May 2016 13:41:59 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailout.nyi.internal (Postfix) with ESMTP id BCEF3205A2
	for <linux-btrfs@vger.kernel.org>; Thu, 12 May 2016 13:41:58 -0400 (EDT)
Received: from ebox.rath.org (ebox.rath.org [45.79.69.51])
	by mail.messagingengine.com (Postfix) with ESMTPA id 83BCCC00019
	for <linux-btrfs@vger.kernel.org>; Thu, 12 May 2016 13:41:58 -0400 (EDT)
Received: from thinkpad.rath.org (thinkpad [192.168.12.2])
	by ebox.rath.org (Postfix) with ESMTPS id A6DB62A3D7A
	for <linux-btrfs@vger.kernel.org>; Thu, 12 May 2016 17:41:57 +0000 (UTC)
From: Nikolaus Rath <Nikolaus@rath.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: Input/output error on newly created file
References: <8760uoqjlt.fsf@vostro.rath.org> <878tzilhf3.fsf@vostro.rath.org>
	<87eg971dqf.fsf@thinkpad.rath.org> <58549996.M9MX6vESn9@archlinux>
Date: Thu, 12 May 2016 10:41:57 -0700
In-Reply-To: <58549996.M9MX6vESn9@archlinux> (Diego Calleja's message of "Thu,
	12 May 2016 18:17:50 +0200")
Message-ID: <8760uj18d6.fsf@thinkpad.rath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On May 12 2016, Diego Calleja <diegocg@gmail.com> wrote:
> El jueves, 12 de mayo de 2016 8:46:00 (CEST) Nikolaus Rath escribió:
>> *ping*
>> 
>> Anyone any idea?
>
> All I can say is that I've had the same problem in the past. In my
> case, the problematic files where active torrents. The interesting
> thing is that I was able to read them correctly up to a point, then
> I would get the same error as you. No messages in dmesg. The amount
> of data I was able to read from them was not random, it was
> something multiple of 4K. After reboot the problems went away and
> I wasn't able to reproduce it.
>
> There has been reports of similiar issues in the past:
> http://www.spinics.net/lists/linux-btrfs/msg52371.html

Thanks for the pointer. So according to these reports, the IO errors
happen with:


1. dm-crypt, LVM and mount options
   rw,noatime,compress=lzo,ssd,discard,space_cache,autodefrag,inode_cache
2. dm-crypt, no LVM, and mount options
   noatime,compress,nossd

I can add the following data point:

3. dm-crypt on LVM, and mount options
   relatime,compress=lzo


(Just to preserve this for the future)


Best,
-Nikolaus
-- 
GPG encrypted emails preferred. Key id: 0xD113FCAC3C4E599F
Fingerprint: ED31 791B 2C5C 1613 AF38 8B8A D113 FCAC 3C4E 599F

             »Time flies like an arrow, fruit flies like a Banana.«
