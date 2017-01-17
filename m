Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail6.webfaction.com ([74.55.86.74]:39788 "EHLO
        smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751115AbdAQU0H (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jan 2017 15:26:07 -0500
From: Christoph Groth <christoph@grothesque.org>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Unocorrectable errors with RAID1
References: <87o9z7dzvd.fsf@grothesque.org>
        <42eaf69b-c444-fc50-2128-3a1fbd18b335@suse.de>
        <871sw2cbzb.fsf@grothesque.org>
        <6f5ba97f-0c13-4ad1-fda3-a10db7024ef7@suse.de>
Date: Tue, 17 Jan 2017 21:25:28 +0100
In-Reply-To: <6f5ba97f-0c13-4ad1-fda3-a10db7024ef7@suse.de> (Goldwyn
        Rodrigues's message of "Tue, 17 Jan 2017 05:32:44 -0600")
Message-ID: <87lgu9cu2v.fsf@grothesque.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--=-=-=
Content-Type: text/plain; format=flowed

Goldwyn Rodrigues wrote:
> On 01/17/2017 02:44 AM, Christoph Groth wrote:
>> Goldwyn Rodrigues wrote:
>> 
>>> Would you be able to upload a btrfs-image for me to 
>>> examine. This is a
>>> core ctree error where most probably item size is incorrectly 
>>> registered.
>> 
>> Sure, I can do that.  I'd like to use the -s option, will this 
>> be fine? 
>
> Yes, I think that should be fine.

Unfortunately, giving -s causes btrfs-image to segfault.  I tried 
both btrfs-progs 4.7.3 and 4.4.  I also tried different 
compression levels.

Without -s it works, but since this file system contains the 
complete digital life of our family, I would rather not share even 
the file names.

Any ideas on what could be done?  If you need help to debug the 
problem with btrfs-image, please tell me what I should do.  I can 
keep the broken file system around until an image can be created 
at some later time.

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEUimQV/rXmWU8TwiKw/FH9ZgPNTUFAlh+fbgACgkQw/FH9ZgP
NTWyTA/+Ms11j0/3Ts6k0gN6/b9RXPymm815Bjz2t+OJuXpRFyuSU66Pw06sveLz
I1S71O0qVpDupAZ/n5wZNg8HaErZip3uNmfuDq2sIdAv3turXfr9h9wJt7RzQ7TC
HPThvK5OIt44wIxkRjsi4Jq/mPkxyanwqBezivCf4NLpPcUux7xbMvCNTsL6Fo6f
49j8GiDLrgaOeqb/0fw4w0VlSFU3yLx8mvTxGNeyOQ3RCeSIPkZr9znq5JEWpRZs
v+UDadniLMWHp41j6eAikSJGk9Y2R9irsBmX7qn8FdaND2cAv0cF+cp/xpE0jj4G
srYSkqSGjl4GknR1mxnLSi6Pl/g1kVTl2OxGVQ4jbyD7uzhs2Sm/uqQZZRSqP9cv
E3dsD1Dj6jaUhuTd+sNjWprVlXgsC4Wlf3n7XsSE4Oi4SjPak5cQeXQ37I2XGqr1
hxMliC38SKwZHEpIfMBpIIWmSNQ4dUCDk40ATQzQtrXfODBonr4hMpZ01U2DG7Pf
+ZS8EUtIlbc9pNSSozMpRcahW2ZXejTN9QdbneL9eMyPxJOmwEgsPcZ7bh2Mi7ov
SzMvg0eAPl22PuZ8nV0fnbjiYYjaVzodN6AJ/GoEOGo/zK67nJF/njQdyTrmc/KQ
51fFAbuO437MUy/5vGOI/c8ZzjFwE7OnDpZwKHjrXQgynOtF1T0=
=4XNT
-----END PGP SIGNATURE-----
--=-=-=--
