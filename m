Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:36619 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751917AbeBXChv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Feb 2018 21:37:51 -0500
Subject: Re: [RFC PATCH] btrfs: Speedup btrfs_read_block_groups()
To: "Ellis H. Wilson III" <ellisw@panasas.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <20180222045215.16426-1-wqu@suse.com>
 <c85baf37-d030-1718-1ee8-c64d2f031101@gmx.com>
 <59c448b6-cc46-da82-a0bf-3b64d1a79081@panasas.com>
 <24fd39fb-459b-b562-1ff6-9324462a448b@gmx.com>
 <98d70452-a643-b0e6-5372-c524b9bf2ff0@panasas.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <b042f74b-8e98-29f5-9978-9c693784a9a4@gmx.com>
Date: Sat, 24 Feb 2018 10:37:28 +0800
MIME-Version: 1.0
In-Reply-To: <98d70452-a643-b0e6-5372-c524b9bf2ff0@panasas.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="S5wfF1jKeksFzn8NJdbHDLP7GJJfpjx5T"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--S5wfF1jKeksFzn8NJdbHDLP7GJJfpjx5T
Content-Type: multipart/mixed; boundary="121Yjhr36Gjz64xgLfDoEMB1dDLGyqvd6";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Ellis H. Wilson III" <ellisw@panasas.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org, dsterba@suse.cz
Message-ID: <b042f74b-8e98-29f5-9978-9c693784a9a4@gmx.com>
Subject: Re: [RFC PATCH] btrfs: Speedup btrfs_read_block_groups()
References: <20180222045215.16426-1-wqu@suse.com>
 <c85baf37-d030-1718-1ee8-c64d2f031101@gmx.com>
 <59c448b6-cc46-da82-a0bf-3b64d1a79081@panasas.com>
 <24fd39fb-459b-b562-1ff6-9324462a448b@gmx.com>
 <98d70452-a643-b0e6-5372-c524b9bf2ff0@panasas.com>
In-Reply-To: <98d70452-a643-b0e6-5372-c524b9bf2ff0@panasas.com>

--121Yjhr36Gjz64xgLfDoEMB1dDLGyqvd6
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8824=E6=97=A5 00:29, Ellis H. Wilson III wrote:
> On 02/22/2018 06:37 PM, Qu Wenruo wrote:
>> On 2018=E5=B9=B402=E6=9C=8823=E6=97=A5 00:31, Ellis H. Wilson III wrot=
e:
>>> On 02/21/2018 11:56 PM, Qu Wenruo wrote:
>>>> On 2018=E5=B9=B402=E6=9C=8822=E6=97=A5 12:52, Qu Wenruo wrote:
>>>>> btrfs_read_block_groups() is used to build up the block group cache=

>>>>> for
>>>>> all block groups, so it will iterate all block group items in exten=
t
>>>>> tree.
>>>>>
>>>>> For large filesystem (TB level), it will search for BLOCK_GROUP_ITE=
M
>>>>> thousands times, which is the most time consuming part of mounting
>>>>> btrfs.
>>>>>
>>>>> So this patch will try to speed it up by:
>>>>>
>>>>> 1) Avoid unnecessary readahead
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 We were using READA_FORWARD to search for =
block group item.
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 However block group items are in fact scat=
tered across quite a
>>>>> lot of
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 leaves. Doing readahead will just waste ou=
r IO (especially
>>>>> important
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 for HDD).
>>>>>
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 In real world case, for a filesystem with =
3T used space, it would
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 have about 50K extent tree leaves, but onl=
y have 3K block group
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 items. Meaning we need to iterate 16 leave=
s to meet one block
>>>>> group
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 on average.
>>>>>
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 So readahead won't help but waste slow HDD=
 seeks.
>>>>>
>>>>> 2) Use chunk mapping to locate block group items
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 Since one block group item always has one =
corresponding chunk
>>>>> item,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 we could use chunk mapping to get the bloc=
k group item size.
>>>>>
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 With block group item size, we can do a pi=
npoint tree search,
>>>>> instead
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 of searching with some uncertain value and=
 do forward search.
