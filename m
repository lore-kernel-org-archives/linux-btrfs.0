Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36383 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753773AbdCHOXP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Mar 2017 09:23:15 -0500
From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: [PATCH 3/9] btrfs: qgroup: Fix qgroup corruption caused by
 inode_cache mount option
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.com, clm@fb.com
References: <20170227071039.8335-1-quwenruo@cn.fujitsu.com>
 <20170227071039.8335-4-quwenruo@cn.fujitsu.com>
 <b9217275-263f-7a72-8194-3a4f3d72c804@suse.com>
 <3bbf70b2-124c-8a2a-1a0d-2e8a58b0898b@cn.fujitsu.com>
Message-ID: <51669a5c-652b-b6be-5246-0b5c207f352b@suse.com>
Date: Wed, 8 Mar 2017 09:23:08 -0500
MIME-Version: 1.0
In-Reply-To: <3bbf70b2-124c-8a2a-1a0d-2e8a58b0898b@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="MPreG1U6n2dVdeEvHnTEBpfRH9c8VoBGR"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MPreG1U6n2dVdeEvHnTEBpfRH9c8VoBGR
Content-Type: multipart/mixed; boundary="AWubfAr71sJsj1ohRxrkMaOh3OvUSt9lt";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
 dsterba@suse.com, clm@fb.com
Message-ID: <51669a5c-652b-b6be-5246-0b5c207f352b@suse.com>
Subject: Re: [PATCH 3/9] btrfs: qgroup: Fix qgroup corruption caused by
 inode_cache mount option
References: <20170227071039.8335-1-quwenruo@cn.fujitsu.com>
 <20170227071039.8335-4-quwenruo@cn.fujitsu.com>
 <b9217275-263f-7a72-8194-3a4f3d72c804@suse.com>
 <3bbf70b2-124c-8a2a-1a0d-2e8a58b0898b@cn.fujitsu.com>
In-Reply-To: <3bbf70b2-124c-8a2a-1a0d-2e8a58b0898b@cn.fujitsu.com>

--AWubfAr71sJsj1ohRxrkMaOh3OvUSt9lt
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 3/7/17 7:36 PM, Qu Wenruo wrote:
>=20
>=20
> At 03/08/2017 03:21 AM, Jeff Mahoney wrote:
>> On 2/27/17 2:10 AM, Qu Wenruo wrote:
>>> [BUG]
>>> The easist way to reproduce the bug is:
>>> ------
>>>  # mkfs.btrfs -f $dev -n 16K
>>>  # mount $dev $mnt -o inode_cache
>>>  # btrfs quota enable $mnt
>>>  # btrfs quota rescan -w $mnt
>>>  # btrfs qgroup show $mnt
>>> qgroupid         rfer         excl
>>> --------         ----         ----
>>> 0/5          32.00KiB     32.00KiB
>>>              ^^ Twice the correct value
>>> ------
>>>
>>> And fstests/btrfs qgroup test group can easily detect them with
>>> inode_cache mount option.
>>> Although some of them are false alerts since old test cases are using=

>>> fixed golden output.
>>> While new test cases will use "btrfs check" to detect qgroup mismatch=
=2E
>>>
>>> [CAUSE]
>>> Inode_cache mount option will make commit_fs_roots() to call
>>> btrfs_save_ino_cache() to update fs/subvol trees, and generate new
>>> delayed refs.
>>>
>>> However we call btrfs_qgroup_prepare_account_extents() too early, bef=
ore
>>> commit_fs_roots().
>>> This makes the "old_roots" for newly generated extents are always NUL=
L.
>>> For freeing extent case, this makes both new_roots and old_roots to b=
e
>>> empty, while correct old_roots should not be empty.
>>> This causing qgroup numbers not decreased correctly.
>>>
>>> [FIX]
>>> Modify the timing of calling btrfs_qgroup_prepare_account_extents() t=
o
>>> just before btrfs_qgroup_account_extents(), and add needed delayed_re=
fs
>>> handler.
>>> So qgroup can handle inode_map mount options correctly.
>>>
>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>
>> Could we also fix this by excepting the free space inode from qgroups?=

>> It seems like this is something we'd want to do anyway unless we want =
to
>> handle EDQUOT there too.
>=20
> I'm afraid it's not possible here.

Not within the context of this patch set, but I was thinking we could
just never do the tracing up front so there'd be nothing to check later.
 I still think this is probably the right approach for non-fsroots but
it does seem like there's no way to do it easily on a per-inode basis.

> As qgroup accounts any tree and data blocks that belong to specified
> tree(fs and subvolumes), not caring the inode it belongs to.
>=20
> And the design of free inode space cache is to restore it in
> fs/subvolume tree, which has no difference with normal inode, except it=

