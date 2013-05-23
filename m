Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:48883 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758440Ab3EWM33 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 May 2013 08:29:29 -0400
Received: by mail-pa0-f42.google.com with SMTP id bj3so2912261pad.29
        for <linux-btrfs@vger.kernel.org>; Thu, 23 May 2013 05:29:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <519E09F2.4060806@giantdisaster.de>
References: <CAFTPBc+Z=qK1oi4MzvpTZKB-Qttc0STDHmN2qiwpi36UgqoPhQ@mail.gmail.com>
	<519E09F2.4060806@giantdisaster.de>
Date: Thu, 23 May 2013 14:29:29 +0200
Message-ID: <CAFTPBc+i1u7nyKyuiMBJQBRM7mHQF-M9FRGk8NQmkbj5mnLXnw@mail.gmail.com>
Subject: Re: Problem with btrfs send/receive
From: Felix Blanke <felixblanke@gmail.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

thanks for pointing it out. You are right: Sending the snapshot to a
different btrfs fixes the problem. Interesting :) It's not what you
would except, but for my purposes it's ok, because in the end I'll
send it to a different btrfs.

Felix

On Thu, May 23, 2013 at 2:22 PM, Stefan Behrens
<sbehrens@giantdisaster.de> wrote:
> On Thu, 23 May 2013 13:51:59 +0200, Felix Blanke wrote:
>> Hi everyone,
>>
>> I was trying the new send/receive feature today but can't make it work.
>>
>> These are the commands I was using:
>>
>> btrfs subvol snap -r /mnt/data1/@downloads/ /mnt/data1/snapshots/testsnap
>> btrfs send /mnt/data1/snapshots/testsnap | btrfs receive
>> /mnt/data1/snapshots/testreceive/
>>
>> This command never finishes. A 'ls /mnt/data1/snapshots/testreceive/ '
>> never finishes too. After killing the send/receive process one can see
>> that the target subvolume was created but is empty.
>>
>>
>> Sending the snapshot to a file and use this for receiving does work.
>> What am I missing?
>>
>
> That's a known design flaw in the btrfs send code.
> 'btrfs send /subvol | sleep 666'
> is an easier way to block the system. But it's interruptable if you
> terminate the sleep task in this case.
>
> btrfs send blocks on the pipe while being in the kernel, the call chain
> is like this:
> btrfs_ioctl_send -> send_subvol -> full_send_tree -> changed_cb ->
> send_cmd -> write_buf -> vfs_write -> pipe_write -> pipe_wait
>
> And full_send_tree() has called btrfs_join_transaction() before, thus
> the whole file system and afterwards the system is blocked.
>
> You can avoid it if you receive to a different filesystem or if you
> redirect the output of btrfs send into a file. In general, the output of
> btrfs send must never be blocked or you are lost.
>
