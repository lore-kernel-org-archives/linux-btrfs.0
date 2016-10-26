Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:39519 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750866AbcJZER3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Oct 2016 00:17:29 -0400
Received: by mail-it0-f68.google.com with SMTP id q75so251842itc.6
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Oct 2016 21:17:29 -0700 (PDT)
Subject: Re: [PATCH 5/5] don't set *REFERENCED unless we are on the lru list
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_EC832973-3E90-4661-83BC-35E1FCC21397"; protocol="application/pgp-signature"; micalg=pgp-sha256
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20161025224442.GA18879@vader.DHCP.thefacebook.com>
Date: Tue, 25 Oct 2016 22:17:19 -0600
Cc: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, david@fromorbit.com, jack@suse.cz,
        linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        hch@infradead.org, jweiner@fb.com
Message-Id: <706289B2-E2F9-46A0-903A-9D5CB5F21CBF@dilger.ca>
References: <1477420904-1399-1-git-send-email-jbacik@fb.com> <1477420904-1399-6-git-send-email-jbacik@fb.com> <20161025224442.GA18879@vader.DHCP.thefacebook.com>
To: Omar Sandoval <osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Apple-Mail=_EC832973-3E90-4661-83BC-35E1FCC21397
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Oct 25, 2016, at 4:44 PM, Omar Sandoval <osandov@osandov.com> wrote:
>=20
> On Tue, Oct 25, 2016 at 02:41:44PM -0400, Josef Bacik wrote:
>> With anything that populates the inode/dentry cache with a lot of one =
time use
>> inodes we can really put a lot of pressure on the system for things =
we don't
>> need to keep in cache.  It takes two runs through the LRU to evict =
these one use
>> entries, and if you have a lot of memory you can end up with 10's of =
millions of
>> entries in the dcache or icache that have never actually been touched =
since they
>> were first instantiated, and it will take a lot of CPU and a lot of =
pressure to
>> evict all of them.
>>=20
>> So instead do what we do with pagecache, only set the *REFERENCED =
flags if we
>> are being used after we've been put onto the LRU.  This makes a =
significant
>> difference in the system's ability to evict these useless cache =
entries.  With a
>> fs_mark workload that creates 40 million files we get the following =
results (all
>> in files/sec)
>>=20
>> Btrfs			Patched		Unpatched
>> Average Files/sec:	72209.3		63254.2
>> p50 Files/sec:		70850		57560
>> p90 Files/sec:		68757		53085
>> p99 Files/sec:		68757		53085
>>=20
>> XFS			Patched		Unpatched
>> Average Files/sec:	61025.5		60719.5
>> p50 Files/sec:		60107		59465
>> p90 Files/sec: 		59300		57966
>> p99 Files/sec: 		59227		57528
>>=20
>> Ext4			Patched		Unpatched
>> Average Files/sec:	121785.4	119248.0
>> p50 Files/sec:		120852		119274
>> p90 Files/sec:		116703		112783
>> p99 Files/sec:		114393		104934
>>=20
>> The reason Btrfs has a much larger improvement is because it holds a =
lot more
>> things in memory so benefits more from faster slab reclaim, but =
across the board
>> is an improvement for each of the file systems.
>>=20
>> Signed-off-by: Josef Bacik <jbacik@fb.com>
>> ---
>> fs/dcache.c | 15 ++++++++++-----
>> fs/inode.c  |  5 ++++-
>> 2 files changed, 14 insertions(+), 6 deletions(-)
>>=20
>> diff --git a/fs/dcache.c b/fs/dcache.c
>> index 5c7cc95..a558075 100644
>> --- a/fs/dcache.c
>> +++ b/fs/dcache.c
>> @@ -779,8 +779,6 @@ repeat:
>> 			goto kill_it;
>> 	}
>>=20
>> -	if (!(dentry->d_flags & DCACHE_REFERENCED))
>> -		dentry->d_flags |=3D DCACHE_REFERENCED;
>> 	dentry_lru_add(dentry);
>>=20
>> 	dentry->d_lockref.count--;
>> @@ -803,6 +801,13 @@ static inline void __dget_dlock(struct dentry =
*dentry)
>> 	dentry->d_lockref.count++;
>> }
>>=20
>> +static inline void __dget_dlock_reference(struct dentry *dentry)
>> +{
>> +	if (dentry->d_flags & DCACHE_LRU_LIST)
>> +		dentry->d_flags |=3D DCACHE_REFERENCED;
>> +	dentry->d_lockref.count++;
>> +}
>> +
>> static inline void __dget(struct dentry *dentry)
>> {
>> 	lockref_get(&dentry->d_lockref);
>> @@ -875,7 +880,7 @@ again:
>> 			    (alias->d_flags & DCACHE_DISCONNECTED)) {
>> 				discon_alias =3D alias;
>> 			} else {
>> -				__dget_dlock(alias);
>> +				__dget_dlock_reference(alias);
>> 				spin_unlock(&alias->d_lock);
>> 				return alias;
>> 			}
>> @@ -886,7 +891,7 @@ again:
>> 		alias =3D discon_alias;
>> 		spin_lock(&alias->d_lock);
>> 		if (S_ISDIR(inode->i_mode) || !d_unhashed(alias)) {
>> -			__dget_dlock(alias);
>> +			__dget_dlock_reference(alias);
>> 			spin_unlock(&alias->d_lock);
>> 			return alias;
>> 		}
>> @@ -2250,7 +2255,7 @@ struct dentry *__d_lookup(const struct dentry =
*parent, const struct qstr *name)
>> 		if (!d_same_name(dentry, parent, name))
>> 			goto next;
>>=20
>> -		dentry->d_lockref.count++;
>> +		__dget_dlock_reference(dentry);
>=20
> This misses dentries that we get through __d_lookup_rcu(), so I think
> your change made it so most things aren't getting DCACHE_REFERENCED =
set
> at all. Maybe something like this instead?
>=20
> diff --git a/fs/dcache.c b/fs/dcache.c
> index 5c7cc95..d7a56a8 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -412,15 +412,6 @@ static void d_lru_shrink_move(struct list_lru_one =
*lru, struct dentry *dentry,
> 	list_lru_isolate_move(lru, &dentry->d_lru, list);
> }
>=20
> -/*
> - * dentry_lru_(add|del)_list) must be called with d_lock held.
> - */
> -static void dentry_lru_add(struct dentry *dentry)
> -{
> -	if (unlikely(!(dentry->d_flags & DCACHE_LRU_LIST)))
> -		d_lru_add(dentry);
> -}
> -
> /**
>  * d_drop - drop a dentry
>  * @dentry: dentry to drop
> @@ -779,9 +770,12 @@ void dput(struct dentry *dentry)
> 			goto kill_it;
> 	}
>=20
> -	if (!(dentry->d_flags & DCACHE_REFERENCED))
> -		dentry->d_flags |=3D DCACHE_REFERENCED;
> -	dentry_lru_add(dentry);
> +	if (likely(dentry->d_flags & DCACHE_LRU_LIST)) {
> +		if (!(dentry->d_flags & DCACHE_REFERENCED))
> +			dentry->d_flags |=3D DCACHE_REFERENCED;

There is no benefit to checking if DCACHE_REFERENCED is unset before
trying to set it.  You've already accessed the cacheline, so you can
avoid the branch here and just set it unconditionally.

Cheers, Andreas

> +	} else {
> +		d_lru_add(dentry);
> +	}
>=20
> 	dentry->d_lockref.count--;
> 	spin_unlock(&dentry->d_lock);
> diff --git a/fs/inode.c b/fs/inode.c
> index 88110fd..16faca3 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -798,6 +798,8 @@ static struct inode *find_inode(struct super_block =
*sb,
> 			__wait_on_freeing_inode(inode);
> 			goto repeat;
> 		}
> +		if (!list_empty(&inode->i_lru))
> +			inode->i_state |=3D I_REFERENCED;
> 		__iget(inode);
> 		spin_unlock(&inode->i_lock);
> 		return inode;
> @@ -825,6 +827,8 @@ static struct inode *find_inode_fast(struct =
super_block *sb,
> 			__wait_on_freeing_inode(inode);
> 			goto repeat;
> 		}
> +		if (!list_empty(&inode->i_lru))
> +			inode->i_state |=3D I_REFERENCED;
> 		__iget(inode);
> 		spin_unlock(&inode->i_lock);
> 		return inode;
> @@ -1492,7 +1496,6 @@ static void iput_final(struct inode *inode)
> 		drop =3D generic_drop_inode(inode);
>=20
> 	if (!drop && (sb->s_flags & MS_ACTIVE)) {
> -		inode->i_state |=3D I_REFERENCED;
> 		inode_add_lru(inode);
> 		spin_unlock(&inode->i_lock);
> 		return;
>=20
> --
> Omar
> --
> To unsubscribe from this list: send the line "unsubscribe =
linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_EC832973-3E90-4661-83BC-35E1FCC21397
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWBAuT3Kl2rkXzB/gAQi8pg//aGZDeWwawR2VOoBVFopfCFzCv0bYZxp3
ho4qiJONCKqx0udzFcGPVlyjcDHiz90m7I8v1N/g1X3GYgp0MSlG6jqphT5faJK5
qQjGUo8UpKpSYfBgx+ILjgI2tdHL97f8KHooVSU+Lo6da6egbSorUsrHuCkpG1fC
6D4X4Cx+RpXcim1aWh3vSA/+B6e9kVycnuAo+xsJKKLpsnf2d2Lx3xndxhGiAYqi
YZw8dE0B9PGfa0qMDTXOEJZCMZCyskfTwzESBsUhUzjvTJ1hgYGsNN+73Tg4E/sp
nePlqXNVrZeztsd1OPQie0XSYxiqzCqu/dg0RgRl370N6JmUVWwXSj583efksA7z
3Y/CvKy3R+DKbyYNh5Dp38S3Rv9wP+f48nPY7zXXh3rDFUU+EPsuM29mRFfrgW18
X6+6ZPKWR8si6Sl4JyFHZ0XCIk8d0HpICc5Jx/hLNQvFEADXPp2ULTSsvVGiJhgf
eJaMTSj04t2PZESkWH6U1PAb1/140vqlecDnUIbv3LjFx2ZbKd86jA2bi0Xwb15c
qE8ZMFp2Yi5dTMwtiHrHraT/GayxrpRwAwD2mqfVUIPVEShS6vUtAFhQEgcNYNTJ
sVgG4MLWCKIAzHhYFd6ZJJlJYR//Nv+O4csRTtvqVM00v2wWsEuGy2C6XXg1es4L
BkWpJjTe4KQ=
=9zdh
-----END PGP SIGNATURE-----

--Apple-Mail=_EC832973-3E90-4661-83BC-35E1FCC21397--