> doesn't have INODE_REF and its ino is FREE_INO.
> (Much the same behavior for space cache inode)
>=20
> The correct solution for caching free space and inode should be the new=

> space cache tree, which puts all these info into their own tree, never
> affecting existing trees.

Agreed.

> The only good news is, inode_cache is not commonly used and IIRC has
> bugs. Maybe it will be good idea to depreciate the option?

I wouldn't object to that.

-Jeff

>>> ---
>>>  fs/btrfs/transaction.c | 25 ++++++++++++++++++-------
>>>  1 file changed, 18 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
>>> index 6b3e0fc2fe7a..1ff3ec797356 100644
>>> --- a/fs/btrfs/transaction.c
>>> +++ b/fs/btrfs/transaction.c
>>> @@ -2130,13 +2130,6 @@ int btrfs_commit_transaction(struct
>>> btrfs_trans_handle *trans)
>>>          goto scrub_continue;
>>>      }
>>>
>>> -    /* Reocrd old roots for later qgroup accounting */
>>> -    ret =3D btrfs_qgroup_prepare_account_extents(trans, fs_info);
>>> -    if (ret) {
>>> -        mutex_unlock(&fs_info->reloc_mutex);
>>> -        goto scrub_continue;
>>> -    }
>>> -
>>>      /*
>>>       * make sure none of the code above managed to slip in a
>>>       * delayed item
>>> @@ -2179,6 +2172,24 @@ int btrfs_commit_transaction(struct
>>> btrfs_trans_handle *trans)
>>>      btrfs_free_log_root_tree(trans, fs_info);
>>>
>>>      /*
>>> +     * commit_fs_roots() can call btrfs_save_ino_cache(), which
>>> generates
>>> +     * new delayed refs. Must handle them or qgroup can be wrong.
>>> +     */
>>> +    ret =3D btrfs_run_delayed_refs(trans, fs_info, (unsigned long)-1=
);
>>> +    if (ret) {
>>> +        mutex_unlock(&fs_info->tree_log_mutex);
>>> +        mutex_unlock(&fs_info->reloc_mutex);
>>> +        goto scrub_continue;
>>> +    }
>>> +
>>> +    ret =3D btrfs_qgroup_prepare_account_extents(trans, fs_info);
>>> +    if (ret) {
>>> +        mutex_unlock(&fs_info->tree_log_mutex);
>>> +        mutex_unlock(&fs_info->reloc_mutex);
>>> +        goto scrub_continue;
>>> +    }
>>> +
>>> +    /*
>>>       * Since fs roots are all committed, we can get a quite accurate=

>>>       * new_roots. So let's do quota accounting.
>>>       */
>>>
>>
>>
>=20
>=20
>=20


--=20
Jeff Mahoney
SUSE Labs



--AWubfAr71sJsj1ohRxrkMaOh3OvUSt9lt--

--MPreG1U6n2dVdeEvHnTEBpfRH9c8VoBGR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWMATzR57S2MheeWyAQhsaQ/+JzBsxBCs3VO2lBRTDWHWSIKZ1syfWcG0
+DmBNpUD0a1G9os8ARMzwZhgqSJQrU9wMzZ+zNteL/pN8LEVtvqUjo7A7kDo7fpD
IBa4lowRd0P5n6Vtf5GU9fqIty3eLkwFXt2uClLTSpZGdWlBjefp/PmKhA/KmZxx
V1T160H2fSKC3mYWaI0VHvzVa71wM+d4WF4lvLRxn2QKfRJDLJos58M5SuJzG7cC
kOL991WRU9DwabgHJ9+jijPYMKWPShLFUwn0fctsnfAxN4+T+UYMJ6bA4JHVvKj2
d7oky02ZxAO9aemhd3wXN7wLdH899u9Hye34yyox8nWdLMGSpBCE9p7Bs2vxwPfL
ZKCavCq7JxKxMUWxKSFvEzkgrz/cWWqul9fE9Vmhta5w1ayLF/8WnsAtYvKfgriI
856aJ86ByKkshaDkceNgo+fnd0uBL6saqfHtOQFRexLqIh/H2e9TO1PwYIlOmuvR
ojkOqe6Z2b8OGI3a1pZ8Fm5Dt/6oo31arjnSOPreYf209M+2vmCjZyPxZeE/Au44
OfJvMoA6HaXXm4c6O5FTDjm+O56iki//GUXIx1lhInYxsNtS07kxbZLbppzaGz1d
oYKDJNPDde6+Di2kOJbf+4iyS1ykNcOQz9sjBupPkT3HBIFJWgbgdrDTSv1jWVZa
xBqb38R+u3E=
=LzTI
-----END PGP SIGNATURE-----

--MPreG1U6n2dVdeEvHnTEBpfRH9c8VoBGR--
