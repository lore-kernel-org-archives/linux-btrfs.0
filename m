Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:63600 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751784AbeA2L5z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Jan 2018 06:57:55 -0500
Subject: Re: [PATCH v2] btrfs: Gracefully handle errors in
 btrfs_qgroup_trace_extent_post
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1517211848-13324-1-git-send-email-nborisov@suse.com>
 <67d1afde-c6f7-ea41-d9d4-35c5d0a1c136@gmx.com>
 <0aace605-1267-2b4d-d15a-167f4e7946f2@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <4031fa1b-4839-d496-b015-0cd75a04084b@gmx.com>
Date: Mon, 29 Jan 2018 19:57:40 +0800
MIME-Version: 1.0
In-Reply-To: <0aace605-1267-2b4d-d15a-167f4e7946f2@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2QAHNVg7djucYw5te2ZlF54dV3SZFNIpW"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2QAHNVg7djucYw5te2ZlF54dV3SZFNIpW
Content-Type: multipart/mixed; boundary="VBgJyuGjlM8sroYF6BI9Is8rH0hBv9uRY";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <4031fa1b-4839-d496-b015-0cd75a04084b@gmx.com>
Subject: Re: [PATCH v2] btrfs: Gracefully handle errors in
 btrfs_qgroup_trace_extent_post
References: <1517211848-13324-1-git-send-email-nborisov@suse.com>
 <67d1afde-c6f7-ea41-d9d4-35c5d0a1c136@gmx.com>
 <0aace605-1267-2b4d-d15a-167f4e7946f2@suse.com>
In-Reply-To: <0aace605-1267-2b4d-d15a-167f4e7946f2@suse.com>

