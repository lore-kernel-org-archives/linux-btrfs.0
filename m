Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:58101 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbaBXNoZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Feb 2014 08:44:25 -0500
Received: by mail-ig0-f172.google.com with SMTP id h3so4712422igd.5
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Feb 2014 05:44:24 -0800 (PST)
Message-ID: <530B4CB4.5010909@gmail.com>
Date: Mon, 24 Feb 2014 08:44:20 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Ilya Dryomov <idryomov@gmail.com>, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Allow forced conversion of metadata to dup profile
 on multiple devices
References: <5304D781.6020309@gmail.com>	<20140220165743.GT16073@twin.jikos.cz> <CAOi1vP9hEqBcDgY-zthijx37+_cowhoMQaTZyWG9OUqOQvJR2A@mail.gmail.com>
In-Reply-To: <CAOi1vP9hEqBcDgY-zthijx37+_cowhoMQaTZyWG9OUqOQvJR2A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-02-24 08:37, Ilya Dryomov wrote:
> On Thu, Feb 20, 2014 at 6:57 PM, David Sterba <dsterba@suse.cz> wrote:
>> On Wed, Feb 19, 2014 at 11:10:41AM -0500, Austin S Hemmelgarn wrote:
>>> Currently, btrfs balance start fails when trying to convert metadata or
>>> system chunks to dup profile on filesystems with multiple devices.  This
>>> requires that a conversion from a multi-device filesystem to a single
>>> device filesystem use the following methodology:
>>>     1. btrfs balance start -dconvert=single -mconvert=single \
>>>        -sconvert=single -f /
>>>     2. btrfs device delete / /dev/sdx
>>>     3. btrfs balance start -mconvert=dup -sconvert=dup /
>>> This results in a period of time (possibly very long if the devices are
>>> big) where you don't have the protection guarantees of multiple copies
>>> of metadata chunks.
>>>
>>> After applying this patch, one can instead use the following methodology
>>> for conversion from a multi-device filesystem to a single device
>>> filesystem:
>>>     1. btrfs balance start -dconvert=single -mconvert=dup \
>>>        -sconvert=dup -f /
>>>     2. btrfs device delete / /dev/sdx
>>> This greatly reduces the chances of the operation causing data loss due
>>> to a read error during the device delete.
>>>
>>> Signed-off-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
>> Reviewed-by: David Sterba <dsterba@suse.cz>
>>
>> Sounds useful. The muliple devices + DUP is allowed setup when the
>> device is added, this patch only adds the 'delete' counterpart. The
>> imroved data loss protection during the process is a good thing.
> 
> Hi,
> 
> Have you actually tried to queue it?  Unless I'm missing something, it won't
> compile, and on top of that, it seems to be corrupted too..
The patch itself was made using git, AFAICT it should be fine.  I've
personally built and tested it using UML.
> 
> IIRC muliple devices + DUP is "allowed" only until the first balance, has that
> changed?

This is just a limitation of how the kernel handles balances, DUP
profiles with multiple devices work, it's just terribly inefficient.
The primary use case is converting a multi-device FS with RAID for
metadata to a single device FS without having to reduce integrity.
> Thanks,
> 
>                 Ilya
> 
