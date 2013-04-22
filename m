Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:49288 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab3DVOCn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Apr 2013 10:02:43 -0400
Received: by mail-lb0-f176.google.com with SMTP id y8so5584323lbh.7
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Apr 2013 07:02:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CD9B00AC.385FF%mark@backupsystems.co.uk>
References: <20130422134249.GN16427@twin.jikos.cz> <CD9B00AC.385FF%mark@backupsystems.co.uk>
From: Harald Glatt <mail@hachre.de>
Date: Mon, 22 Apr 2013 16:02:21 +0200
Message-ID: <CAFWF=akYgS2oe+aFZmiMMhPVAfNF10xCXYQNCC3kvx=QGdOOTg@mail.gmail.com>
Subject: Re: BTRFS 3.8.7 Kernel Crash Report
To: Mark Ridley <mark@backupsystems.co.uk>
Cc: "dsterba@suse.cz" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 22, 2013 at 4:01 PM, Mark Ridley <mark@backupsystems.co.uk> wrote:
> Thanks, David.
>
> What causes this corruption and how can I fix it?
>
> I'm very worried about running btrfs.fsck as last time it made a slight
> corruption like this worse and the whole volume had to be trashed.
>
> After fsck the "available space" on df ended up being negative so nothing
> could be written to the volume.
>
> Mark
>
> On 22/04/2013 14:42, "David Sterba" <dsterba@suse.cz> wrote:
>
>>On Mon, Apr 22, 2013 at 01:19:41PM +0000, Mark Ridley wrote:
>>> If I then use rsync --inplace to update the images, I get a btrfs stack
>>>trace
>>> and btrfs hangs:
>>>
>>> This happens every night.
>>
>>> [<ffffffffa00bd5c1>] btrfs_set_item_key_safe+0x141/0x150 [btrfs]
>>
>>The check fails because it finds keys in reverted order. Given the
>>conditions under which it happens I think it's an on-disk corruption and
>>fsck should be able to at least detect it.
>>
>>david
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

This happened without --repair?
