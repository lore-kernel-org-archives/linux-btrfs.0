Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46623 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752263AbdCHPNs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Mar 2017 10:13:48 -0500
Subject: Re: [PATCH 0/9 PULL REQUEST] Qgroup fixes for 4.11
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.com, clm@fb.com
References: <20170227071039.8335-1-quwenruo@cn.fujitsu.com>
 <c11675d5-dd41-955c-06d0-db8aea1c7331@cn.fujitsu.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <fd92287d-c048-0950-4769-9f06ba2a843e@suse.com>
Date: Wed, 8 Mar 2017 09:24:05 -0500
MIME-Version: 1.0
In-Reply-To: <c11675d5-dd41-955c-06d0-db8aea1c7331@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tGVqq5CbVFQv0tiskfRa6coqpJa7F9uuJ"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tGVqq5CbVFQv0tiskfRa6coqpJa7F9uuJ
Content-Type: multipart/mixed; boundary="0BAQdL9U7T25H1iB3DFJo3JiA8KVjbfSx";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
 dsterba@suse.com, clm@fb.com
Message-ID: <fd92287d-c048-0950-4769-9f06ba2a843e@suse.com>
Subject: Re: [PATCH 0/9 PULL REQUEST] Qgroup fixes for 4.11
References: <20170227071039.8335-1-quwenruo@cn.fujitsu.com>
 <c11675d5-dd41-955c-06d0-db8aea1c7331@cn.fujitsu.com>
In-Reply-To: <c11675d5-dd41-955c-06d0-db8aea1c7331@cn.fujitsu.com>

--0BAQdL9U7T25H1iB3DFJo3JiA8KVjbfSx
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 3/6/17 3:08 AM, Qu Wenruo wrote:
> Any response?
>=20
> These patches are already here for at least 2 kernel releases.
> And are all bug fixes, and fix bugs that are already reported.
>=20
> I didn't see any reason why it should be delayed for so long time.

I'll work my way through as I can.  I posted some review earlier today.

Man, I wish we could just get rid of the hierarchical part of qgroups. :)=


-Jeff

> Thanks,
> Qu
>=20
> At 02/27/2017 03:10 PM, Qu Wenruo wrote:
>> Pull request can be fetched from my github:
>> https://github.com/adam900710/linux.git qgroup_fixes_for_4.11
>>
>> The base is 6288d6eabc7505f42dda34a2c2962f91914be3a4.
>> Author: Liu Bo <bo.li.liu@oracle.com>
>> Date:   Tue Feb 21 12:12:58 2017 -0800
>>
>>     Btrfs: use the correct type when creating cow dio extent
>>
>> These patches are already in mail list for almost 3 months.
>> For example the tracepoint patch is last updated at 2016/12/09.
>>
>> With this patchset btrfs can pass all xfstest qgroup tests now.
>>
>> This pull request should be good for 4.11 as they are all bug fixes an=
d
>> has been delayed for several times.
>>
>> I don't know if these patchset will be delayed again if someone wants =
to
>> cleanup something else, and cause rebase conflicts to delay such fixes=
=2E
>> But I must say, that's very frustrating to see bug fixes just get drop=
ped
>> again and again just due to new cleanups and lack of reviewers.
>>
>> Despite all these pities, this pull request includes:
>> 1) Fix for inode_cache mount option
>>    Although no one really cares inode_cache mount option, it will scre=
w
>>    qgroup for a long time.
>>    Not only it will screw up qgroup test uses golden output, but also
>>    new test cases use btrfsck to verify qgroup.
>>
>> 2) Fix for btrfs/104 kernel warning
>>    This is caused by quota enabling with dirty buffers not written to
>>    disc.
>>
>>    Fixed by checking EXTENT_QGROUP_RESERVED flag other than just
>>    decreasing qgroup->reserved.
>>
>> 3) Fix qgroup underflow caused by freeing ranges not reserved by calle=
r
>>    Mainly exposed by Chandan on PPC64.
>>
>>    It's possible that buffered write is blocked by reserving metadata,=

