Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:58725 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752969AbeGEBhB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Jul 2018 21:37:01 -0400
Subject: Re: [PATCH 0/5] Enhancement for block group/chunk verification
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180703091009.16399-1-wqu@suse.com>
 <20180704133607.GQ3126@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <c80e2352-2edd-bacf-4c22-e51155bca7d4@gmx.com>
Date: Thu, 5 Jul 2018 09:36:47 +0800
MIME-Version: 1.0
In-Reply-To: <20180704133607.GQ3126@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="MgRKTLsGjuMkJWijyS65aPghPZB0flGcz"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MgRKTLsGjuMkJWijyS65aPghPZB0flGcz
Content-Type: multipart/mixed; boundary="rOnvApNjYuaTPggH9RidrIR7KC9ib31Av";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <c80e2352-2edd-bacf-4c22-e51155bca7d4@gmx.com>
Subject: Re: [PATCH 0/5] Enhancement for block group/chunk verification
References: <20180703091009.16399-1-wqu@suse.com>
 <20180704133607.GQ3126@twin.jikos.cz>
In-Reply-To: <20180704133607.GQ3126@twin.jikos.cz>

--rOnvApNjYuaTPggH9RidrIR7KC9ib31Av
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8804=E6=97=A5 21:36, David Sterba wrote:
> On Tue, Jul 03, 2018 at 05:10:04PM +0800, Qu Wenruo wrote:
>> Can be fetched from github, which is based on v4.18-rc1 tag:
>> https://github.com/adam900710/linux/tree/tree_checker_enhance
>>
>> Reported by Xu Wen <wen.xu@gatech.edu>, some crafted btrfs image can
>> cause unexpected kernel behavior.
>>
>> All of them are related to block group and chunk, so this patchset wil=
l
>> enhance block group and chunk verification, so kernel can detect them
>> and error out gracefully (with user friendly error message showing
>> what's going wrong)
>>
>> Obvious corruption (don't need to cross check with chunk/block group),=

>> will be addressed by enhanced tree-checker.
>> (Most crafted images will be caught by tree-checker)
>>
>> More complex corruption will be addressed mostly at
>> btrfs_read_block_groups(), doing extra cross reference check for
>> chunk<->block group mapping.
>> It may cause extra mount time, but compared to the existing time
>> consuming block group items search, all added check is done completely=

>> in memory using rb_tree, so it shouldn't add too much overhead.
>>
>> Qu Wenruo (5):
>>   btrfs: tree-checker: Verify block_group_item
>>   btrfs: tree-checker: Detect invalid empty essential tree
>>   btrfs: relocation: Only remove reloc rb_trees if reloc control has
>>     been initialized
>>   btrfs: Check each block group has corresponding chunk at mount time
>>   btrfs: Verify every chunk has corresponding block group at mount tim=
e
>=20
> Patches 1-3 queued, thanks. 4 and 5 have some comments.

Did I miss the comments for 4 and 5?

I only see some discussion on "Link:" tag.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--rOnvApNjYuaTPggH9RidrIR7KC9ib31Av--

--MgRKTLsGjuMkJWijyS65aPghPZB0flGcz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAls9di8ACgkQwj2R86El
/qgsKgf+Nc8W3NNFbulR1IV7A0+K2tlQOs6O+PzqHzPeMibcU8anXvFX805N3kvh
73Ris7ih9jRRL+U6ubqhCGrRbs0SQK+XdMs4SVPMuGX8cO18ILBP9DfL3NYcXa9C
SVpmTi5741V/FjmMO3rKeANh/mshXhYJc23MoJquv6mGlwXrdxrMLiLkdmCiRjYQ
3W684aSA2ot0MBcHkXknhT1YCpxQ95C2vOvAf6Vd5b8LuY7laEGDQsQpZzsaLCrq
/I4jUwNnL4vX8cep8h/GxI0Zr7lyfI61nEhoJUGHyTAI8dLmIGpE41sR0iP47+8j
Wko95IOhIaaZOSypmQcP46zbvl5CDw==
=oQEX
-----END PGP SIGNATURE-----

--MgRKTLsGjuMkJWijyS65aPghPZB0flGcz--
