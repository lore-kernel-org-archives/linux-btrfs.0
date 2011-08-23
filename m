From: Jim Maloney <jim@webstarts.com>
Subject: Re: btrfs over nfs
Date: Tue, 23 Aug 2011 09:27:59 -0400
Message-ID: <CAGFoeJ_JxF+0WVaUNBmS20OeeYEgKFHqadj5H+c+BmXQAEbhcg@mail.gmail.com>
References: <CAGFoeJ8J4f2_r=bdWapr0CM+Oq+aSJ78-E4D2zP5atHXdovoFw@mail.gmail.com>
	<20110822212847.GA5412@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Hugo Mills <hugo@carfax.org.uk>, Jim Maloney <jim@webstarts.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110822212847.GA5412@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Thanks Hugo, I totally missed the fsid's.  That works perfectly.
Jim

On Mon, Aug 22, 2011 at 5:28 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Mon, Aug 22, 2011 at 05:07:45PM -0400, Jim Maloney wrote:
>> I have been experimenting exporting btrfs subvolumes over nfs. =C2=A0=
Main
>> subvolume is filesys1 mounted at /filesys1. =C2=A0Below this is subv=
olume
>> base, user1 is in base and documents is in user1. =C2=A0 documents i=
s
>> mounted at /documents. =C2=A0/etc/exports is:
>> /filesys1/base/user1 =C2=A0 =C2=A0172.16.0.0/24(rw,no_acl,no_root_sq=
uash,fsid=3D0)
>> /filesys1/user1-snapshot =C2=A0 =C2=A0 =C2=A0 =C2=A0172.16.0.0/24(rw=
,no_acl,no_root_squash,fsid=3D0)
>> /documents =C2=A0 =C2=A0 =C2=A0172.16.0.0/24(rw,no_acl,no_root_squas=
h,fsid=3D0)
>
> =C2=A0 I think you need to specify a different fsid for each export.
> That's what I've got here, and it seems to work.
>
> =C2=A0 Hugo.
>
>>
>> On the client machine I mount user1 as /mnt/user and all data from
>> user is present.
>> I can also umount /mnt/usr and mount /documents as /mnt/documents an=
d
>> all data is present.
>> However, if I mount user1 as /mnt/user and then mount /documents as
>> /mnt/documents
>> the data from the last subvolume mounted shows in both mounts. =C2=A0=
Mount
>> also shows:
>> 172.16.0.28:/documents/ on /mnt/user type nfs
>> (rw,relatime,vers=3D3,rsize=3D262144,wsize=3D262144,namlen=3D255,har=
d,proto=3Dtcp,timeo=3D600,retrans=3D2,sec=3Dsys,mountaddr=3D172.16.0.28=
,mountvers=3D3,mountport=3D892,mountproto=3Dudp,local_lock=3Dnone,addr=3D=
172.16.0.28)
>> 172.16.0.28:/documents/ on /mnt/documents type nfs
>> (rw,relatime,vers=3D3,rsize=3D262144,wsize=3D262144,namlen=3D255,har=
d,proto=3Dtcp,timeo=3D600,retrans=3D2,sec=3Dsys,mountaddr=3D172.16.0.28=
,mountvers=3D3,mountport=3D892,mountproto=3Dudp,local_lock=3Dnone,addr=3D=
172.16.0.28)
>>
>> The initial mount of user1 on /mnt/user showed correctly in mount.
>> Mount changes when I add the mount for /documents.
>> I don't know how to troubleshoot this. =C2=A0I am happy to provide a=
ny info
>> which can help.
>> Btrfs is currently on a centOS6 machine running kernel 3.0.1 with
>> btrfs-progs from git unstable.
>> NFS is v3 on both server and client and the client is Fedora 15 kern=
el
>> 2.6.40-4.fc15.x86_64
>> Thanks
>> Jim Maloney
>>
>>
>
> --
> =3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.=
org.uk =3D=3D=3D
> =C2=A0PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.=
org.uk
> =C2=A0 =C2=A0 =C2=A0 --- Someone's been throwing dead sheep down my F=
un Well ---
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.10 (GNU/Linux)
>
> iD8DBQFOUsoPIKyzvlFcI40RAkm1AJ4no85LpWeJEHDQKM+FYmGhyQOnrgCeOYlU
> hdRi30122c6NTzMYX9y2XvY=3D
> =3DnwXm
> -----END PGP SIGNATURE-----
>
>



--=20
Jim Maloney

email - jim@webstarts.com
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
