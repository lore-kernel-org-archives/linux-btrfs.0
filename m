Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:35759 "EHLO
	mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458AbbHYT6u (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 15:58:50 -0400
Received: by vkfi73 with SMTP id i73so79473071vkf.2
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2015 12:58:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55DCAD07.1020500@gmail.com>
References: <1440516154.040713246@apps.rackspace.com>
	<CAJCQCtTSU08EjVrYGyL5TuXsEtTEmkAkpZ4XjM5rMXVZLQsjPA@mail.gmail.com>
	<55DCAD07.1020500@gmail.com>
Date: Tue, 25 Aug 2015 13:58:49 -0600
Message-ID: <CAJCQCtSruXgXGm7ZDtYwXJ_eM9Opp69wcbEykmWMXxDzdK8dbg@mail.gmail.com>
Subject: Re: Response to Bcachefs Claims
From: Chris Murphy <lists@colorremedies.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 25, 2015 at 11:59 AM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2015-08-25 12:39, Chris Murphy wrote:

>> The one problem case I still have with the latest versions is multiple
>> device Btrfs volume UUID doesn't exist when 1 or more devices are
>> missing.
>
> I've seen this myself, but only sometimes.  Based on my own testing, it only
> seems to happen when one of the disks with a system chunk on it is missing
> (for example, in a 3 device raid1 setup, one of the disks won't have a
> system chunk on it, and if disk goes missing, I can still mount by UUID
> fine).

I'm virtually certain I've reproduced this with a 2 disk raid1, both
should have system chunks. Separately, it seems to me that every disk
should have a copy of the system chunk, i.e. make it fixed as either
DUP on single or n-copies raid1 when on multiple devices. *shrug*



-- 
Chris Murphy
