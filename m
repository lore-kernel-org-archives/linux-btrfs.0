Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62675 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab2GZOH6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Jul 2012 10:07:58 -0400
Received: by pbbrp8 with SMTP id rp8so3281744pbb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Jul 2012 07:07:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHf9xvaj+uzWc39Hp5SLaVfevhwqvNXY9eWBY0Q-yT=7yPgS-w@mail.gmail.com>
References: <CAHf9xvbz92KdUrXHhEFyEqwFhA97yTw7=10YC8YyCMxDZ20_Yw@mail.gmail.com>
	<CAB9VWqDS+zVku2diCYh08k=V_iT10fssRpEFcw9p8rn+dtaQqg@mail.gmail.com>
	<CAHf9xvbaWkM8EqeBA-z1HaFV56vtMfWjpZDp+OfUGu88nsOzug@mail.gmail.com>
	<CAHf9xvaj+uzWc39Hp5SLaVfevhwqvNXY9eWBY0Q-yT=7yPgS-w@mail.gmail.com>
Date: Thu, 26 Jul 2012 16:07:57 +0200
Message-ID: <CAB9VWqDj5c2Ds=zthKdUPfNyGELgaTmfj9UHf4uvqxMs4--9+Q@mail.gmail.com>
Subject: Re: btrfs send/receive: if new inode ino is less than its new
 directory ino, incorrect path is sent
From: Alexander Block <ablock84@googlemail.com>
To: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm currently working on another solution for the initial problem. I
will create a for-alex branch for you to test later.