>>    and in error path we will release reserved space for both data and
>>    metadata.
>>
>>    However the reserved data can already be reserved by another proces=
s
>>    writing the same page.
>>
>>    In that case, data reserved space can be freed by two process, one
>>    for error path, one for normal write routine, causing underflow.
>>
>>    Fixed by checking if that data range is reserved by ourselves and
>>    only free it if it's reserved by ourselves.
>>
>> Update since 2016/12/09:
>>   Rebased to latest for-linux-4.11.
>>
>>   Add missing reviewed-by and tested-by tags.
>>
>>   Add more comment for btrfs_qgroup_reserve_data() for error handling.=

>>
>>   Add more comment for qgroup_free_reserved_data() for later
>>   enhancement (not function enhancement).
>>
>> Qu Wenruo (9):
>>   btrfs: qgroup: Add trace point for qgroup reserved space
>>   btrfs: qgroup: Re-arrange tracepoint timing to co-operate with
>>     reserved space tracepoint
>>   btrfs: qgroup: Fix qgroup corruption caused by inode_cache mount
>>     option
>>   btrfs: qgroup: Add quick exit for non-fs extents
>>   btrfs: qgroup: Cleanup btrfs_qgroup_prepare_account_extents function=

>>   btrfs: qgroup: Return actually freed bytes for qgroup release or fre=
e
>>     data
>>   btrfs: qgroup: Fix qgroup reserved space underflow caused by buffere=
d
>>     write and quota enable
>>   btrfs: qgroup: Introduce extent changeset for qgroup reserve functio=
ns
>>   btrfs: qgroup: Fix qgroup reserved space underflow by only freeing
>>     reserved ranges
>>
>>  fs/btrfs/ctree.h             |  12 ++-
>>  fs/btrfs/extent-tree.c       |  31 +++---
>>  fs/btrfs/extent_io.h         |  14 ++-
>>  fs/btrfs/file.c              |  46 +++++----
>>  fs/btrfs/inode-map.c         |   6 +-
>>  fs/btrfs/inode.c             |  64 +++++++++----
>>  fs/btrfs/ioctl.c             |  11 ++-
>>  fs/btrfs/qgroup.c            | 221
>> ++++++++++++++++++++++++++++++++-----------
>>  fs/btrfs/qgroup.h            |  14 +--
>>  fs/btrfs/relocation.c        |  13 ++-
>>  fs/btrfs/transaction.c       |  21 ++--
>>  include/trace/events/btrfs.h |  43 +++++++++
>>  12 files changed, 358 insertions(+), 138 deletions(-)
>>
>=20
>=20
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Jeff Mahoney
SUSE Labs


--0BAQdL9U7T25H1iB3DFJo3JiA8KVjbfSx--

--tGVqq5CbVFQv0tiskfRa6coqpJa7F9uuJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWMAUBR57S2MheeWyAQhpSg//atabeV1jw27+dojVWETh4VC90eSfDzHT
JgvDmRw+6H35jNbksD6h2+XkF/2pYsDRUKLMCaHQ/yislFkJRczZdl/+1ppgubZU
WXKmA1jFKhe2dfgZPlur9st7wF9j1+GKk8PKSahswf5uvlBPJ8obbY4gXtiwbXDv
g8pufh0b2uKPDb7u2Zm76pAUAqL4uNTYlJmH8NVT+kzQwCfqPCRf+3u0gWOvD4hj
WbtHklPDcJEmct6sztwfzn+DGti1+IWqbDvDyyk4H1IC6Hp0P1InCFXceDOTaNTJ
rb+/pdr/JEZSN2yLsGH0KyfPrOv9VdCdAQagTI8MMbydlVC6GLFq+2KnJ1qePs6i
CYxjG5adxZF6b7/u3WNXx/59lbxDgN6d4pZNULJrPblGCxofQ3Hezwki08oTZgSR
V9dHhMKZuVWn8BD0hCskVhq/C59O2OGAujXYgks2aHWanFZNtFvauPKCh5obgaFa
4WJV75a/jNlMtaYh3D5/ZnzoKR1vMRyooOJPXVfXuHvkAC0gjUP2gbSMtE/+xsRQ
JsxYqlhSyOgvtlh2zFZOshEPBFW61/dCtxKlJfPMXauXv2/zplw078SmMO8vlqQ8
RTdujY/0swH98vB9d4JCfxRK9pWc5FZswLRzlyoO+3gtuKI5BpaCrxwAtLTq98x6
ZGKgvk0ft4c=
=6qha
-----END PGP SIGNATURE-----

--tGVqq5CbVFQv0tiskfRa6coqpJa7F9uuJ--
