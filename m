Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42063 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752038AbdEQUzv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 16:55:51 -0400
Subject: Re: [PATCH v2 1/2] btrfs: Separate space_info create/update
To: Noah Massey <noah.massey@gmail.com>, Nikolay Borisov <nborisov@suse.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <1495033663-15610-1-git-send-email-nborisov@suse.com>
 <CADfjVrg9OByV7rLEtRPKywJRJgRh5cVtrmC+GXLLv_24UfyFBw@mail.gmail.com>
 <bee0d0c0-2c8a-9654-4dde-6bd736527d99@suse.com>
 <CADfjVrhC1U4Wd9PfOZP-Bb0CouocMrbo+kuHW2p_rp2Y7E_etA@mail.gmail.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <9ef08ee9-526f-d7df-ae9d-f7777716908f@suse.com>
Date: Wed, 17 May 2017 16:55:40 -0400
MIME-Version: 1.0
In-Reply-To: <CADfjVrhC1U4Wd9PfOZP-Bb0CouocMrbo+kuHW2p_rp2Y7E_etA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Bjrbc1SOEKpDe1TO6bPSriSwQN8FjKfQs"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Bjrbc1SOEKpDe1TO6bPSriSwQN8FjKfQs
Content-Type: multipart/mixed; boundary="WTRoS8LAsFT275qFxhtEGDgC0IA8wFJDn";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Noah Massey <noah.massey@gmail.com>, Nikolay Borisov <nborisov@suse.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <9ef08ee9-526f-d7df-ae9d-f7777716908f@suse.com>
Subject: Re: [PATCH v2 1/2] btrfs: Separate space_info create/update
References: <1495033663-15610-1-git-send-email-nborisov@suse.com>
 <CADfjVrg9OByV7rLEtRPKywJRJgRh5cVtrmC+GXLLv_24UfyFBw@mail.gmail.com>
 <bee0d0c0-2c8a-9654-4dde-6bd736527d99@suse.com>
 <CADfjVrhC1U4Wd9PfOZP-Bb0CouocMrbo+kuHW2p_rp2Y7E_etA@mail.gmail.com>
In-Reply-To: <CADfjVrhC1U4Wd9PfOZP-Bb0CouocMrbo+kuHW2p_rp2Y7E_etA@mail.gmail.com>

--WTRoS8LAsFT275qFxhtEGDgC0IA8wFJDn
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 5/17/17 4:52 PM, Noah Massey wrote:
> On Wed, May 17, 2017 at 4:34 PM, Nikolay Borisov <nborisov@suse.com> wr=
ote:
>>
>>
>> On 17.05.2017 21:57, Noah Massey wrote:
>>> On Wed, May 17, 2017 at 11:07 AM, Nikolay Borisov <nborisov@suse.com>=
 wrote:
