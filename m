Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48295 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751573AbcLEQFQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Dec 2016 11:05:16 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E55EBAAD0
        for <linux-btrfs@vger.kernel.org>; Mon,  5 Dec 2016 15:50:38 +0000 (UTC)
Subject: Re: [PATCH 10/18] btrfs: root->fs_info cleanup,
 btrfs_calc_{trans,trunc}_metadata_size
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1480655258-15400-1-git-send-email-jeffm@suse.com>
 <1480655258-15400-11-git-send-email-jeffm@suse.com>
 <20161205152904.GW12522@twin.jikos.cz>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <b4fd0266-e743-a90a-ac9a-d816a2ef2c61@suse.com>
Date: Mon, 5 Dec 2016 10:50:34 -0500
MIME-Version: 1.0
In-Reply-To: <20161205152904.GW12522@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7jWUdEjE7D92fp8oKbutfvHs7KCxqcvof"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7jWUdEjE7D92fp8oKbutfvHs7KCxqcvof
Content-Type: multipart/mixed; boundary="gtQsR3AgkTl8SuT2nDGwQWH5R2h7jBDdT";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Message-ID: <b4fd0266-e743-a90a-ac9a-d816a2ef2c61@suse.com>
Subject: Re: [PATCH 10/18] btrfs: root->fs_info cleanup,
 btrfs_calc_{trans,trunc}_metadata_size
References: <1480655258-15400-1-git-send-email-jeffm@suse.com>
 <1480655258-15400-11-git-send-email-jeffm@suse.com>
 <20161205152904.GW12522@twin.jikos.cz>
In-Reply-To: <20161205152904.GW12522@twin.jikos.cz>

--gtQsR3AgkTl8SuT2nDGwQWH5R2h7jBDdT
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 12/5/16 10:29 AM, David Sterba wrote:
> On Fri, Dec 02, 2016 at 12:07:30AM -0500, jeffm@suse.com wrote:
>> -static inline u64 btrfs_calc_trans_metadata_size(struct btrfs_root *r=
oot,
>> +static inline u64 btrfs_calc_trans_metadata_size(struct btrfs_fs_info=
 *fs_info,
>>  						 unsigned num_items)
>>  {
>> -	return root->fs_info->nodesize * BTRFS_MAX_LEVEL * 2 * num_items;
>> +	return fs_info->nodesize * BTRFS_MAX_LEVEL * 2 * num_items;
>=20
> Is there a missing patch that moves 'nodesize' to fs_info? The patch ha=
s
> a minor conflict in the original line where it's just 'root->nodesize',=

> but thre are many compilation faiures due to lack of fs_info::nodesize.=


Yeah, it looks like the list dropped it.  It shows up in the thread
posted to me.

I've pushed the series as the for-4.10/misc-4.10 branch in
my repo at git://git.kernel.org/pub/scm/linux/kernel/git/jeffm/linux-btrf=
s.git

It also contains the fix Omar suggested in his review.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--gtQsR3AgkTl8SuT2nDGwQWH5R2h7jBDdT--

--7jWUdEjE7D92fp8oKbutfvHs7KCxqcvof
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJYRYzLAAoJEB57S2MheeWyCMIP/Aiqm1lP7bWlq0RcCltz3Txa
xqbuVbuf+/FwBx6e7pEqOLu8GuAuZoyww9Ns8oaWIrL5+X2X2LWeQkcHRdUu5lcU
oCbAjKMpRJXoq6m7Vhzw7agi+7CSnYm2gB0oPI/M0Lj/maT18/E8/nbSCdkxvdh2
7wTg45gSLdmKULQAaU+GcfX1RTSKlj/Rjul4lKzbIVB8ICdltECHAcrDyegBMckG
hpugWijOfYuovZmpaSrG8ZLFxFkuSvmps5g7b5PcsJnWIhztuzd8swf0tc65wbyg
XZhxSn6jkLlzENM1FyUg18p5+wZISG2oBdQ9tpyyzzbkBtyLypEdFSL10v9LGZ7C
+n2qZgtqqi/TpCD0Oq58pjkF0J7DWePDI+kZPKjdyRsmFNcxJ/qN70prcOY4l3Wh
kHZSzyB9wGt1Xe/75x6k1NpNeKRQgSL9s1E623HpeVqdjg4x4trUetcsMx9ovua2
865uzpdOsGcPGpOrDGya8lf88mOiBcreQvp6hxpWl1xRE83bhiPb4foB0lsCNpo+
5qF8fDjYpcMFdUHUcq9IOg4jWW3J8lDXgeK3aAfK8HUXnByOarb3RFG/6IvG/rHU
UmtA563kzL7857+NEkRE5b06E79FtptKu00kzGn6m3/efBbqjYcFTF10UGaw13DB
U5XUCzbEJq3asceBPeqC
=kBa5
-----END PGP SIGNATURE-----

--7jWUdEjE7D92fp8oKbutfvHs7KCxqcvof--
