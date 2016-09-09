Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53963 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751372AbcIID0z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Sep 2016 23:26:55 -0400
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
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <e1d0adbb-922d-0778-a59d-6e6922c2ab68@suse.com>
Date: Thu, 8 Sep 2016 23:25:48 -0400
MIME-Version: 1.0
In-Reply-To: <20160909030836.GA15304@linux-zmni.apac.novell.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="CfWLj2PLBftAjRRoAIHx7hHpBWRttbEUC"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CfWLj2PLBftAjRRoAIHx7hHpBWRttbEUC
Content-Type: multipart/mixed; boundary="LlHLfJMI8Vobh64g8FJr9tnnqaE0iEFpl";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
 Zhao Lei <zhaolei@cn.fujitsu.com>, clm@fb.com, anand.jain@oracle.com,
 Filipe Manana <FdManana@suse.com>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <e1d0adbb-922d-0778-a59d-6e6922c2ab68@suse.com>
Subject: Re: [PATCH] Btrfs: remove unnecessary code of chunk_root assignment
 in btrfs_read_chunk_tree.
References: <1472990010-10707-1-git-send-email-fxinrong@gmail.com>
 <002501d20713$7ee67050$7cb350f0$@cn.fujitsu.com>
 <e48353fc-cd00-789c-291e-80c684afe2e2@cn.fujitsu.com>
 <57CE326C.8000105@suse.com> <57CE3464.7090107@suse.com>
 <20160906095858.GA16983@suse.cz>
 <61eeb5da-c537-2392-74e4-eac77eda6264@suse.com>
 <20160909030836.GA15304@linux-zmni.apac.novell.com>
In-Reply-To: <20160909030836.GA15304@linux-zmni.apac.novell.com>

--LlHLfJMI8Vobh64g8FJr9tnnqaE0iEFpl
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/8/16 11:08 PM, Sean Fu wrote:
> On Tue, Sep 06, 2016 at 11:12:20AM -0400, Jeff Mahoney wrote:
>> On 9/6/16 5:58 AM, David Sterba wrote:
>>> On Mon, Sep 05, 2016 at 11:13:40PM -0400, Jeff Mahoney wrote:
>>>>>> Since root is only used to get fs_info->chunk_root, why not use fs=
_info
>>>>>> directly?
>>>>>
>>>>> Weird.  Exactly this was a part of my fs_info patchset.  I guess I =
need
>>>>> to go back and check what else is missing.
>>>>
>>>> Actually, most of this didn't land.  Pretty much anything that's a r=
oot
>>>> ->fs_info conversion is in there.
>>>
>>> Only half of the patchset has been merged so far because it did not p=
ass
>>> testing, so I bisected to some point. I was about to let you know onc=
e
>>> most of 4.9 patches are prepared so there are less merge conflicts.
>>
>> Ok, thanks.  I was going to start the rebase today but I'll hold off
>> until you're set for 4.9.
>>
> Hi Jeff, Could you please share your patch? Where can i get it?
> I wanna have a look at it.

Sure, it's the whole series that starts with this commit:
commit 160ceedfd40085cfb1e08305917fcc24cefdad93
Author: Jeff Mahoney <jeffm@suse.com>
Date:   Wed Aug 31 23:55:33 2016 -0400

    btrfs: add dynamic debug support

=2E.. I still need to do clean up some commits that need merging.

https://git.kernel.org/cgit/linux/kernel/git/jeffm/linux-btrfs.git/log/?h=
=3Dbtrfs-testing/kdave/misc-4.9/root-fsinfo-cleanup

-Jeff


> Thanks
>> -Jeff
>>
>> --=20
>> Jeff Mahoney
>> SUSE Labs
>>
>=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Jeff Mahoney
SUSE Labs


--LlHLfJMI8Vobh64g8FJr9tnnqaE0iEFpl--

--CfWLj2PLBftAjRRoAIHx7hHpBWRttbEUC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJX0iu8AAoJEB57S2MheeWybwIP/2krnXA5euKNe23wAUHvCPxo
VOrIxN1QjqQiY+BHZGlhXJQwmoFZIsLXGP6A4az0q6GKRcPGosiNwwFY38xm2bD1
LAooQxP1okAgrDSiq6iGm9BiK2amccD4ayuIhzZeulQ92i9/1SkoEvymMcGfG2jp
6WzvJhHi4Z4/h38D+82DsJdLGhzg6zjebBTXsoFbfvRvng4r3+McedVXMqngMSge
2N29XZRZo4rvriAx8JKsEnfHKFxxvI4iIVylwX7tQwkQrRfjcafJntgpyg7k+SWk
gEmP/Q8yminfer4acLzZ5uRXBVjbOOSeGKR7T2e57IviILbeeHqsnDwqCujxG7nA
cW/6Q1T8UMDRnISY25UCwyXHDinLeSXF8H3t+k+G2RLhuUIiZ6m1fhloLWGEOuV6
8trzOpJr3rxmLvYgSXJztAqb0Z9FDJzMeMOkMT+a6ZK76zBzeQqcRgoqdFpdSxBJ
m3dRAdIEBz+nfdy6Vf3J3iD4K1XFzErWYChE2wXeYiHZ9YqT9NN18fD2wtMIrK/n
SANJFpyvd1qYo25mBOHQc4UWM8QBkPu8ez2appd7GSHR7+JU42t0eM2rK846CCl8
PMpno6Rmdnt9OBUtCHRh15n0OPX+9h0NrExZt+yHk5do4kDNpga/2k/59eexurFl
Q2Apl6/D4SdNVbc7ChBv
=8WWf
-----END PGP SIGNATURE-----

--CfWLj2PLBftAjRRoAIHx7hHpBWRttbEUC--
