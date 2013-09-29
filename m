Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:33790 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab3I2JW6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Sep 2013 05:22:58 -0400
Received: by mail-ie0-f180.google.com with SMTP id u16so7557922iet.39
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Sep 2013 02:22:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130929004252.GL18681@localhost.localdomain>
References: <CAEx9m45FDjNCBLEYM0x7fY36R7QJesS0F-fzWzNi=d_cBSOjOQ@mail.gmail.com>
 <20130929004252.GL18681@localhost.localdomain>
From: Aastha Mehta <aasthakm@gmail.com>
Date: Sun, 29 Sep 2013 11:22:36 +0200
Message-ID: <CAEx9m440QMtfkaZjc5Qgu6jv+TsejheKG5nVuYhAEe_vqgp0MQ@mail.gmail.com>
Subject: Re: Questions regarding logging upon fsync in btrfs
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you very much for the reply. That clarifies a lot of things.

I was trying a small test case that opens a file, writes a block of
data, calls fsync and then closes the file. If I understand correctly,
fsync would return only after all in-memory buffers have been
committed to disk. I have added few print statements in the
__extent_writepage function, and I notice that the function gets
called a bit later after fsync returns. It seems that I am not
guaranteed to see the data going to disk by the time fsync returns.

Am I doing something wrong, or am I looking at the wrong place for
disk write? This happens both with tree logging enabled as well as
with notreelog.

Thanks

On 29 September 2013 02:42, Josef Bacik <jbacik@fusionio.com> wrote:
> On Sun, Sep 29, 2013 at 01:35:15AM +0200, Aastha Mehta wrote:
>> Hi,
>>
>> I have few questions regarding logging triggered by calling fsync in BTRFS:
>>
>> 1. If I understand correctly, fsync will call to log entire inode in
>> the log tree. Does this mean that the data extents are also logged
>> into the log tree? Are they copied into the log tree, or just
>> referenced? Are they copied into the subvolume's extent tree again
>> upon replay?
>>
>
> The data extents are copied as well, as in the metadata that points to the data,
> not the actual data itself.  For 3.1 it's all of the extents in the inode, in
> 3.8 on it's only the extents that have changed this transaction.
>
>> 2. During replay, when the extents are added into the extent
>> allocation tree, do they acquire the physical extent number during
>> replay? Does they physical extent allocated to the data in the log
>> tree differ from that in the subvolume?
>>
>
> No the physical location was picked when we wrote the data out during fsync.  If
> we crash and re-mount the replay will just insert the ref into the extent tree
> for the disk offset as it replays the extents.
>
>> 3. I see there is a mount option of notreelog available. After
>> disabling tree logging, does fsync still lead to flushing of buffers
>> to the disk directly?
>>
>
> notreelog just means that we write the data and wait on the ordered data extents
> and then commit the transaction.  So you get the data for the inode you are
> fsycning and all of the metadata for the entire file system that has changed in
> that transaction.
>
>> 4. Is it possible to selectively identify certain files in the log
>> tree and flush them to disk directly, without waiting for the replay
>> to do it?
>>
>
> I don't understand this question, replay only happens on mount after a
> crash/power loss, and everything is replayed that is in the log, there is no way
> to select which inode is replayed.  Thanks,
>
> Josef



-- 
Aastha Mehta
MPI-SWS, Germany
E-mail: aasthakm@mpi-sws.org
