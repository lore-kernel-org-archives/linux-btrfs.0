Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f41.google.com ([209.85.213.41]:35803 "EHLO
	mail-vk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbbHARcu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Aug 2015 13:32:50 -0400
Received: by vkhg129 with SMTP id g129so30590136vkh.2
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Aug 2015 10:32:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABozSb+L4iDwALP8=uvTM-CLTnN1otkW8vK0oHKU9UX8j74jWg@mail.gmail.com>
References: <CABozSb+L4iDwALP8=uvTM-CLTnN1otkW8vK0oHKU9UX8j74jWg@mail.gmail.com>
Date: Sat, 1 Aug 2015 11:26:14 -0600
Message-ID: <CAJCQCtR_2+ufz4FEM5AmhgBYwJttHKbmJYv85n20iYjqJGG0ig@mail.gmail.com>
Subject: Re: Filesystem unmountable
From: Chris Murphy <lists@colorremedies.com>
To: Cornelius van Rooyen <nexusdk@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There appears to be some regressions in btrfs-convert that are in the
list archive over the last month in particular - but I think the
problems particularly started to surface about 6ish months ago. When I
filed the bugs I was seeing with converted ext4 file systems, they
were completely consistently reproducible. But then I went back a few
days later to the same source qcow2 that I was snapshotting (qcow2
snapshot, not a btrfs snapshot) to do the testing, and the problem did
not always trigger. But fortunately Qu has reproduced this and is
working on it.

In your case it might be possible to mount with ro,recovery and get
data off of it. Or you might have to resort to btrfs restore if it's
badly broken and at least get /home data out of it.  If you have
backups, it's easier to just obliterate it and start over, unless you
want to experiment and learn more with btrfs restore...


Chris Murphy
