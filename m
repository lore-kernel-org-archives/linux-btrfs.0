Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47616 "EHLO mx1.suse.de"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752717AbdF2Tti (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Jun 2017 15:49:38 -0400
Subject: Re: [PATCH v2 1/2] btrfs: account for pinned bytes in
 should_alloc_chunk
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
References: <20170622135148.16730-1-jeffm@suse.com>
 <20170629192141.GA20229@vader.DHCP.thefacebook.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <b431385d-049f-5972-b5f2-367b7d3e4c7c@suse.com>
Date: Thu, 29 Jun 2017 15:49:05 -0400
MIME-Version: 1.0
In-Reply-To: <20170629192141.GA20229@vader.DHCP.thefacebook.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="BW0KghXhltPAgr7Kr3uvhSQ2tsSp5vOI8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BW0KghXhltPAgr7Kr3uvhSQ2tsSp5vOI8
Content-Type: multipart/mixed; boundary="j98xNmD63SJ4Txn3bdVxDFPawsvTO1oPD";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Message-ID: <b431385d-049f-5972-b5f2-367b7d3e4c7c@suse.com>
Subject: Re: [PATCH v2 1/2] btrfs: account for pinned bytes in
 should_alloc_chunk
References: <20170622135148.16730-1-jeffm@suse.com>
 <20170629192141.GA20229@vader.DHCP.thefacebook.com>
In-Reply-To: <20170629192141.GA20229@vader.DHCP.thefacebook.com>

--j98xNmD63SJ4Txn3bdVxDFPawsvTO1oPD
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 6/29/17 3:21 PM, Omar Sandoval wrote:
> On Thu, Jun 22, 2017 at 09:51:47AM -0400, jeffm@suse.com wrote:
>> From: Jeff Mahoney <jeffm@suse.com>
>>
>> In a heavy write scenario, we can end up with a large number of pinned=
 bytes.
>> This can translate into (very) premature ENOSPC because pinned bytes
>> must be accounted for when allowing a reservation but aren't accounted=
 for
>> when deciding whether to create a new chunk.
>>
>> This patch adds the accounting to should_alloc_chunk so that we can
>> create the chunk.
>=20
> Hey, Jeff,

Hi Omar -

> Does this fix your ENOSPC problem on a fresh filesystem? I just tracked=


No, it didn't.  It helped somewhat, but we were still hitting it
frequently.  What did help was reverting "Btrfs: skip commit transaction
if we don't have enough pinned bytes" (not upstream yet, on the list).

> down an ENOSPC issue someone here reported when doing a btrfs send to a=

> fresh filesystem and it sounds a lot like your issue: metadata
> bytes_may_use shoots up but we don't allocate any chunks for it. I'm no=
t
> seeing how including bytes_pinned will help for this case. We won't hav=
e
> any pinned bytes when populating a new fs, right?

Our test environment is just installing the OS.  That means lots of
creates, writes, and then renames, so there's a fair amount of metadata
churn that results in elevated pinned_bytes.  Rsync can cause the same
workload pretty easily too.  Nikolay was going to look into coming up
with a configuration for fsstress that would emulate it.

> I don't have a good solution. Allocating chunks based on bytes_may_use
> is going to way over-allocate because of our worst-case estimations. I'=
m
> double-checking now that the flusher is doing the right thing and not
> missing anything. I'll keep digging, just wanted to know if you had any=

> thoughts.

My suspicion is that it all just happens to work and that there are
several bugs working together that approximate a correct result.  My
reasoning is that the patch I referenced above is correct.  The logic in
may_commit_transaction is inverted and causing a ton of additional
transaction commits.  I think that having the additional transaction
commits is serving to free pinned bytes more quickly so things just work
for the most part and pinned bytes doesn't play as much of a role.  But
once the transaction count comes down, that pinned bytes count gets
elevated and becomes more important.  I think it should be taken into
account to determine whether committing a transaction early will result
in releasing enough space to honor the reservation without allocating a
new chunk.  If the answer is yes, flush it.  If no, there's no point in
flushing it now, so just allocate the chunk and move on.

The big question is where this 80% number comes into play.

There is a caveat here: almost all of our testing has been on 4.4 with a
bunch of these patches backported.  I believe the same issue will still
be there on mainline, but we're in release crunch mode and I haven't had
a chance to test more fully.

-Jeff

>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>> ---
>>  fs/btrfs/extent-tree.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 33d979e9ea2a..88b04742beea 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -4377,7 +4377,7 @@ static int should_alloc_chunk(struct btrfs_fs_in=
fo *fs_info,
>>  {
>>  	struct btrfs_block_rsv *global_rsv =3D &fs_info->global_block_rsv;
>>  	u64 num_bytes =3D sinfo->total_bytes - sinfo->bytes_readonly;
>> -	u64 num_allocated =3D sinfo->bytes_used + sinfo->bytes_reserved;
>> +	u64 num_allocated =3D sinfo->bytes_used + sinfo->bytes_reserved + si=
nfo->bytes_pinned;
>>  	u64 thresh;
>> =20
>>  	if (force =3D=3D CHUNK_ALLOC_FORCE)
>> --=20
>> 2.11.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Jeff Mahoney
SUSE Labs


--j98xNmD63SJ4Txn3bdVxDFPawsvTO1oPD--

--BW0KghXhltPAgr7Kr3uvhSQ2tsSp5vOI8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWVVZsh57S2MheeWyAQiSsg/+JoBKgl2Z2hcS/n/o2ggQUjk6FIWWIIFq
XGHcs4VOFChp9PppYXdiS4W/KYfD3JeZ0pZhlKUreEkn6Al/8oI6ZOBqm7MC/niE
OVQOvBbzALnFDkwyWT/Q5laI3CW0WL6UdMSjCAnkdUy9Kk0AUIH2Z6RgzucgKG9p
Vp/ym4MM2YmSbgU7ZH/KtNHFQXazFwBOeBWKOP6RZuBz+MChzPdPE1HHTQ+xU4VQ
4oR9m6dN1YsrtmUe/UC9wPT3jsEuWRmgVxZkO53rsFd/F1XmRTbH6kLwd5ek9hZ/
nQoSH25pv+daW/g2bEK9jmBoMJRHBw8Bop5q4qkxtxyP/tU2yfb3ozhrTsetbM+T
UCnfOjw2rkX5qMqWjuQ2DRr7r6afaY8Dan2eHZUEu5n2m5yBGroQmakogza4/P6L
RVkxJDI5xmXes6ClhHn60/mxzhCkg/UBC+wnXihpOTykIxCLL25VibBBWYBSVK9p
gAxRmXUZINtLmvgfG2LdA3Z3CWxsIvoYLYBsIG32fuy4rLKAJd6PVDhb9SMb4YUl
JtW0ZT5fhhPeT+dFLjI+X0KliDdz/Kt1cnicxfMbinW3r2LIef220hb/fPwztST/
qbmBjaKYhc+F+6wZJuQan3FV3JLHeYyMBAV3mjlVIc57JadWWAYmn/VIwpirhr+W
bsAScNb/6ow=
=embz
-----END PGP SIGNATURE-----

--BW0KghXhltPAgr7Kr3uvhSQ2tsSp5vOI8--
