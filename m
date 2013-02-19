Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:39717 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756851Ab3BSH6a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Feb 2013 02:58:30 -0500
Received: by mail-we0-f175.google.com with SMTP id x8so5515340wey.34
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Feb 2013 23:58:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOcd+r0u=nF9V9wWGttQGMDbO7GJ+o-_CuaVf5Qi+-929WZt_A@mail.gmail.com>
References: <CAOcd+r36TOugPs+5P3W6v6m5pzojGnqZ3YUNS-zzFK2pdm1A8A@mail.gmail.com>
	<51079151.4070905@jan-o-sch.net>
	<CAOcd+r0u=nF9V9wWGttQGMDbO7GJ+o-_CuaVf5Qi+-929WZt_A@mail.gmail.com>
Date: Tue, 19 Feb 2013 09:58:28 +0200
Message-ID: <CAOcd+r1wVvxwDZE7SK5iVpCMK5nMq-VD7kXo91f4+AX9LALMgw@mail.gmail.com>
Subject: Re: backref for an extent not found in send_root (!backref_ctx->found_itself)
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Alexander Block <ablock84@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jan,
any luck reproducing this?

Alex.


On Thu, Jan 31, 2013 at 9:24 PM, Alex Lyakas
<alex.btrfs@zadarastorage.com> wrote:
> Hi Jan,
> attached are bash scripts to repro the issue.
>
> Some instructions on how to run them:
> - create 2 btrfs filesystems with "mkfs.btrfs /dev/sdXXX". I don't
> think that size matters.
> - mount them in /mnt/src and /mnt/dst
> - mount options: noatime,nodatasum,nodatacow,nospace_cache
> - put the 3 scripts into one directory and cd to it
> - run btrfs_init_tests.sh (it sets up a small file tree for tests)
> - run btrfs_test_first_ref_jan.sh
>
> After about 20-30 seconds, it hits the error I mentioned and script
> stops. It happens on "for-linus" branch, top commit
> 1eafa6c73791e4f312324ddad9cbcaf6a1b6052b.
> I suspect the issue might be that the test schedules a lot of
> subvolumes for deletion, and once the cleaner thread kicks in and also
> starts doing backref stuff, the problem happens.
>
> Another small note: there is an issue in btrfs-progs subvolume listing
> code (also used by send). When it finds a ROOT_ITEM in the root tree
> that is not linked with ROOT_REF/ROOT_BACKREF (i.e., one scheduled for
> deletion), it gets confused and exits. Miao sent a patch to fix it
> here:
> http://www.spinics.net/lists/linux-btrfs/msg19767.html
> I don't think it got merged into progs yet (progs are really behind:()
>
> If you want a quick fix, add code like this to the beginning of
> __list_subvol_fill_paths (but Miao sent a better patch):
>         /*
>          * due to change in __list_subvol_search(), root_lookup
>          * might contain subvolumes with ref_tree==0 (in deletion).
>          */
> again:
>         n = rb_first(&root_lookup->root);
>         while (n) {
>                 struct root_info *entry = rb_entry(n, struct root_info, rb_node);
>                 if (entry->ref_tree == 0) {
>                         fprintf(stderr, "__list_subvol_fill_paths: drop root_id=%llu,
> because it has no ref_tree\n", entry->root_id);
>                         rb_erase(n, &root_lookup->root);
>                         free(entry);
>                         goto again;
>                 }
>                 n = rb_next(n);
>         }
>
> Otherwise, "btrfs send" might fail, but this is not the failure we are
> looking for:)
>
> Thanks,
> Alex.
>
>
>
>
>
> On Tue, Jan 29, 2013 at 11:07 AM, Jan Schmidt <list.btrfs@jan-o-sch.net> wrote:
>> Hi Alex,
>>
>> On Mon, January 28, 2013 at 17:11 (+0100), Alex Lyakas wrote:
>>> Hi Jan,
>>> I have a set of unit tests (part of the larger system) for the
>>> send-receive functionality, with which I am able to hit this error:
>>>
>>> Jan 28 18:01:00 687-dev kernel: [16968.451358] btrfs: ERROR did not
>>> find backref in send_root. inode=259, offset=139264, disk_byte=4263936
>>> found extent=4263936
>>>
>>> As the code states, this could indicate a bug in backref walking. This
>>> reproduces with "for-linus" branch.
>>>
>>> Typically this happens when a snapshot is deleted, immediately a new
>>> snap with the same name is created, and then "btrfs send" is issued
>>> without parent (i.e., full-send) on this snap.
>>>
>>> To debug this further, we can do one of two things:
>>> # I can apply patches/debug prints & reproduce
>>> # I can work to isolate the unit test into a bash script and send you
>>> a script that reproduces
>>
>> I'd prefer #2 of the above. You can also send me the unit tests you've got if I
>> can get them running without multiple days of setup.
>>
>> I'm guessing that this is more likely going to end up in send.c than in
>> backref.c, perhaps Alexander would like to trace this one down. But anyway, send
>> me a reproducer (in private, if you don't want to publish it) and we'll see
>> what's going on.
>>
>> Thanks,
>> -Jan
