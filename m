Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60062 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933386AbeCGQhn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 11:37:43 -0500
Subject: Re: [PATCH 4/8] btrfs-progs: qgroups: add pathname to show output
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <20180302184704.22399-1-jeffm@suse.com>
 <20180302184704.22399-5-jeffm@suse.com>
 <59988490-c594-f505-70af-00361b69d025@gmx.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <c0d96203-83e2-865b-5bb2-77f81b68194c@suse.com>
Date: Wed, 7 Mar 2018 11:37:40 -0500
MIME-Version: 1.0
In-Reply-To: <59988490-c594-f505-70af-00361b69d025@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="omTml8XI6agjHfE9LW8pCrjFB4JPaJ4RN"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--omTml8XI6agjHfE9LW8pCrjFB4JPaJ4RN
Content-Type: multipart/mixed; boundary="B784sKdA8JRaaVLeWoHj9BIWL3dBPtzht";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Message-ID: <c0d96203-83e2-865b-5bb2-77f81b68194c@suse.com>
Subject: Re: [PATCH 4/8] btrfs-progs: qgroups: add pathname to show output
References: <20180302184704.22399-1-jeffm@suse.com>
 <20180302184704.22399-5-jeffm@suse.com>
 <59988490-c594-f505-70af-00361b69d025@gmx.com>
In-Reply-To: <59988490-c594-f505-70af-00361b69d025@gmx.com>

