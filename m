Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.3.12.4.46.clients.your-server.de ([46.4.12.3]:54386 "EHLO
	mx.mokrynskyi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752254AbcBVTje (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Feb 2016 14:39:34 -0500
Received: from localhost (localhost [127.0.0.1])
	by mx.mokrynskyi.com (Postfix) with ESMTP id 51C9D71DE
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Feb 2016 19:39:33 +0000 (UTC)
Received: from mx.mokrynskyi.com ([127.0.0.1])
	by localhost (mx.mokrynskyi.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4U7LL_r2_GGD for <linux-btrfs@vger.kernel.org>;
	Mon, 22 Feb 2016 19:39:32 +0000 (UTC)
Received: from [10.8.0.6] (unknown [91.234.34.231])
	by mx.mokrynskyi.com (Postfix) with ESMTPSA id 55BE971DD
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Feb 2016 19:39:31 +0000 (UTC)
To: linux-btrfs@vger.kernel.org
From: Nazar Mokrynskyi <nazar@mokrynskyi.com>
Subject: Re: Major HDD performance degradation on btrfs receive
Message-ID: <9cc4652e-5991-8a92-bf9b-d2771c176ca3@mokrynskyi.com>
Date: Mon, 22 Feb 2016 20:39:29 +0100
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms050704010803070701040207"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms050704010803070701040207
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

> > I have 2 SSD with BTRFS filesystem (RAID) on them and several
> > subvolumes. Each 15 minutes I'm creating read-only snapshot of
> > subvolumes /root, /home and /web inside /backup.
> > After this I'm searching for last common subvolume on /backup_hdd,
> > sending difference between latest common snapshot and simply latest
> > snapshot to /backup_hdd.
> > On top of all above there is snapshots rotation, so that /backup
> > contains much less snapshots than /backup_hdd.
> One thing thing that you imply, but don't actually make explicit except=

> in the btrfs command output and mount options listing, is that /backup_=
hdd
> is a mountpoint for a second entirely independent btrfs (LABEL=3DBackup=
),
> while /backup is a subvolume on the primary / btrfs.  Knowing that is
> quite helpful in figuring out exactly what you're doing. =3D:^)
>
> Further, implied, but not explicit since some folks use hdd when
> referring to ssds as well, is that the /backup_hdd hdd is spinning rust=
,
> tho you do make it explicit that the primary btrfs is on ssds.
>
> > I'm using this setup for last 7 months or so and this is luckily the
> > longest period when I had no problems with BTRFS at all.
> > However, last 2+ months btrfs receive command loads HDD so much that =
I
> > can't even get list of directories in it.
> > This happens even if diff between snapshots is really small.
> > HDD contains 2 filesystems - mentioned BTRFS and ext4 for other files=
,
> > so I can't even play mp3 file from ext4 filesystem while btrfs receiv=
e
> > is running.
> > Since I'm running everything each 15 minutes this is a real headache.=

>
> The *big* question is how many snapshots you have on LABEL=3DBackup, si=
nce
> you mention rotating backups in /backup, but don't mention rotating/
> thinning backups on LABEL=3DBackup, and do explicitly state that it has=
 far
> more snapshots, and with four snapshots an hour, they'll build up rathe=
r
> fast if you aren't thinning them.
>
> The rest of this post assumes that's the issue, since you didn't mentio=
n
> thinning out the snapshots on LABEL=3DBackup.  If you're already famili=
ar
> with the snapshot scaling issue and snapshot caps and thinning
> recommendations regularly posted here, feel free to skip the below as
> it'll simply be review. =3D:^)
>
> Btrfs has scaling issues when there's too many snapshots.  The
> recommendation I've been using is a target of no more than 250 snapshot=
s
> per subvolume, with a target of no more than eight subvolumes and ideal=
ly
> no more than four subvolumes being snapshotted per filesystem, which
> doing the math leads to an overall filesystem target snapshot cap of
> 1000-2000, and definitely no more than 3000, tho by that point the
> scaling issues are beginning to kick in and you'll feel it in lost
> performance, particularly on spinning rust, when doing btrfs maintenanc=
e
> such as snapshotting, send/receive, balance, check, etc.
>
> Unfortunately, many people post here complaining about performance issu=
es
> when they're running 10K+ or even 100K+ snapshots per filesystem and th=
e
> various btrfs maintenance commands have almost ground to a halt. =3D:^(=

>
> You say you're snapshotting three subvolumes, / /home and /web, at 15
> minute intervals.  That's 3*4=3D12 snapshots per hour, 12*24=3D288 snap=
shots
> per day.  If all those are on LABEL=3DBackup, you're hitting the 250
> snapshots per subvolume target in 250/4/24 =3D ... just over 2 and a ha=
lf
> days.  And you're hitting the total per-filesystem snapshots target cap=

> in 2000/288=3D ... just under seven days.
>
> If you've been doing that for 7 months with no thinning, that's
> 7*30*288=3D ... over 60K snapshots!  No *WONDER* you're seeing performa=
nce
> issues!
>
> Meanwhile, say you need a file from a snapshot from six months ago.  Ar=
e
> you *REALLY* going to care, or even _know_, exactly what 15 minute
> snapshot it was?  And even if you do, just digging thru 60K+ snapshots.=
=2E.
> OK, so we'll assume you sort them by snapshotted subvolume so only have=

> to dig thru 20K+ snapshots... just digging thru 20K snapshots to find t=
he
> exact 15-minute snapshot you need... is quite a bit of work!
>
> Instead, suppose you have a "reasonable" thinning program.  First, do y=
ou
> really need _FOUR_ snapshots an hour to LABEL=3DBackup?  Say you make i=
t
> every 20 minutes, three an hour instead of four.  That already kills a
> third of them.  Then, say you take them every 15 or 20 minutes, but onl=
y
> send one per hour to LABEL=3DBackup.  (Or if you want, do them every 15=

> minutes and send only ever other one, half-hourly to LABEL=3DBackup.  T=
he
> point is to keep it both something you're comfortable with but also mor=
e
> reasonable.)
>
> For illustration, I'll say you send once an hour.  That's 3*24=3D72
> snapshots per day, 24/day per subvolume, already a great improvement ov=
er
> the 96/day/subvolume and 288/day total you're doing now.
>
> If then once a day, you thin down the third day back to every other hou=
r,
> you'll have 2-3 days worth of hourly snapshots on LABEL=3Dbackup, so up=
to
> 72 hourly snapshots per subvolume.  If on the 8th day you thin down to
> six-hourly, 4/day, cutting out 2/3, you'll have five days of 12/day/
> subvolume, 60 snapshots per subvolume, plus the 72, 132 snapshots per
> subvolume total, to 8 days out so you can recover over a week's worth a=
t
> at least 2-hourly, if needed.
>
> If then on the 32 day (giving you a month's worth of at least 4X/day),
> you cut every other one, giving you twice a day snapshots, that's 24 da=
ys
> of 2X/day or 48 snapshots per subvolume, plus the 132 from before, 180
> snapshots per subvolume total, now.
>
> If then on the 92 day (giving you two more months of 2X/day, a quarter'=
s
> worth of at least 2X/day) you again thin every other one, to one per da=
y,
> you have 60 days @ 2X/day or 120 snapshots per subvolume, plus the 180 =
we
> had already, 300 snapshots per subvolume, now.
>
> OK, so we're already over our target 250/subvolume, so we could thin a
> bit more drastically.  However, we're only snapshotting three subvolume=
s,
> so we can afford a bit of lenience on the per-subvolume cap as that's
> assuming 4-8 snapshotted subvolumes, and we're still well under our tot=
al
> filesystem snapshot cap.
>
> If then you keep another quarter's worth of daily snapshots, out to 183=

> days, that's 91 days of daily snapshots, 91 per subvolume, on top of th=
e
> 300 we had, so now 391 snapshots per subvolume.
>
> If you then thin to weekly snapshots, cutting 6/7, and keep them around=

> another 27 weeks (just over half a year, thus over a year total), that'=
s
> 27 more snapshots per subvolume, plus the 391 we had, 418 snapshots per=

> subvolume total.
>
> 418 snapshots per subvolume total, starting at 3-4X per hour to /backup=

> and hourly to LABEL=3DBackup, thinning down gradually to weekly after s=
ix
> months and keeping that for the rest of the year.  Given that you're
> snapshotting three subvolumes, that's 1254 snapshots total, still well
> within the 1000-2000 total snapshots per filesystem target cap.
>
> During that year, if the data is worth it, you should have done an offs=
ite
> or at least offline backup, we'll say quarterly.  After that, keeping t=
he
> local online backup around is merely for convenience, and with quarterl=
y
> backups, after a year you have multiple copies and can simply delete th=
e
> year-old snapshots, one a week, probably at the same time you thin down=

> the six-month-old daily snapshots to weekly.
>
> Compare that just over 1200 snapshots to the 60K+ snapshots you may hav=
e
> now, knowing that scaling over 10K snapshots is an issue particularly o=
n
> spinning rust, and you should be able to appreciate the difference it's=

> likely to make. =3D:^)
>
> But at the same time, in practice it'll probably be much easier to
> actually retrieve something from a snapshot a few months old, because y=
ou
> won't have tens of thousands of effectively useless snapshots to sort
> thru as you will be regularly thinning them down! =3D:^)
>
> > ~> uname [-r]
> > 4.5.0-rc4-haswell
> >
> > ~> btrfs --version
> > btrfs-progs v4.4
>
> You're staying current with your btrfs versions.  Kudos on that! =3D:^)=

>
> And on including btrfs fi show and btrfs fi df, as they were useful, th=
o
> I'm snipping them here.
>
> One more tip.  Btrfs quotas are known to have scaling issues as well.  =
If
> you're using them, they'll exacerbate the problem.  And while I'm not
> sure about current 4.4 status, thru 4.3 at least, they were buggy and n=
ot
> reliable anyway.  So the recommendation is to leave quotas off on btrfs=
,
> and use some other more mature filesystem where they're known to work
> reliably if you really need them.
>
> --=20
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
First of all, sorry for delay, for whatever reason was not subscribed to =

mailing list.

You are right, RAID is on 2 SSDs and backup_hdd (LABEL=3DBackup) is=20
separate really HDD.

Example was simplified to give an overview to not dig too deep into=20
details. I actually have correct backups rotation, so we are not talking =

about thousands of snapshots:)
Here is tool I've created and using right now:=20
https://github.com/nazar-pc/just-backup-btrfs
I'm keeping all snapshots for last day, up to 90 for last month and up=20
to 48 throughout the year.
So as result there are:
* 166 snapshots in /backup_hdd/root
* 166 snapshots in /backup_hdd/home
* 159 snapshots in /backup_hdd/web

I'm not using quotas, there is nothing on this BTRFS partition besides=20
mentioned snapshots.

--=20
Sincerely, Nazar Mokrynskyi
github.com/nazar-pc
Skype: nazar-pc
Diaspora: nazarpc@diaspora.mokrynskyi.com
Tox: A9D95C9AA5F7A3ED75D83D0292E22ACE84BA40E912185939414475AF28FD2B2A5C8E=
F5261249



--------------ms050704010803070701040207
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: ÐÑÑÐ¿ÑÐ¾Ð³ÑÐ°ÑÑÑÐ½Ð¸Ð¹ Ð¿ÑÐ´Ð¿Ð¸Ñ S/MIME

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
CuMwggT5MIID4aADAgECAhBk6v6TVth6hqLyl5xsFf+NMA0GCSqGSIb3DQEBCwUAMHUxCzAJ
BgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSkwJwYDVQQLEyBTdGFydENvbSBD
ZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMaU3RhcnRDb20gQ2xhc3MgMSBDbGll
bnQgQ0EwHhcNMTUxMjIyMDYwNTUxWhcNMTYxMjIyMDYwNTUxWjBEMR0wGwYDVQQDDBRuYXph
ckBtb2tyeW5za3lpLmNvbTEjMCEGCSqGSIb3DQEJARYUbmF6YXJAbW9rcnluc2t5aS5jb20w
ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCugsLCcazI+Sjl29kaCHer/z6I0aPy
cKYqk4Bk0jUE6CcfQLX98E8b1sc2kbBjwd+jPPvWtqSGHzLUKLL1jfXJC6X5At+UHNdWiU6n
xaKnCiWiV0NZK6AVfrr+KdP+f1gYfMryPp/JkzcRDquML+YSz0BJ3ODaU538lDtC2sPeH7hY
nTiuMBfL6h2c680MF9UrIUqvqJ94QEillrDShGxaMHIWZepLxydmACnI9Sga8dZPjG84hV//
JKGRmdlQ1fA7g0LUE2hZcY/zdB6Qey87ctNkND/bQfghbArOdJZK2/cal0xJ6znrPAyqs7wj
2HVz8/coOlXPPsV4OkoA9X1PAgMBAAGjggG0MIIBsDALBgNVHQ8EBAMCBLAwHQYDVR0lBBYw
FAYIKwYBBQUHAwIGCCsGAQUFBwMEMAkGA1UdEwQCMAAwHQYDVR0OBBYEFCfmAiR7cI5aUj1L
5j5v0+wVzVy1MB8GA1UdIwQYMBaAFCSBbDlhvkkPj7cbRivJKLUnSG1oMG8GCCsGAQUFBwEB
BGMwYTAkBggrBgEFBQcwAYYYaHR0cDovL29jc3Auc3RhcnRzc2wuY29tMDkGCCsGAQUFBzAC
hi1odHRwOi8vYWlhLnN0YXJ0c3NsLmNvbS9jZXJ0cy9zY2EuY2xpZW50MS5jcnQwOAYDVR0f
BDEwLzAtoCugKYYnaHR0cDovL2NybC5zdGFydHNzbC5jb20vc2NhLWNsaWVudDEuY3JsMB8G
A1UdEQQYMBaBFG5hemFyQG1va3J5bnNreWkuY29tMCMGA1UdEgQcMBqGGGh0dHA6Ly93d3cu
c3RhcnRzc2wuY29tLzBGBgNVHSAEPzA9MDsGCysGAQQBgbU3AQIEMCwwKgYIKwYBBQUHAgEW
Hmh0dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeTANBgkqhkiG9w0BAQsFAAOCAQEAkIZk
GJPfY91CrJnZzsF0+qviIsqRCWqdT64E5ttyODEvfo9TVccBvwTgVZzKJY2e+ALaDNX0dBH+
9YXMUg5pNfXGHauhQjGan8bdKsaLhvqaq3g0CO1oZU38pqizWTzQYbzu62414VeIDauHMbFD
pdRD0Egx/iY8R7JAO9k+hciD0W/L7FPRU7UTtz1vPqrKO54mYNFMn6EUhR2poM1j0dmwZH4W
Cly6N88RT6zhncbgDnjKr6+IHCxSP0E75uf+6kgbYRtwHnLydUIZdkEESlHhKdgJJFoL7nHr
PU3kWyAMrRdf2YtCwDa5USI5mE9v6sf0ynMrThlXbkb12Dz9wzCCBeIwggPKoAMCAQICEGun
in0K14jWUQr5WeTntOEwDQYJKoZIhvcNAQELBQAwfTELMAkGA1UEBhMCSUwxFjAUBgNVBAoT
DVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNp
Z25pbmcxKTAnBgNVBAMTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTE1
MTIxNjAxMDAwNVoXDTMwMTIxNjAxMDAwNVowdTELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0
YXJ0Q29tIEx0ZC4xKTAnBgNVBAsTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5
MSMwIQYDVQQDExpTdGFydENvbSBDbGFzcyAxIENsaWVudCBDQTCCASIwDQYJKoZIhvcNAQEB
BQADggEPADCCAQoCggEBAL192vfDon2D9luC/dtbX64eG3XAtRmvmCSsu1d52DXsCR58zJQb
CtB2/A5uFqNxWacpXGGtTCRk9dEDBlmixEd8QiLkUfvHpJX/xKnmVkS6Iye8wUbYzMsDzgnp
azlPg19dnSqfhM+Cevdfa89VLnUztRr2cgmCfyO9Otrh7LJDPG+4D8ZnAqDtVB8MKYJL6QgK
yVhhaBc4y3bGWxKyXEtx7QIZZGxPwSkzK3WIN+VKNdkiwTubW5PIdopmykwvIjLPqbJK7yPw
FZYekKE015OsW6FV+s4DIM8UlVS8pkIsoGGJtMuWjLL4tq2hYQuuN0jhrxK1ljz50hH23gA9
cbMCAwEAAaOCAWQwggFgMA4GA1UdDwEB/wQEAwIBBjAdBgNVHSUEFjAUBggrBgEFBQcDAgYI
KwYBBQUHAwQwEgYDVR0TAQH/BAgwBgEB/wIBADAyBgNVHR8EKzApMCegJaAjhiFodHRwOi8v
Y3JsLnN0YXJ0c3NsLmNvbS9zZnNjYS5jcmwwZgYIKwYBBQUHAQEEWjBYMCQGCCsGAQUFBzAB
hhhodHRwOi8vb2NzcC5zdGFydHNzbC5jb20wMAYIKwYBBQUHMAKGJGh0dHA6Ly9haWEuc3Rh
cnRzc2wuY29tL2NlcnRzL2NhLmNydDAdBgNVHQ4EFgQUJIFsOWG+SQ+PtxtGK8kotSdIbWgw
HwYDVR0jBBgwFoAUTgvvGqRAW6UXaYcwyjRoQ9BBrvIwPwYDVR0gBDgwNjA0BgRVHSAAMCww
KgYIKwYBBQUHAgEWHmh0dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeTANBgkqhkiG9w0B
AQsFAAOCAgEAi+P3h+wBi4StDwECW5zhIycjBL008HACblIf26HY0JdOruKbrWDsXUsiI0j/
7Crft9S5oxvPiDtVqspBOB/y5uzSns1lZwh7sG96bYBZpcGzGxpFNjDmQbcM3yl3WFIRS4Wh
NrsOY14V7y2IrUGsvetsD+bjyOngCIVeC/GmsmtbuLOzJ606tEc9uRbhjTu/b0x2Fo+/e7Uk
QvKzNeo7OMhijixaULyINBfCBJb+e29bLafgu6JqjOUJ9eXXj20p6q/CW+uVrZiSW57+q5an
2P2i7hP85jQJcy5j4HzA0rSiF3YPhKGAWUxKPMAVGgcYoXzWydOvZ3UDsTDTagXpRDIKQLZo
02wrlxY6iMFqvlzsemVf1odhQJmi7Eh5TbxI40kDGcBOBHhwnaOumZhLP+SWJQnjpLpSlUOj
95uf1zo9oz9e0NgIJoz/tdfrBzez76xtDsK0KfUDHt1/q59BvDI7RX6gVr0fQoCyMczNzCTc
RXYHY0tq2J0oT+bsb6sH2b4WVWAiJKnSYaWDjdA70qHX4mq9MIjO/ZskmSY8wtAk24orAc0v
wXgYanqNsBX5Yv4sN4Z9VyrwMdLcusP7HJgRdAGKpkR2I9U4zEsNJQJewM7S4Jalo1DyPrLp
L2nTET8ZrSl5Utp1UeGp/2deoprGevfnxWB+vHNQiu85o6MxggPMMIIDyAIBATCBiTB1MQsw
CQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjEpMCcGA1UECxMgU3RhcnRDb20g
Q2VydGlmaWNhdGlvbiBBdXRob3JpdHkxIzAhBgNVBAMTGlN0YXJ0Q29tIENsYXNzIDEgQ2xp
ZW50IENBAhBk6v6TVth6hqLyl5xsFf+NMA0GCWCGSAFlAwQCAQUAoIICEzAYBgkqhkiG9w0B
CQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xNjAyMjIxOTM5MjlaMC8GCSqGSIb3
DQEJBDEiBCA2/Qeih8ygMVfLX/hk3NYGfe8DiIosqwltq5BBLuV33jBsBgkqhkiG9w0BCQ8x
XzBdMAsGCWCGSAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwIC
AgCAMA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGaBgkrBgEEAYI3
EAQxgYwwgYkwdTELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKTAnBgNV
BAsTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MSMwIQYDVQQDExpTdGFydENv
bSBDbGFzcyAxIENsaWVudCBDQQIQZOr+k1bYeoai8pecbBX/jTCBnAYLKoZIhvcNAQkQAgsx
gYyggYkwdTELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKTAnBgNVBAsT
IFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MSMwIQYDVQQDExpTdGFydENvbSBD
bGFzcyAxIENsaWVudCBDQQIQZOr+k1bYeoai8pecbBX/jTANBgkqhkiG9w0BAQEFAASCAQCI
L6Bc9iR0HIGXcZdaBUiqa1o/kNpODksjCGvhdJQ5k/Z1kClLpGIoxWuQTzLJUkuzTF6c15vz
ET+mOc10qPGP56y/naFNhG8MUUyuW0hrBWs+87SYjccIJktxa/0I0Qy/HN/cQX8vJZo3xcoU
NEq38wRL22jyY4vESFtYguc1mkUW/kciPGhJzZyWk/8jN4sEMqJNFK0L08AO4NaGL8g02FRx
n/4a5Ko6nCe2tNuiJF8cGPwjOMhE/dOGHEJwfHrVzgbWvchcItM9kOmBt9JtKdqcoZg9DF7w
7EvBpIyS2iB7kvJu5ZD/lEUMELU1ysSlJ304pCbogezO3QjFNekaAAAAAAAA
--------------ms050704010803070701040207--
