Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:48778 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756505AbcKBSWk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Nov 2016 14:22:40 -0400
Subject: Re: Send/receive snapshot from/between backup (also restore example)
References: <a58d070d-30f8-9abe-04cd-4cb4ba88697b@buehlmann.net>
 <0db7a069-e29b-f548-969e-2fc8ad15f96a@mendix.com>
 <824b6cdc-a220-9137-7df4-eb3fd2ca66c7@buehlmann.net>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
To: =?UTF-8?B?UmVuw6kgQsO8aGxtYW5u?= <rene@buehlmann.net>,
        linux-btrfs@vger.kernel.org
Message-ID: <117c6e94-7821-a2b8-482d-c76428e0a378@mendix.com>
Date: Wed, 2 Nov 2016 19:22:36 +0100
MIME-Version: 1.0
In-Reply-To: <824b6cdc-a220-9137-7df4-eb3fd2ca66c7@buehlmann.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/02/2016 04:14 PM, René Bühlmann wrote:
> On 11/02/2016 03:49 PM, Hans van Kranenburg wrote:
>> On 11/02/2016 03:23 PM, René Bühlmann wrote:
>>> I have a system running on btrfs which is backed up to two (one local
>>> USB and one through SSH) external drives (also using btrfs) using
>>> send/receive (with the help of btrbk). For each backup a snapshot is
>>> created and transferred to the external drives. After some time, the
>>> snapshot on the origin is removed but kept on the two backups.
>>>
>>> Now my problem is, that the SSH-drive has not received any snapshots for
>>> some time such that there is no snapshot any more which is on the origin
>>> AND the SSH-drive. I would like to prevent transferring a full snapshot
>>> over the network and am now trying to work around it.
>>>
>>> Here the current situation (S? for a Snapshot):
>>>
>>> Origin: S2 S3
>>>
>>> USB: S1 S2
>>>
>>> SSH: S1
>>>
>>> Transferring S3 to USB is no problem as S2 is on both btrfs drives. But
>>> how can I transfer S3 to SSH?
>> Since there is no snapshot left that is present on both drives, you
>> cannot use incremental send.
>>
>> btrbk does not remember what snapshots were last transferred or were
>> present on the missing disk, since the tool does not do any extra meta
>> administation on top of just having the snapshots on btrfs level. So
>> it's figuring out the relationships between each of them (combining it
>> with info from the remotes) again every time it runs.
> Yes this explains why 1. did not work. But why can't I transfer S1 from
> USB back to Origin as incremental to S2?

You can, but what you end up with is not the same as the original S1 any
more. It will have a new uuid, which is not the received_uuid of the S1
that is still on SSH, so they won't be 'common'.

Allow me to demonstrate... A slightly different use case, but based on
this you can debug your own scenario again in the same way:

The following is how to snapshot to a remote, how to roll back to a
snapshot that is only on the remote (send it back), and then continue
sending incrementals again to the remote again.

Let's create some snapshots, and send them:

/mnt/zooi 12-# mkdir send
/mnt/zooi 12-# mkdir receive
/mnt/zooi 12-# mount /dev/zooi/send send/
/mnt/zooi 12-# mount /dev/zooi/receive receive/
/mnt/zooi 12-# cd send/

/mnt/zooi/send 12-# btrfs sub create A
Create subvolume './A'

/mnt/zooi/send 12-# dd if=/dev/zero of=A/1 bs=1 count=0 seek=1G; shred
-n 1 A/1
/mnt/zooi/send 12-# btrfs sub snap -r A A1
Create a readonly snapshot of 'A' in './A1'
/mnt/zooi/send 12-# btrfs send A1 | btrfs receive ../receive/
At subvol A1
At subvol A1

/mnt/zooi/send 12-# dd if=/dev/zero of=A/2 bs=1 count=0 seek=1G; shred
-n 1 A/2
/mnt/zooi/send 12-# btrfs sub snap -r A A2
Create a readonly snapshot of 'A' in './A2'
/mnt/zooi/send 12-# btrfs send -p A1 A2 | btrfs receive ../receive/
At subvol A2
At snapshot A2

/mnt/zooi/send 12-# dd if=/dev/zero of=A/3 bs=1 count=0 seek=1G; shred
-n 1 A/3
/mnt/zooi/send 12-# btrfs sub snap -r A A3
Create a readonly snapshot of 'A' in './A3'
/mnt/zooi/send 12-# btrfs send -p A2 A3 | btrfs receive ../receive/
At subvol A3
At snapshot A3

