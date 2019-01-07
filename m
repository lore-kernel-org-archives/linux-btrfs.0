Return-Path: <SRS0=zk84=PP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2B6AC43387
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Jan 2019 22:40:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B7092147C
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Jan 2019 22:40:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfAGWkY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 7 Jan 2019 17:40:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:36560 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726773AbfAGWkY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 Jan 2019 17:40:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EF8D0AFB5;
        Mon,  7 Jan 2019 22:40:21 +0000 (UTC)
Subject: Re: [COMMAND HANGS] The command 'btrfs subvolume sync -s 2 xyz' can
 hangs.
To:     Giuseppe Della Bianca <giusdbg@gmail.com>
Cc:     linux-btrfs@vger.kernel.org
References: <2543962.HIiRWmuHEy@exnet.gdb.it>
 <2282965.574ZSNQ4d8@exnet.gdb.it>
 <067ee226-4636-4ede-1ce7-2bedcc5b4507@suse.com>
 <2971657.kkKnYu9ILp@exnet.gdb.it>
From:   Jeff Mahoney <jeffm@suse.com>
Message-ID: <1533b054-9d55-e968-74e2-b895de9e35fc@suse.com>
Date:   Mon, 7 Jan 2019 17:40:19 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:64.0)
 Gecko/20100101 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <2971657.kkKnYu9ILp@exnet.gdb.it>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fv1DODBKmZN52buxbULX0BRsy3E0EJ7XP"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fv1DODBKmZN52buxbULX0BRsy3E0EJ7XP
Content-Type: multipart/mixed; boundary="eFNLTPkatM5YyLvJzZwBgLcecQskluh39";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Giuseppe Della Bianca <giusdbg@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <1533b054-9d55-e968-74e2-b895de9e35fc@suse.com>
Subject: Re: [COMMAND HANGS] The command 'btrfs subvolume sync -s 2 xyz' can
 hangs.
References: <2543962.HIiRWmuHEy@exnet.gdb.it>
 <2282965.574ZSNQ4d8@exnet.gdb.it>
 <067ee226-4636-4ede-1ce7-2bedcc5b4507@suse.com>
 <2971657.kkKnYu9ILp@exnet.gdb.it>
In-Reply-To: <2971657.kkKnYu9ILp@exnet.gdb.it>

--eFNLTPkatM5YyLvJzZwBgLcecQskluh39
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 1/5/19 7:30 AM, Giuseppe Della Bianca wrote:
> In data venerd=C3=AC 4 gennaio 2019 21:34:03 CET, Jeff Mahoney ha scrit=
to:
> ]zac[
>>>
>>> root     17133 17127  0 17:17 ?        00:00:00 btrfs subvolume sync =
-s 2
>>> /
>>> tmp/tmp.p9SiQ1GnpV
>>>
>>> cat /proc/17133/stack
>>> [<0>] hrtimer_nanosleep+0xce/0x1e0
>>> [<0>] __x64_sys_nanosleep+0x77/0xa0
>>> [<0>] do_syscall_64+0x5b/0x160
>>> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>> [<0>] 0xffffffffffffffff
>>
>> Ok, so this is it just sleeping between tree searches.
> ]zac[
>> This part is actually important since we see below that we're searchin=
g
>> for bytenr 76428623872 which, if present, would be in the cut portion =
of
>> your log.
> ]zac[
>=20
> If you want, I can send you the full log (very long).
> From what you wrote below it seems to me that you do not need it

Please do.  It would be good to see what the state of the extent tree is
there.

> ]zac]
>>
>> This is the more important part.  The file system has gone read-only d=
ue
>> to a missing extent backref.  This is corruption.
>=20
> Yes, but this is an autocorruption of btrfs, which occurred (it seems t=
o me),=20
> during a cleanup after a deleting of a snapshoot of an operating system=
=20
> installation (perhaps interrupted by an umount).
>=20
>> It also means that the subvolume is never going to disappear during th=
is
>> mount and 'btrfs subvol sync' will wait forever.
> ]zac[
>=20
> In my opinion this is bad.

Agreed.  I was describing what the situation is, not how it should be.

> The infinite wait occurs during the execution of a backup script, so I =
will=20
> have to find a bypass even for this problem (the sync was a patch to an=
other=20
> autocorruption problem).

It's something that needs fixing.  The question is how to go about that.
 My first take on it is to have that loop also check whether the file
system is read-only.  That will cover the file system being taken
read-only due to failure, but is also general enough that it'll cover
the case where it can't possibly succeed.  For example, if the file
system is mounted read-only intentionally.

-Jeff
--=20
Jeff Mahoney
SUSE Labs



--eFNLTPkatM5YyLvJzZwBgLcecQskluh39--

--fv1DODBKmZN52buxbULX0BRsy3E0EJ7XP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlwz1VMACgkQHntLYyF5
5bLtJQ//Wf5dbbOj3wd/aFaq7wXHp+0Kwzd15S9elvgjU9Don8vYHKUhr9mtPEnP
jUcGr4AjjYBoobjqjo4aPeRmyQ/LTk3wvC9L+dIduNSQ0K18/4doT7Qqw9kTUXhE
3kZejtLLVhlKJ+PpYigMUMp0hypfF7KEcQXwnMTTBF3TJT3WapLXEHHk9yGD3xJV
4Sr1x+/Fa/38h8z9pkkM+hUgZjuklIRqg8x5MQl6oKh7/WOXaUB25/4MfQQhg89d
nKqMUcnLqCY8T54Sr/naCTEqZXOpH6fyA3etxObxrrYj47rCB9kotA/vNWl0YZAO
fF2dn9yd4qedjP3NsmdA3bIzZq4MuE0+i7uEwXTAivgIS6KVXqgqKaRUlOr5r6NN
2TJoDNudNz1JhgabCBCgOaWokoeU4Imlb7BgRHIAh1Go20xmbrHez2GET5LwpbP2
KNpw1xnTXyNlKksASNn89zGsbllTue/wTszU1Jj+5lKnAvkVAkjH14JKs3VCp2u3
hmRf3jPDhWg4tt4LRPcYn4uZTMp8bF/pNP7R+NEyMEl5U7YpOUgrkDcaum+xxpQK
uSV1+Zh6HsD7FGVDAVr5mOVpQbAeSykEcw1s2W9ALAbonG4M6JQfIFUbQfWYy2cn
FIhzO+43QQviTLpD6sYwHOEdhDdij3u4W5T0XlU/ZkE5e8hZAFo=
=96mn
-----END PGP SIGNATURE-----

--fv1DODBKmZN52buxbULX0BRsy3E0EJ7XP--
