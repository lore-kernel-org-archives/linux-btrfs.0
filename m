Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:42143 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbaIYVFN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Sep 2014 17:05:13 -0400
Received: by mail-la0-f46.google.com with SMTP id gi9so3107368lab.33
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Sep 2014 14:05:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan.2014.09.24.22.23.33@googlemail.com>
References: <CAPL5yKfTfzkqBT9dQBpJAjuBtq2-=QqdCn_Pzfnnd1URKA_q4A@mail.gmail.com>
	<pan.2014.09.24.22.23.33@googlemail.com>
Date: Thu, 25 Sep 2014 17:05:11 -0400
Message-ID: <CAPL5yKdt7eTk-+0NP2Y9Aa8zNQqJpujTm31z_ee04OS3DocMXg@mail.gmail.com>
Subject: Re: 3.16 Managed to ENOSPC with <80% used
From: Dan Merillat <dan.merillat@gmail.com>
To: =?UTF-8?Q?Holger_Hoffst=C3=A4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 24, 2014 at 6:23 PM, Holger Hoffstätte
<holger.hoffstaette@googlemail.com> wrote:

>> Basically it's been data allocation happy, since I haven't deleted
>> 53GB at any point.  Unfortunately, none of the chunks are at 0% usage
>> so a balance -dusage=0 finds nothing to drop.
>
> Also try -musage=0..10, just for fun.

Tried a few of them.  When it's completely wedged, balance with any
usage above zero won't work, because it needs one allocatable group to
move to.   I'm not sure if it was needing a new data chunk to merge
partials into, or if it thought it needed more metadata space to write
out the changes.  (Metadata was also only 75% used).

>> Is this recoverable, or do I need to copy to another disk and back?
>
> Another neat trick that will free up space is to convert to single
> metadata: -mconvert=single -f (to force). A subsequent balance
> with -musage=0..10 will likely free up quite some space.

Deleting files or dropping snapshots is difficult when it's wedged as
well, a lot of disk activity (journal thrash?) and no persistent
progress - a reboot brigs the deleted files back.  I eventually
managed to empty a single data chunk and after that it was a trivial
recovery.

> That particular workload seems to cause the block allocator to go
> on a spending spree; you're not the first to see this.

I could see normal-user usage patterns getting ignored, but this is
the patterns of the people working on BTRFS.   Maybe they need to
remove their balance cronjobs for a while. :)
