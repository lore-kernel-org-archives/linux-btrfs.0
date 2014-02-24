Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:56993 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbaBXNhH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Feb 2014 08:37:07 -0500
Received: by mail-wi0-f181.google.com with SMTP id hi5so3045034wib.8
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Feb 2014 05:37:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140220165743.GT16073@twin.jikos.cz>
References: <5304D781.6020309@gmail.com>
	<20140220165743.GT16073@twin.jikos.cz>
Date: Mon, 24 Feb 2014 15:37:05 +0200
Message-ID: <CAOi1vP9hEqBcDgY-zthijx37+_cowhoMQaTZyWG9OUqOQvJR2A@mail.gmail.com>
Subject: Re: [PATCH] btrfs: Allow forced conversion of metadata to dup profile
 on multiple devices
From: Ilya Dryomov <idryomov@gmail.com>
To: David Sterba <dsterba@suse.cz>, Austin S Hemmelgarn <ahferroin7@gmail.com>,
        linux-btrfs@vger.kernel.org, Ilya Drymov <idryomov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 20, 2014 at 6:57 PM, David Sterba <dsterba@suse.cz> wrote:
> On Wed, Feb 19, 2014 at 11:10:41AM -0500, Austin S Hemmelgarn wrote:
>> Currently, btrfs balance start fails when trying to convert metadata or
>> system chunks to dup profile on filesystems with multiple devices.  This
>> requires that a conversion from a multi-device filesystem to a single
>> device filesystem use the following methodology:
>>     1. btrfs balance start -dconvert=single -mconvert=single \
>>        -sconvert=single -f /
>>     2. btrfs device delete / /dev/sdx
>>     3. btrfs balance start -mconvert=dup -sconvert=dup /
>> This results in a period of time (possibly very long if the devices are
>> big) where you don't have the protection guarantees of multiple copies
>> of metadata chunks.
>>
>> After applying this patch, one can instead use the following methodology
>> for conversion from a multi-device filesystem to a single device
>> filesystem:
>>     1. btrfs balance start -dconvert=single -mconvert=dup \
>>        -sconvert=dup -f /
>>     2. btrfs device delete / /dev/sdx
>> This greatly reduces the chances of the operation causing data loss due
>> to a read error during the device delete.
>>
>> Signed-off-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
> Reviewed-by: David Sterba <dsterba@suse.cz>
>
> Sounds useful. The muliple devices + DUP is allowed setup when the
> device is added, this patch only adds the 'delete' counterpart. The
> imroved data loss protection during the process is a good thing.

Hi,

Have you actually tried to queue it?  Unless I'm missing something, it won't
compile, and on top of that, it seems to be corrupted too..

IIRC muliple devices + DUP is "allowed" only until the first balance, has that
changed?

Thanks,

                Ilya
