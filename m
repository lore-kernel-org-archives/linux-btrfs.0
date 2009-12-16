From: briaeros007 <briaeros007@gmail.com>
Subject: Re: (Little) Patch about null dereference with acl and posix.
Date: Wed, 16 Dec 2009 17:51:04 +0100
Message-ID: <61bf8f4f0912160851s4579b670x5e25fd7d4ed6fa66@mail.gmail.com>
References: <61bf8f4f0911181328y794436ackb82acca35d578f46@mail.gmail.com>
	 <200912112321.09143.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200912112321.09143.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

2009/12/11 Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>:
> Am Mittwoch 18 November 2009 22:28:27 schrieb briaeros007:
>> Hello,
>> For some days, i've got oops on my system and i've investigate it a =
bit.
>> The trouble was with =C2=A0"posix_acl_equiv_mode" , and for some rea=
son
>> (corrupted metadata ?) btrfs sometimes call it with "acl"=3D=3DNULL
>> This function doesn't like it.
>> So in my patch I've first put a little error protection around the
>> call, and then avoid to call btrfs_set_acl with acl=3DNULL.
>>
>> I'm not sure if it's ok with best practice, but i've done the test
>> which produce the oops, and know it doesn't (but some csum failed.
>> Well if my btrfs is corrupted, it's comprehensible).
>>
>> The patch is the following.
>>
>> diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
>> index 3616042..f8ade24 100644
>> --- a/fs/btrfs/acl.c
>> +++ b/fs/btrfs/acl.c
>> @@ -111,7 +111,8 @@ static int btrfs_set_acl(struct inode *inode,
>> struct posix_acl *acl, int type)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 switch (type) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 case ACL_TYPE_ACCESS:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mode =3D ino=
de->i_mode;
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D posix_acl=
_equiv_mode(acl, &mode);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (acl && mode)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 ret =3D posix_acl_equiv_mode(acl, &mode);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ret < 0)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 return ret;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D 0;
>> @@ -165,12 +166,13 @@ static int btrfs_xattr_set_acl(struct inode
>> *inode, int type,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else if (I=
S_ERR(acl)) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 return PTR_ERR(acl);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 ret =3D btrfs_set_acl(inode, acl, type);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 posix_acl_release(acl);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>>
>> - =C2=A0 =C2=A0 =C2=A0 ret =3D btrfs_set_acl(inode, acl, type);
>> -
>> - =C2=A0 =C2=A0 =C2=A0 posix_acl_release(acl);
>> -
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ret;
>> =C2=A0}
>
> Shouldn't this go upstream and into stable review?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
Hello,

Nobody agrees with this suggestion  (except me of course) ?

Cordially.




--=20
-------------------------------------------------------------------
Subete ga wakatta toki=E2=80=A6watashi ga anta wo korosu.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
