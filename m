Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f178.google.com ([209.85.128.178]:54483 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaAIXea (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jan 2014 18:34:30 -0500
Received: by mail-ve0-f178.google.com with SMTP id c14so2938175vea.23
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jan 2014 15:34:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140106175312.GB6498@twin.jikos.cz>
References: <CACeaM8_zLWB_R3-kWWqGGk45ySbXEpb9J1f58adggoQ7Ovi-Ng@mail.gmail.com>
	<20140106175312.GB6498@twin.jikos.cz>
Date: Fri, 10 Jan 2014 00:34:28 +0100
Message-ID: <CACeaM8-cRGq3LwoZjh52K2X2WhZOfsZ11=dGL+CzWvu+LkMTGg@mail.gmail.com>
Subject: Re: FILE_EXTENT_SAME changes mtime and ctime
From: Gerhard Heift <gerhard@heift.name>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2014/1/6 David Sterba <dsterba@suse.cz>:
> On Mon, Jan 06, 2014 at 12:02:51AM +0100, Gerhard Heift wrote:
>> I am currently playing with snapshots and manual deduplication of
>> files. During these tests I noticed the change of ctime and mtime in
>> the snapshot after the deduplication with FILE_EXTENT_SAME. Does this
>> happens on purpose? Otherwise I would like to have ctime and mtime
>> left unmodified, because on a read only snapshot I cannot change them
>> back after the ioctl call.
>
> I'm not sure what's the correct behaviour wrt timestamps and extent
> cloning. The inode metadata are modified in some way, but the stat data
> and actual contents are left unchanged, so the timestamps do not reflect
> that something changed according to their definition (stat(2)).
>
> On the other hand, the differences can be seen in the extent listing,
> the physical offset of the blocks will change. I'm not aware of any
> tools that would become broken by breaking this assumption. Also, the
> (partial) cloning functionality is not implemented anywhere so we could
> have a look and try to stay consistent with that.
>
> My oppinion is to drop the mtime/iversion updates completely.

In my opinion, we should never update, if we dedup content of files
with FILE_EXTENT_SAME.

If we clone with CLONE(_RANGE), the mtime should be updated, because
its like a write operation.

The semantics of ctime is not completely clear to me. It should change
if the "visible" meta data of a file changes. In this cases should it
be updated if write to it, because mtime changes, or only if the size
of the file changes?

> david

Gerhard