Now, the list of subvolumes at the send side looks like (linebreaks added):

/mnt/zooi/send 12-# btrfs sub list -u -q -R .
ID 271
 gen 40
 top level 5
 parent_uuid -
 received_uuid -
 uuid f08112b1-223d-cb46-b54b-2d90c8339617
 path A
ID 274
 gen 39
 top level 5
 parent_uuid f08112b1-223d-cb46-b54b-2d90c8339617
 received_uuid -
 uuid 862f3808-ccdf-cb40-8cf1-c31b8cbea635
 path A1
ID 276
 gen 40
 top level 5
 parent_uuid f08112b1-223d-cb46-b54b-2d90c8339617
 received_uuid -
 uuid ab4bd82b-39f9-a24c-9ead-02023e392e9f
 path A2
ID 278
 gen 41
 top level 5
 parent_uuid f08112b1-223d-cb46-b54b-2d90c8339617
 received_uuid -
 uuid d6d29fd8-d0db-cf49-81f5-8a7993134363
 path A3

You can see that all of the snapshots have f08112b1 as parent.

At the receiving side:

/mnt/zooi/receive 12-# btrfs sub list -u -q -R .

ID 263
 gen 31
 top level 5
 parent_uuid -
 received_uuid 862f3808-ccdf-cb40-8cf1-c31b8cbea635
 uuid 41a4495c-89bd-f949-8bfe-601e197eb96d
 path A1
ID 265
 gen 34
 top level 5
 parent_uuid 41a4495c-89bd-f949-8bfe-601e197eb96d
 received_uuid ab4bd82b-39f9-a24c-9ead-02023e392e9f
 uuid 332fd67a-cfd4-7e45-9114-a910fc8d5b95
 path A2
ID 267
 gen 36
 top level 5
 parent_uuid 332fd67a-cfd4-7e45-9114-a910fc8d5b95
 received_uuid d6d29fd8-d0db-cf49-81f5-8a7993134363
 uuid bb3a14fd-668c-6c4d-be1b-fc11a4cda6a0
 path A3

Here we see that if -p is used for send, the receiving side snapshots
the subvolume which has the sender-side uuid of the one referenced with
-p in its received_uuid field, and based on that clone (which on the
receiving side now has the previous received one as parent_uuid), it
adds the diff and it ends up as new read-only snapshot.

The original parent_uuid two steps back, is nowhere to be found any more.

Now let's remove some snapshots from the origin...

/mnt/zooi/send 12-# btrfs sub del A1 A2
Delete subvolume (no-commit): '/mnt/zooi/send/A1'
Delete subvolume (no-commit): '/mnt/zooi/send/A2'

I keep one snapshot in common, otherwise it's end of the game.

/mnt/zooi 12-# tree
.
├── receive
│   ├── A1
│   │   └── 1
│   ├── A2
│   │   ├── 1
│   │   └── 2
│   └── A3
│       ├── 1
│       ├── 2
│       └── 3
└── send
    ├── A
    │   ├── 1
    │   ├── 2
    │   └── 3
    └── A3
        ├── 1
        ├── 2
        └── 3

I can send back A1 or A2 now, using A3 as reference:

/mnt/zooi/receive 12-# btrfs send -v -p A3 A1 | btrfs receive -v ../send/
At subvol A1
BTRFS_IOC_SEND returned 0
joining genl thread
At snapshot A1
receiving snapshot A1
 uuid=862f3808-ccdf-cb40-8cf1-c31b8cbea635, ctransid=30
 parent_uuid=d6d29fd8-d0db-cf49-81f5-8a7993134363, parent_ctransid=38
BTRFS_IOC_SET_RECEIVED_SUBVOL
 uuid=862f3808-ccdf-cb40-8cf1-c31b8cbea635, stransid=30

What this does, is at the send side (which is now receiving back)
snapshotting the d6d29fd8 (which is A3) into A1 again, and then applying
the differences on top, setting received uuid to the uuid of the sent
A3. No actual data was sent.

And now:

/mnt/zooi/send -# btrfs sub list -u -q -R .

ID 271
 gen 41
 top level 5
 parent_uuid -
 received_uuid -
 uuid f08112b1-223d-cb46-b54b-2d90c8339617
 path A
