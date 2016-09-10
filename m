Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46583 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754821AbcIJQCE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Sep 2016 12:02:04 -0400
Subject: Re: [PATCH] Btrfs: remove unnecessary code of chunk_root assignment
 in btrfs_read_chunk_tree.
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Zhao Lei <zhaolei@cn.fujitsu.com>, clm@fb.com, anand.jain@oracle.com,
        Filipe Manana <FdManana@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1472990010-10707-1-git-send-email-fxinrong@gmail.com>
 <002501d20713$7ee67050$7cb350f0$@cn.fujitsu.com>
 <e48353fc-cd00-789c-291e-80c684afe2e2@cn.fujitsu.com>
 <57CE326C.8000105@suse.com> <57CE3464.7090107@suse.com>
 <20160906095858.GA16983@suse.cz>
 <61eeb5da-c537-2392-74e4-eac77eda6264@suse.com>
 <20160909030836.GA15304@linux-zmni.apac.novell.com>
 <e1d0adbb-922d-0778-a59d-6e6922c2ab68@suse.com>
 <20160910155804.GB5659@linux-zmni.DHCP>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <55120216-6af9-b79d-2bbb-9530ed608ecd@suse.com>
Date: Sat, 10 Sep 2016 12:01:55 -0400
MIME-Version: 1.0
In-Reply-To: <20160910155804.GB5659@linux-zmni.DHCP>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="oF5uUm2IAHOr0m3aB9tJD33Lj2A216SXk"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oF5uUm2IAHOr0m3aB9tJD33Lj2A216SXk
Content-Type: multipart/mixed; boundary="SLbaTdVxEM1TRcT4hVJx4EjBX2wVpkKpl";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
 Zhao Lei <zhaolei@cn.fujitsu.com>, clm@fb.com, anand.jain@oracle.com,
 Filipe Manana <FdManana@suse.com>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <55120216-6af9-b79d-2bbb-9530ed608ecd@suse.com>
Subject: Re: [PATCH] Btrfs: remove unnecessary code of chunk_root assignment
 in btrfs_read_chunk_tree.
References: <1472990010-10707-1-git-send-email-fxinrong@gmail.com>
 <002501d20713$7ee67050$7cb350f0$@cn.fujitsu.com>
 <e48353fc-cd00-789c-291e-80c684afe2e2@cn.fujitsu.com>
 <57CE326C.8000105@suse.com> <57CE3464.7090107@suse.com>
 <20160906095858.GA16983@suse.cz>
 <61eeb5da-c537-2392-74e4-eac77eda6264@suse.com>
 <20160909030836.GA15304@linux-zmni.apac.novell.com>
 <e1d0adbb-922d-0778-a59d-6e6922c2ab68@suse.com>
 <20160910155804.GB5659@linux-zmni.DHCP>
In-Reply-To: <20160910155804.GB5659@linux-zmni.DHCP>

--SLbaTdVxEM1TRcT4hVJx4EjBX2wVpkKpl
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/10/16 11:58 AM, Sean Fu wrote:
> On Thu, Sep 08, 2016 at 11:25:48PM -0400, Jeff Mahoney wrote:
>> On 9/8/16 11:08 PM, Sean Fu wrote:
>>> On Tue, Sep 06, 2016 at 11:12:20AM -0400, Jeff Mahoney wrote:
>>>> On 9/6/16 5:58 AM, David Sterba wrote:
>>>>> On Mon, Sep 05, 2016 at 11:13:40PM -0400, Jeff Mahoney wrote:
>>>>>>>> Since root is only used to get fs_info->chunk_root, why not use =
fs_info
>>>>>>>> directly?
>>>>>>>
>>>>>>> Weird.  Exactly this was a part of my fs_info patchset.  I guess =
I need
>>>>>>> to go back and check what else is missing.
>>>>>>
>>>>>> Actually, most of this didn't land.  Pretty much anything that's a=
 root
