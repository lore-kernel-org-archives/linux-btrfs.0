Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:37985 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751537AbcKIM0Q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Nov 2016 07:26:16 -0500
Received: by mail-it0-f50.google.com with SMTP id q124so266838964itd.1
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Nov 2016 04:26:16 -0800 (PST)
Subject: Re: Could receive allow updating an existing subvolume?
To: Ian Kelling <ian@iankelling.org>, Hugo Mills <hugo@carfax.org.uk>
References: <1478645336.2739242.781712345.6ADE1927@webmail.messagingengine.com>
 <20161108230057.GQ16645@carfax.org.uk>
 <1478646934.2753701.781728689.373545C7@webmail.messagingengine.com>
Cc: linux-btrfs@vger.kernel.org
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <c2f0c964-fb66-e536-c96c-a97508056ff4@gmail.com>
Date: Wed, 9 Nov 2016 07:26:12 -0500
MIME-Version: 1.0
In-Reply-To: <1478646934.2753701.781728689.373545C7@webmail.messagingengine.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-11-08 18:15, Ian Kelling wrote:
> On Tue, Nov 8, 2016, at 03:00 PM, Hugo Mills wrote:
>> On Tue, Nov 08, 2016 at 02:48:56PM -0800, Ian Kelling wrote:
>>> It seems to be an artificially imposed limitation which hurts which
>>> hurts its usefulness. Let me know if this makes sense. If so, perhaps it
>>> can be implemented eventually. It seems a bit obvious but I couldn't
>>> find any existing discussion of it.
>>
>>    It's not artificial -- it's ensuring safety of operation.
>
> No, it doesn't ensure the subvolume is not modified, so it IS
> artificial. I can still set the subvolume to rw before or probably
> during the send and modify a file and mess things up.
>
>>
>>    If the sender sends an incremental stream, that assumes an *exact*
>> subvol state on the receiving side. If the subvol on the receiving
>> side is modified, then the receive can fail.
>
> No. The reading program never needs to have access to rw files if it's
> reading from a read-only mountpoint while the subvolume is rw and
> mounted as such elsewhere. And a reading program does not magically risk
> writes.
That assumes that the reading program is bug free (and perfectly 
secured) running on 100% reliable hardware with no chance of any kind of 
failure, which is a pretty significant requirement that's functionally 
impossible to enforce.

There's also the fact that things which have files opened read-only 
generally expect that the file will not change under them, and that 
you'd need to restart most software anyway so that it would pick up on 
any renames and new or deleted paths.
>
>>
>>    So, the assumption is that the reference subvol on the receiving
>> side (equivalent to the -p subvol on the sending side) hasn't been
>> changed since it was received. The same assumption applies to the -p
>> subvol on the sending side.
>>
>>    Now, receive is a fully userspace tool, so it would have to set the
>> subvol to RW, then update it, then set it to RO. The subvol risks
>> being modified by other processes during that window -- *particularly*
>> if it's actively being read by those other processes.
>
> No. The reading program never needs to have access to rw files if it's
> reading from a read-only mountpoint while the subvolume is rw and
> mounted as such elsewhere. And a reading program does not magically risk
> writes.
>
>>
>>    Note that this is still an issue with the current situation, but
>> the expectation is that nothing's going to be actively reading that
>> location at the time the receive is running. But, if something does go
>> wrong with the receive, it's possible to abort and restart the
>> process. If you're modifying an existing subvol, there's no
>> recoverability if something goes wrong halfway through.
>
> No. You could recover using the snapshot that I mentioned.
>
>>    Hugo.
>
> So my question still stands.
Given the use case you're describing, it sounds like `rsync --inplace` 
plus snapshots is a better fit for what you want to do than 
send/receive.  It's worth pointing out though that this is _NOT_ a safe 
way to handle things if your actually serving data based on the contents 
of those files, because any read while the file is being updated will 
likely return half-updated data.  The only case where I would ever 
consider doing something like this is on a system which is an 
active-backup for another system, because it's pretty much guaranteed to 
not be serving data if it's syncing it from the primary system.

