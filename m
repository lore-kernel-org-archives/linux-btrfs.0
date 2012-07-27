Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46752 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab2G0OhM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jul 2012 10:37:12 -0400
Received: by obbuo13 with SMTP id uo13so4351789obb.19
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Jul 2012 07:37:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB9VWqAv-86CtAgitTD0BBaifomMGVsGZEnhaMsZ4DNV8DndFA@mail.gmail.com>
References: <CAHf9xvbz92KdUrXHhEFyEqwFhA97yTw7=10YC8YyCMxDZ20_Yw@mail.gmail.com>
	<CAB9VWqDS+zVku2diCYh08k=V_iT10fssRpEFcw9p8rn+dtaQqg@mail.gmail.com>
	<CAHf9xvbaWkM8EqeBA-z1HaFV56vtMfWjpZDp+OfUGu88nsOzug@mail.gmail.com>
	<CAHf9xvaj+uzWc39Hp5SLaVfevhwqvNXY9eWBY0Q-yT=7yPgS-w@mail.gmail.com>
	<CAB9VWqDj5c2Ds=zthKdUPfNyGELgaTmfj9UHf4uvqxMs4--9+Q@mail.gmail.com>
	<CAB9VWqAv-86CtAgitTD0BBaifomMGVsGZEnhaMsZ4DNV8DndFA@mail.gmail.com>
Date: Fri, 27 Jul 2012 17:37:10 +0300
Message-ID: <CAHf9xvYApp7yEmX7BCi1Y3Ut7hX2VDxAkJgAxNp-FtkQCBiXUQ@mail.gmail.com>
Subject: Re: btrfs send/receive: if new inode ino is less than its new
 directory ino, incorrect path is sent
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: Alexander Block <ablock84@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: multipart/mixed; boundary=f46d044786e7c43d1f04c5d0a507
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--f46d044786e7c43d1f04c5d0a507
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Alexander,
your solution is simple and elegant. I this this issue is solved now. Thank=
s!
Two minor issues:
1)
/*
 * We need some special handling for inodes that get processed before the p=
arent
 * directory got created. See process_all_refs for details.
 * This function does the check if we already created the dir out of order.
 */
/*
 * Only creates the inode if it is:
 * 1. Not a directory
 * 2. Or a directory which was not created already due to out of order
 *    directories. See did_create_dir and process_all_refs for details.
 */

These comments tell to look at process_all_refs(), while we should
look at process_recorded_refs().

2)
		 * We can however not delete the orphan in case the inode relies
		 * in a directory that was not created yet (see
		 * __record_new_ref)
		 */
This part should be removed, because your new solution does not work this w=
ay.


If you find, time, pls look at the two attached scripts.