On Thu, Jul 26, 2012 at 4:04 PM, Alex Lyakas
<alex.bolshoy.btrfs@gmail.com> wrote:
> Alexander,
> (pls let me know when this gets annoying:).
>
> Parent:
> /mnt/src/v2_snap0/
> └── [    257]  file1
>
> Send:
> /mnt/src/v2_snap1
> └── [    259]  dir1
>     └── [    258]  dir2
>         └── [    257]  file1
>
> I encountered two problems:
> 1) process_recorded_refs_if_needed() if needed does not call
> process_recorded_refs() if both new_refs and deleted_refs() are empty.
> But in this case, we need to get to finish_outoforder_dir() by dir2 to
> move file1 under it (this is before dir1 is created).
>
> @@ -4199,8 +4227,25 @@ static int
> process_recorded_refs_if_needed(struct send_ctx *sctx, int at_end)
>         if (!at_end && sctx->cur_ino == sctx->cmp_key->objectid &&
>             sctx->cmp_key->type <= BTRFS_INODE_REF_KEY)
>                 goto out;
> -       if (list_empty(&sctx->new_refs) && list_empty(&sctx->deleted_refs))
> -               goto out;
> +       if (list_empty(&sctx->new_refs) && list_empty(&sctx->deleted_refs) &&
> +               /*
> +                * If this is a new directory, still do the
> finish_outoforder_dir() thing,
> +                * even though it has no references recorded. This
> means that the directory's
> +                * parent has higher inode and was not created yet
> (thus we should have
> +                * sctx->cur_inode_first_ref_orphan flag set).
> +                * Note that after a call to process_recorded_refs(),
> new_refs and deleted_refs
> +                * become empty, which prevents further calls to
> process_recorded_refs(),
> +                * but here we need something else to prevent it, so
> look at send_progress too.
> +                */
> +               !(S_ISDIR(sctx->cur_inode_mode) && sctx->cur_inode_new &&
> +                 sctx->cur_inode_first_ref_orphan &&
> sctx->send_progress == sctx->cur_ino))
> +               goto out;
>
>         ret = process_recorded_refs(sctx);
>
> Then I encountered another problem that finish_outoforder_dir() does
> not check for itself the cur_inode_first_ref_orphan flag:
> @@ -2736,7 +2754,17 @@ static int finish_outoforder_dir(struct
> send_ctx *sctx, u64 dir, u64 dir_gen)
>         }
>         fctx.dir_ino = dir;
>
> -       ret = get_cur_path(sctx, dir, dir_gen, fctx.dir_path, 1/*do_print*/);
> +       /*
> +        * If the current directory itself has a parent, which was not
> +        * created yet, we need to use gen_unique_name().
> +        */
> +       BUG_ON(sctx->cur_ino != dir || sctx->cur_inode_gen != dir_gen);
> +       if (sctx->cur_inode_first_ref_orphan)
> +               ret = gen_unique_name(sctx, dir, dir_gen, fctx.dir_path);
> +       else
> +               ret = get_cur_path(sctx, dir, dir_gen, fctx.dir_path);
>
> Finally, the send_truncate(), send_chmod(), send_chown(),send_utimes()
> need the following check:
>
>         if (sctx->cur_ino == ino && sctx->cur_inode_first_ref_orphan) {
>                 WARN_ON(sctx->cur_inode_gen != gen);
>                 ret = gen_unique_name(sctx, ino, gen, p);
>         } else {
>                 ret = get_cur_path(sctx, ino, gen, p);
>         }
>
> All of them except utimes() are used with cur_ino only, so for those
> this check is redundant (and probably makes sense to drop ino/gen
> parameters of them?).
>
> Thanks,
> Alex.
>
>
> On Thu, Jul 26, 2012 at 1:52 PM, Alex Lyakas
> <alex.bolshoy.btrfs@gmail.com> wrote:
>> Hi Alexander,
>> I did some very initial testing, and there is still an issue.
>> The logic of finish_outoforder_dir works as expected. But then problem
>> is that later, when we process xattr/extents or finish the inode, the
>> code still uses get_cur_path(), which brings an incorrect name.
>>
>> Consider the following simple scenario:
>>
>> Parent tree:
>> /mnt/src/v2
>> └── [    260]  file1
>>
>> Send tree:
>> /mnt/src/v2
>> └── [    262]  dir1
>>     └── [    260]  file1
>>
>> So when file1 is being processed, it is first renamed, as expected:
>>  C_RENAME: A_PATH=file1, A_PATH_TO=o260-511-0
>> But then, when we finish it, we do:
>> C_TRUNCATE: A_PATH=o262-517-0/file1, A_SIZE=16
>>
>> So in some functions like send_truncate(), send_write(), send_utimes()
>> etc, we need:
>>
>> -       ret = get_cur_path(sctx, ino, gen, p, 0/*do_print*/);
>> +       if (sctx->cur_inode_first_ref_orphan)
>> +               ret = gen_unique_name(sctx, ino, gen, p);
>> +       else
>> +               ret = get_cur_path(sctx, ino, gen, p, 0/*do_print*/);
>>         if (ret < 0)
>>                 goto out;
>>
>> I will continue testing more complicated cases now.
>>
>> Thanks,
>> Alex.
>>
>>
>>
>>
>>
>>
>>
>>
>> On Tue, Jul 24, 2012 at 11:26 PM, Alexander Block
>> <ablock84@googlemail.com> wrote:
>>> On Wed, Jul 18, 2012 at 7:45 PM, Alex Lyakas
>>> <alex.bolshoy.btrfs@gmail.com> wrote:
>>>> Hi Alexander,
>>>> I am testing different scenarios in order to better understand the
>>>> non-trivial magic of
>>>> get_cur_path()/will_overwrite_ref()/did_overwrite_ref()/did_overwrite_first_ref().
>>>> I hit the following issue, when testing full-send:
>>>>
>>>> This is my source subvolume (inode numbers are written):
>>>> tree -A  --inodes --noreport /mnt/src/tmp/
>>>> /mnt/src/tmp/
>>>> └── [    270]  dir2
>>>>     └── [    268]  file1_nod
>>>>
>>>> As you see, the ino(file1_nod) < ino(dir2). It is very easy to
>>>> achieve: first create the file, then the dir, and then move the file
>>>> to dir.
>>>>
>>>> During send the following happens (I augmented the send code with many prints):
>>>>
>>>> file1_nod is sent first. Since its a new inode, it is sent as an
>>>> orphan. When recording its reference, __record_new_ref() calls
>>>> get_cur_path() for its parent (270). Then __get_cur_name_and_parent()
>>>> is called on 270, which calls is_inode_existent(), which calls
>>>> get_cur_inode_state(), and the state of the parent is "will_create".
>>>> So __get_cur_name_and_parent() creates an orphan name for it, and
>>>> finally the new reference for 268 is recorded as:
>>>> o270-136-0/file1_nod:
>>>>
>>>> [changed_cb:4102] key(256 INODE_ITEM 0) : NEW
>>>> [changed_cb:4102] key(256 INODE_REF 256) : NEW
>>>> [changed_cb:4102] key(268 INODE_ITEM 0) : NEW
>>>> [send_create_inode:2407] NEW ino(268,135) type=0100000, path=[o268-135-0]
>>>> [changed_cb:4102] key(268 INODE_REF 270) : NEW
>>>> [get_cur_inode_state:1475] (270,136): L(EX,136)
>>>> R(NE,18446744072099047770) sp=268 ==> will_create
>>>> [is_inode_existent:1498] (270,136): NOT existent
>>>> [__get_cur_name_and_parent:1918] ino(270,136) not existent => unique
>>>> name [o270-136-0]
>>>> [get_cur_path:2051] ino(0,0) cur_path=[o270-136-0]
>>>> [__record_new_ref:2911] record new ref [o270-136-0/file1_nod]
>>>>
>>>> Then process_recorded_refs() sees that 268 is still orphan, so it
>>>> sends "rename" to its valid place, but the problem is that its parent
>>>> dir was not sent yet (and its parent dir is also an orphan):
>>>> [process_recorded_refs:2601] ino(268,135): start with refs
>>>> [28118.347602] [process_recorded_refs:2651] ino(268,135): new=1,
>>>> did_overwrite_first_ref=0, is_orphan=1, valid_path=[o268-135-0]
>>>> [28118.347605] [process_recorded_refs:2701] ino(268,135): is orphan,
>>>> move it: [o268-135-0]=>[o270-136-0/file1_nod]
>>>> [28118.347610] [process_recorded_refs:2837] checking dir(270,136)
>>>> [28118.347612] [process_recorded_refs:2869] ino(268,135) done with refs
>>>>
>>>> Now the parent dir is processed:
>>>> [changed_cb:4102] key(270 INODE_ITEM 0) : NEW
>>>> [send_create_inode:2407] NEW ino(270,136) type=040000, path=[o270-136-0]
>>>> [changed_cb:4102] key(270 INODE_REF 256) : NEW
>>>> [get_cur_path:2051] ino(256,133) cur_path=[]
>>>> [__record_new_ref:2911] record new ref [dir2]
>>>> [process_recorded_refs:2601] ino(270,136): start with refs
>>>> [process_recorded_refs:2651] ino(270,136): new=1,
>>>> did_overwrite_first_ref=0, is_orphan=1, valid_path=[o270-136-0]
>>>> [process_recorded_refs:2701] ino(270,136): is orphan, move it:
>>>> [o270-136-0]=>[dir2]
>>>> [process_recorded_refs:2837] checking dir(256,133)
>>>> [get_cur_inode_state:1475] (256,133): L(EX,133)
>>>> R(NE,18446612135413283512) sp=270 ==> did_create
>>>> [process_recorded_refs:2869] ino(270,136) done with refs
>>>>
>>>> Nothing special here, the parent is first sent as an orphan, and then
>>>> renamed to its valid name, but it's too late.
>>>>
>>>> During receive:
>>>> ERROR: rename o268-135-0 -> o270-136-0/file1_nod failed. No such file
>>>> or directory
>>>>
>>>> I am not yet sure where is the proper place to fix this, I just wanted
>>>> to report it first. Basically, I think that when sending any kind of
>>>> A_PATH, it is needed to ensure that path components exist, either as
>>>> orphan or real path (by sending them out-of-order if needed?). But I
>>>> am not yet sure where is the core place that should ensure this.
>>>>
>>>> Thanks,
>>>> Alex.
>>>
>>> I have pushed a fix for this case. Basically, the solution is to
>>> postpone the processing of refs in not created dirs until the dir is
>>> created. Big thanks for investigating this one.