--B784sKdA8JRaaVLeWoHj9BIWL3dBPtzht
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 3/7/18 12:45 AM, Qu Wenruo wrote:
>=20
>=20
> On 2018=E5=B9=B403=E6=9C=8803=E6=97=A5 02:47, jeffm@suse.com wrote:
>> diff --git a/cmds-qgroup.c b/cmds-qgroup.c
>> index 48686436..94cd0fd3 100644
>> --- a/cmds-qgroup.c
>> +++ b/cmds-qgroup.c
>> @@ -280,8 +280,10 @@ static const char * const cmd_qgroup_show_usage[]=
 =3D {
>>  	"               (including ancestral qgroups)",
>>  	"-f             list all qgroups which impact the given path",
>>  	"               (excluding ancestral qgroups)",
>> +	"-P             print first-level qgroups using pathname",
>> +	"-v             verbose, prints all nested subvolumes",
>=20
> Did you mean the subvolume paths of all children qgroups?

Yes.  I'll make that clearer.

>>  	HELPINFO_UNITS_LONG,
>> -	"--sort=3Dqgroupid,rfer,excl,max_rfer,max_excl",
>> +	"--sort=3Dqgroupid,rfer,excl,max_rfer,max_excl,pathname",
>>  	"               list qgroups sorted by specified items",
>>  	"               you can use '+' or '-' in front of each item.",
>>  	"               (+:ascending, -:descending, ascending default)",

>> diff --git a/qgroup.c b/qgroup.c
>> index 67bc0738..83918134 100644
>> --- a/qgroup.c
>> +++ b/qgroup.c
>> @@ -210,8 +220,42 @@ static void print_qgroup_column_add_blank(enum bt=
rfs_qgroup_column_enum column,
>>  		printf(" ");
>>  }
>> =20
>> +void print_pathname_column(struct btrfs_qgroup *qgroup, bool verbose)=

>> +{
>> +	struct btrfs_qgroup_list *list =3D NULL;
>> +
>> +	fputs("  ", stdout);
>> +	if (btrfs_qgroup_level(qgroup->qgroupid) > 0) {
>> +		int count =3D 0;
>=20
> Newline after declaration please.

Ack.

> And declaration in if() {} block doesn't pass checkpath IIRC.

Declarations in if () {} are fine.

>> +		list_for_each_entry(list, &qgroup->qgroups,
>> +				    next_qgroup) {
>> +			if (verbose) {
>> +				struct btrfs_qgroup *member =3D list->qgroup;
>=20
> Same coding style problem here.

Ack.

>> +				u64 level =3D btrfs_qgroup_level(member->qgroupid);
>> +				u64 sid =3D btrfs_qgroup_subvid(member->qgroupid);
>> +				if (count)
>> +					fputs(" ", stdout);
>> +				if (btrfs_qgroup_level(member->qgroupid) =3D=3D 0)
>> +					fputs(member->pathname, stdout);
>=20
> What about checking member->pathname before outputting?
> As it could be missing.

Yep.

>> +static const char *qgroup_pathname(int fd, u64 qgroupid)
>> +{
>> +	struct root_info root_info;
>> +	int ret;
>> +	char *pathname;
>> +
>> +	ret =3D get_subvol_info_by_rootid_fd(fd, &root_info, qgroupid);

This is a leak too.  Callers are responsible for freeing the root_info
paths.  With this and your review fixed, valgrind passes with 0 leaks
for btrfs qgroups show -P.

>> +	if (ret)
>> +		return NULL;
>> +
>> +	ret =3D asprintf(&pathname, "%s%s",
>> +		       root_info.full_path[0] =3D=3D '/' ? "" : "/",
>> +		       root_info.full_path);
>> +	if (ret < 0)
>> +		return NULL;
>> +
>> +	return pathname;
>> +}
>> +
>>  /*
>>   * Lookup or insert btrfs_qgroup into qgroup_lookup.
>>   *
>> @@ -588,7 +697,7 @@ static struct btrfs_qgroup *qgroup_tree_search(str=
uct qgroup_lookup *root_tree,
>>   * Return the pointer to the btrfs_qgroup if found or if inserted suc=
cessfully.
>>   * Return ERR_PTR if any error occurred.
>>   */
>> -static struct btrfs_qgroup *get_or_add_qgroup(
>> +static struct btrfs_qgroup *get_or_add_qgroup(int fd,
>>  		struct qgroup_lookup *qgroup_lookup, u64 qgroupid)
>>  {
>>  	struct btrfs_qgroup *bq;
>> @@ -608,6 +717,8 @@ static struct btrfs_qgroup *get_or_add_qgroup(
>>  	INIT_LIST_HEAD(&bq->qgroups);
>>  	INIT_LIST_HEAD(&bq->members);
>> =20
>> +	bq->pathname =3D qgroup_pathname(fd, qgroupid);
>> +
>=20
> Here qgroup_pathname() will allocate memory, but no one is freeing this=

> memory.
>=20
> The cleaner should be in __free_btrfs_qgroup() but there is no
> modification to that function.

Ack.

Thanks for the review,

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--B784sKdA8JRaaVLeWoHj9BIWL3dBPtzht--

--omTml8XI6agjHfE9LW8pCrjFB4JPaJ4RN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCAAtFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlqgFVQPHGplZmZtQHN1
c2UuY29tAAoJEB57S2MheeWygzcP/RnlNhZFatlUleQkeBztgPAM7ALDSW9RVpuZ
AMx5L5M8f1ugely+1jBHOSZo6Yi+AsSxSm485nQqcafbYx2vsgR5qLMFVnsGH8pr
qOokJjea/oN9bJdWkBxGqFiW6F5g2WIkIkAZuD39j+R35ovTUJZ0WZlW8pnkz/9M
hSAjv5CNYKnklxIpkUK4NQxdMDrWz1DOM/FZi8JVa6w/3KLdysSefWwN6LNO6QBA
teANIV9GlFPRETVTl87XOOwu9GHG7E4gK6Cc1ya6DtCTSck7ggZ5o7caPbEVRn4Y
ykDjRTck1fuEhall0/xCkpb4Nafq4LSGUo4W+KbDAvNP2ngYVM90FJgs7RFpphS/
z+Dd/Y4sJCseece78EhXnn0QOIgwfVd1Qk7208llWFyNLzgoiXBLNM9wgtb6nE4z
DwhBOD9UwYrFnY3wNeK6DY/Kdq3SLCGWOAR7L2yT/oiNVG1Yy8CSrAKuIQDEE5mz
qBnIsKZKstbReG7sFDkjLKu88P7ACJMJ+zXzSihzOeU2mFbi1Q7Anfg6N8t7HbDj
UzvjnuxWC0/g2y9rZpqVH7etYOZS4Dh9KZF6ZtVLtW160Hu6o/h8p+f02NtGQhPg
UX0o6h7N1C7KAykOUPlqgi4f5eAEvslga/ILNXiOO7dvBaMso7RAhSaXi3Fp7aDA
lYEURTIt
=hghA
-----END PGP SIGNATURE-----

--omTml8XI6agjHfE9LW8pCrjFB4JPaJ4RN--
