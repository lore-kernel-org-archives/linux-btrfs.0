Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f172.google.com ([209.85.220.172]:59816 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161016Ab3CVRGm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Mar 2013 13:06:42 -0400
Received: by mail-vc0-f172.google.com with SMTP id hr11so3275187vcb.17
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Mar 2013 10:06:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130322142659.27874.81283@localhost.localdomain>
References: <orhak8fm0u.fsf@livre.home>
	<20130319120940.29898.80124@localhost.localdomain>
	<ora9pzdwdw.fsf@livre.home>
	<or1ubaesrx.fsf@livre.home>
	<ord2utb4xx.fsf@livre.home>
	<20130321180614.30044.29961@localhost.localdomain>
	<20130321230621.30044.80640@localhost.localdomain>
	<orzjxw9f75.fsf@livre.home>
	<20130322120754.27874.14389@localhost.localdomain>
	<orobeba58l.fsf@livre.home>
	<20130322142659.27874.81283@localhost.localdomain>
Date: Fri, 22 Mar 2013 10:06:41 -0700
Message-ID: <CA+4uBUbyF-3yiBQ00xP4NHEX96CXa9HZo5-ZYdZ3Fjrfnm=Ssw@mail.gmail.com>
Subject: Re: corruption of active mmapped files in btrfs snapshots
From: Samuel Just <sam.just@inktank.com>
To: Chris Mason <clmason@fusionio.com>
Cc: Alexandre Oliva <oliva@gnu.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Incomplete writes for leveldb should just result in lost updates, not
corruption.  Also, we do stop writes before the snapshot is initiated
so there should be no in-progress writes to leveldb other than leveldb
compaction (though that might be something to investigate).
-Sam

On Fri, Mar 22, 2013 at 7:26 AM, Chris Mason <clmason@fusionio.com> wrote:
> Quoting Alexandre Oliva (2013-03-22 10:17:30)
>> On Mar 22, 2013, Chris Mason <clmason@fusionio.com> wrote:
>>
>> > Are you using compression in btrfs or just in leveldb?
>>
>> btrfs lzo compression.
>
> Perfect, I'll focus on that part of things.
>
>>
>> > I'd like to take snapshots out of the picture for a minute.
>>
>> That's understandable, I guess, but I don't know that anyone has ever
>> got the problem without snapshots.  I mean, even when the master copy of
>> the database got corrupted, snapshots of the subvol containing it were
>> being taken every now and again, because that's the way ceph works.
>
> Hopefully Sage can comment, but the basic idea is that if you snapshot a
> database file the db must participate.  If it doesn't, it really is the
> same effect as crashing the box.
>
> Something is definitely broken if we're corrupting the source files
> (either with or without snapshots), but avoiding incomplete writes in
> the snapshot files requires synchronization with the db.
>
> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
