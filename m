Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-server.com ([216.13.78.11]:52453 "EHLO smtp-server.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453Ab2LPXVy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Dec 2012 18:21:54 -0500
Received: from [192.168.1.104] (dynamic-adsl-78-13-211-5.clienti.tiscali.it [78.13.211.5])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client did not present a certificate)
	by smtp-server.com (Postfix) with ESMTP id B0FEB17BA27
	for <linux-btrfs@vger.kernel.org>; Sun, 16 Dec 2012 23:21:52 +0000 (UTC)
Message-ID: <50CE578D.9080701@libero.it>
Date: Mon, 17 Dec 2012 00:21:49 +0100
From: Claudio Carbone <erupter@libero.it>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: unmountable partition and live distro (no space left)
References: <50CDCFD1.5000304@libero.it> <50CDF3ED.8060601@libero.it> <CAE5mzviNM9w_q7WSZJ_S7J9rTXUgW=qbPLuYgVAHBP5zUNybog@mail.gmail.com>
In-Reply-To: <CAE5mzviNM9w_q7WSZJ_S7J9rTXUgW=qbPLuYgVAHBP5zUNybog@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 16/12/12 21:40, cwillu wrote:
> Try booting with bootflags=ro,recovery in grub (with the latest
> possible kernel), or mounting with -o recovery from the livecd
> (likewise).  If it works, then you're done, you should be able to boot
> normally after a clean umount and shutdown.  If it doesn't, post dmesg
> from the attempt.

Already tried mounting with -o recovery to no avail.
>
>> I'v been told this is missing relevant details.
>> The original kernel version was 3.2.0-something (standard Ubuntu 12.04 LTS).
>> I've since upgraded to 3.7 but this has made no difference.
>> Right now I don't have the dmesg, I'll post it later.
>>
>> Currently I've been able to mount the partition with btrfs-restore and am
>> trying to rsync it on another ext4 volume.
> Terminology note: btrfs-restore doesn't "mount" anything, it just
> copies files directly from a device.
I didn't know that at the time of writing.
Here is the btrfsck log
https://www.dropbox.com/s/pwmj2t9kvy6sqpc/btrfs_log.txt

Claudio
