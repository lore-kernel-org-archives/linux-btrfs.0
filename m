Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:35631 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751600AbdC1PZ3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Mar 2017 11:25:29 -0400
Received: by mail-it0-f43.google.com with SMTP id y18so117016067itc.0
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Mar 2017 08:25:18 -0700 (PDT)
Subject: Re: Qgroups are not applied when snapshotting a subvol?
To: Marat Khalili <mkh@rqc.ru>, linux-btrfs@vger.kernel.org
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
 <ecf7f048-65f9-3f81-76c1-61528859ddc3@rqc.ru>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <9038f785-90c2-2e68-1c7f-4b53e8b9e4c5@gmail.com>
Date: Tue, 28 Mar 2017 11:24:50 -0400
MIME-Version: 1.0
In-Reply-To: <ecf7f048-65f9-3f81-76c1-61528859ddc3@rqc.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-03-28 09:53, Marat Khalili wrote:
>> There are a couple of reasons I'm advocating the specific behavior I
>> outlined:
> Some of your points are valid, but some break current behaviour and
> expectations or create technical difficulties.
>
>
>> 1. It doesn't require any specific qgroup setup.  By definition, you
>> can be 100% certain that the destination qgroup exists, and that you
>> won't need to create new qgroups behind the user's back (given your
>> suggestion, what happens when qgroup 1/N doesn't exist?).
> This is a general problem with current qgroups: you have to reference
> them by some random numbers, not by user-assigned names like files. It
> would need to be fixed sooner or later with syntax like L:<path> in
> place of L/N, or even some special syntax made specifically for path
> snapshots.
>
> BTW, what about reserving level 1 for qgroups describing subvolumes and
> all their snapshots and forbidding manual management of qgroups at this
> level?
If we were going to reserve something, it should be a high number, not a 
low one.  Having 0 reserved makes some sense, but reserving other low 
numbers seems kind of odd when they aren't already reserved.
>
>
>> 2. Just because it's the default, doesn't mean that the subvolume
>> can't be reassigned to a different qgroup.  This also would not remove
>> the ability to assign a specific qgroup through the snapshot creation
>> command.  This is arguably a general point in favor of having any
>> default of course, but it's still worth pointing out.
> Currently 0/N qgroups are special in that they are created automatically
> and belong to the bottom of the hierarchy. It would be very nice to keep
> it this way.
>
> Changing qgroup assignments after snapshot creation is very inconvenient
> because it requires quota rescan and thus blocks all other quota
> operations.
The subvolume create command lets you set a specific qgroup on subvolume 
creation.  When I said it won't prevent assigning a specific qgroup, I 
meant using that, not some after-the-fact assignment, although I hadn't 
realized that the snapshot command _does not_ have this argument, when 
it absolutely should.
>
>
>> 3. Because BTRFS has COW semantics, the new snapshot should take up
>> near zero space in the qgroup of it's parent.
>
> Indeed it works this way in my experiments if you assign snapshot to 1/N
> qgroup at creation where 0/N also belongs. Moreover, it does not require
> quota rescan, which is very nice.
I mean if it's placed in that qgroup itself.  If you create a snapshot 
of an idle subvolume, you only effectively double the metadata (and 
possibly not even that completely), so unless it's got a very large 
number of small files, it should take up next to zero space if it gets 
put in it's parent's qgroup.
>
>
>> 4. This correlates with the behavior most people expect based on ZFS
>> and LVM, which is that snapshots are tied to their parent.
>
> I'm not against tying it to the parent. I'm against removing snapshot's
> own qgroup.
Perhaps have an option (in the filesystem, not the mount options, this 
is tied to qgroup policy, which should be independent of who mounts the 
FS where) that specifies one of:
1. Current behavior.
2. Join parent's qgroup.
3. Join some other predefined qgroup.

>
>
>> At a minimum, it should belong to _some_ qgroup.  This could also be
>> covered by having a designated 'default' qgroup that all new
>> subvolumes created without a specified qgroup get put in, but I feel
>> that that is somewhat orthogonal to the issue of how snapshots are
>> handled.
> It belongs to its own 0/N' qgroup, but this is not probably what you mean.
The 0/N groups are accounting only until some limit is set, correct?  If 
that is the case, then that really isn't what I mean.  Quotas can be 
used for accounting, but when used, they are often intended for 
restricting resource usage.  New subvolumes going into unrestricted 
qgroups by default completely eliminates any usability for resource 
restriction the moment anybody but the admin has any shell access to the 
system, and that's my biggest complaint against the current behavior. 
Putting a snapshot in it's parent's qgroup would completely close this 
hole and provide semantics that most people are likely to understand 
pretty easily.

