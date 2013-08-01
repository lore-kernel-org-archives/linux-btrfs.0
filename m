Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:39845 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318Ab3HAKxi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Aug 2013 06:53:38 -0400
Received: by mail-wi0-f173.google.com with SMTP id en1so6537459wid.12
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Aug 2013 03:53:37 -0700 (PDT)
Received: from [192.168.0.103] (cpc2-hawk4-0-0-cust102.18-1.cable.virginmedia.com. [82.38.233.103])
        by mx.google.com with ESMTPSA id w4sm2906604wia.9.2013.08.01.03.53.35
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Thu, 01 Aug 2013 03:53:35 -0700 (PDT)
Message-ID: <51FA3E2E.30405@gmail.com>
Date: Thu, 01 Aug 2013 11:53:34 +0100
From: Andrew Stubbs <andrew.stubbs@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: How to merge two partitions?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If I have two partitions, /dev/sda1 and /dev/sda2, one btrfs, and one 
ext4 (but I could convert it first), how can I merge them into one 
filesystem without moving all the data onto an external device and then 
moving it all back again? (I do have a backup, of course, but 
transferring the data takes hours, maybe days.)

I'm left with this layout for historical reasons, and now the smaller 
partition is close to running out of space.

I thought of using "btrfs device add" and just living with the untidy 
underlying devices, but an experiment with loopback filesystems shows 
that any data on the new device is silently obliterated (it might be 
nice if the docs mentioned this!)

I've thought of shrinking the larger partition, creating a third 
partition, and adding that to the smaller filesystem. This would solve 
the free-space issue, but doesn't feel great.

I've thought of using a temporary third partition as an intermediary, 
but I don't have space to move all the data in one go.

I've thought of using a clever partition manager to move the start of 
the second partition, transfer some data, move it some more, transfer 
some more data, but this seems like an equally lengthy process.

I could move the data from the smaller partition into the larger one, 
then delete the first partition, and move the whole larger partition 
forward, extend it, and fix up the fstab. That might be less painful.

Is there a cunning btrfs trick to do this? Can a btrfs filesystem be 
extended "backwards", if you see what I mean?

Any other ideas? Comments?

Thanks in advance

Andrew
