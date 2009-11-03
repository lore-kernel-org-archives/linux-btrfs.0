From: Dmitry Monakhov <rjevskiy@gmail.com>
Subject: Re: ext3/jbd oops in journal_start
Date: Tue, 3 Nov 2009 13:01:49 +0300
Message-ID: <c18d6aa20911030201s2d1b7eb7q8897a3943bd04fbb@mail.gmail.com>
References: <Pine.LNX.4.64.0910302253100.1867@cobra.newdream.net>
	 <87bpjorn6g.fsf@openvz.org>
	 <Pine.LNX.4.64.0911022157360.26157@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0911022157360.26157@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

2009/11/3 Sage Weil <sage@newdream.net>:
> On Sat, 31 Oct 2009, Dmitry Monakhov wrote:
>
>> Sage Weil <sage@newdream.net> writes:
>>
>> > Hi,
>> >
>> > I'm consistently seeing ext3 oops on a fresh ~60 GB fs on 2.6.32-r=
c3 (and
>> > 2.6.31). =C2=A0data=3Dwriteback or data=3Dordered. =C2=A0It's not =
the hardware or
>> > drive... I have 8 boxes (each with slightly different hardware) th=
at crash
>> > identically.
>> Strange, 2.6.31 with ext3 is quite popular configuration...
>> Can you please post exact test-case.
>> >
>> > The oops is at fs/jbd/transaction.c, journal_start():
>> >
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 J_ASSERT(handle->h_trans=
action->t_journal =3D=3D journal);
>> *handle =3D journal_current_handle()
>>
>> IMHO it's looks like you have entered here with current->journal_inf=
o !=3D NULL
>>
>> , but journal_info contains unexpected data
>> This may happens in two cases:
>> 1) calling jbd code from other filesystem.
>> 2) Some fs forget to zero current->journal_info on exit from vfs
>> According to call trace we have got second case. Do you use some
>> unusual/experimental fs?
>
> Yep, it was #2. =C2=A0It turns out btrfs s setting current->journal_i=
nfo
> (for no reason that I can see?), and with the transaction ioctl a
> transaction can span multiple calls.
Whait a minute. Thats ioctl totally wrong! How it can prevent from prob=
lems?
issues:
1) If we are using this thechnic to preserving atomic behaviour, but
process dies unexpectedly in the midle of complex
operation which  must be done attomically. Then we call trans_end
which result in committing some internal file state.

2) What happens when second process try to touch file with opened
transaction? what behavuour expected from fsync?
process 1                                    process 2
1 fd =3D open("./file)                         open("./file")
2 ioctl_start_trans
3 write(fd, "a", 1)                           write(fd,"b", 1)
4                                                 fsync
5
What data do you expect after state (4), and after state (5)
>
> Chris, is it ok to just remove the journal_info bits? =C2=A0Nothing i=
n fs/btrfs
> even looks at it. =C2=A0I'm not sure what the point of only condition=
ally
> setting/clearly journal_info would be either, unless it's for debuggi=
ng or
> something?
>
> Thanks-
> sage
>
> ---
> From: Sage Weil <sage@newdream.net>
> Date: Mon, 2 Nov 2009 14:21:29 -0800
> Subject: [PATCH] Btrfs: don't set current->journal_info
>
> Btrfs doesn't use current->journal_info for anything, so don't set it=
=2E
> We currently cause a NULL dereference in jbd if a process starts a bt=
rfs
> user transaction and then touches another mounted fs that uses jbd, s=
ince
> current->journal_info is only supposed to be set for the duration of =
a
> single call into the fs.

NAK The root of bad thing is ioctl patch.
If you really want to design external(from kernel point of view)
atomic interface then you have to use another
locking mechanism not transaction. Some thing like lock_flag. And it
must be stored on inode in order to provide
mutal exclusion for concurent task. Otherwise this mechanism is useless=
=2E
This patch just hide problem under a carpet. Actually setting
current->journal_info
is a good way to catch  fs to fs switching.
>
> Signed-off-by: Sage Weil <sage@newdream.net>
> ---
> =C2=A0fs/btrfs/transaction.c | =C2=A0 =C2=A08 --------
> =C2=A01 files changed, 0 insertions(+), 8 deletions(-)
>
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index bca82a4..c6dbbb8 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -186,9 +186,6 @@ static struct btrfs_trans_handle *start_transacti=
on(struct btrfs_root *root,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0h->alloc_exclude_start =3D 0;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0h->delayed_ref_updates =3D 0;
>
> - =C2=A0 =C2=A0 =C2=A0 if (!current->journal_info)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 current->journal_i=
nfo =3D h;
> -
> =C2=A0 =C2=A0 =C2=A0 =C2=A0root->fs_info->running_transaction->use_co=
unt++;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0record_root_in_trans(h, root);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0mutex_unlock(&root->fs_info->trans_mutex);
> @@ -321,8 +318,6 @@ static int __btrfs_end_transaction(struct btrfs_t=
rans_handle *trans,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0put_transaction(cur_trans);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0mutex_unlock(&info->trans_mutex);
>
> - =C2=A0 =C2=A0 =C2=A0 if (current->journal_info =3D=3D trans)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 current->journal_i=
nfo =3D NULL;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0memset(trans, 0, sizeof(*trans));
> =C2=A0 =C2=A0 =C2=A0 =C2=A0kmem_cache_free(btrfs_trans_handle_cachep,=
 trans);
>
> @@ -1105,9 +1100,6 @@ int btrfs_commit_transaction(struct btrfs_trans=
_handle *trans,
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0mutex_unlock(&root->fs_info->trans_mutex);
>
> - =C2=A0 =C2=A0 =C2=A0 if (current->journal_info =3D=3D trans)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 current->journal_i=
nfo =3D NULL;
> -
> =C2=A0 =C2=A0 =C2=A0 =C2=A0kmem_cache_free(btrfs_trans_handle_cachep,=
 trans);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;
> =C2=A0}
> --
> 1.5.6.5
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
