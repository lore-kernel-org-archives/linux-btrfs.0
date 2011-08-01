From: cwillu <cwillu@cwillu.com>
Subject: Re: PLEASE TEST: Everybody who is seeing weird and long hangs
Date: Mon, 1 Aug 2011 17:28:35 -0600
Message-ID: <CAE5mzviteeoNF840ef8_zgVk5ZfX=tgt_k7EVOeEvD47jWeBug@mail.gmail.com>
References: <4E36C47E.70309@redhat.com>
	<1312213264-sup-9624@shiny>
	<4E36CE56.1060206@redhat.com>
	<1312220929-sup-8405@shiny>
	<4E36E9FF.9050805@redhat.com>
	<1312222583-sup-6514@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1312222583-sup-6514@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 1, 2011 at 12:21 PM, Chris Mason <chris.mason@oracle.com> w=
rote:
> Excerpts from Josef Bacik's message of 2011-08-01 14:01:35 -0400:
>> On 08/01/2011 01:54 PM, Chris Mason wrote:
>> > Excerpts from Josef Bacik's message of 2011-08-01 12:03:34 -0400:
>> >> On 08/01/2011 11:45 AM, Chris Mason wrote:
>> >>> Excerpts from Josef Bacik's message of 2011-08-01 11:21:34 -0400=
:
>> >>>> Hello,
>> >>>>
>> >>>> We've seen a lot of reports of people having these constant lon=
g pauses
>> >>>> when doing things like sync or such. =C2=A0The stack traces usu=
ally all look
>> >>>> the same, one is btrfs-transaction stuck in btrfs_wait_marked_e=
xtents
>> >>>> and one is btrfs-submit-# stuck in get_request_wait. =C2=A0I ha=
d originally
>> >>>> thought this was due to the new plugging stuff, but I think it =
just
>> >>>> makes the problem happen more quickly as we've seen that 2.6.38=
 which we
>> >>>> thought was ok will still have the problem happen if given enou=
gh time.
>> >>>>
>> >>>> I _think_ this is because of the way we write out metadata in t=
he
>> >>>> transaction commit phase. =C2=A0We're doing write_on_page for e=
very dirty
>> >>>> page in the btree during the commit. =C2=A0This sucks because b=
asically we
>> >>>> end up with one bio per page, which makes us blow out our nr_re=
quests
>> >>>> constantly, which is why btrfs-submit-# is always stuck in
>> >>>> get_request_wait. =C2=A0What we need to do instead is use filem=
ap_fdatawrite
>> >>>> which will do a WB_SYNC_ALL but will do it via writepages, so h=
opefully
>> >>>> we will get less bios and this problem will go away. =C2=A0Plea=
se try this
>> >>>> very hastily put together patch if you are experiencing this pr=
oblem and
>> >>>> let me know if it fixes it for you. =C2=A0Thanks,
>> >>>
>> >>> I'm definitely curious to hear if this helps, but I think it mig=
ht cause
>> >>> a different set of problems. =C2=A0It writes everything that is =
dirty on the
>> >>> btree, which includes a lot of things we've cow'd in the current
>> >>> transaction and marked dirty. =C2=A0They will have to go through=
 COW again
>> >>> if someone wants to modify them again.
>> >>>
>> >>
>> >> But this is happening in the commit after we've done all of our w=
ork, we
>> >> shouldn't be dirtying anything else at this point right?
>> >
>> > The commit code is setup to unblock people before we start the IO:
>> >
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0trans->transaction->blocked =3D 0;
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_lock(&root->fs_info->trans_lock);
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 root->fs_info->running_transaction =3D=
 NULL;
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 root->fs_info->trans_no_join =3D 0;
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_unlock(&root->fs_info->trans_lock=
);
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 mutex_unlock(&root->fs_info->reloc_mut=
ex);
>> >
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 wake_up(&root->fs_info->transaction_wa=
it);
>> >
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D btrfs_write_and_wait_transacti=
on(trans, root);
>> >
>> > So, we should have concurrent FS mods for a new transaction while =
we are
>> > writing out this old transaction.
>> >
>>
>> Ah right, but then this brings up another question, we shouldn't cow
>> them again since we would have set the new transid. =C2=A0And isn't =
this kind
>> of bad, since somebody could come in and dirty a piece of metadata
>> before we have a chance to write it out for this transaction, so we =
end
>> up writing out the new data instead of what we are trying to commit?
>
> I think we're mixing together different ideas here. =C2=A0If we're do=
ing a
> commit on transaction N, we allow N+1 to start while we're doing the
> btrfs_write_and_wait_transaction(). =C2=A0N+1 might allocate and dirt=
y a new
> block, which btrfs_write_and_wait_transaction might start IO on.
>
> Strictly speaking this isn't a problem. =C2=A0It doesn't break any ru=
les of
> COW because we're allowed to write metadata at any time. =C2=A0But, o=
nce we
> do write it, we must COW it again if we want to change it. =C2=A0So, =
anything
> that btrfs_write_and_wait_transaction() catches from transaction N+1 =
is
> likely to make more work for us because future mods will have to
> allocate a new block. =C2=A0Basically it's wasted IO.
>
> But, it's also free IO, assuming it was contiguous. =C2=A0The problem=
 is that
> write_cache_pages isn't actually making sure it was contiguous, so we
> end up doing many more writes than we could have.
>
> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

=46irst user ("youagree") reported back on irc:

<youagree> guys, just came to report its much worse with josef's patch
<youagree> now i can hardly start anything, it's slowed down most of th=
e time
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