>>>> Currently the struct space_info creation code is intermixed in the
>>>> udpate_space_info function. There are well-defined points at which t=
he we
>>>
>>> ^^^ update_space_info
>>>
>>>> actually want to create brand-new space_info structs (e.g. during mo=
unt of
>>>> the filesystem as well as sometimes when adding/initialising new chu=
nks). In
>>>> such cases udpate_space_info is called with 0 as the bytes parameter=
=2E All of
>>>> this makes for spaghetti code.
>>>>
>>>> Fix it by factoring out the creation code in a separate create_space=
_info
>>>> structure. This also allows to simplify the internals. Furthermore i=
t will
>>>> make the update_space_info function not fail, allowing to remove err=
or
>>>> handling in callers. This will come in a follow up patch.
>>>>
>>>> This bears no functional changes
>>>>
>>>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>>>> Reviewed-by: Jeff Mahoney <jeffm@suse.com>
>>>> ---
>>>>  fs/btrfs/extent-tree.c | 127 ++++++++++++++++++++++++--------------=
-----------
>>>>  1 file changed, 62 insertions(+), 65 deletions(-)
>>>>
>>>> Change since v1:
>>>>
>>>>  Incorporated Jeff Mahoney's feedback and added his reviewed-by
>>>>
>>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>>> index be5477676cc8..28848e45b018 100644
>>>> --- a/fs/btrfs/extent-tree.c
>>>> +++ b/fs/btrfs/extent-tree.c
>>>> @@ -3914,15 +3914,58 @@ static const char *alloc_name(u64 flags)
>>>>         };
>>>>  }
>>>>
>>>> +static int create_space_info(struct btrfs_fs_info *info, u64 flags,=

>>>> +                            struct btrfs_space_info **new) {
>>>> +
>>>> +       struct btrfs_space_info *space_info;
>>>> +       int i;
>>>> +       int ret;
>>>> +
>>>> +       space_info =3D kzalloc(sizeof(*space_info), GFP_NOFS);
>>>> +       if (!space_info)
>>>> +               return -ENOMEM;
>>>> +
>>>> +       ret =3D percpu_counter_init(&space_info->total_bytes_pinned,=
 0, GFP_KERNEL);
>>>> +       if (ret) {
>>>> +               kfree(space_info);
>>>> +               return ret;
>>>> +       }
>>>> +
>>>> +       for (i =3D 0; i < BTRFS_NR_RAID_TYPES; i++)
>>>> +               INIT_LIST_HEAD(&space_info->block_groups[i]);
>>>> +       init_rwsem(&space_info->groups_sem);
>>>> +       spin_lock_init(&space_info->lock);
>>>> +       space_info->flags =3D flags & BTRFS_BLOCK_GROUP_TYPE_MASK;
>>>> +       space_info->force_alloc =3D CHUNK_ALLOC_NO_FORCE;
>>>> +       init_waitqueue_head(&space_info->wait);
>>>> +       INIT_LIST_HEAD(&space_info->ro_bgs);
>>>> +       INIT_LIST_HEAD(&space_info->tickets);
>>>> +       INIT_LIST_HEAD(&space_info->priority_tickets);
>>>> +
>>>> +       ret =3D kobject_init_and_add(&space_info->kobj, &space_info_=
ktype,
>>>> +                                   info->space_info_kobj, "%s",
>>>> +                                   alloc_name(space_info->flags));
>>>> +       if (ret) {
>>>> +               percpu_counter_destroy(&space_info->total_bytes_pinn=
ed);
>>>> +               kfree(space_info);
>>>> +               return ret;
>>>> +       }
>>>> +
>>>> +       *new =3D space_info;
>>>> +       list_add_rcu(&space_info->list, &info->space_info);
>>>> +       if (flags & BTRFS_BLOCK_GROUP_DATA)
>>>> +               info->data_sinfo =3D space_info;
>>>> +
>>>> +       return ret;
>>>> +}
>>>> +
>>>>  static int update_space_info(struct btrfs_fs_info *info, u64 flags,=

>>>>                              u64 total_bytes, u64 bytes_used,
>>>>                              u64 bytes_readonly,
>>>>                              struct btrfs_space_info **space_info)
>>>>  {
>>>>         struct btrfs_space_info *found;
>>>> -       int i;
>>>>         int factor;
>>>> -       int ret;
>>>>
>>>>         if (flags & (BTRFS_BLOCK_GROUP_DUP | BTRFS_BLOCK_GROUP_RAID1=
 |
>>>>                      BTRFS_BLOCK_GROUP_RAID10))
>>>> @@ -3946,53 +3989,6 @@ static int update_space_info(struct btrfs_fs_=
info *info, u64 flags,
>>>>                 *space_info =3D found;
>>>>                 return 0;
>>>>         }
>>>> -       found =3D kzalloc(sizeof(*found), GFP_NOFS);
>>>> -       if (!found)
>>>> -               return -ENOMEM;
>>>> -
>>>> -       ret =3D percpu_counter_init(&found->total_bytes_pinned, 0, G=
FP_KERNEL);
>>>> -       if (ret) {
>>>> -               kfree(found);
>>>> -               return ret;
>>>> -       }
>>>> -
>>>> -       for (i =3D 0; i < BTRFS_NR_RAID_TYPES; i++)
>>>> -               INIT_LIST_HEAD(&found->block_groups[i]);
>>>> -       init_rwsem(&found->groups_sem);
>>>> -       spin_lock_init(&found->lock);
>>>> -       found->flags =3D flags & BTRFS_BLOCK_GROUP_TYPE_MASK;
>>>> -       found->total_bytes =3D total_bytes;
>>>> -       found->disk_total =3D total_bytes * factor;
>>>> -       found->bytes_used =3D bytes_used;
>>>> -       found->disk_used =3D bytes_used * factor;
>>>> -       found->bytes_pinned =3D 0;
>>>> -       found->bytes_reserved =3D 0;
>>>> -       found->bytes_readonly =3D bytes_readonly;
>>>> -       found->bytes_may_use =3D 0;
>>>> -       found->full =3D 0;
>>>> -       found->max_extent_size =3D 0;
>>>> -       found->force_alloc =3D CHUNK_ALLOC_NO_FORCE;
>>>> -       found->chunk_alloc =3D 0;
>>>> -       found->flush =3D 0;
>>>> -       init_waitqueue_head(&found->wait);
>>>> -       INIT_LIST_HEAD(&found->ro_bgs);
>>>> -       INIT_LIST_HEAD(&found->tickets);
>>>> -       INIT_LIST_HEAD(&found->priority_tickets);
>>>> -
>>>> -       ret =3D kobject_init_and_add(&found->kobj, &space_info_ktype=
,
>>>> -                                   info->space_info_kobj, "%s",
>>>> -                                   alloc_name(found->flags));
>>>> -       if (ret) {
>>>> -               kfree(found);
>>>> -               return ret;
>>>> -       }
>>>> -
>>>> -       *space_info =3D found;
>>>> -       list_add_rcu(&found->list, &info->space_info);
>>>> -       if (flags & BTRFS_BLOCK_GROUP_DATA)
>>>> -               info->data_sinfo =3D found;
>>>> -
>>>> -       return ret;
>>>>  }
>>>>
>>>>  static void set_avail_alloc_bits(struct btrfs_fs_info *fs_info, u64=
 flags)
