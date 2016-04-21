Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f51.google.com ([209.85.213.51]:35657 "EHLO
	mail-vk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbcDUSoI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Apr 2016 14:44:08 -0400
Received: by mail-vk0-f51.google.com with SMTP id t129so109109634vkg.2
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Apr 2016 11:44:07 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 21 Apr 2016 14:44:07 -0400
Message-ID: <CAJtFHUQ-mW53pzVQ6wjsZPK2rGZM3w=QR2iXh_XeXAxMfMisWg@mail.gmail.com>
Subject: RE: btrfs forced readonly + errno=-28 No space left
From: E V <eliventer@gmail.com>
To: martin.svec@zoner.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>we use btrfs subvolumes for rsync-based backups. During backups btrfs often fails with "No >space
>left" error and goes to readonly mode (dmesg output is below) while there's still plenty of
>unallocated space

I have the same use case and the same issue with no real solution that
I've found. However, mounting nospace_cache greatly reduces the
problem. For me the frequency has gone from every other rsync giving
No space to about 1 in six, after which I delete some snapshots and
start again.
