Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7799CC43387
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 21:18:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 503F520883
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 21:18:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729978AbfAHVSP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 16:18:15 -0500
Received: from mx2.suse.de ([195.135.220.15]:43632 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729688AbfAHVSP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Jan 2019 16:18:15 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A99E1AD5C;
        Tue,  8 Jan 2019 21:18:13 +0000 (UTC)
Subject: Re: [COMMAND HANGS] The command 'btrfs subvolume sync -s 2 xyz' can
 hangs.
To:     Giuseppe Della Bianca <giusdbg@gmail.com>
Cc:     linux-btrfs@vger.kernel.org
References: <2543962.HIiRWmuHEy@exnet.gdb.it>
 <2971657.kkKnYu9ILp@exnet.gdb.it>
 <1533b054-9d55-e968-74e2-b895de9e35fc@suse.com>
 <70326422.XUdVI2pWXa@exnet.gdb.it>
From:   Jeff Mahoney <jeffm@suse.com>
Message-ID: <04891508-41fd-9d63-9dfb-a51041a3b8ea@suse.com>
Date:   Tue, 8 Jan 2019 16:18:11 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:64.0)
 Gecko/20100101 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <70326422.XUdVI2pWXa@exnet.gdb.it>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="LHvFUqVz1oaRGoTy7DvDvsZQ38nfjKwLX"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LHvFUqVz1oaRGoTy7DvDvsZQ38nfjKwLX
Content-Type: multipart/mixed; boundary="59xvuypFUE4DGUKLIiJUGdtkfpQKkdfsa";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Giuseppe Della Bianca <giusdbg@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <04891508-41fd-9d63-9dfb-a51041a3b8ea@suse.com>
Subject: Re: [COMMAND HANGS] The command 'btrfs subvolume sync -s 2 xyz' can
 hangs.
References: <2543962.HIiRWmuHEy@exnet.gdb.it>
 <2971657.kkKnYu9ILp@exnet.gdb.it>
 <1533b054-9d55-e968-74e2-b895de9e35fc@suse.com>
 <70326422.XUdVI2pWXa@exnet.gdb.it>
In-Reply-To: <70326422.XUdVI2pWXa@exnet.gdb.it>

--59xvuypFUE4DGUKLIiJUGdtkfpQKkdfsa
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 1/8/19 4:02 PM, Giuseppe Della Bianca wrote:
> In data luned=C3=AC 7 gennaio 2019 23:40:19 CET, Jeff Mahoney ha scritt=
o:
> ]zac[
>>> If you want, I can send you the full log (very long).
>>> From what you wrote below it seems to me that you do not need it
>>
>> Please do.  It would be good to see what the state of the extent tree =
is
>> there.
>=20
>=20
> -- Logs begin at Sat 2016-11-26 18:16:29 CET, end at Tue 2019-01-08 21:=
39:44=20

Thanks.  As it turns out, since Filipe's identified the fix for this
issue, we don't need it anymore.  If that turns out to be a different
issue, we can revisit the log.

> ]zac[
>>>> It also means that the subvolume is never going to disappear during =
this
>>>> mount and 'btrfs subvol sync' will wait forever.
>>>
>>> ]zac[
>>>
>>> In my opinion this is bad.
>>
>> Agreed.  I was describing what the situation is, not how it should be.=

>=20
> Ok, sorry ( :) ).
>=20
> ]zac[
>> It's something that needs fixing.  The question is how to go about tha=
t.
>>  My first take on it is to have that loop also check whether the file
> ]zac[
>=20
> I don't know how btrfs works inside.
> I just suppose that somewhere in the code an error state is not handled=
=20
> correctly (which can be a file or the whole filesystem not accessible).=


Kind of, if you look at it under the right light.  The sync subcommand
only waits for the lookup for the subvolume undergoing deletion to not
be there anymore.  There's no error state to be passed back to the
waiter, only the initiator.

The command will hang any time a situation arises that the subvolume
won't go away.  That includes:
1) Read-only file system, intentionally
2) Read-only file system as part of a failure
3) Specifying a subvolume that isn't being deleted

The first two mean that the condition can never be met.  The latter is
something of a special case since the user could remove it at any time.

-Jeff
--=20
Jeff Mahoney
SUSE Labs



--59xvuypFUE4DGUKLIiJUGdtkfpQKkdfsa--

--LHvFUqVz1oaRGoTy7DvDvsZQ38nfjKwLX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIyBAEBCAAdFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlw1E5MACgkQHntLYyF5
5bJtWA/46cAcYSqcVpotVccQO210z1dxl5dNrYAC1MTxRtYkVUbElRolhrP1s29r
7oH66IvbPobQZLX54i5BQHGJQ2Ex2plFfp7od96O6f8JzwM9fQb+q1Gqcx1Q7j61
LZ/PvVLvO4An1pbPrL26ZAOSDSipcYUv7p5zpYFz2G3b+S57CAjIC3XNLoVSY0d5
1c6hjDGyh8H8YRzU3R1ijzTQJcRYve7q/DkNe+LWXMAFO5HUgUFyVJfEM6kISfBb
0vRNX6qcY4djpZ2gi1URXwRZ3ZtmXnBGoLYtB2F3CNaOXkkS7N7q6R0O4Yi/x3Er
zJKx+eCCsHvDOv1Q26DbiQ189zIvPzR4T7pvIn+JapXcQWV7Jd4D5djfuuB/pbaZ
PPQ4ITdLdbI/frLLfnjZbuGDf6ZrDMvq1qen/f5urFr7+yvMQz65Qa8XyOUdmKKR
w0QkTnx8hYvMNn/BMEbdszEA/XCfjrxWnvMbxtno8FSiQMjPi9YiHzCMzQkl5rU/
Zw7Is1cCb6XI7UXe2dJZVE8+ZkdE0Rqg1dhJbOyleFXw+a0FB2U5FRdqrWXEG7M1
0WlJ0mdfH0+ILY1jXKqVhkXBaZ+wF27gZwZHCrEVfdsM2lSFWaqjgkluzMf9XcA/
jEX9eqPwtRYQOkfXq4Dnrha73lpbpr+y1oB3rMElutjTcTVJLQ==
=CH55
-----END PGP SIGNATURE-----

--LHvFUqVz1oaRGoTy7DvDvsZQ38nfjKwLX--