>>>>>> ->fs_info conversion is in there.
>>>>>
>>>>> Only half of the patchset has been merged so far because it did not=
 pass
>>>>> testing, so I bisected to some point. I was about to let you know o=
nce
>>>>> most of 4.9 patches are prepared so there are less merge conflicts.=

>>>>
>>>> Ok, thanks.  I was going to start the rebase today but I'll hold off=

>>>> until you're set for 4.9.
>>>>
>>> Hi Jeff, Could you please share your patch? Where can i get it?
>>> I wanna have a look at it.
>>
>> Sure, it's the whole series that starts with this commit:
>> commit 160ceedfd40085cfb1e08305917fcc24cefdad93
>> Author: Jeff Mahoney <jeffm@suse.com>
>> Date:   Wed Aug 31 23:55:33 2016 -0400
>>
>>     btrfs: add dynamic debug support
>>
>> ... I still need to do clean up some commits that need merging.
>>
>> https://git.kernel.org/cgit/linux/kernel/git/jeffm/linux-btrfs.git/log=
/?h=3Dbtrfs-testing/kdave/misc-4.9/root-fsinfo-cleanup
>>
> Nice work. Thanks for your explaination.
> I have one more question about it.
> Although the total text size of this function is not changed, using
> fs_info should need one more instruction to get chunk_root field of
> fs_info than using chunk_root directly.
> Does it cause any performance impact?

I doubt it.  The caller had to do the dereference before.

-Jeff

> Sean
>> -Jeff
>>
>>
>>> Thanks
>>>> -Jeff
>>>>
>>>> --=20
>>>> Jeff Mahoney
>>>> SUSE Labs
>>>>
>>>
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>>
>> --=20
>> Jeff Mahoney
>> SUSE Labs
>>
>=20
>=20
>=20
>=20


--=20
Jeff Mahoney
SUSE Labs


--SLbaTdVxEM1TRcT4hVJx4EjBX2wVpkKpl--

--oF5uUm2IAHOr0m3aB9tJD33Lj2A216SXk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJX1C53AAoJEB57S2MheeWyk14QAJtiFW1PnrsX4mGFtNMhVbwY
5YgpsbiJUziE13DNW8dvIVlVX2CUl38PB59mAVMdQi697ssjNMegjCfJ/hfBO0RH
Cw2YAlpM+Ow5R8PHZDB9Cq/fVc6wMmrbAtxQDGeUhBWoOZ3IoITB3b06k4qMMlXD
f+qWSB7cTauMooehk5PmBodroi38ZymZvzPV46JPSndiPL+tCShTF81H10yHnENf
XhXXcnHYFJ74NLmy48XfI+tkcNyCqS+wpTwnzh4W6eBvYgDGlwf8FFWCtlkIlxU7
GiIJOuOEKlTkt3D7Gw14y6pvCChkYPABJo5Wbahcuz/Nt+VDweoCuqoCxjcHVJq0
UWt+wkQdduTR9KZJIU2pdzqWghPE9KXMbkto45JMGvGlOQb56lyhksE9D3pVud+h
N6PzZQ0aQKSCI3tzKnc7yiDdTlREPWCdw2eZqVsX5XuXNpN9Obc5WMMd+szzul+6
Ysfy9jrXsiDwE9IZbgCYJaUo1WZDCywECFzW3UPcAP8dTlq30zH6EmPBiYcp0oY3
zvBKgQ8EOqFwnD1n8i4oR1URCVD7gPKrX3mkf7nMoP6mBcSksPB+VVuEiJqdaNxz
Z0zDlrFB/GIH48gGNBNInmu61O4ndZ38ifOLi6xziKttjYw4EAAuhJnQu0foe0VO
Fai/3zjHVWWjQlVBeFpB
=XXiU
-----END PGP SIGNATURE-----

--oF5uUm2IAHOr0m3aB9tJD33Lj2A216SXk--
