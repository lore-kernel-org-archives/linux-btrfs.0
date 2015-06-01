Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:36298 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbbFATNF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jun 2015 15:13:05 -0400
Received: by ieclw1 with SMTP id lw1so21338016iec.3
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Jun 2015 12:13:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG3t+pEHqATjGFUQrLn__O5-ByW4oX6MWjQiYh9GpgfqdKKiyg@mail.gmail.com>
References: <mkhjkp$hgl$1@ger.gmane.org>
	<CAJCQCtSSt623v-M6wvRUt7vbkd9qkKPnS7guMgCKDxJd+C9rtw@mail.gmail.com>
	<CAG3t+pEHqATjGFUQrLn__O5-ByW4oX6MWjQiYh9GpgfqdKKiyg@mail.gmail.com>
Date: Mon, 1 Jun 2015 13:13:02 -0600
Message-ID: <CAJCQCtSKFgxygYcOgW8GfjDq-mQ0M1RLEORExa33R+Zsk-6CYg@mail.gmail.com>
Subject: Re: [newb] move /home to subvolume
From: Chris Murphy <lists@colorremedies.com>
To: Neal Becker <ndbecker2@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 1, 2015 at 12:52 PM, Neal Becker <ndbecker2@gmail.com> wrote:

> Let me just make sure I'm clear on this.  So I already have /dev/sdaX
> mounted as /.

Actually your fstab will show you have subvol=root mounted at /, not
the top level.

>You're saying I should mount it again as /mnt, and this
> procedure is OK while the filesystem is in use, correct?

Yes.

>
>>
>> btrfs sub create /mnt/home
>
>
> Well there is already a directory called /home, under / on this filesystem.

/ is a mount point. And the subvolume named root is what's mounted
there. If you mount the top level subvolume at /mnt then you will see
the root subvolume in /mnt/. And you will see your current home
directory in /mnt/root/home.


> Well, /home is not mounted.  There is right now just a single mount of /
>
>>
>> umount /home

OK so you can skip the umount part.


-- 
Chris Murphy
