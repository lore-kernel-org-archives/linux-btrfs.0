Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:40973 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751277AbeCIA1q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 19:27:46 -0500
Subject: Re: [PATCH 08/20] btrfs-progs: qgroups: introduce btrfs_qgroup_query
To: Jeff Mahoney <jeffm@suse.com>, linux-btrfs@vger.kernel.org
References: <20180308024047.10104-1-jeffm@suse.com>
 <20180308024047.10104-9-jeffm@suse.com>
 <5e0953a9-0677-08ad-708b-acbefa66ab41@gmx.com>
 <1379e4ee-91b6-e9ca-ee06-435d0da54282@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <b4df7661-5454-a2ba-1152-07e39b83f65d@gmx.com>
Date: Fri, 9 Mar 2018 08:27:33 +0800
MIME-Version: 1.0
In-Reply-To: <1379e4ee-91b6-e9ca-ee06-435d0da54282@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2B1NvcPLu4RYC24aWSNQbocE5I2Kp3lUV"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2B1NvcPLu4RYC24aWSNQbocE5I2Kp3lUV
Content-Type: multipart/mixed; boundary="odkRYyA68j5si6iV75HDmuX99hYmPSmol";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Jeff Mahoney <jeffm@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <b4df7661-5454-a2ba-1152-07e39b83f65d@gmx.com>
Subject: Re: [PATCH 08/20] btrfs-progs: qgroups: introduce btrfs_qgroup_query
References: <20180308024047.10104-1-jeffm@suse.com>
 <20180308024047.10104-9-jeffm@suse.com>
 <5e0953a9-0677-08ad-708b-acbefa66ab41@gmx.com>
 <1379e4ee-91b6-e9ca-ee06-435d0da54282@suse.com>
In-Reply-To: <1379e4ee-91b6-e9ca-ee06-435d0da54282@suse.com>

--odkRYyA68j5si6iV75HDmuX99hYmPSmol
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8808=E6=97=A5 23:21, Jeff Mahoney wrote:
> On 3/8/18 12:54 AM, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B403=E6=9C=8808=E6=97=A5 10:40, jeffm@suse.com wrote:
>>> From: Jeff Mahoney <jeffm@suse.com>
>>>
>>> The only mechanism we have in the progs for searching qgroups is to l=
oad
>>> all of them and filter the results.  This works for qgroup show but
>>> to add quota information to 'btrfs subvoluem show' it's pretty wastef=
ul.
>>>
>>> This patch splits out setting up the search and performing the search=
 so
>>> we can search for a single qgroupid more easily.  Since TREE_SEARCH
>>> will give results that don't strictly match the search terms, we add
>>> a filter to match only the results we care about.
>>>
>>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>>> ---
>>>  qgroup.c | 143 ++++++++++++++++++++++++++++++++++++++++++++++++-----=
----------
>>>  qgroup.h |   7 ++++
>>>  2 files changed, 116 insertions(+), 34 deletions(-)
>>>
>>> diff --git a/qgroup.c b/qgroup.c
>>> index 57815718..d076b1de 100644
>>> --- a/qgroup.c
>>> +++ b/qgroup.c
>>> @@ -1165,11 +1165,30 @@ static inline void print_status_flag_warning(=
u64 flags)
>>>  		warning("qgroup data inconsistent, rescan recommended");
>>>  }
>>> =20
>>> -static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_loo=
kup)
>>> +static bool key_in_range(const struct btrfs_key *key,
>>> +			 const struct btrfs_ioctl_search_key *sk)
>>> +{
>>> +	if (key->objectid < sk->min_objectid ||
>>> +	    key->objectid > sk->max_objectid)
>>> +		return false;
>>> +
>>> +	if (key->type < sk->min_type ||
>>> +	    key->type > sk->max_type)
>>> +		return false;
>>> +
>>> +	if (key->offset < sk->min_offset ||
>>> +	    key->offset > sk->max_offset)
>>> +		return false;
>>> +
>>> +	return true;
>>> +}
>>
>> Even with the key_in_range() check here, we are still following the tr=
ee
>> search slice behavior:
>>
>> tree search will still gives us all the items in key range from
>> (min_objectid, min_type, min_offset) to
>> (max_objectid, max_type, max_offset).
>>
>> I don't see much different between the tree search ioctl and this one.=

>=20
> It's fundamentally different.
>=20
> The one in the kernel has a silly interface.  It should be min_key and
> max_key since the components aren't evaluated independently.  It
> effectively treats min_key and max_key as 136-bit values and returns
> everything between them, inclusive.  That's the slice behavior, as you
> call it.
>=20
> This key_in_range treats each component separately and acts as a filter=

> on the slice returned from the kernel.  If we request min/max_offset =3D=