>>>>>
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 In some case, like next BLOCK_GROUP_ITEM i=
s in the next leaf of
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 current path, we could save such unnecessa=
ry tree block read.
>>>>>
>>>>> Cc: Ellis H. Wilson III <ellisw@panasas.com>
>>>>
>>>> Hi Ellis,
>>>>
>>>> Would you please try this patch to see if it helps to speedup the mo=
unt
>>>> of your large filesystem?
>>>
>>> I will try either tomorrow or over the weekend.=C2=A0 I'm waiting on =
hardware
>>> to be able to build and load a custom kernel on.
>>
>> If you're using Archlinux, I could build the package for you.
>>
>> (For other distributions, unfortunately I'm not that familiar with)
>>
>> Thanks,
>> Qu
>=20
> No sweat.=C2=A0 I'm not running arch anywhere, so was glad to handle th=
is
> myself.
>=20
> Short story: It doesn't appear to have any notable impact on mount time=
=2E
>=20
> Long story:
> #Built a modern kernel:
> git clone https://github.com/kdave/btrfs-devel
> cd'd into btrfs-devel
> copied my current kernel config in /boot to .config
> make olddefconfig
> make -j16
> make modules_install
> make install
> grub2-mkconfig -o /boot/grub/grub.cfg
> reboot
>=20
> #Reran tests with vanilla 4.16.0-rc1+ kernel
> As root, of the form: time mount /dev/sdb /mnt/btrfs
> 5 iteration average: 16.869s
>=20
> #Applied your patch, rebuild, switched kernel module
> wget -O - 'https://patchwork.kernel.org/patch/10234619/mbox' | git am -=

> make -j16
> make modules_install
> rmmod btrfs
> modprobe btrfs
>=20
> #Reran tests with patched 4.16.0-rc1+ kernel
> As root, of the form: time mount /dev/sdb /mnt/btrfs
> 5 iteration average: 16.642s
>=20
> So, there's a slight improvement against vanilla 4.16.0-rc1+, but it's
> still slightly slower than my original runs in 4.5.5, which got me
> 16.553s.=C2=A0 In any event, most of this is statistically unsignifican=
t
> since the standard deviation is about two tenths of a second.

Yep, I also saw guys with similar report when the first version is sent.

Despite of the readahead things, the patch can only reduce disk reads
where block group items are located at the 1st slot of a leaf.

If all block group items are located from the 2nd slot of leaves, then
it shouldn't have much affect.
And I think your fs is already in such states so it doesn't have much
speedup.

BTW, you could also verify this by btrfs-debug-tree.

To get all block group items number:
# btrfs-debug-tree -t extent <device> | grep BLOCK_GROUP_ITEM | grep
item | nc -l

To get block group items which locates at 1st slot:
# btrfs-debug-tree -t extent <device> | grep BLOCK_GROUP_ITEM | grep
"item 0" | nc -l

And the ratio should imply how effective the patch will speedup.

>
> So, my conclusion here is this problem needs to be handled at an
> architectural level to be truly solved (read: have mounts that few
> seconds at worst), which either requires:
> a) On-disk format changes like you (Qu) suggested some time back for a
> tree of block groups or
> b) Lazy block group walking post-mount and algorithms that can cope wit=
h
> making sub-optimal choices.=C2=A0 One would likely want to stonewall ou=
t
> certain operations until the lazy post-mount walk completed like
> balance, defrag, etc, that have more reason to require complete
> knowledge of the usage of each block group.
>=20
> I may take a stab at b), but I'm first going to do the tests I promised=

> relating to how mount times scale with increased capacity consumption
> for varying filesizes.

Along with above ratio and the mount time difference would also help.

Thanks,
Qu

>=20
> Best,
>=20
> ellis


--121Yjhr36Gjz64xgLfDoEMB1dDLGyqvd6--

--S5wfF1jKeksFzn8NJdbHDLP7GJJfpjx5T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqQz+gXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhWnAf9Eq86PKdQqWwsxU46lZ/+x7cy
GnBQocTcGu6H6gd/0OsOhlgMLCA5MnnYLL511MVUiLR6i9tNXbjX01ZCb6T0WTH8
qC1ykcbTtnCmnnti+rqXORbs27aL+0/c5/s6EOizOh9IetgvWnxW5+1LPhbkLCM7
nyfVRJTNWNtW0xfL1fHB19eC/KEsk8Ju68IajWIpnngFVprDbCB7P78fZi17HQgU
+pMhzOzmKP5cPz0BaPBHnQliKtCVa54Nkyr/JLM+5WGeoC72zQraoUhLfW+oGG/D
i0Ufc8fLZWexBGODKONXD89UAuLDgMcx6eKjI9zdPyFOY763sHn82ah0ZAmN+g==
=UN65
-----END PGP SIGNATURE-----

--S5wfF1jKeksFzn8NJdbHDLP7GJJfpjx5T--
