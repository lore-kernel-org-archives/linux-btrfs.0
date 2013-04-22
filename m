Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail2.jellyfishnet.co.uk ([93.91.20.10]:48892 "EHLO
	mail2.jellyfishnet.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab3DVOEZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Apr 2013 10:04:25 -0400
From: Mark Ridley <mark@backupsystems.co.uk>
To: Harald Glatt <mail@hachre.de>
CC: "dsterba@suse.cz" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Mon, 22 Apr 2013 15:04:26 +0100
Subject: Re: BTRFS 3.8.7 Kernel Crash Report
Message-ID: <CD9B01B0.38607%mark@backupsystems.co.uk>
In-Reply-To: <CAFWF=akYgS2oe+aFZmiMMhPVAfNF10xCXYQNCC3kvx=QGdOOTg@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No.

Without --repair pointed out some problems, but whats the point of knowing
about the problems if they can't be fixed so I ran with --repair and it
broke the volume.

On 22/04/2013 15:02, "Harald Glatt" <mail@hachre.de> wrote:

>On Mon, Apr 22, 2013 at 4:01 PM, Mark Ridley <mark@backupsystems.co.uk>
>wrote:
>> Thanks, David.
>>
>> What causes this corruption and how can I fix it?
>>
>> I'm very worried about running btrfs.fsck as last time it made a slight
>> corruption like this worse and the whole volume had to be trashed.
>>
>> After fsck the "available space" on df ended up being negative so
>>nothing
>> could be written to the volume.
>>
>> Mark
>>
>> On 22/04/2013 14:42, "David Sterba" <dsterba@suse.cz> wrote:
>>
>>>On Mon, Apr 22, 2013 at 01:19:41PM +0000, Mark Ridley wrote:
>>>> If I then use rsync --inplace to update the images, I get a btrfs
>>>>stack
>>>>trace
>>>> and btrfs hangs:
>>>>
>>>> This happens every night.
>>>
>>>> [<ffffffffa00bd5c1>] btrfs_set_item_key_safe+0x141/0x150 [btrfs]
>>>
>>>The check fails because it finds keys in reverted order. Given the
>>>conditions under which it happens I think it's an on-disk corruption and
>>>fsck should be able to at least detect it.
>>>
>>>david
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
>>in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>This happened without --repair?

