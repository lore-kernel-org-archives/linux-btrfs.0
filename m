Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f51.google.com ([209.85.219.51]:37056 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab3BZA7v (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 19:59:51 -0500
Received: by mail-oa0-f51.google.com with SMTP id h2so4178253oag.24
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2013 16:59:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPF83msjTJWjWJgJOAWsQ2GoxAC-cZ4GkK_+H11tAyA689KD_w@mail.gmail.com>
References: <CAPF83msjTJWjWJgJOAWsQ2GoxAC-cZ4GkK_+H11tAyA689KD_w@mail.gmail.com>
Date: Tue, 26 Feb 2013 00:59:50 +0000
Message-ID: <CAMU1PDhQqm6s5FUbVJa5nwOD4Ewf-6Cr2gx2khHHwrBxUqsQDA@mail.gmail.com>
Subject: Re: lvm volume like support
From: Mike Fleetwood <mike.fleetwood@googlemail.com>
To: Suman C <schakrava@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 25 February 2013 23:35, Suman C <schakrava@gmail.com> wrote:
> Hi,
>
> I think it would be great if there is a lvm volume or zfs zvol type
> support in btrfs. As far as I can tell, there's nobody actively
> working on this feature. I want to know what the core developers think
> of this feature, is it technically possible? any strong opinions?
> implementation ideas?
>
> I'd be happy to work towards this feature, but want your feedback
> before proceeding.

Btrfs already has capabilities to add and remove block devices on the
fly.  Data can be stripped or mirrored or both.  Raid 5/6 is in
testing at the moment.
https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices
https://btrfs.wiki.kernel.org/index.php/UseCases#RAID

Which specific features do you think btrfs is lacking?

Mike
