Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:44461 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab2LQJFs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Dec 2012 04:05:48 -0500
Received: by mail-ia0-f174.google.com with SMTP id y25so5261455iay.19
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2012 01:05:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANTVtNqB_C+srL9DsL2b7QC1rUT4m5-6RHR6CqQbajQm2NCy0w@mail.gmail.com>
References: <CAFhuFEdxHxdiAutfxxsQ9i0OJj_CfRwWD-0LuhvoJYGHkTsG4A@mail.gmail.com>
	<CAOcd+r1LnMP=CU37mUSxZGuksTY4kYo+Y5vg9n3BV-E=ye=-Yg@mail.gmail.com>
	<CANTVtNqzGmK2fb3EEXtjAanNBGxBCN2T44wnMw9xLTYSyPV3vA@mail.gmail.com>
	<CAOcd+r2fS-=dCU-v8ZLUNGrS3ojfhLXYAtBek-JGvvOJLOar3Q@mail.gmail.com>
	<CANTVtNqB_C+srL9DsL2b7QC1rUT4m5-6RHR6CqQbajQm2NCy0w@mail.gmail.com>
Date: Mon, 17 Dec 2012 11:05:47 +0200
Message-ID: <CAOcd+r05VgvOrW-_X89OyVd-AgJuyXt0O4ZhJ=ZisaZDJkxuhg@mail.gmail.com>
Subject: Re: Snapper snapshot comparison algorithm
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Mohit Bhadade <mohitbhadade@gmail.com>
Cc: nafisa mandliwala <nafisa.mandliwala@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mohit,
(unfortunately, it looks like I can answer emails only once a week:( )

On Mon, Dec 10, 2012 at 3:36 PM, Mohit Bhadade <mohitbhadade@gmail.com> wrote:
> Hi,
>         I started traversing the code and have some doubts in the
> btrfs_compare_trees function.
>
> 1. Can you please explain the transaction join and leave concept?
I don't know much about it, but as you can see this function uses
commit roots, e.g.:
left_path->search_commit_root = 1;
...
right_path->search_commit_root = 1;
...
left_level = btrfs_header_level(left_root->commit_root);
etc.

I read somewhere in the comments that "commit roots are protected by
transactions". On the other hand, you don't want this function to join
a transaction and never leave it. So I guess, that this function
checks whether it is needed to end the current transaction, and in
that case and leaves it, and rejoins the new transaction. Or something
like that.

>
> 2. Once we rejoin a transaction, how does btrfs_search_slot find the key,
> which key is it referring to?
I don't understand the question. That's what btrfs_search_slot() does,
it finds a leaf (or node) given the key. So we always remember the key
we are/were looking at, and when we rejoin the transaction, we just
re-search for this key.

>
> 3. What happens when the tree undergoes a change when we have left the
> transaction?
First of all, the user-space checks that the subvolume being sent is
BTRFS_SUBVOL_RDONLY. Though it looks like it doesn't check for the
parent being read-only. In any case, it is obvious that comparing
trees that undergo changes while we compare them is not what we want.
For that the btrfs_compare_trees() function uses "root_ctransid".
After it rejoins the transaction, it checks that both roots still have
the same ctransid. If not, it bails out. Does this make sense?
ctransid is updated when root item changes, meaning there was a change
to the tree.

>
> Apart from this, can you explain the concept of orphaned nodes.

This is one of the difficult parts of the send. Each existing inode
has at least one hard-link (INODE_REF), but it can have more than one.
Consider the following simple case:
- in snapshot S1 inode X had hardlink HL1
- user added a new hardlink HL2 to inode X and deleted the first hardlink HL1
- user took snapshot S2

Now we compare between S1 and S2. While processing the changes, we
cannot blindly generate "unlink HL1" command, because this would
delete the inode X on the receive side. And when we get to create a
new hardlink HL2, it is too late, because the inode on receive side is
already gone. So for such cases, we may rename inode X to the orphan
name. This is a temp name, which is generated based on (inode number,
inode generation) tuple. Then later, we rename this temporary name to
HL2.

This is just an example, there are more complicated cases. If you look
at the code, you see the concept of "first ref". This is kind of "the
main inode name". So if we suspect that this name becomes unavailable,
we rename the inode to the orphan name. Later, we may delete the inode
(if it doesn't receive a new HL) or rename to the new HL.

Another example:
- in snapshot S1, we had inode X with hardlink HLX1 and inode Y with HLY1
- user added HLY2 to inode Y
- user deleted HLY1 (inode Y still exists, because it has HLY2)
- user added HLY1 to inode X (now it has two hardlinks)
- user created snapshot S2.

So now we compare between snapshots.
It may happen that we process inode X first. And we may want to add
hardlink HLY1 to it. But if we do it blindly, we will kill inode Y. So
we must first "orphanize" inode Y, and then we can add HLY1 to inode
X. Later, inode Y will receive new hardlink HLY2.

I suggest you try scenarios like follows:
- Add HL to existing file, which overwrites 'second' HL of another existing file
- Add HL to existing file, which overwrites 'first' HL of another existing file
- Add HL to existing file, which overwrites 'second' HL of another
existing file, but the existing file has lower inode number
- Add HL to existing file, which overwrites 'first' HL of another
existing file, but the existing file has lower inode number

Key thing is that btrfs_compare_trees() works according to inode
numbers, and not necessarily to the order of user-operatons between
snapshots.

See you next week:)

Alex.








>
> Thanks!
>
>
>
>
> On Sun, Dec 9, 2012 at 2:44 PM, Alex Lyakas <alex.btrfs@zadarastorage.com>
> wrote:
>>
>> Mohit, Nafisa,
>> you should start reading from "changed_cb" function, which is the one
>> that notifies the send code about a particular change that needs to be
>> addressed.
>>
>> The lowest-level instruction generation happens in functions like
>> "send_rename", "send_link", "send_unlink", "send_truncate" etc.
>>
>> The best way to understand what is in between, is to stuff the code
>> with printk's and see what is happening (do a small change to the
>> file, observe the prints). This is how I learned:)
>>
>> For starter, for example, create some file, do send, then grow the
>> file and see how the send code detects and reacts to this change. The
>> trickiest part is handling the changes in file name/hardlinks. So try
>> to rename the file and see what the code does.
>>
>> You may also read through discussions with Alexander Block on the
>> list, on the link that I posted and others.
>>
>> Alex.
>>
>>
>> On Thu, Dec 6, 2012 at 11:16 AM, Mohit Bhadade <mohitbhadade@gmail.com>
>> wrote:
>> > Hello,
>> > Could oomeone please tell me how the instruction generation based on
>> > differences in snapshots takes place in the send receive code. ? I am
>> > going
>> > through the code but cant understand the hierarchy of structures
>> > declared in
>> > it. Some one please direct me to the function where the instructions are
>> > generated.
>> >
>> > Thanks
>> >
>> >
>> > On Sat, Dec 1, 2012 at 2:00 PM, Alex Lyakas
>> > <alex.btrfs@zadarastorage.com>
>> > wrote:
>> >>
>> >> Hi nafisa,
>> >> in order to understand how btrfs send code compares two btrfs file
>> >> trees, you may read this:
>> >> http://www.spinics.net/lists/linux-btrfs/msg17731.html (where I am
>> >> trying to understand it) and further down the thread. It's a very nice
>> >> algorithm, actually.
>> >>
>> >> Thanks,
>> >> Alex.
>> >>
>> >>
>> >>
>> >> On Sat, Dec 1, 2012 at 9:54 AM, nafisa mandliwala
>> >> <nafisa.mandliwala@gmail.com> wrote:
>> >> > I needed help with understanding the snapshot comparison algorithm
>> >> > that snapper uses and its shortcomings. From reading the code, what I
>> >> > understood is that it does a block by block compare. I'm not very
>> >> > sure
>> >> > if that's the best way to go about it. Also, since the send receive
>> >> > code is still in development stages, is there a scope to add more
>> >> > functionality to it?
>> >> > --
>> >> > To unsubscribe from this list: send the line "unsubscribe
>> >> > linux-btrfs"
>> >> > in
>> >> > the body of a message to majordomo@vger.kernel.org
>> >> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
>> >> in
>> >> the body of a message to majordomo@vger.kernel.org
>> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >
>> >
>
>