--VBgJyuGjlM8sroYF6BI9Is8rH0hBv9uRY
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8829=E6=97=A5 19:21, Nikolay Borisov wrote:
>=20
>=20
> On 29.01.2018 13:09, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B401=E6=9C=8829=E6=97=A5 15:44, Nikolay Borisov wrote:
>>> Running generic/019 with qgroups on the scratch device enabled is
>>> almost guaranteed to trigger the BUG_ON in btrfs_free_tree_block. It'=
s
>>> supposed to trigger only on -ENOMEM, in reality, however, it's possib=
le
>>> to get -EIO from btrfs_qgroup_trace_extent_post. This function just
>>> finds the roots of the extent being tracked and sets the qrecord->old=
_roots
>>> list. If this operation fails nothing critical happens except the
>>> quota accounting can be considered wrong. In such case just set the
>>> INCONSISTENT flag for the quota and print a warning.
>>>
>>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>>> ---
>>>
>>> V2:=20
>>>  * Always print a warning if btrfs_qgroup_trace_extent_post fails=20
>>>  * Set quota inconsistent flag if btrfs_qgroup_trace_extent_post fail=
s
>>>
>>>  fs/btrfs/delayed-ref.c | 7 +++++--
>>>  fs/btrfs/qgroup.c      | 6 ++++--
>>>  2 files changed, 9 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
>>> index a1a40cf382e3..5b2789a28a13 100644
>>> --- a/fs/btrfs/delayed-ref.c
>>> +++ b/fs/btrfs/delayed-ref.c
>>> @@ -820,8 +820,11 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_i=
nfo *fs_info,
>>>  			     num_bytes, parent, ref_root, level, action);
>>>  	spin_unlock(&delayed_refs->lock);
>>> =20
>>> -	if (qrecord_inserted)
>>> -		return btrfs_qgroup_trace_extent_post(fs_info, record);
>>> +	if (qrecord_inserted) {
>>> +		int ret =3D btrfs_qgroup_trace_extent_post(fs_info, record);
>>> +		if (ret < 0)
>>> +			btrfs_warn(fs_info, "Error accounting new delayed refs extent (er=
r code: %d). Quota inconsistent", ret);
>>
>> Sorry that I didn't point it out in previous review, there are 2 calle=
rs
>> in delayed-ref.c using btrfs_qgroup_trace_extent_post().
>>
>> One is the one you're fixing, and the other one is
>> btrfs_add_delayed_data_ref().
>=20
> Yes, but the callers of btrfs_add_delayed_data_ref seem to be expecting=

> error values and actually handling them.

Not exactly.

A quick search leads to extra unhandled btrfs_add_delayed_data_ref().

walk_down_proc()
|- btrfs_dec_ref()
   |- __btrfs_mod_ref()
      |- btrfs_free_extent()
         |- btrfs_add_delayed_data_ref()
            |- btrfs_qgroup_trace_extent_post()

And this leads to another BUG_ON().

> So a failure doesn't
> necessarily mean the fs is in inconsistent state.

But at the cost of aborting current transaction.

>=20
>>
>> So it would be even better if the warning message can be integrated in=
to
>> btrfs_qgroup_trace_extent_post().
>=20
> See below why I don't think integrating the warning is a good idea. In
> the case being modified in this patch we will continue operating
> normally, hence the warning and INCONSISTENT flag make sense.
>=20
>>
>> Also btrfs_qgroup_trace_extent_post() also needs to ignore the return
>> value from btrfs_qgroup_trace_extent_post().
>=20
> I don't think so, if we are able to handle failures as is the case in
> the delayed_data_ref case then we might abort the current transaction
> and this should leave the fs in a consistent state.

Here comes the trade-off.

Keep the on-disk data consistent while abort current transaction and
make fs read-only.

VS

Make the fs continue running while just discard the qgroup data.


Although the truth is, either way we may eventually goes
abort_transaction() since we failed to read some tree blocks.

But since there are still some BUG_ON() wondering around the wild, the
latter one seems a little better.

> In that case even
> the "STATUS_FLAG_INCONSISTENT" being set in qgroup_trace_extent_post
> might be "wrong" in the sense that a failure from this function doesn't=

> necessarily make the quota inconsistent if upper layers can handle the
> failures and revert their work.

Well, most of them just abort the transaction and leads to above trade-of=
f.

Unfortunately, there is not much thing we can do in error handler. :(

Thanks,
Qu

> So I'm now starting to think that the
> inconsistent flag should be set in add_delayed_tree_ref, but this sort
> of leaks the qgroup implementation detail into the delayed tree ref
> function...
>>
>> Thanks,
>> Qu
>>
>>> +	}
>>>  	return 0;
>>> =20
>>>  free_head_ref:
>>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>>> index b2ab5f795816..33f9dba44e92 100644
>>> --- a/fs/btrfs/qgroup.c
>>> +++ b/fs/btrfs/qgroup.c
>>> @@ -1440,8 +1440,10 @@ int btrfs_qgroup_trace_extent_post(struct btrf=
s_fs_info *fs_info,
>>>  	int ret;
>>> =20
>>>  	ret =3D btrfs_find_all_roots(NULL, fs_info, bytenr, 0, &old_root, f=
alse);
>>> -	if (ret < 0)
>>> +	if (ret < 0) {
>>> +		fs_info->qgroup_flags |=3D BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
>>>  		return ret;
>>> +	}
>>> =20
>>>  	/*
>>>  	 * Here we don't need to get the lock of
>>> @@ -2933,7 +2935,7 @@ static int __btrfs_qgroup_release_data(struct i=
node *inode,
>>>  	if (free && reserved)
>>>  		return qgroup_free_reserved_data(inode, reserved, start, len);
>>>  	extent_changeset_init(&changeset);
>>> -	ret =3D clear_record_extent_bits(&BTRFS_I(inode)->io_tree, start,=20
>>> +	ret =3D clear_record_extent_bits(&BTRFS_I(inode)->io_tree, start,
>>>  			start + len -1, EXTENT_QGROUP_RESERVED, &changeset);
>>>  	if (ret < 0)
>>>  		goto out;
>>>
>>


--VBgJyuGjlM8sroYF6BI9Is8rH0hBv9uRY--

--2QAHNVg7djucYw5te2ZlF54dV3SZFNIpW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpvDDQXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjs5Qf/Qdej2ZxzrkItuH0b58a0qxeF
B8t3ZMDRokQZrLpOrpnJYWFZyUIEb60MJ11xV/QJ8PnjIG2y6beDDzDRsFW6yS4/
/aYC3IhIE4o9mkS18n7JQriIOUkqX1iaNk76NbL03URnFjXaAK6ahqx9oRQi3HPk
rUopmtO0Xwmkjexlr31JIHH5rSh3dZnz1/NB1W3FofCZ+/+AQ64vW92xNzsb35A0
KQx+cGUgCcCKNDkmxKvyeHFVZRG+gY8SYozPOKByuLi7j9rC4uXM/9V7tkphCtyW
Mfv1+9qLVOLezKNIZn/lfKk+AViOv++TIkHOVd7I+awibgtbuBXrd5+0Axqv/g==
=Al8K
-----END PGP SIGNATURE-----

--2QAHNVg7djucYw5te2ZlF54dV3SZFNIpW--