ID 278
 gen 42
 top level 5
 parent_uuid f08112b1-223d-cb46-b54b-2d90c8339617
 received_uuid -
 uuid d6d29fd8-d0db-cf49-81f5-8a7993134363
 path A3
ID 279
 gen 43
 top level 5
 parent_uuid d6d29fd8-d0db-cf49-81f5-8a7993134363
 received_uuid 862f3808-ccdf-cb40-8cf1-c31b8cbea635
 uuid c787af91-874c-534f-ae8a-f3d78c18c971
 path A1

The parent_uuid of A1 is now A3, and not A!

But, we want to stop using A, because something terrible happened
between A1 and A2, and continue working based on A1, before the disaster.

/mnt/zooi/send 12-# mv A A-borken
/mnt/zooi/send 12-# btrfs sub snap A1 B
Create a snapshot of 'A1' in './B'
/mnt/zooi/send 12-# dd if=/dev/zero of=B/4 bs=1 count=0 seek=1G; shred
-n 1 B/4
/mnt/zooi/send 12-# btrfs sub snap -r B B4
Create a readonly snapshot of 'B' in './B4'

/mnt/zooi/send 12-# btrfs sub list -u -q -R .
[...]
ID 280
 gen 47
 top level 5
 parent_uuid c787af91-874c-534f-ae8a-f3d78c18c971
 received_uuid -
 uuid b1616848-a3e8-2149-9a96-9042d23c94c3
 path B
ID 282
 gen 47
 top level 5
 parent_uuid b1616848-a3e8-2149-9a96-9042d23c94c3
 received_uuid -
 uuid a5432e89-cf87-7443-9abf-8927d9c52ca0
 path B4

Fun thing is that you can actually continue the chain of incremental
sends for B4 on top of A1... which is quite nice, because it allows to
do a restore from the remote to an older snapshot, and then continue
with incrementals only again.

/mnt/zooi/send 12-# btrfs send -v -p A1 B4 | btrfs receive -v ../receive/
At subvol B4
At snapshot B4
receiving snapshot B4
 uuid=a5432e89-cf87-7443-9abf-8927d9c52ca0, ctransid=46
 parent_uuid=862f3808-ccdf-cb40-8cf1-c31b8cbea635, parent_ctransid=43
BTRFS_IOC_SEND returned 0
joining genl thread
BTRFS_IOC_SET_RECEIVED_SUBVOL
 uuid=a5432e89-cf87-7443-9abf-8927d9c52ca0, stransid=46

(No GiBs of data transferred at all!)

> And why can't I transfer S2 from USB to SSH? Is S1 not recognized as the
> same snapshot there?

Because S1 on USB and S1 on SSH are not the same thing. :| You can
compare their uuid fields, like I did above and see.

Btrfs send/receive is not as powerful as git with clone and merge. :] I
would certainly like it to be, that would be absolutely fabulous, but
it's not, right now.

>>> I tried to transfer...

Origin: S2 S3
USB: S1 S2
SSH: S1

>>> 1. S3 from Origin to SSH -> does not work as there is no common snapshot.

True. Not incremental

>>> 2. S2 from USB to SSH -> did not work.

What does 'did not work' mean?
You can send it, but not incremental, see above.

>>> 3. S1 from USB to Origin (such that there is a common snapshot with SSH)
>>> -> did not work.

When you send S1 back from USB to Origin, based on common S2, it will be
something new, having S2 as parent_uuid, and a new uuid of its own.

>>>
>>> Is it correct that 1. would work if a common snapshot is present on
>>> Origin and SSH?
>>>
>>> Is it expected that 2. and 3. do not work?
>>>
>>> Is there some other way to achieve it?
>> At home, I do a similar thing, I periodically send/receive changes of a
>> filesystem to two external disks, also using btrbk. Since I don't want
>> to have both backup disks and the originating filesystem all online and
>> in the same geographical location at the same moment, I have the same
>> problem.
>>
>> What I did is just setting expiry the snapshots on the origin manually,
>> and keep the meta-administration in my head. I don't do it that often
>> anyway.
>>

Btrfs send/receive is not as powerful as git with clone and merge. :] I
would certainly like it to be, that would be absolutely fabulous, but
it's not, right now.

-- 
Hans van Kranenburg
