Return-Path: <SRS0=Zicy=M3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B821AC04AA5
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 14:30:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7844F20644
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 14:30:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7844F20644
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=carfax.org.uk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbeJOWPu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Oct 2018 18:15:50 -0400
Received: from frost.carfax.org.uk ([85.119.82.111]:54961 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726571AbeJOWPu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Oct 2018 18:15:50 -0400
Received: from hrm by frost.carfax.org.uk with local (Exim 4.80)
        (envelope-from <hrm@carfax.org.uk>)
        id 1gC3sv-0002Jl-80; Mon, 15 Oct 2018 14:30:17 +0000
Date:   Mon, 15 Oct 2018 14:30:17 +0000
From:   Hugo Mills <hugo@carfax.org.uk>
To:     Anton Shepelev <anton.txt@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Interpreting `btrfs filesystem show'
Message-ID: <20181015143017.GE9538@carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo@carfax.org.uk>,
        Anton Shepelev <anton.txt@gmail.com>, linux-btrfs@vger.kernel.org
References: <20181015172408.1b3867debea3951fb7014ee4@gmail.com>
 <20181015142641.GD9538@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="C94crkcyjafcjHxo"
Content-Disposition: inline
In-Reply-To: <20181015142641.GD9538@carfax.org.uk>
X-GPG-Fingerprint: DD84 D558 9D81 DDEE 930D  2054 585E 1475 E2AB 1DE4
X-GPG-Key: E2AB1DE4
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--C94crkcyjafcjHxo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 15, 2018 at 02:26:41PM +0000, Hugo Mills wrote:
> On Mon, Oct 15, 2018 at 05:24:08PM +0300, Anton Shepelev wrote:
> > Hello, all
> > 
> > While trying to resolve free space problems, and found that
> > I cannot interpret the output of:
> > 
> > > btrfs filesystem show
> > 
> > Label: none  uuid: 8971ce5b-71d9-4e46-ab25-ca37485784c8
> >         Total devices 1 FS bytes used 34.06GiB
> >         devid    1 size 40.00GiB used 37.82GiB path /dev/sda2
> > 
> > How come the total used value is less than the value listed
> > for the only device?
> 
>    "Used" on the device is the mount of space allocated. "Used" on the

s/mount/amount/

> FS is the total amount of actual data and metadata in that allocation.
> 
>    You will also need to look at the output of "btrfs fi df" to see
> the breakdown of the 37.82 GiB into data, metadata and currently
> unused.
> 
>    See https://btrfs.wiki.kernel.org/index.php/FAQ#Understanding_free_space.2C_using_the_original_tools for the details.
> 
>    Hugo.
> 

-- 
Hugo Mills             | "Your problem is that you have a negative
hugo@... carfax.org.uk | personality."
http://carfax.org.uk/  | "No, I don't!"
PGP: E2AB1DE4          |                              Londo and Vir, Babylon 5

--C94crkcyjafcjHxo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJbxKR4AAoJEFheFHXiqx3kJ40P/idcan3L9jX/S6I4YxZkJENn
rvJ2tddpKR7beLeEmb5uzjH1weqbkI9MWUvl+k2WvvxEDhPd4TJcGeAmCja6H3HA
zfE3c5AahWFdTS0vfaeq85UBUVdIWkLRbZui+O0idsu4JncbhtpWAOXwLx6h4ngl
MDtc+L+QAbQ/1ssOIqSECNi/0GNWFJyuMFdF3d1N2Rp4WDaarFdj1YmbqzxjX4lS
m7Ch76zDsPcIXhu3woI5FhgY5IKZ8054smmVpZEh2XTm34NsJW8dc+7l3ymWTtSw
2vRZEX6GtlFYi7nIBfUMxAT2+LkCCFhBqZMT3mkW6pLfVR+FQW3v1C9z38kmSUTi
PYDeZJH9f/uv6Acjv9hRveNFCUuznsS1UhMVs+nY3xrIAyat5goNbve7FhQ210xP
y41hiPX98dCh7MhVyhK34TTqAJSwp1rldzcnHTeHAEoec0BKt+Xr3pQkIoaiuTHO
ioU8nR/hYe1RR750Zhav7tViUg3rKR2W3bUGvhAeNWYxMCwKB4D9Vxp3TgGXvZG7
Lzpmk0FRYHY1/fJIkclMxWp+/x3idpPEe7COj6H7/51fHh5RpHjG+ZFgqq+dhJxd
hzYDA2eJC7N7zfbKc+cAmVXCKqxeRq7lmmwW8lwTn/IPlTkQc4CIXpEZVoizPy2W
cr4ZkKz6yFsjjvl0bSLy
=U7c+
-----END PGP SIGNATURE-----

--C94crkcyjafcjHxo--