> 259, the caller will not get anything without offset =3D 259.

You're right.

I'm just an idiot, the separate check on objectid/type/offset breaks the
slice behavior so we won't found any thing unrelated.


So the current design is completely fine, even we try to query something
doesn't exist we won't have any noise.

Thanks for the filter and this really helps a lot.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

>=20
> I suppose, ultimately, this could also be done using a filter on the
> rbtree using the existing interface but that seems even more wasteful.
>=20
> -Jeff
>=20
>>> +
>>> +static int __qgroups_search(int fd, struct btrfs_ioctl_search_args *=
args,
>>> +			    struct qgroup_lookup *qgroup_lookup)
>>>  {
>>>  	int ret;
>>> -	struct btrfs_ioctl_search_args args;
>>> -	struct btrfs_ioctl_search_key *sk =3D &args.key;
>>> +	struct btrfs_ioctl_search_key *sk =3D &args->key;
>>> +	struct btrfs_ioctl_search_key filter_key =3D args->key;
>>>  	struct btrfs_ioctl_search_header *sh;
>>>  	unsigned long off =3D 0;
>>>  	unsigned int i;
>>> @@ -1180,30 +1199,15 @@ static int __qgroups_search(int fd, struct qg=
roup_lookup *qgroup_lookup)
>>>  	u64 qgroupid;
>>>  	u64 qgroupid1;
>>> =20
>>> -	memset(&args, 0, sizeof(args));
>>> -
>>> -	sk->tree_id =3D BTRFS_QUOTA_TREE_OBJECTID;
>>> -	sk->max_type =3D BTRFS_QGROUP_RELATION_KEY;
>>> -	sk->min_type =3D BTRFS_QGROUP_STATUS_KEY;
>>> -	sk->max_objectid =3D (u64)-1;
>>> -	sk->max_offset =3D (u64)-1;
>>> -	sk->max_transid =3D (u64)-1;
>>> -	sk->nr_items =3D 4096;
>>> -
>>>  	qgroup_lookup_init(qgroup_lookup);
>>> =20
>>>  	while (1) {
>>> -		ret =3D ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
>>> +		ret =3D ioctl(fd, BTRFS_IOC_TREE_SEARCH, args);
>>>  		if (ret < 0) {
>>> -			if (errno =3D=3D ENOENT) {
>>> -				error("can't list qgroups: quotas not enabled");
>>> +			if (errno =3D=3D ENOENT)
>>>  				ret =3D -ENOTTY;
>>> -			} else {
>>> -				error("can't list qgroups: %s",
>>> -				       strerror(errno));
>>> +			else
>>>  				ret =3D -errno;
>>> -			}
>>> -
>>>  			break;
>>>  		}
>>> =20
>>> @@ -1217,37 +1221,46 @@ static int __qgroups_search(int fd, struct qg=
roup_lookup *qgroup_lookup)
>>>  		 * read the root_ref item it contains
>>>  		 */
>>>  		for (i =3D 0; i < sk->nr_items; i++) {
>>> -			sh =3D (struct btrfs_ioctl_search_header *)(args.buf +
>>> +			struct btrfs_key key;
>>> +
>>> +			sh =3D (struct btrfs_ioctl_search_header *)(args->buf +
>>>  								  off);
>>>  			off +=3D sizeof(*sh);
>>> =20
>>> -			switch (btrfs_search_header_type(sh)) {
>>> +			key.objectid =3D btrfs_search_header_objectid(sh);
>>> +			key.type =3D btrfs_search_header_type(sh);
>>> +			key.offset =3D btrfs_search_header_offset(sh);
>>> +
>>> +			if (!key_in_range(&key, &filter_key))
>>> +				goto next;
>>
>> It still looks like that most other qgroup info will get calculated.
>>
>>> +
>>> +			switch (key.type) {
>>>  			case BTRFS_QGROUP_STATUS_KEY:
>>>  				si =3D (struct btrfs_qgroup_status_item *)
>>> -				     (args.buf + off);
>>> +				     (args->buf + off);
>>>  				flags =3D btrfs_stack_qgroup_status_flags(si);
>>> =20
>>>  				print_status_flag_warning(flags);
>>>  				break;
>>>  			case BTRFS_QGROUP_INFO_KEY:
>>> -				qgroupid =3D btrfs_search_header_offset(sh);
>>> +				qgroupid =3D key.offset;
>>>  				info =3D (struct btrfs_qgroup_info_item *)
>>> -				       (args.buf + off);
>>> +				       (args->buf + off);
>>> =20
>>>  				ret =3D update_qgroup_info(fd, qgroup_lookup,
>>>  							 qgroupid, info);
>>>  				break;
>>>  			case BTRFS_QGROUP_LIMIT_KEY:
>>> -				qgroupid =3D btrfs_search_header_offset(sh);
>>> +				qgroupid =3D key.offset;
>>>  				limit =3D (struct btrfs_qgroup_limit_item *)
>>> -					(args.buf + off);
>>> +					(args->buf + off);
>>> =20
>>>  				ret =3D update_qgroup_limit(fd, qgroup_lookup,
>>>  							  qgroupid, limit);
>>>  				break;
>>>  			case BTRFS_QGROUP_RELATION_KEY:
>>> -				qgroupid =3D btrfs_search_header_offset(sh);
>>> -				qgroupid1 =3D btrfs_search_header_objectid(sh);
>>> +				qgroupid =3D key.offset;
>>> +				qgroupid1 =3D key.objectid;
>>> =20
>>>  				if (qgroupid < qgroupid1)
>>>  					break;
>>> @@ -1262,15 +1275,16 @@ static int __qgroups_search(int fd, struct qg=
roup_lookup *qgroup_lookup)
>>>  			if (ret)
>>>  				return ret;
>>> =20
>>> +next:
>>>  			off +=3D btrfs_search_header_len(sh);
>>> =20
>>>  			/*
>>>  			 * record the mins in sk so we can make sure the
>>>  			 * next search doesn't repeat this root
>>>  			 */
>>> -			sk->min_type =3D btrfs_search_header_type(sh);
>>> -			sk->min_offset =3D btrfs_search_header_offset(sh);
>>> -			sk->min_objectid =3D btrfs_search_header_objectid(sh);
>>> +			sk->min_type =3D key.type;
>>> +			sk->min_offset =3D key.offset;
>>> +			sk->min_objectid =3D key.objectid;
>>>  		}
>>>  		sk->nr_items =3D 4096;
>>>  		/*
>>> @@ -1286,6 +1300,67 @@ static int __qgroups_search(int fd, struct qgr=
oup_lookup *qgroup_lookup)
>>>  	return ret;
>>>  }
>>> =20
>>> +static int qgroups_search_all(int fd, struct qgroup_lookup *qgroup_l=
ookup)
>>> +{
>>> +	struct btrfs_ioctl_search_args args =3D {
>>> +		.key =3D {
>>> +			.tree_id =3D BTRFS_QUOTA_TREE_OBJECTID,
>>> +			.max_type =3D BTRFS_QGROUP_RELATION_KEY,
>>> +			.min_type =3D BTRFS_QGROUP_STATUS_KEY,
>>> +			.max_objectid =3D (u64)-1,
>>> +			.max_offset =3D (u64)-1,
>>> +			.max_transid =3D (u64)-1,
>>> +			.nr_items =3D 4096,
>>> +		},
>>> +	};
>>> +	int ret;
>>> +
>>> +	ret =3D __qgroups_search(fd, &args, qgroup_lookup);
>>> +	if (ret =3D=3D -ENOTTY)
>>> +		error("can't list qgroups: quotas not enabled");
>>> +	else if (ret < 0)
>>> +		error("can't list qgroups: %s", strerror(-ret));
>>> +	return ret;
>>> +}
>>> +
>>> +int btrfs_qgroup_query(int fd, u64 qgroupid, struct btrfs_qgroup_sta=
ts *stats)
>>> +{
>>> +	struct btrfs_ioctl_search_args args =3D {
>>> +		.key =3D {
>>> +			.tree_id =3D BTRFS_QUOTA_TREE_OBJECTID,
>>> +			.min_type =3D BTRFS_QGROUP_INFO_KEY,
>>> +			.max_type =3D BTRFS_QGROUP_LIMIT_KEY,
>>> +			.max_objectid =3D 0,
>>> +			.min_offset =3D qgroupid,
>>> +			.max_offset =3D qgroupid,
>>
>> Just keep in mind that such search could include unrelated qgroup info=

>> into the result, key_in_range() check won't help much due to the limit=

>> of how tree search works.
>>
>>> +			.max_transid =3D (u64)-1,
>>> +			.nr_items =3D 4096,
>>> +		},
>>> +	};
>>> +	struct qgroup_lookup qgroup_lookup;
>>> +	struct btrfs_qgroup *qgroup;
>>> +	struct rb_node *n;
>>> +	int ret;
>>> +
>>> +	ret =3D __qgroups_search(fd, &args, &qgroup_lookup);
>>> +	if (ret < 0)
>>> +		return ret;
>>> +
>>> +	ret =3D -ENODATA;
>>> +	n =3D rb_first(&qgroup_lookup.root);
>>
>> And in worst case, if we're query some qgroup which doesn't exist (may=
be
>> manually deleted), then due to limit of tree search, @qgroup_lookup
>> could contain unrelated qgroup info.
>>
>> In that case, rb_first() could gives us some unrelated qgroup.
>>
>> For example, we have qgroups info for 5, 258, 259, 1/1, and we're tryi=
ng
>> to query qgroup 257 (deleted manually), then we will get the following=

>> result from tree search:
>>
>> 	item 3 key (0 QGROUP_INFO 0/258) itemoff 16131 itemsize 40
>> 	item 4 key (0 QGROUP_INFO 0/259) itemoff 16131 itemsize 40
>> 	item 5 key (0 QGROUP_INFO 1/1) itemoff 16091 itemsize 40
>> 	item 6 key (0 QGROUP_LIMIT 0/5) itemoff 16051 itemsize 40
>>
>> So in @qgroup_lookup, the first item will be qgroup 258 instead of the=

>> non-exist qgroup 257.
>>
>> Either caller needs extra check or we need to do extra check in this
>> function.
>>
>> Thanks,
>> Qu
>>
>>> +	if (n) {
>>> +		qgroup =3D rb_entry(n, struct btrfs_qgroup, rb_node);
>>> +		stats->qgroupid =3D qgroup->qgroupid;
>>> +		stats->info =3D qgroup->info;
>>> +		stats->limit =3D qgroup->limit;
>>> +
>>> +		ret =3D 0;
>>> +	}
>>> +
>>> +	__free_all_qgroups(&qgroup_lookup);
>>> +	return ret;
>>> +}
>>> +
>>>  static void print_all_qgroups(struct qgroup_lookup *qgroup_lookup, b=
ool verbose)
>>>  {
>>> =20
>>> @@ -1312,7 +1387,7 @@ int btrfs_show_qgroups(int fd,
>>>  	struct qgroup_lookup sort_tree;
>>>  	int ret;
>>> =20
>>> -	ret =3D __qgroups_search(fd, &qgroup_lookup);
>>> +	ret =3D qgroups_search_all(fd, &qgroup_lookup);
>>>  	if (ret)
>>>  		return ret;
>>>  	__filter_and_sort_qgroups(&qgroup_lookup, &sort_tree,
>>> diff --git a/qgroup.h b/qgroup.h
>>> index 5e71349c..688f92b2 100644
>>> --- a/qgroup.h
>>> +++ b/qgroup.h
>>> @@ -87,6 +87,12 @@ struct btrfs_qgroup_info {
>>>  	u64 exclusive_compressed;
>>>  };
>>> =20
>>> +struct btrfs_qgroup_stats {
>>> +	u64 qgroupid;
>>> +	struct btrfs_qgroup_info info;
>>> +	struct btrfs_qgroup_limit limit;
>>> +};
>>> +
>>>  int btrfs_qgroup_parse_sort_string(const char *opt_arg,
>>>  				struct btrfs_qgroup_comparer_set **comps);
>>>  int btrfs_show_qgroups(int fd, struct btrfs_qgroup_filter_set *,
>>> @@ -105,4 +111,5 @@ int qgroup_inherit_add_group(struct btrfs_qgroup_=
inherit **inherit, char *arg);
>>>  int qgroup_inherit_add_copy(struct btrfs_qgroup_inherit **inherit, c=
har *arg,
>>>  			    int type);
>>> =20
>>> +int btrfs_qgroup_query(int fd, u64 qgroupid, struct btrfs_qgroup_sta=
ts *stats);
>>>  #endif
>>>
>>
>=20
>=20


--odkRYyA68j5si6iV75HDmuX99hYmPSmol--

--2B1NvcPLu4RYC24aWSNQbocE5I2Kp3lUV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqh1PUXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjLxAf/eAgVTDHrctGAMVei1kBGZ2x+
2MKgcYJF86qEFoBnQvuYM4XgO+/djZFdRbsQ1Gs1bETn9oKZn2h9CBdC+RX28Nbc
PUnSZ7n2s/bKxm5K8nw6EuR9bgtBZTWAXt0PwsC2IY59THQf460c7FQKu6bxzVCJ
A9qKenR9/zXBqGxj4q8rsRqEcdIiFaUXm2YDHmgj8iww3J8QES7E+ZycI0z2eJMU
1vngW3pYIlU5lY9Dv0UJ6WvIQHWZRU8f/ulaiVPlOwl1ccUFtQjZd1oYC4XJPNRb
gZugG7hKd1yKu2B++fMko6yUMa4VpRBt1ckrffbJ+vpoNnmlWEDxPtUUnXP3jw==
=SqyY
-----END PGP SIGNATURE-----

--2B1NvcPLu4RYC24aWSNQbocE5I2Kp3lUV--
