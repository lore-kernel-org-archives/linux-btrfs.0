Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp145.dfw.emailsrvr.com ([67.192.241.145]:43458 "EHLO
        smtp145.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754461AbdC1OBt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Mar 2017 10:01:49 -0400
Received: from smtp19.relay.dfw1a.emailsrvr.com (localhost [127.0.0.1])
        by smtp19.relay.dfw1a.emailsrvr.com (SMTP Server) with ESMTP id B6FB74014B
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Mar 2017 09:53:36 -0400 (EDT)
Received: by smtp19.relay.dfw1a.emailsrvr.com (Authenticated sender: m.khalili-AT-rqc.ru) with ESMTPSA id 56C024017E
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Mar 2017 09:53:36 -0400 (EDT)
Subject: Re: Qgroups are not applied when snapshotting a subvol?
To: linux-btrfs@vger.kernel.org
References: <4428fdc3-157a-a98e-8ca3-e3701c6c1c80@sichert.me>
 <279513f7-5297-cf2f-aa94-35bef1f674aa@cn.fujitsu.com>
 <2e816c46-7a6a-7db9-a2c3-663dc7d8e6c9@gmail.com>
 <8c55c034-27cc-e8b5-5317-b388cc6492f4@cn.fujitsu.com>
 <e57c6cc8-4943-a93a-f568-d3654d341b65@sichert.me>
 <6e464739-5540-87ab-a46d-954a06086cba@gmail.com>
 <CAJCQCtRikr0CaYRj1rQid-UPukNm6NXem_8QD_e-VZYoZ3HPWA@mail.gmail.com>
 <11740657-b2f9-36ab-9644-df2db29dd174@gmail.com>
 <1c8a021b-d258-3a50-3104-d898662c4375@rqc.ru>
 <8c87b1fb-c7ba-5494-0ecd-b692637cdd54@gmail.com>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <ecf7f048-65f9-3f81-76c1-61528859ddc3@rqc.ru>
Date: Tue, 28 Mar 2017 16:53:34 +0300
MIME-Version: 1.0
In-Reply-To: <8c87b1fb-c7ba-5494-0ecd-b692637cdd54@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> There are a couple of reasons I'm advocating the specific behavior I 
> outlined:
Some of your points are valid, but some break current behaviour and 
expectations or create technical difficulties.


> 1. It doesn't require any specific qgroup setup.  By definition, you 
> can be 100% certain that the destination qgroup exists, and that you 
> won't need to create new qgroups behind the user's back (given your 
> suggestion, what happens when qgroup 1/N doesn't exist?).
This is a general problem with current qgroups: you have to reference 
them by some random numbers, not by user-assigned names like files. It 
would need to be fixed sooner or later with syntax like L:<path> in 
place of L/N, or even some special syntax made specifically for path 
snapshots.

BTW, what about reserving level 1 for qgroups describing subvolumes and 
all their snapshots and forbidding manual management of qgroups at this 
level?


> 2. Just because it's the default, doesn't mean that the subvolume 
> can't be reassigned to a different qgroup.  This also would not remove 
> the ability to assign a specific qgroup through the snapshot creation 
> command.  This is arguably a general point in favor of having any 
> default of course, but it's still worth pointing out.
Currently 0/N qgroups are special in that they are created automatically 
and belong to the bottom of the hierarchy. It would be very nice to keep 
it this way.

Changing qgroup assignments after snapshot creation is very inconvenient 
because it requires quota rescan and thus blocks all other quota operations.


> 3. Because BTRFS has COW semantics, the new snapshot should take up 
> near zero space in the qgroup of it's parent.

Indeed it works this way in my experiments if you assign snapshot to 1/N 
qgroup at creation where 0/N also belongs. Moreover, it does not require 
quota rescan, which is very nice.


> 4. This correlates with the behavior most people expect based on ZFS 
> and LVM, which is that snapshots are tied to their parent.

I'm not against tying it to the parent. I'm against removing snapshot's 
own qgroup.


> At a minimum, it should belong to _some_ qgroup.  This could also be 
> covered by having a designated 'default' qgroup that all new 
> subvolumes created without a specified qgroup get put in, but I feel 
> that that is somewhat orthogonal to the issue of how snapshots are 
> handled. 
It belongs to its own 0/N' qgroup, but this is not probably what you mean.


--

With Best Regards,
Marat Khalili

