Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from y235201.ppp.asahi-net.or.jp ([118.243.235.201]:56438 "EHLO
	mactop" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751128Ab3KZHxY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Nov 2013 02:53:24 -0500
Received: from [10.81.1.3] (mydomain.com [10.81.1.3])
	by mactop (Postfix) with ESMTP id D08665FA99
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Nov 2013 16:53:22 +0900 (JST)
Message-ID: <52945372.4050605@parallels.com>
Date: Tue, 26 Nov 2013 16:53:22 +0900
From: dima <dolenin@parallels.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: missing /sbin/fsck.btrfs
References: <13F547BC-D81C-45FB-9DC8-9C076B8605EF@colorremedies.com> <pan$8f316$eba9671d$d7cae9b2$d1c7e678@cox.net>
In-Reply-To: <pan$8f316$eba9671d$d7cae9b2$d1c7e678@cox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/26/2013 04:18 PM, Duncan wrote:
> Chris Murphy posted on Mon, 25 Nov 2013 23:40:49 -0700 as excerpted:
>
>> Is there supposed to be an /sbin/fsck.btrfs? I'm seeing a handful of
>> threads indicating some idea of having it just do a no-op like fsck.xfs
>> does, but then also the idea that /etc/fstab should correctly set
>> fs_passno to 0 instead of such trickery.
>>
>> I ask due to systemd-fstab-generator seemingly getting the idea from
>> Fedora 20's default /etc/fstab that btrfs should have its file system
>> checked, and during offline  updates, systemd tries to do this, doesn't
>> find /sbin/fsck.btrfs, and then has several dozen fits.
>>
>> https://bugzilla.redhat.com/show_bug.cgi?id=1034563
>> https://bugzilla.redhat.com/show_bug.cgi?id=862871
>>
>> So the question, is there supposed to be (one day) a faux
>> /sbin/fsck.btrfs? Or should things always check /etc/fstab fs_passno and
>> honor the fact there is really no such thing?
>
> Just symlink/copy fsck.btrfs to (/bin/)true.
>
> https://btrfs.wiki.kernel.org/index.php/FAQ#What.27s_the_difference_between_btrfsck_and_fsck.btrfs
>
> Or just do the /etc/fstab fs_passno = 0 thing, which is what I did with
> reiserfs, so no change in that regard here when I switched to btrfs
> for most partitions.
>
> But I'm on gentoo and haven't opted to drink the systemd koolaid yet,
> so what it thinks about that I wouldn't know.
>

I think it is better to symlink to true, because otherwise mkinitramfs 
in the default configuration will be complaining about the missing hook 
(can be ignored of course)
