Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f195.google.com ([209.85.214.195]:35747 "EHLO
	mail-ob0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbcDUWou (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Apr 2016 18:44:50 -0400
Received: by mail-ob0-f195.google.com with SMTP id o7so311724obl.2
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Apr 2016 15:44:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <022276ed-577c-5616-abc0-3e1a7644f31e@zoner.cz>
References: <022276ed-577c-5616-abc0-3e1a7644f31e@zoner.cz>
Date: Thu, 21 Apr 2016 16:44:49 -0600
Message-ID: <CAJCQCtRUtwY8zcRMoq2xCVgm=_rTeU5zxvM4_=1VrYtva7m6iw@mail.gmail.com>
Subject: Re: btrfs forced readonly + errno=-28 No space left
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 21, 2016 at 6:53 AM, Martin Svec <martin.svec@zoner.cz> wrote:
> Hello,
>
> we use btrfs subvolumes for rsync-based backups. During backups btrfs often fails with "No space
> left" error and goes to readonly mode (dmesg output is below) while there's still plenty of
> unallocated space:

Are you snapshotting near the time of enospc? If so it's a known
problem that's been around for a while. There are some suggestions in
the archives but I think the main thing is to back off on the workload
momentarily, take the snapshot, and then resume the workload. I don't
think it has to come to a complete stop but it's a lot more
reproducible with heavy writes.


-- 
Chris Murphy
