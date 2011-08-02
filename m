From: Chris Mason <chris.mason@oracle.com>
Subject: Re: PLEASE TEST: Everybody who is seeing weird and long hangs
Date: Mon, 01 Aug 2011 20:09:01 -0400
Message-ID: <1312243693-sup-7056@shiny>
References: <4E36C47E.70309@redhat.com> <1312213264-sup-9624@shiny> <4E36CE56.1060206@redhat.com> <1312220929-sup-8405@shiny> <4E36E9FF.9050805@redhat.com> <1312222583-sup-6514@shiny> <CAE5mzviteeoNF840ef8_zgVk5ZfX=tgt_k7EVOeEvD47jWeBug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Cc: Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: cwillu <cwillu@cwillu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <CAE5mzviteeoNF840ef8_zgVk5ZfX=tgt_k7EVOeEvD47jWeBug@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from cwillu's message of 2011-08-01 19:28:35 -0400:
> On Mon, Aug 1, 2011 at 12:21 PM, Chris Mason <chris.mason@oracle.com>=
 wrote:
> > Excerpts from Josef Bacik's message of 2011-08-01 14:01:35 -0400:
> >> On 08/01/2011 01:54 PM, Chris Mason wrote:
> >> > Excerpts from Josef Bacik's message of 2011-08-01 12:03:34 -0400=
:
> >> >> On 08/01/2011 11:45 AM, Chris Mason wrote:
> >> >>> Excerpts from Josef Bacik's message of 2011-08-01 11:21:34 -04=
00:
> >> >>>> Hello,
> >> >>>>
> >> >>>> We've seen a lot of reports of people having these constant l=
ong pauses
> >> >>>> when doing things like sync or such. =C2=A0The stack traces u=
sually all look
> >> >>>> the same, one is btrfs-transaction stuck in btrfs_wait_marked=
_extents
> >> >>>> and one is btrfs-submit-# stuck in get_request_wait. =C2=A0I =
had originally
> >> >>>> thought this was due to the new plugging stuff, but I think i=
t just
> >> >>>> makes the problem happen more quickly as we've seen that 2.6.=
38 which we
> >> >>>> thought was ok will still have the problem happen if given en=
ough time.
> >> >>>>
> >> >>>> I _think_ this is because of the way we write out metadata in=
 the
> >> >>>> transaction commit phase. =C2=A0We're doing write_on_page for=
 every dirty
> >> >>>> page in the btree during the commit. =C2=A0This sucks because=
 basically we
> >> >>>> end up with one bio per page, which makes us blow out our nr_=
requests
> >> >>>> constantly, which is why btrfs-submit-# is always stuck in
> >> >>>> get_request_wait. =C2=A0What we need to do instead is use fil=
emap_fdatawrite
> >> >>>> which will do a WB_SYNC_ALL but will do it via writepages, so=
 hopefully
> >> >>>> we will get less bios and this problem will go away. =C2=A0Pl=
ease try this
> >> >>>> very hastily put together patch if you are experiencing this =
problem and
> >> >>>> let me know if it fixes it for you. =C2=A0Thanks,
> >> >>>
> >> >>> I'm definitely curious to hear if this helps, but I think it m=
ight cause
> >> >>> a different set of problems. =C2=A0It writes everything that i=
s dirty on the
> >> >>> btree, which includes a lot of things we've cow'd in the curre=
nt
> >> >>> transaction and marked dirty. =C2=A0They will have to go throu=
gh COW again
> >> >>> if someone wants to modify them again.
> >> >>>
> >> >>
> >> >> But this is happening in the commit after we've done all of our=
 work, we
> >> >> shouldn't be dirtying anything else at this point right?
> >> >
> >> > The commit code is setup to unblock people before we start the I=
O:
> >> >
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0trans->transaction->blocked =3D 0;
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_lock(&root->fs_info->trans_lock=
);
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 root->fs_info->running_transaction =3D=
 NULL;
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 root->fs_info->trans_no_join =3D 0;
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_unlock(&root->fs_info->trans_lo=
ck);
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 mutex_unlock(&root->fs_info->reloc_m=
utex);
> >> >
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 wake_up(&root->fs_info->transaction_=
wait);
> >> >
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D btrfs_write_and_wait_transac=
tion(trans, root);
> >> >
> >> > So, we should have concurrent FS mods for a new transaction whil=
e we are
> >> > writing out this old transaction.
> >> >
> >>
> >> Ah right, but then this brings up another question, we shouldn't c=
ow
> >> them again since we would have set the new transid. =C2=A0And isn'=
t this kind
> >> of bad, since somebody could come in and dirty a piece of metadata
> >> before we have a chance to write it out for this transaction, so w=
e end
> >> up writing out the new data instead of what we are trying to commi=
t?
> >
> > I think we're mixing together different ideas here. =C2=A0If we're =
doing a
> > commit on transaction N, we allow N+1 to start while we're doing th=
e
> > btrfs_write_and_wait_transaction(). =C2=A0N+1 might allocate and di=
rty a new
> > block, which btrfs_write_and_wait_transaction might start IO on.
> >
> > Strictly speaking this isn't a problem. =C2=A0It doesn't break any =
rules of
> > COW because we're allowed to write metadata at any time. =C2=A0But,=
 once we
> > do write it, we must COW it again if we want to change it. =C2=A0So=
, anything
> > that btrfs_write_and_wait_transaction() catches from transaction N+=
1 is
> > likely to make more work for us because future mods will have to
> > allocate a new block. =C2=A0Basically it's wasted IO.
> >
> > But, it's also free IO, assuming it was contiguous. =C2=A0The probl=
em is that
> > write_cache_pages isn't actually making sure it was contiguous, so =
we
> > end up doing many more writes than we could have.
>=20
> First user ("youagree") reported back on irc:
>=20
> <youagree> guys, just came to report its much worse with josef's patc=
h
> <youagree> now i can hardly start anything, it's slowed down most of =
the time

Josef's filemap_fdatawrite patch?  He sent a second one to the list tha=
t
gets rid of the extra IO done by the current code.  That's the one we
hope will fix things.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