btrfs_test_1.sh:
it tries to explore the is_first_ref() issue and founds a problem.
Proposed patch - compare also the (dir,gen) tuple and only the name:

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 68e504c..b83ec5f 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1597,7 +1597,7 @@ out:

 static int is_first_ref(struct send_ctx *sctx,
                        struct btrfs_root *root,
-                       u64 ino, u64 dir,
+                       u64 ino, u64 dir, u64 dir_gen,
                        const char *name, int name_len)
 {
        int ret;
@@ -1613,6 +1613,11 @@ static int is_first_ref(struct send_ctx *sctx,
        if (ret < 0)
                goto out;

+       if (dir !=3D tmp_dir || dir_gen !=3D tmp_dir_gen) {
+               ret =3D 0;
+               goto out;
+       }
+
        if (name_len !=3D fs_path_len(tmp_name)) {
                ret =3D 0;
                goto out;
@@ -2834,7 +2839,7 @@ verbose_printk("btrfs: process_recorded_refs
%llu\n", sctx->cur_ino);
                        goto out;
                if (ret) {
                        ret =3D is_first_ref(sctx, sctx->parent_root,
-                                       ow_inode, cur->dir, cur->name,
+                                       ow_inode, cur->dir,
cur->dir_gen, cur->name,
                                        cur->name_len);
                        if (ret < 0)
                                goto out;


btrfs_test_2.sh
The last test exposes an interesting issue: when a directory has a
deleted reference recorded, this deleted reference is not added to the
'check_dirs' list. As a result, the upper directory (already
orphanized) is not rmdir'd.

Thanks,
Alex.



On Fri, Jul 27, 2012 at 12:42 AM, Alexander Block
<ablock84@googlemail.com> wrote:
> I have pushed a for-alex branch to github with a new approach for the
> whole problem. Can you test this?
>
> On Thu, Jul 26, 2012 at 4:07 PM, Alexander Block
> <ablock84@googlemail.com> wrote:
>> I'm currently working on another solution for the initial problem. I
>> will create a for-alex branch for you to test later.
>>
>> On Thu, Jul 26, 2012 at 4:04 PM, Alex Lyakas
>> <alex.bolshoy.btrfs@gmail.com> wrote:
>>> Alexander,
>>> (pls let me know when this gets annoying:).
>>>
>>> Parent:
>>> /mnt/src/v2_snap0/
>>> =E2=94=94=E2=94=80=E2=94=80 [    257]  file1
>>>
>>> Send:
>>> /mnt/src/v2_snap1
>>> =E2=94=94=E2=94=80=E2=94=80 [    259]  dir1
>>>     =E2=94=94=E2=94=80=E2=94=80 [    258]  dir2
>>>         =E2=94=94=E2=94=80=E2=94=80 [    257]  file1
>>>
>>> I encountered two problems:
>>> 1) process_recorded_refs_if_needed() if needed does not call
>>> process_recorded_refs() if both new_refs and deleted_refs() are empty.
>>> But in this case, we need to get to finish_outoforder_dir() by dir2 to
>>> move file1 under it (this is before dir1 is created).
>>>
>>> @@ -4199,8 +4227,25 @@ static int
>>> process_recorded_refs_if_needed(struct send_ctx *sctx, int at_end)
>>>         if (!at_end && sctx->cur_ino =3D=3D sctx->cmp_key->objectid &&
>>>             sctx->cmp_key->type <=3D BTRFS_INODE_REF_KEY)
>>>                 goto out;
>>> -       if (list_empty(&sctx->new_refs) && list_empty(&sctx->deleted_re=
fs))
>>> -               goto out;
>>> +       if (list_empty(&sctx->new_refs) && list_empty(&sctx->deleted_re=
fs) &&
>>> +               /*
>>> +                * If this is a new directory, still do the
>>> finish_outoforder_dir() thing,
>>> +                * even though it has no references recorded. This
>>> means that the directory's
>>> +                * parent has higher inode and was not created yet
>>> (thus we should have
>>> +                * sctx->cur_inode_first_ref_orphan flag set).
>>> +                * Note that after a call to process_recorded_refs(),
>>> new_refs and deleted_refs
>>> +                * become empty, which prevents further calls to
>>> process_recorded_refs(),
>>> +                * but here we need something else to prevent it, so
>>> look at send_progress too.
>>> +                */
>>> +               !(S_ISDIR(sctx->cur_inode_mode) && sctx->cur_inode_new =
&&
>>> +                 sctx->cur_inode_first_ref_orphan &&
>>> sctx->send_progress =3D=3D sctx->cur_ino))
>>> +               goto out;
>>>
>>>         ret =3D process_recorded_refs(sctx);
>>>
>>> Then I encountered another problem that finish_outoforder_dir() does
>>> not check for itself the cur_inode_first_ref_orphan flag:
>>> @@ -2736,7 +2754,17 @@ static int finish_outoforder_dir(struct
>>> send_ctx *sctx, u64 dir, u64 dir_gen)
>>>         }
>>>         fctx.dir_ino =3D dir;
>>>
>>> -       ret =3D get_cur_path(sctx, dir, dir_gen, fctx.dir_path, 1/*do_p=
rint*/);
>>> +       /*
>>> +        * If the current directory itself has a parent, which was not
>>> +        * created yet, we need to use gen_unique_name().
>>> +        */
>>> +       BUG_ON(sctx->cur_ino !=3D dir || sctx->cur_inode_gen !=3D dir_g=
en);
>>> +       if (sctx->cur_inode_first_ref_orphan)
>>> +               ret =3D gen_unique_name(sctx, dir, dir_gen, fctx.dir_pa=
th);
>>> +       else
>>> +               ret =3D get_cur_path(sctx, dir, dir_gen, fctx.dir_path)=
;
>>>
>>> Finally, the send_truncate(), send_chmod(), send_chown(),send_utimes()
>>> need the following check:
>>>
>>>         if (sctx->cur_ino =3D=3D ino && sctx->cur_inode_first_ref_orpha=
n) {
>>>                 WARN_ON(sctx->cur_inode_gen !=3D gen);
>>>                 ret =3D gen_unique_name(sctx, ino, gen, p);
>>>         } else {
>>>                 ret =3D get_cur_path(sctx, ino, gen, p);
>>>         }
>>>
>>> All of them except utimes() are used with cur_ino only, so for those
>>> this check is redundant (and probably makes sense to drop ino/gen
>>> parameters of them?).
>>>
>>> Thanks,
>>> Alex.
>>>
>>>
>>> On Thu, Jul 26, 2012 at 1:52 PM, Alex Lyakas
>>> <alex.bolshoy.btrfs@gmail.com> wrote:
>>>> Hi Alexander,
>>>> I did some very initial testing, and there is still an issue.
>>>> The logic of finish_outoforder_dir works as expected. But then problem
>>>> is that later, when we process xattr/extents or finish the inode, the
>>>> code still uses get_cur_path(), which brings an incorrect name.
>>>>
>>>> Consider the following simple scenario:
>>>>
>>>> Parent tree:
>>>> /mnt/src/v2
>>>> =E2=94=94=E2=94=80=E2=94=80 [    260]  file1
>>>>
>>>> Send tree:
>>>> /mnt/src/v2
>>>> =E2=94=94=E2=94=80=E2=94=80 [    262]  dir1
>>>>     =E2=94=94=E2=94=80=E2=94=80 [    260]  file1
>>>>
>>>> So when file1 is being processed, it is first renamed, as expected:
>>>>  C_RENAME: A_PATH=3Dfile1, A_PATH_TO=3Do260-511-0
>>>> But then, when we finish it, we do:
>>>> C_TRUNCATE: A_PATH=3Do262-517-0/file1, A_SIZE=3D16
>>>>
>>>> So in some functions like send_truncate(), send_write(), send_utimes()
>>>> etc, we need:
>>>>
>>>> -       ret =3D get_cur_path(sctx, ino, gen, p, 0/*do_print*/);
>>>> +       if (sctx->cur_inode_first_ref_orphan)
>>>> +               ret =3D gen_unique_name(sctx, ino, gen, p);
>>>> +       else
>>>> +               ret =3D get_cur_path(sctx, ino, gen, p, 0/*do_print*/)=
;
>>>>         if (ret < 0)
>>>>                 goto out;
>>>>
>>>> I will continue testing more complicated cases now.
>>>>
>>>> Thanks,
>>>> Alex.
>>>>
>>>>
>>>>
>>>>
>>>>
>>>>
>>>>
>>>>
>>>> On Tue, Jul 24, 2012 at 11:26 PM, Alexander Block
>>>> <ablock84@googlemail.com> wrote:
>>>>> On Wed, Jul 18, 2012 at 7:45 PM, Alex Lyakas
>>>>> <alex.bolshoy.btrfs@gmail.com> wrote:
>>>>>> Hi Alexander,
>>>>>> I am testing different scenarios in order to better understand the
>>>>>> non-trivial magic of
>>>>>> get_cur_path()/will_overwrite_ref()/did_overwrite_ref()/did_overwrit=
e_first_ref().
>>>>>> I hit the following issue, when testing full-send:
>>>>>>
>>>>>> This is my source subvolume (inode numbers are written):
>>>>>> tree -A  --inodes --noreport /mnt/src/tmp/
>>>>>> /mnt/src/tmp/
>>>>>> =E2=94=94=E2=94=80=E2=94=80 [    270]  dir2
>>>>>>     =E2=94=94=E2=94=80=E2=94=80 [    268]  file1_nod
>>>>>>
>>>>>> As you see, the ino(file1_nod) < ino(dir2). It is very easy to
>>>>>> achieve: first create the file, then the dir, and then move the file
>>>>>> to dir.
>>>>>>
>>>>>> During send the following happens (I augmented the send code with ma=
ny prints):
>>>>>>
>>>>>> file1_nod is sent first. Since its a new inode, it is sent as an
>>>>>> orphan. When recording its reference, __record_new_ref() calls
>>>>>> get_cur_path() for its parent (270). Then __get_cur_name_and_parent(=
)
>>>>>> is called on 270, which calls is_inode_existent(), which calls
>>>>>> get_cur_inode_state(), and the state of the parent is "will_create".
>>>>>> So __get_cur_name_and_parent() creates an orphan name for it, and
>>>>>> finally the new reference for 268 is recorded as:
>>>>>> o270-136-0/file1_nod:
>>>>>>
>>>>>> [changed_cb:4102] key(256 INODE_ITEM 0) : NEW
>>>>>> [changed_cb:4102] key(256 INODE_REF 256) : NEW
>>>>>> [changed_cb:4102] key(268 INODE_ITEM 0) : NEW
>>>>>> [send_create_inode:2407] NEW ino(268,135) type=3D0100000, path=3D[o2=
68-135-0]
>>>>>> [changed_cb:4102] key(268 INODE_REF 270) : NEW
>>>>>> [get_cur_inode_state:1475] (270,136): L(EX,136)
>>>>>> R(NE,18446744072099047770) sp=3D268 =3D=3D> will_create
>>>>>> [is_inode_existent:1498] (270,136): NOT existent
>>>>>> [__get_cur_name_and_parent:1918] ino(270,136) not existent =3D> uniq=
ue
>>>>>> name [o270-136-0]
>>>>>> [get_cur_path:2051] ino(0,0) cur_path=3D[o270-136-0]
>>>>>> [__record_new_ref:2911] record new ref [o270-136-0/file1_nod]
>>>>>>
>>>>>> Then process_recorded_refs() sees that 268 is still orphan, so it
>>>>>> sends "rename" to its valid place, but the problem is that its paren=
t
>>>>>> dir was not sent yet (and its parent dir is also an orphan):
>>>>>> [process_recorded_refs:2601] ino(268,135): start with refs
>>>>>> [28118.347602] [process_recorded_refs:2651] ino(268,135): new=3D1,
>>>>>> did_overwrite_first_ref=3D0, is_orphan=3D1, valid_path=3D[o268-135-0=
]
>>>>>> [28118.347605] [process_recorded_refs:2701] ino(268,135): is orphan,
>>>>>> move it: [o268-135-0]=3D>[o270-136-0/file1_nod]
>>>>>> [28118.347610] [process_recorded_refs:2837] checking dir(270,136)
>>>>>> [28118.347612] [process_recorded_refs:2869] ino(268,135) done with r=
efs
>>>>>>
>>>>>> Now the parent dir is processed:
>>>>>> [changed_cb:4102] key(270 INODE_ITEM 0) : NEW
>>>>>> [send_create_inode:2407] NEW ino(270,136) type=3D040000, path=3D[o27=
0-136-0]
>>>>>> [changed_cb:4102] key(270 INODE_REF 256) : NEW
>>>>>> [get_cur_path:2051] ino(256,133) cur_path=3D[]
>>>>>> [__record_new_ref:2911] record new ref [dir2]
>>>>>> [process_recorded_refs:2601] ino(270,136): start with refs
>>>>>> [process_recorded_refs:2651] ino(270,136): new=3D1,
>>>>>> did_overwrite_first_ref=3D0, is_orphan=3D1, valid_path=3D[o270-136-0=
]
>>>>>> [process_recorded_refs:2701] ino(270,136): is orphan, move it:
>>>>>> [o270-136-0]=3D>[dir2]
>>>>>> [process_recorded_refs:2837] checking dir(256,133)
>>>>>> [get_cur_inode_state:1475] (256,133): L(EX,133)
>>>>>> R(NE,18446612135413283512) sp=3D270 =3D=3D> did_create
>>>>>> [process_recorded_refs:2869] ino(270,136) done with refs
>>>>>>
>>>>>> Nothing special here, the parent is first sent as an orphan, and the=
n
>>>>>> renamed to its valid name, but it's too late.
>>>>>>
>>>>>> During receive:
>>>>>> ERROR: rename o268-135-0 -> o270-136-0/file1_nod failed. No such fil=
e
>>>>>> or directory
>>>>>>
>>>>>> I am not yet sure where is the proper place to fix this, I just want=
ed
>>>>>> to report it first. Basically, I think that when sending any kind of
>>>>>> A_PATH, it is needed to ensure that path components exist, either as
>>>>>> orphan or real path (by sending them out-of-order if needed?). But I
>>>>>> am not yet sure where is the core place that should ensure this.
>>>>>>
>>>>>> Thanks,
>>>>>> Alex.
>>>>>
>>>>> I have pushed a fix for this case. Basically, the solution is to
>>>>> postpone the processing of refs in not created dirs until the dir is
>>>>> created. Big thanks for investigating this one.

--f46d044786e7c43d1f04c5d0a507
Content-Type: application/x-sh; name="btrfs_init_tests.sh"
Content-Disposition: attachment; filename="btrfs_init_tests.sh"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h55dkdmq0

IyEgL2Jpbi9iYXNoCgpzZXQgLWUKCmVjaG8gIkNsZWFudXAuLi4uIgouL2J0cmZzIHN1YiBkZWwg
L21udC9zcmMvY2cwIHx8IHRydWUKLi9idHJmcyBzdWIgZGVsIC9tbnQvc3JjL3NuYXBfY2cwX29y
aWcvIHx8IHRydWUKLi9idHJmcyBzdWIgZGVsIC9tbnQvc3JjL3NuYXAwLyB8fCB0cnVlCi4vYnRy
ZnMgc3ViIGRlbCAvbW50L2RzdC9zbmFwMC8gfHwgdHJ1ZQouL2J0cmZzIHN1YiBkZWwgL21udC9k
c3Qvc25hcDEvIHx8IHRydWUKCmVjaG8gIkNyZWF0ZSBiYXNlIHN1YnZvbHVtZSBhbmQgZmlsbCB3
aXRoIGRhdGEuLi4iCi4vYnRyZnMgc3ViIGNyZWF0ZSAvbW50L3NyYy9jZzAKbWtkaXIgL21udC9z
cmMvY2cwL2RpcjEKZGQgaWY9L2Rldi91cmFuZG9tIG9mPS9tbnQvc3JjL2NnMC9maWxlMV9ub2Qg
YnM9MSBjb3VudD0xNjMKZGQgaWY9L2Rldi91cmFuZG9tIG9mPS9tbnQvc3JjL2NnMC9maWxlMl9u
b2QgYnM9MSBjb3VudD05NTE1IHNlZWs9MTQwMDAwCmRkIGlmPS9kZXYvdXJhbmRvbSBvZj0vbW50
L3NyYy9jZzAvZGlyMS9maWxlMl9kaXIxIGJzPTEgY291bnQ9MjAwMDAgc2Vlaz0xMDAwMApkZCBp
Zj0vZGV2L3VyYW5kb20gb2Y9L21udC9zcmMvY2cwL2RpcjEvZmlsZTFfZGlyMSBicz0xIGNvdW50
PTcyMDYzCmNwIC9tbnQvc3JjL2NnMC9kaXIxL2ZpbGUyX2RpcjEgL21udC9zcmMvY2cwL2RpcjEv
ZmlsZTNfZGlyMV90cnVuYwpkZCBpZj0vZGV2L3VyYW5kb20gb2Y9L21udC9zcmMvY2cwL2RpcjEv
ZmlsZTNfZGlyMV90cnVuYyBicz0xIHNlZWs9Njk5OTkgY291bnQ9MSBjb252PW5vdHJ1bmMKdG91
Y2ggL21udC9zcmMvY2cwL2ZpbGUyX25vZAp0b3VjaCAvbW50L3NyYy9jZzAvZmlsZTNfbm9kCnRv
dWNoIC9tbnQvc3JjL2NnMC9kaXIxL2ZpbGU0X2RpcjEKbWtkaXIgL21udC9zcmMvY2cwL2RpcjIK
bG4gL21udC9zcmMvY2cwL2RpcjEvZmlsZTFfZGlyMSAvbW50L3NyYy9jZzAvZGlyMi9maWxlMV9k
aXIxX0hMCnRvdWNoIC9tbnQvc3JjL2NnMC9kaXIyL2ZpbGUxX2RpcjIKbWtkaXIgL21udC9zcmMv
Y2cwL2RpcjIvZGlyMwp0b3VjaCAvbW50L3NyYy9jZzAvZGlyMi9kaXIzL2ZpbGUxX2RpcjMKdG91
Y2ggL21udC9zcmMvY2cwL2RpcjIvZGlyMy9maWxlMl9kaXIzCnRvdWNoIC9tbnQvc3JjL2NnMC9k
aXIyL2RpcjMvZmlsZTNfZGlyMwpsbiAvbW50L3NyYy9jZzAvZGlyMS9maWxlMV9kaXIxIC9tbnQv
c3JjL2NnMC9kaXIyL2RpcjMvCgplY2hvICJDcmVhdGluZyBiYWNrdXAgc25hcC4uLiIKLi9idHJm
cyBzdWIgc25hcCAtciAvbW50L3NyYy9jZzAgL21udC9zcmMvc25hcF9jZzBfb3JpZy8KCmVjaG8g
IkNyZWF0aW5nIGJhc2Ugc25hcCBmb3Igc2VuZCAuLi4iCi4vYnRyZnMgc3ViIHNuYXAgLXIgL21u
dC9zcmMvY2cwIC9tbnQvc3JjL3NuYXAwCmVjaG8gIlNlbmRpbmcgZnVsbCB0cmVlLi4uIgouL2J0
cmZzIHNlbmQgLXYgLXYgLXYgL21udC9zcmMvc25hcDAgPiAvdG1wL2R1bXAKZWNobyAiUmVjZWl2
aW5nLi4uIgouL2J0cmZzIHJlY2VpdmUgL21udC9kc3QgPCAvdG1wL2R1bXAKCmVjaG8gIkNoZWNr
aW5nIGRpZmYgLXIiCmRpZmYgLXIgL21udC9zcmMvc25hcDAgL21udC9kc3Qvc25hcDAgCgplY2hv
ICJEb25lIHNldHRpbmcgdXAgdGVzdDoiCnRyZWUgLUEgIC0taW5vZGVzIC0tbm9yZXBvcnQgL21u
dC9zcmMvY2cwCg==
--f46d044786e7c43d1f04c5d0a507
Content-Type: application/x-sh; name="btrfs_test_1.sh"
Content-Disposition: attachment; filename="btrfs_test_1.sh"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h55dkdmt1

IyEgL2Jpbi9iYXNoCgpzZXQgLWUKCnJlc3RvcmUoKQp7CgllY2hvICItLS0tLS1SZXN0b3JlIGJh
c2Ugc25hcHNob3QtLS0tLS0tLS0iCgllY2hvICJEZWxldGUgbGFzdCBzbmFwLCBpZiBhbnkiCgku
L2J0cmZzIHN1YiBkZWwgL21udC9zcmMvc25hcDEgfHwgdHJ1ZQoJZWNobyAiRGVsZXRlIGNnMCIK
CS4vYnRyZnMgc3ViIGRlbCAvbW50L3NyYy9jZzAKCWVjaG8gIlJlLWNyZWF0ZSBjZzAgZnJvbSBz
bmFwMCIKCS4vYnRyZnMgc3ViIHNuYXAgL21udC9zcmMvc25hcDAgL21udC9zcmMvY2cwCgl0cmVl
IC1BICAtLWlub2RlcyAtLW5vcmVwb3J0IC9tbnQvc3JjL2NnMQoJZWNobyAiLS0tLS0tQmFzZSBz
bmFwc2hvdCByZXN0b3JlZC0tLS0tLS0tLSIKfQoKZG9fZGlmZl9zZW5kKCkKewoJZWNobyAiRGVs
ZXRlIHNuYXAxIGlmIGFueSIKCS4vYnRyZnMgc3ViIGRlbCAvbW50L3NyYy9zbmFwMSB8fCB0cnVl
CgllY2hvICJDcmVhdGUgc25hcDEgZnJvbSBjZzAiCgkuL2J0cmZzIHN1YiBzbmFwIC1yIC9tbnQv
c3JjL2NnMCAvbW50L3NyYy9zbmFwMQoJZWNobyAic2VuZCBzbmFwMSIKCS4vYnRyZnMgc2VuZCAt
diAtdiAtdiAtdiAtcCAvbW50L3NyYy9zbmFwMCAvbW50L3NyYy9zbmFwMSA+IC90bXAvZHVtcAoJ
ZWNobyAiUHJpbnQgcHJldiBhbmQgY3VyciB0cmVlcyIKCXRyZWUgLUEgIC0taW5vZGVzIC0tbm9y
ZXBvcnQgL21udC9zcmMvc25hcDAKCXRyZWUgLUEgIC0taW5vZGVzIC0tbm9yZXBvcnQgL21udC9z
cmMvc25hcDEKCQoJZWNobyAiRGVsZXRlIHNuYXAxIGlmIGFueSBvbiBkZXN0IgoJLi9idHJmcyBz
dWIgZGVsIC9tbnQvZHN0L3NuYXAxIHx8IHRydWUKCWVjaG8gIlJlY2VpdmUiCgkuL2J0cmZzIHJl
Y2VpdmUgLXYgLXYgLXYgL21udC9kc3QvICA8IC90bXAvZHVtcAoJZWNobyAiVmFsaWRhdGUiCglk
aWZmIC1yIC9tbnQvc3JjL3NuYXAxIC9tbnQvZHN0L3NuYXAxCgllY2hvICJTdWNjZXNzISIKfQoK
ZG9fZnVsbF9zZW5kKCkKewoJZWNobyAiRGVsZXRlIHNuYXAxIGlmIGFueSIKCS4vYnRyZnMgc3Vi
IGRlbCAvbW50L3NyYy9zbmFwMSB8fCB0cnVlCgllY2hvICJDcmVhdGUgc25hcDEgZnJvbSBjZzAi
CgkuL2J0cmZzIHN1YiBzbmFwIC1yIC9tbnQvc3JjL2NnMCAvbW50L3NyYy9zbmFwMQoJZWNobyAi
c2VuZCBzbmFwMSBmdWxseSIKCS4vYnRyZnMgc2VuZCAtdiAtdiAtdiAtdiAvbW50L3NyYy9zbmFw
MSA+IC90bXAvZHVtcAoJZWNobyAiUHJpbnQgZnVsbCB0cmVlIgoJdHJlZSAtQSAgLS1pbm9kZXMg
LS1ub3JlcG9ydCAvbW50L3NyYy9zbmFwMQoKCWVjaG8gIkRlbGV0ZSBzbmFwMSBpZiBhbnkgb24g
ZGVzdCIKCS4vYnRyZnMgc3ViIGRlbCAvbW50L2RzdC9zbmFwMSB8fCB0cnVlCgllY2hvICJSZWNl
aXZlIgoJLi9idHJmcyByZWNlaXZlIC12IC12IC12IC9tbnQvZHN0LyAgPCAvdG1wL2R1bXAKCWVj
aG8gIlZhbGlkYXRlIgoJZGlmZiAtciAvbW50L3NyYy9zbmFwMSAvbW50L2RzdC9zbmFwMQoJZWNo
byAiU3VjY2VzcyEiCn0KCgp0ZXN0MSgpCnsKZWNobyAiIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyIKZWNobyAgIkFkZCBITCB0byBleGlzdGluZyBmaWxlLCB3aGljaCBvdmVy
d3JpdGVzICdzZWNvbmQnIEhMIG9mIGFub3RoZXIgZXhpc3RpbmcgZmlsZSIKcmVzdG9yZQp1bmxp
bmsgL21udC9zcmMvY2cwL2RpcjIvZGlyMy9maWxlMV9kaXIxCmxuIC9tbnQvc3JjL2NnMC9maWxl
MV9ub2QgL21udC9zcmMvY2cwL2RpcjIvZGlyMy9maWxlMV9kaXIxCmRvX2RpZmZfc2VuZAplY2hv
ICAiVGVzdCBkb25lLiIKfQoKdGVzdDExKCkKewplY2hvICIjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIgplY2hvICAiQWRkIEhMIHRvIGV4aXN0aW5nIGZpbGUsIHdoaWNoIG92
ZXJ3cml0ZXMgJ2ZpcnN0JyBITCBvZiBhbm90aGVyIGV4aXN0aW5nIGZpbGUiCnJlc3RvcmUKdW5s
aW5rIC9tbnQvc3JjL2NnMC9kaXIxL2ZpbGUxX2RpcjEKbG4gL21udC9zcmMvY2cwL2ZpbGUxX25v
ZCAvbW50L3NyYy9jZzAvZGlyMS9maWxlMV9kaXIxCmRvX2RpZmZfc2VuZAplY2hvICAiVGVzdCBk
b25lLiIKfQoKdGVzdDExMSgpCnsKZWNobyAiIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyIKZWNobyAgIkFkZCBITCB0byBleGlzdGluZyBmaWxlLCB3aGljaCBvdmVyd3JpdGVz
ICdzZWNvbmQnIEhMIG9mIGFub3RoZXIgZXhpc3RpbmcgZmlsZSwgYnV0IHRoZSBleGlzdGluZyBm
aWxlIGlzIGxvd2VyIGlubyIKcmVzdG9yZQp1bmxpbmsgL21udC9zcmMvY2cwL2RpcjIvZGlyMy9m
aWxlMV9kaXIxCmxuIC9tbnQvc3JjL2NnMC9kaXIyL2RpcjMvZmlsZTNfZGlyMyAvbW50L3NyYy9j
ZzAvZGlyMi9kaXIzL2ZpbGUxX2RpcjEKZG9fZGlmZl9zZW5kCmVjaG8gICJUZXN0IGRvbmUuIgp9
Cgp0ZXN0MTEyKCkKewplY2hvICIjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IgplY2hvICAiQWRkIEhMIHRvIGV4aXN0aW5nIGZpbGUsIHdoaWNoIG92ZXJ3cml0ZXMgJ2ZpcnN0
JyBITCBvZiBhbm90aGVyIGV4aXN0aW5nIGZpbGUsIGJ1dCB0aGUgZXhpc3RpbmcgZmlsZSBpcyBs
b3dlciBpbm8iCnJlc3RvcmUKdW5saW5rIC9tbnQvc3JjL2NnMC9kaXIxL2ZpbGUxX2RpcjEKbG4g
L21udC9zcmMvY2cwL2RpcjIvZGlyMy9maWxlM19kaXIzIC9tbnQvc3JjL2NnMC9kaXIxL2ZpbGUx
X2RpcjEKZG9fZGlmZl9zZW5kCmVjaG8gICJUZXN0IGRvbmUuIgp9Cgp0ZXN0MTEyCg==
--f46d044786e7c43d1f04c5d0a507
Content-Type: application/x-sh; name="btrfs_test_2.sh"
Content-Disposition: attachment; filename="btrfs_test_2.sh"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h55dkdmv2

IyEgL2Jpbi9iYXNoCgpzZXQgLWUKCnJlc3RvcmUoKQp7CgllY2hvICItLS0tLS1SZXN0b3JlIGJh
c2Ugc25hcHNob3QtLS0tLS0tLS0iCgllY2hvICJEZWxldGUgbGFzdCBzbmFwLCBpZiBhbnkiCgku
L2J0cmZzIHN1YiBkZWwgL21udC9zcmMvc25hcDEgfHwgdHJ1ZQoJZWNobyAiRGVsZXRlIGNnMCIK
CS4vYnRyZnMgc3ViIGRlbCAvbW50L3NyYy9jZzAKCWVjaG8gIlJlLWNyZWF0ZSBjZzAgZnJvbSBz
bmFwMCIKCS4vYnRyZnMgc3ViIHNuYXAgL21udC9zcmMvc25hcDAgL21udC9zcmMvY2cwCgl0cmVl
IC1BICAtLWlub2RlcyAtLW5vcmVwb3J0IC9tbnQvc3JjL2NnMQoJZWNobyAiLS0tLS0tQmFzZSBz
bmFwc2hvdCByZXN0b3JlZC0tLS0tLS0tLSIKfQoKZG9fZGlmZl9zZW5kKCkKewoJZWNobyAiRGVs
ZXRlIHNuYXAxIGlmIGFueSIKCS4vYnRyZnMgc3ViIGRlbCAvbW50L3NyYy9zbmFwMSB8fCB0cnVl
CgllY2hvICJDcmVhdGUgc25hcDEgZnJvbSBjZzAiCgkuL2J0cmZzIHN1YiBzbmFwIC1yIC9tbnQv
c3JjL2NnMCAvbW50L3NyYy9zbmFwMQoJZWNobyAic2VuZCBzbmFwMSIKCS4vYnRyZnMgc2VuZCAt
diAtdiAtdiAtdiAtcCAvbW50L3NyYy9zbmFwMCAvbW50L3NyYy9zbmFwMSA+IC90bXAvZHVtcAoJ
ZWNobyAiUHJpbnQgcHJldiBhbmQgY3VyciB0cmVlcyIKCXRyZWUgLUEgIC0taW5vZGVzIC0tbm9y
ZXBvcnQgL21udC9zcmMvc25hcDAKCXRyZWUgLUEgIC0taW5vZGVzIC0tbm9yZXBvcnQgL21udC9z
cmMvc25hcDEKCQoJZWNobyAiRGVsZXRlIHNuYXAxIGlmIGFueSBvbiBkZXN0IgoJLi9idHJmcyBz
dWIgZGVsIC9tbnQvZHN0L3NuYXAxIHx8IHRydWUKCWVjaG8gIlJlY2VpdmUiCgkuL2J0cmZzIHJl
Y2VpdmUgLXYgLXYgLXYgL21udC9kc3QvICA8IC90bXAvZHVtcAoJZWNobyAiVmFsaWRhdGUiCglk
aWZmIC1yIC9tbnQvc3JjL3NuYXAxIC9tbnQvZHN0L3NuYXAxCgllY2hvICJTdWNjZXNzISIKfQoK
ZG9fZnVsbF9zZW5kKCkKewoJZWNobyAiRGVsZXRlIHNuYXAxIGlmIGFueSIKCS4vYnRyZnMgc3Vi
IGRlbCAvbW50L3NyYy9zbmFwMSB8fCB0cnVlCgllY2hvICJDcmVhdGUgc25hcDEgZnJvbSBjZzAi
CgkuL2J0cmZzIHN1YiBzbmFwIC1yIC9tbnQvc3JjL2NnMCAvbW50L3NyYy9zbmFwMQoJZWNobyAi
c2VuZCBzbmFwMSBmdWxseSIKCS4vYnRyZnMgc2VuZCAtdiAtdiAtdiAtdiAvbW50L3NyYy9zbmFw
MSA+IC90bXAvZHVtcAoJZWNobyAiUHJpbnQgZnVsbCB0cmVlIgoJdHJlZSAtQSAgLS1pbm9kZXMg
LS1ub3JlcG9ydCAvbW50L3NyYy9zbmFwMQoKCWVjaG8gIkRlbGV0ZSBzbmFwMSBpZiBhbnkgb24g
ZGVzdCIKCS4vYnRyZnMgc3ViIGRlbCAvbW50L2RzdC9zbmFwMSB8fCB0cnVlCgllY2hvICJSZWNl
aXZlIgoJLi9idHJmcyByZWNlaXZlIC12IC12IC12IC9tbnQvZHN0LyAgPCAvdG1wL2R1bXAKCWVj
aG8gIlZhbGlkYXRlIgoJZGlmZiAtciAvbW50L3NyYy9zbmFwMSAvbW50L2RzdC9zbmFwMQoJZWNo
byAiU3VjY2VzcyEiCn0KCnRlc3QxKCkKewplY2hvICIjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIgplY2hvICAiUmVtb3ZlIGRpciB3aXRoIGNvbnRlbnQsIHJlbmFtZSBhbm90
aGVyIGRpciB3aXRoIGxvd2VyIGlubyB0byB0aGlzIGRpciIKcmVzdG9yZQpybSAtciAvbW50L3Ny
Yy9jZzAvZGlyMi9kaXIzCm12IC9tbnQvc3JjL2NnMC9kaXIxIC9tbnQvc3JjL2NnMC9kaXIyL2Rp
cjMKZG9fZGlmZl9zZW5kCmVjaG8gICJUZXN0IGRvbmUuIgp9Cgp0ZXN0MTEoKQp7CmVjaG8gIiMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMiCmVjaG8gICJSZW1vdmUgZGlyIHdp
dGggY29udGVudCwgcmVuYW1lIGFub3RoZXIgZGlyIHdpdGggaGlnaGVyIGlubyB0byB0aGlzIGRp
ciIKcmVzdG9yZQpybSAtciAvbW50L3NyYy9jZzAvZGlyMQptdiAvbW50L3NyYy9jZzAvZGlyMi9k
aXIzIC9tbnQvc3JjL2NnMC9kaXIxIApkb19kaWZmX3NlbmQKZWNobyAgIlRlc3QgZG9uZS4iCn0K
dGVzdDIoKQp7CmVjaG8gIiMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMiCmVj
aG8gICJSZW1vdmUgZGlyIHdpdGggY29udGVudCwgcmVuYW1lIGFub3RoZXIgZGlyIHdpdGggaGln
aGVyIGlubyB0byB0aGlzIGRpciIKcmVzdG9yZQptdiAvbW50L3NyYy9jZzAvZGlyMi9kaXIzIC9t
bnQvc3JjL2NnMC9kaXIxMDAKcm0gLXIgL21udC9zcmMvY2cwL2RpcjIKbXYgL21udC9zcmMvY2cw
L2RpcjEwMCAvbW50L3NyYy9jZzAvZGlyMgpkb19kaWZmX3NlbmQKZWNobyAgIlRlc3QgZG9uZS4i
Cn0KCgp0ZXN0Mgo=
--f46d044786e7c43d1f04c5d0a507--