>>>> @@ -4495,10 +4491,9 @@ static int do_chunk_alloc(struct btrfs_trans_=
handle *trans,
>>>>
>>>>         space_info =3D __find_space_info(fs_info, flags);
>>>>         if (!space_info) {
>>>> -               ret =3D update_space_info(fs_info, flags, 0, 0, 0, &=
space_info);
>>>> +               ret =3D create_space_info(fs_info, flags, &space_inf=
o);
>>>>                 BUG_ON(ret); /* -ENOMEM */
>>>>         }
>>>> -       BUG_ON(!space_info); /* Logic error */
>>>
>>> Isn't removing this BUG_ON a functional change?
>>> I understand that it shouldn't happen in the current incarnation of
>>> create_space_info, but that was true before the patch as well
>>
>> No, because this bug_on would have triggere only if !space_info, and
>> this condition would have, in turn, triggered the if statement, which
>> has a BUG_ON(ret). E.g. in case ret is 0 then space_info will definite=
ly
>> be set. Hence BUG_ON(!space_info) is redundant.
>>
>=20
> But the BUG_ON(ret) value is independent of BUG_ON(!space_info)
> The BUG_ON(!space_info) seems to have been there to catch a potential
> logic error if update_space_info is modified / regressed to return 0
> and still not set space_info pointer, so removing the BUG_ON seems to
> be a change separate from the switch to create_space_info.

The BUG_ON(!space_info) is older than the call to update_space_info().
It should've been removed when we started creating the space info there.

-Jeff

> I'm not saying it can't be removed: the current code looks good, and I
> agree the BUG_ON won't trigger. It looks like the current incarnation
> of create_space_info will always set space_info or return an error,
> but so did the previous call to update_space_info, so I was not sure
> it should be dropped as part of the switch.
>=20
> Is the thinking that since we are switching the called method and in
> the new current code the BUG_ON won't trigger, there will be no
> behavior change by removing it so we can drop it in the update?



--=20
Jeff Mahoney
SUSE Labs


--WTRoS8LAsFT275qFxhtEGDgC0IA8wFJDn--

--Bjrbc1SOEKpDe1TO6bPSriSwQN8FjKfQs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWRy4zR57S2MheeWyAQjQUxAAsbJ5OWd6giTVD6AdceJOd2vlPZdDD7K1
cx9BGs+BJlvqMcjx7Vd0V3NG8L2Y4DF6VVBbygj3nSIFFmA2z91zE5fMldeG0SZQ
U8cQF5KtL1IHiippPxwSreWcsuLSJ66EnSV13rM1jxufY5T3bXwVfepqxeLy+S+3
dYsI57e+hKV/ZpY8eQzu0Md6AklivmEJ4vp1+TSJO4tCjh0BezhjT4qaaRyCw87v
tlx63XuxKFyzgdda8OKV3K+Y8o8SzUOBfaho5Th157jQPn7XBelxqwh8FHp3IO8W
2OG1yN1pHDU5DWYPn0I2ZfjpXqkSTw6BXoBTn1jJEgLekNtnI1VEY852kCyoeGJK
bUXS2l6lUbKSvdtny5lcvheyFdkE+CXvuok/YjQkU6bML4ex/TbsgLcavIeULmwP
rVbVmSuPJf1oA/EDOGVhaPRc7iD3O0psnP/I8Mw8eYgcuBZm+LvNu1icp/OjHC92
zDUaL64A+ZhzUkGWogLIzcgOwu8WGxnPcLyms0u9lOY8wudiVgCuLAcloC1cYc0P
3boHth8XizKlQrPc6Nlzi/w8ZdFOlHyxbxzOdFd6z2rUYi/HG2uvHLZ8POpcEuNc
zh7KFyScAQpyLXT9JSPuvnd/89qcAy+0SYN2123dihq8ftM2eUIJRR2ldbs3g+Pd
OJV0SXH9ZJ8=
=yzsu
-----END PGP SIGNATURE-----

--Bjrbc1SOEKpDe1TO6bPSriSwQN8FjKfQs--
