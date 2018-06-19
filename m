Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:36703 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750739AbeFSFDb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Jun 2018 01:03:31 -0400
Subject: Re: About more loose parameter sequence requirement
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <dbd36f90-fb00-0da1-b38f-567575c5b02f@gmx.com>
 <20180618113432.GJ24375@twin.jikos.cz>
 <f746bf72-148d-9fc3-6d0d-c7e07f00c099@gmx.com>
 <20180618120200.GK24375@twin.jikos.cz>
 <c0e6891d-7ec3-87fe-5eb7-ca6178b9ec50@gmx.com>
Message-ID: <e443778a-5e11-25cf-1431-c83feafb9bc7@gmx.com>
Date: Tue, 19 Jun 2018 13:03:23 +0800
MIME-Version: 1.0
In-Reply-To: <c0e6891d-7ec3-87fe-5eb7-ca6178b9ec50@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cdEBYrkP3D7l8IZPy1sVpvYN3zyIgsXyn"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cdEBYrkP3D7l8IZPy1sVpvYN3zyIgsXyn
Content-Type: multipart/mixed; boundary="pl09eIjWaK17M0iORWnLU874VEDgCG6Cu";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, "linux-btrfs@vger.kernel.org"
 <linux-btrfs@vger.kernel.org>
Message-ID: <e443778a-5e11-25cf-1431-c83feafb9bc7@gmx.com>
Subject: Re: About more loose parameter sequence requirement
References: <dbd36f90-fb00-0da1-b38f-567575c5b02f@gmx.com>
 <20180618113432.GJ24375@twin.jikos.cz>
 <f746bf72-148d-9fc3-6d0d-c7e07f00c099@gmx.com>
 <20180618120200.GK24375@twin.jikos.cz>
 <c0e6891d-7ec3-87fe-5eb7-ca6178b9ec50@gmx.com>
In-Reply-To: <c0e6891d-7ec3-87fe-5eb7-ca6178b9ec50@gmx.com>

--pl09eIjWaK17M0iORWnLU874VEDgCG6Cu
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8819=E6=97=A5 12:34, Qu Wenruo wrote:
>=20
>=20
> On 2018=E5=B9=B406=E6=9C=8818=E6=97=A5 20:02, David Sterba wrote:
>> On Mon, Jun 18, 2018 at 07:40:44PM +0800, Qu Wenruo wrote:
>>>
>>>
>>> On 2018=E5=B9=B406=E6=9C=8818=E6=97=A5 19:34, David Sterba wrote:
>>>> On Thu, Jun 14, 2018 at 03:17:45PM +0800, Qu Wenruo wrote:
>>>>> I understand that btrfs-progs introduced restrict parameter/option =
order
>>>>> to distinguish global and sub-command parameter/option.
>>>>>
>>>>> However it's really annoying if one just want to append some new op=
tions
>>>>> to previous command:
>>>>>
>>>>> E.g.
>>>>> # btrfs check /dev/data/btrfs
>>>>> # !! --check-data-csum
>>>>>
>>>>> The last command will fail as current btrfs-progs doesn't allow any=

>>>>> option after parameter.
>>>>>
>>>>>
>>>>> Despite the requirement to distinguish global and subcommand
>>>>> option/parameter, is there any other requirement for such restrict
>>>>> option-first-parameter-last policy?
>>>>
>>>> I'd say that it's a common and recommended pattern. Getopt is able t=
o
>>>> reorder the parameters so mixed options and non-options are accepted=
,
>>>> unless POSIXLY_CORRECT (see man getopt(3)) is not set. With the more=

>>>> strict requirement, 'btrfs' option parser works the same regardless =
of
>>>> that.
>>>
>>> But currently it doesn't work.
>>> Just as the example, btrfs check /dev/data/btrfs --check-data-sum won=
't
>>> work.
>>> It's different from a lot of other common programs.
>>
>> With POSIXLY_CORRECT set, it expectedly won't work. With POSIXLY_CORRE=
CT
>> unset, it would work in general, but not for 'btrfs'.
>>
>> As this is per-application decision I find it ok, besides that I also
>> find the 'options anywhere' pattern bad. Does it really save you that
>> much time while typing the commands with new arguments? There are
>> movement shortcuts to jump by words, you get the previous command by
>> up-arrow. About the same number of keystrokes.
>>
>> New code needs to be tested, documented and maintained, that's the cos=
t
>> I find too high for something that's convenience for people who are us=
ed
>> to some shell builtins.
>>
>=20
> Well, after some testing, the result looks pretty strange on my side.
>=20
> With the testing code (*), mostly just copied from check/main.c, it
> works to detect the final --check-data-csum without problem.
>=20
> I'm originally planning to use '-' to make getopt_long() to keep the
> original order, but the experiment I did shows it unnecessary.
>=20
> And furthermore, even changing the optstring of btrfs check
> getopt_long() with leading '-', it still doesn't work as expected to
> detect non-option parameter.
>=20
> Is there anything wrong/special in btrfs-progs getopt_long() usage?

OK, indeed there is something wrong here.

Just as man page of getopt_long(3) said:
---
NOTES
       A program that scans multiple argument vectors,  or  rescans  the
       same  vector  more than once, and wants to make use of GNU exten=E2=
=80=90
       sions such as '+' and '-' at the start of optstring,  or  changes
       the  value  of  POSIXLY_CORRECT  between scans, must reinitialize
       getopt() by resetting optind to 0, rather  than  the  traditional
       value of 1.  (Resetting to 0 forces the invocation of an internal
       initialization routine that rechecks POSIXLY_CORRECT  and  checks
       for GNU extensions in optstring.)
---

So, "btrfs check /dev/data/btrfs --check-data-csum" should work.

And the bug is, we reset @optind to 1, other than 0 when calling
getopt_long() on the new argc/argv.

I'll fix it soon.

Thanks,
Qu

>=20
> Thanks,
> Qu


--pl09eIjWaK17M0iORWnLU874VEDgCG6Cu--

--cdEBYrkP3D7l8IZPy1sVpvYN3zyIgsXyn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsojpwACgkQwj2R86El
/qhCNwgAmphsazqwg+7G79+3WxRC92Y4b7SpbcTE8WMNqxrONwh1G7rItfvJMlO8
VCkK8zciX8lSZMed1imAFD4F+l5aYg7qcwoAmFYrAN0OUASrNukKLaciGV53Yw4p
2c1dp3TjNjTGvCCeBHg1kQ/zAaJSyf9+SC8V0/NA3bsQMjYj6FXrU5BkYJj8UacG
tuqdq4/Kxcef/0py3BKNmtR8z5oCGxkGbXiWwt0Fd0a1Sw8HY/oBNFvYIWIMjlMY
i4CrA+e2cLc8+hUrQQtPTizGXNjmpEVAK352PefXcEG0GZvF1G/zDspZ2udYZv19
k/njAXkBxi6MFKRPs8u4s40mOXCZgA==
=03li
-----END PGP SIGNATURE-----

--cdEBYrkP3D7l8IZPy1sVpvYN3zyIgsXyn--
