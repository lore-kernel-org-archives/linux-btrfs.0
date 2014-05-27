Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39882 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039AbaE0Q67 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 May 2014 12:58:59 -0400
Message-ID: <5384C44F.8010207@suse.com>
Date: Tue, 27 May 2014 12:58:55 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v3] btrfs: allocate raid type kobjects dynamically
References: <5383EBE0.2000906@suse.com> <5384B904.3070809@fb.com>
In-Reply-To: <5384B904.3070809@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 5/27/14, 12:10 PM, Chris Mason wrote:
> On 05/26/2014 09:35 PM, Jeff Mahoney wrote:
>> We are currently allocating space_info objects in an array when
>> we allocate space_info. When a user does something like:
>> 
>> # btrfs balance start -mconvert=raid1 -dconvert=raid1 /mnt #
>> btrfs balance start -mconvert=single -dconvert=single /mnt -f #
>> btrfs balance start -mconvert=raid1 -dconvert=raid1 /
>> 
>> We can end up with memory corruption since the kobject hasn't 
>> been reinitialized properly and the name pointer was left set.
>> 
>> The rationale behind allocating them statically was to avoid 
>> creating a separate kobject container that just contained the 
>> raid type. It used the index in the array to determine the
>> index.
>> 
>> Ultimately, though, this wastes more memory than it saves in all 
>> but the most complex scenarios and introduces kobject lifetime 
>> questions.
>> 
>> This patch allocates the kobjects dynamically instead. Note that 
>> we also remove the kobject_get/put of the parent kobject since 
>> kobject_add and kobject_del do that internally.
> 
> Thanks Jeff, one small thing below:
> 
>> --- a/fs/btrfs/extent-tree.c +++ b/fs/btrfs/extent-tree.c @@
>> -8352,17 +8351,26 @@ static void __link_block_group(struct bt 
>> up_write(&space_info->groups_sem);
>> 
>> if (first) { -		struct kobject *kobj =
>> &space_info->block_group_kobjs[index]; +		struct raid_kobject
>> *rkobj; int ret;
>> 
>> -		kobject_get(&space_info->kobj); /* put in release */ -		ret =
>> kobject_add(kobj, &space_info->kobj, "%s", -
>> get_raid_name(index)); +		rkobj = kzalloc(sizeof(*rkobj),
>> GFP_KERNEL);
> ^^^^^^^^^^^^
> 
> GFP_NOFS?  We've got a transaction running here.

Sigh. Yep.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.22 (Darwin)

iQIcBAEBAgAGBQJThMRPAAoJEB57S2MheeWyViAP/jVgxqPgISBaMkYX4aM3Cfcq
cO1U1oRFJfn6HQJ58zqqhpnRtgGHAlcoxt5j7GSZejUDi1ks274qJlIfqJBxhoeD
PtgJhIjIdTHs1hHrZprIvTEnEv1OpUq+xbfp3bPEEw+Bgu2oYyRhdZ/MMhFDSWuM
jlvhgmTROz1p7tPbxuFVKPo1dY4OmDFed8TqS+Cl2NygNW1vwNf5v8c00IInlE4R
VLUvhOaZCVSMwpG24ADVz0wAQDOtyogay2UHCY3XfLvH2sdtPiIdx4w+Zf9rOiFD
7IGyx6x1Cf57+H+fjQ2tMdhZuYU4dn1Tp1qxEbL1XivWP/weYLkurdA42XeOYSRt
IUjH6hP4/JX0eJIs4IFZErjlpgvBvcOeChKyUXgAUy+lEd7JV5CEoo58BjfnaCVY
e+GjpTaYHDx7xiuHg06nO2LcugRzVeiORlI5oR6s9reIEbC1SpKblK4jvMRFcM/2
j5GCK25i/bMTBTby50+dBojuMGVOXT7Fm42sK/lMv3OVu3h3zZq0N1Kq5GSLHgfn
rEr/l4HvCE6DCAb3Uqm+Gf/WZ45vd6/29Zt3/UHaOq+vr852H5SDL1qPS9zLCqnx
JwSj+PUK/Ns8fHjlIVweYc0sBgJdQcU8eW8M/m4X261i42veP0YC71P//N+M9PvF
qcsDs/YxPLUod5Itm1Zf
=C73I
-----END PGP SIGNATURE-----
