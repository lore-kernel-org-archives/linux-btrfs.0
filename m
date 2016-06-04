Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-02.dd24.net ([193.46.215.43]:37155 "EHLO
	mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbcFDBvi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jun 2016 21:51:38 -0400
Message-ID: <1465005092.6648.39.camel@scientia.net>
Subject: Re: btrfs
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
Date: Sat, 04 Jun 2016 03:51:32 +0200
In-Reply-To: <6f18c0d1-8ac5-c325-0ba8-ffb949c54554@gmail.com>
References: <1464819934.6742.71.camel@scientia.net>	
 <d500a743-7a39-8ec5-c6ce-e5a3c70ede91@nv-systems.net>	
 <1464975482.6679.11.camel@scientia.net>
	 <6f18c0d1-8ac5-c325-0ba8-ffb949c54554@gmail.com>
Content-Type: multipart/signed; micalg="sha-512";
	protocol="application/x-pkcs7-signature";
	boundary="=-KV8UjhBTuvC/Oie2gZOQ"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-KV8UjhBTuvC/Oie2gZOQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2016-06-03 at 15:50 -0400, Austin S Hemmelgarn wrote:
> There's no point in trying to do higher parity levels if we can't get
> regular parity working correctly.=C2=A0=C2=A0Given the current state of t=
hings,
> it might be better to break even and just rewrite the whole parity
> raid thing from scratch, but I doubt that anybody is willing to do
> that.

Well... as I've said, things are pretty worrying. Obviously I cannot
really judge, since I'm not into btrfs' development... maybe there's a
lack of manpower? Since btrfs seems to be a very important part (i.e.
next-gen fs), wouldn't it be possible to either get some additional
funding by the Linux Foundation, or possible that some of the core
developers make an open call for funding by companies?
Having some additional people, perhaps working fulltime on it, may be a
big help.

As for the RAID... given how many time/effort is spent now into 5/6,..
it really seems that one should have considered multi-parity from the
beginning on.
Kinda feels like either, with multi-parity this whole instability phase
would start again, or it will simply never happen.


> > - Serious show-stoppers and security deficiencies like the UUID
> > =C2=A0 collision corruptions/attacks that have been extensively
> > discussed
> > =C2=A0 earlier, are still open
> The UUID issue is not a BTRFS specific one, it just happens to be
> easier
> to cause issues with it on BTRFS

uhm this had been discussed extensively before, as I've said... AFAICS
btrfs is the only system we have, that can possibly cause data
corruption or even security breach by UUID collisions.
I wouldn't know that other fs, or LVM are affected, these just continue
to use those devices already "online"... and I think lvm refuses to
activate VGs, if conflicting UUIDs are found.


> There is no way to solve it sanely given the requirement that
> userspace
> not be broken.
No this is not true. Back when this was discussed, I and others
described how it could/should be done,... respectively how
userspace/kernel should behave, in short:
- continue using those devices that are already active
- refusing to (auto)assemble by UUID, if there are conflicts
=C2=A0 or requiring to specify the devices (with some=C2=A0--override-yes-i=
-know-
=C2=A0 what-i-do option=C2=A0option or so)
- in case of assembling/rebuilding/similar... never doing this
=C2=A0 automatically

I think there were some more corner cases, I basically had them all
discussed in the thread back then (search for "attacking btrfs
filesystems via UUID collisions?" and IIRC some different titled parent
or child threads).


> =C2=A0=C2=A0Properly fixing this would likely make us more dependent
> on hardware configuration than even mounting by device name.
Sure, if there are colliding UUIDs, and one still wants to mount (by
using some --override-yes-i-know-what-i-do option),.. it would need to
be by specifying the device name...
But where's the problem?
This would anyway only happen if someone either attacks or someone made
a clone, and it's far better to refuse automatic assembly in cases
where accidental corruption can happen or where attacks may be
possible, requiring the user/admin to manually take action, than having
corruption or security breach.

Imagine the simple case: degraded RAID1 on a PC; if btrfs would do some
auto-rebuild based on UUID, then if an attacker knows that he'd just
need to plug in a USB disk with a fitting UUID...and easily gets a copy
of everything on disk, gpg keys, ssh keys, etc.



> > - a number of important core features not fully working in many
> > =C2=A0 situations (e.g. the issues with defrag, not being ref-link
> > aware,...
> > =C2=A0 an I vaguely remember similar things with compression).
> OK, how then should defrag handle reflinks?=C2=A0=C2=A0Preserving them pr=
events
> it
> from being able to completely defragment data.
Didn't that even work in the past and had just some performance issues?


> > - OTOH, defrag seems to be viable for important use cases (VM
> > images,
> > =C2=A0 DBs,... everything where large files are internally re-written
> > =C2=A0 randomly).
> > =C2=A0 Sure there is nodatacow, but with that one effectively completel=
y
> > =C2=A0 looses one of the core features/promises of btrfs (integrity by
> > =C2=A0 checksumming)... and as I've showed in an earlier large
> > discussion,
> > =C2=A0 none of the typical use cases for nodatacow has any high-level
> > =C2=A0 checksumming, and even if, it's not used per default, or doesn't
> > give
> > =C2=A0 the same benefits at it would on the fs level, like using it for
> > RAID
> > =C2=A0 recovery).
> The argument of nodatacow being viable for anything is a pretty
> significant secondary discussion that is itself entirely orthogonal
> to
> the point you appear to be trying to make here.

Well the point here was:=C2=A0
- many people (including myself) like btrfs, it's
=C2=A0 (promised/future/current) features
- it's intended as a general purpose fs
- this includes the case of having such file/IO patterns as e.g. for VM
=C2=A0 images or DBs
- this is currently not really doable without loosing one of the
=C2=A0 promises (integrity)

So the point I'm trying to make:
People do probably not care so much whether their VM image/etc. is
COWed or not, snapshots/etc. still work with that,... but they may
likely care if the integrity feature is lost.
So IMHO, nodatacow + checksumming deserves to be amongst the top
priorities.


> > - still no real RAID 1
> No, you mean still no higher order replication.=C2=A0=C2=A0I know I'm bei=
ng
> stubborn about this, but RAID-1 is offici8ally defined in the
> standards
> as 2-way replication.
I think I remember that you've claimed that last time already, and as
I've said back then:
- what counts is probably the common understanding of the term, which
=C2=A0 is N disks RAID1 =3D N disks mirrored
- if there is something like an "official definition", it's probably
=C2=A0 the original paper that introduced RAID:
=C2=A0=C2=A0http://www.eecs.berkeley.edu/Pubs/TechRpts/1987/CSD-87-391.pdf
=C2=A0 PDF page 11, respectively content page 9 describes RAID1 as:
=C2=A0 "This is the most expensive option since *all* disks are
=C2=A0 duplicated..."


> The only extant systems that support higher
> levels of replication and call it RAID-1 are entirely based on MD
> RAID
> and it's poor choice of naming.

Not true either, show me any single hardware RAID controller that does
RAID1 in a dup2 fashion... I manage some >2PiB of storage at the
faculty, all controller we have, handle RAID1 in the sense of "all
disks mirrored".


> > - no end-user/admin grade maangement/analysis tools, that tell non-
> > =C2=A0 experts about the state/health of their fs, and whether things
> > like
> > =C2=A0 balance etc.pp. are necessary
> I don't see anyone forthcoming with such tools either.=C2=A0=C2=A0As far =
as
> basic
> monitoring, it's trivial to do with simple scripts from tools like
> monit
> or nagios.

AFAIU, even that isn't really possible right now, is it?
Take RAID again,... there is no place where you can see whether the
RAID state is "optimal", or does that exist in the meantime? Last time,
people were advised to look at the kernel logs, but this is no proper
way to check for the state... logging may simply be deactivated, or you
may have an offline fs, for which the logs have been lost because they
were on another disk.

Not to talk about the inability to properly determine how often btrfs
encountered errors, and "silently" corrected it.
E.g. some statistics about a device, that can be used to decide whether
its dying.
I think these things should be stored in the fs (and additionally also
on the respective device), where it can also be extracted when no
/var/log is present or when forensics are done.


> =C2=A0=C2=A0As far as complex things like determining whether a fs needs
> balanced, that's really non-trivial to figure out.=C2=A0=C2=A0Even with a
> person
> looking at it, it's still not easy to know whether or not a balance
> will
> actually help.
Well I wouldn't call myself a btrfs expert, but from time to time I've
been a bit "more active" on the list.
Even I know about these strange cases (sometimes tricks), like many
empty data/meta block groups, that may or may not get cleaned up, and
may result in troubles
How should the normal user/admin be able to cope with such things if
there are no good tools?

It starts with simple things like:
- adding a further disk to a RAID
=C2=A0 =3D> there should be a tool which tells you: dude, some files are no=
t
=C2=A0 =C2=A0 =C2=A0yet "rebuild"(duplicated),... do a balance or whatever.


> >- the still problematic documentation situation
> Not trying to rationalize this, but go take a look at a majority of
> other projects, most of them that aren't backed by some huge
> corporation
> throwing insane amounts of money at them have at best mediocre end-
> user
> documentation.=C2=A0=C2=A0The fact that more effort is being put into
> development
> than documentation is generally a good thing, especially for
> something
> that is not yet feature complete like BTRFS.

Uhm.. yes and no...
The lack of documentation (i.e. admin/end-user-grade documentation)
also means that people have less understanding in the system, less
trust, less knowledge on what they can expect/do with it (will Ctrl-C
on btrfs checl work? what if I shut down during a balance? does it
break then? etc. pp.), less will to play with it.
Further,... if btrfs would reach the state of being "feature complete"
(if that ever happens, and I don't mean because of slow development,
but rather, because most other fs shows that development goes "ever"
on),... there would be *so much* to do in documentation, that it's
unlikely it will happen.


Cheers,
Chris.
--=-KV8UjhBTuvC/Oie2gZOQ
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgMFADCABgkqhkiG9w0BBwEAAKCCEmow
ggXiMIIDyqADAgECAhBctkhuRwyYxn/2gNtkSuKNMA0GCSqGSIb3DQEBCwUAMH0xCzAJBgNVBAYT
AklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0
aWZpY2F0ZSBTaWduaW5nMSkwJwYDVQQDEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0
eTAeFw0xNTEyMTYwMTAwMDVaFw0zMDEyMTYwMTAwMDVaMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQK
Ew1TdGFydENvbSBMdGQuMSkwJwYDVQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0
eTEjMCEGA1UEAxMaU3RhcnRDb20gQ2xhc3MgMiBDbGllbnQgQ0EwggEiMA0GCSqGSIb3DQEBAQUA
A4IBDwAwggEKAoIBAQDuD1CMlQkjhKz1UGqP1jeiTiH9MgllRz6vOPrVG/eE0H/J4QQLV/PeL8RT
4xc44bEzsoJu0IhwnEchb+TxE/qw88w7hxODuw3N8Faxix6a1jp83+RWvZHZf78+O+3GYBpekZfT
Oe9A/FoTXbcgwZfLTMQodn+ckNnX31M/1M2f2/7VA7QBlvihontyHQOlIlryQXnGI0UMCD21oopK
tW48ckv0wUVg8irBKGMeD65gTON/Fsw/ZBbBqadoD1jt85FIM1ql24WUBEBwO1d0ykCKOIbgcqes
3fbcjQpruUNMBbIu1MMIRMqwjx/M7IvSKcS7VYRWl0/K2byzWvBAHh/1AgMBAAGjggFkMIIBYDAO
BgNVHQ8BAf8EBAMCAQYwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMBIGA1UdEwEB/wQI
MAYBAf8CAQAwMgYDVR0fBCswKTAnoCWgI4YhaHR0cDovL2NybC5zdGFydHNzbC5jb20vc2ZzY2Eu
Y3JsMGYGCCsGAQUFBwEBBFowWDAkBggrBgEFBQcwAYYYaHR0cDovL29jc3Auc3RhcnRzc2wuY29t
MDAGCCsGAQUFBzAChiRodHRwOi8vYWlhLnN0YXJ0c3NsLmNvbS9jZXJ0cy9jYS5jcnQwHQYDVR0O
BBYEFJmXqxg1OotZRUOYsnJxyPT7Cc8WMB8GA1UdIwQYMBaAFE4L7xqkQFulF2mHMMo0aEPQQa7y
MD8GA1UdIAQ4MDYwNAYEVR0gADAsMCoGCCsGAQUFBwIBFh5odHRwOi8vd3d3LnN0YXJ0c3NsLmNv
bS9wb2xpY3kwDQYJKoZIhvcNAQELBQADggIBAJlBQQTO9iT1TjA0eEO7V/1AbBvMAfibjAgofxmJ
01jBmHKg0pbTjWInTTYoxb3LBgz3mfjvvS1PjnIfb29MyVm0G/PSHjgq7Ews1dEJMPC9XTuxPf2c
+MWLkynBlotW542JprW+iTWfZafyUtzIKW1hk0YASJ8zSSj8D++9yR+0UhkbvlECJkdi1+et0EaI
7HIX6ccj1rfcFFflWX/fPT64dn9jpg9s0nuJug4WsVkEK236WndZoMHrZmgF7CIyZ3T0muqYwkAS
DDcRt9A21o/Mc+D8Q6GVmKRGB3gEKvOtsioHZEqJv6CdAm3a6gloo5pX3RL1eCzc8Lzfs4T0ISZj
r8xNMbTGlsuHaFH+stDewKsfnpo4N64OtAGrzmVfFFsMIRENRHsVlSEe/6LVpBpjn00+7bqEN3qe
qSxIOraYJ12mJ08G4YnP2U1fadHIaS50O5ZXqAivoBl9pi/6CBNc5wIMlkXMyFZ0sLsI+9ErFDu9
OJhX7iWCo69X0ydlzXj08+2K1PKyr+g6/vTPHur63JotNrhyoWEJyWEjBLA4QmJXfGpB5u+bCwNf
sFpcYAlkiFt1Rs2vemgSBy3q4DHDbPKvr1YImZNRSHP+TX9NP94JRkmqcyD/qaN7u2JV1pRAlwG0
npyrn6ZQM1QHV+iFbwQ4VqLMWk//QVo/rZy1MIIGPjCCBSagAwIBAgIQPZ6tDP/RHLwcz1F+2kRA
DzANBgkqhkiG9w0BAQsFADB1MQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjEp
MCcGA1UECxMgU3RhcnRDb20gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkxIzAhBgNVBAMTGlN0YXJ0
Q29tIENsYXNzIDIgQ2xpZW50IENBMB4XDTE2MDEwMjAyMDIzNloXDTE4MDEwMjAyMDIzNlowejEL
MAkGA1UEBhMCREUxDzANBgNVBAgMBkJheWVybjERMA8GA1UEBwwITcO8bmNoZW4xITAfBgNVBAMM
GENocmlzdG9waCBBbnRvbiBNaXR0ZXJlcjEkMCIGCSqGSIb3DQEJARYVY2FsZXN0eW9Ac2NpZW50
aWEubmV0MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAsoxs789VtR81tlqeP2vwE3Cp
YosZYRfrovj+Wb91paoV5OQcFuXA7yONnLsWxOnJ3AGgy1/wG79Ko+yHSmF2K88pEWjrFe0zmZWZ
0b2OtMoKLEjxz7Nz2N7/lmgss8XinJ083LwLKSe4f+JLjnF5hX/g6wG4NkFXVOIf2YFZ0+c1NYFQ
T6Vy42EWdk+JLDoXjyd2hEperLCz9rQr2k3wh0cn8R1FDUGerBGpMnvyKV6JXj5vZsqJnmiiId9e
0IdBj4Wcs3hT2usk6dJYwHrZ8b7Fkv6BRq90DUI7i8+ukTdp5hnAb8TPSbe1JS4h3Jc7r2NVLkpo
Gbuw98er9s2PEAvpECD3toO3ojBevL56vEDbGa5tXpvvcWCz6t3QyEKJ2E54hWw1fbUA0BtydQC0
mhKBtrENVnnCDrSgiyBMnd8y+kw6iPKeJEjNObGubc4BZp47zPn/ZiDBaHue6S0MXsoS7XEGOuCU
09S/8kD8wTecBg+KdlLSNkLm+xqx6Cy7zwcj3IuQv0PeWi4kfEkAJfl8IeAP/4049iA6a1rkhJl7
1rDjpEGBCG+i9BAgBeNdHLtQ7bugdvU+GfHjFXEU1emUk91E2liML8kpCvhUAXcLhhL8bxPJiX2/
VQ2esrpQVO56OzpivNauonLaWmHEKOSfPC3s5AKMytMTiUiszEUCAwEAAaOCAcMwggG/MAsGA1Ud
DwQEAwIEsDAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwCQYDVR0TBAIwADAdBgNVHQ4E
FgQUwRklxF1ZV2ooSMkFwLiK13apkK0wHwYDVR0jBBgwFoAUmZerGDU6i1lFQ5iycnHI9PsJzxYw
bwYIKwYBBQUHAQEEYzBhMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5zdGFydHNzbC5jb20wOQYI
KwYBBQUHMAKGLWh0dHA6Ly9haWEuc3RhcnRzc2wuY29tL2NlcnRzL3NjYS5jbGllbnQyLmNydDA4
BgNVHR8EMTAvMC2gK6AphidodHRwOi8vY3JsLnN0YXJ0c3NsLmNvbS9zY2EtY2xpZW50Mi5jcmww
IAYDVR0RBBkwF4EVY2FsZXN0eW9Ac2NpZW50aWEubmV0MCMGA1UdEgQcMBqGGGh0dHA6Ly93d3cu
c3RhcnRzc2wuY29tLzBUBgNVHSAETTBLMAwGCisGAQQBgbU3BgEwOwYLKwYBBAGBtTcBAgQwLDAq
BggrBgEFBQcCARYeaHR0cDovL3d3dy5zdGFydHNzbC5jb20vcG9saWN5MA0GCSqGSIb3DQEBCwUA
A4IBAQBb8EIsoUN/tgUgQqrNXNtlksPep84kx5yRBgr71uf3ITLddGtzfDBj6KdZUoy7SG3MQkyO
kvYmXBClj23rv8Iol48/3oi9XWZw5EV3uHrRse1TzQgMPZE0hZsDgkqXVoxMQfk55ndjZIHMfSkn
hdnqSP5zZ4TCmDEKLppPMDcQSSrjilnbthpxlIJzeGeEFtrh6ssh/oF6mUaEGFcd8kx9RS51K1gt
H4J36y4E6pKB7EdxG2+0yVzAIta8dkD/BiMCKRWhp1EmzQ2uIh2nX5y8t4e2xHHuiy11Yeq6UTW/
JmfxF4xcbkNK/rv9ISBg9K+mZtg2QXr+P/CJBtej2RLUMIIGPjCCBSagAwIBAgIQPZ6tDP/RHLwc
z1F+2kRADzANBgkqhkiG9w0BAQsFADB1MQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20g
THRkLjEpMCcGA1UECxMgU3RhcnRDb20gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkxIzAhBgNVBAMT
GlN0YXJ0Q29tIENsYXNzIDIgQ2xpZW50IENBMB4XDTE2MDEwMjAyMDIzNloXDTE4MDEwMjAyMDIz
NlowejELMAkGA1UEBhMCREUxDzANBgNVBAgMBkJheWVybjERMA8GA1UEBwwITcO8bmNoZW4xITAf
BgNVBAMMGENocmlzdG9waCBBbnRvbiBNaXR0ZXJlcjEkMCIGCSqGSIb3DQEJARYVY2FsZXN0eW9A
c2NpZW50aWEubmV0MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAsoxs789VtR81tlqe
P2vwE3CpYosZYRfrovj+Wb91paoV5OQcFuXA7yONnLsWxOnJ3AGgy1/wG79Ko+yHSmF2K88pEWjr
Fe0zmZWZ0b2OtMoKLEjxz7Nz2N7/lmgss8XinJ083LwLKSe4f+JLjnF5hX/g6wG4NkFXVOIf2YFZ
0+c1NYFQT6Vy42EWdk+JLDoXjyd2hEperLCz9rQr2k3wh0cn8R1FDUGerBGpMnvyKV6JXj5vZsqJ
nmiiId9e0IdBj4Wcs3hT2usk6dJYwHrZ8b7Fkv6BRq90DUI7i8+ukTdp5hnAb8TPSbe1JS4h3Jc7
r2NVLkpoGbuw98er9s2PEAvpECD3toO3ojBevL56vEDbGa5tXpvvcWCz6t3QyEKJ2E54hWw1fbUA
0BtydQC0mhKBtrENVnnCDrSgiyBMnd8y+kw6iPKeJEjNObGubc4BZp47zPn/ZiDBaHue6S0MXsoS
7XEGOuCU09S/8kD8wTecBg+KdlLSNkLm+xqx6Cy7zwcj3IuQv0PeWi4kfEkAJfl8IeAP/4049iA6
a1rkhJl71rDjpEGBCG+i9BAgBeNdHLtQ7bugdvU+GfHjFXEU1emUk91E2liML8kpCvhUAXcLhhL8
bxPJiX2/VQ2esrpQVO56OzpivNauonLaWmHEKOSfPC3s5AKMytMTiUiszEUCAwEAAaOCAcMwggG/
MAsGA1UdDwQEAwIEsDAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwCQYDVR0TBAIwADAd
BgNVHQ4EFgQUwRklxF1ZV2ooSMkFwLiK13apkK0wHwYDVR0jBBgwFoAUmZerGDU6i1lFQ5iycnHI
9PsJzxYwbwYIKwYBBQUHAQEEYzBhMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5zdGFydHNzbC5j
b20wOQYIKwYBBQUHMAKGLWh0dHA6Ly9haWEuc3RhcnRzc2wuY29tL2NlcnRzL3NjYS5jbGllbnQy
LmNydDA4BgNVHR8EMTAvMC2gK6AphidodHRwOi8vY3JsLnN0YXJ0c3NsLmNvbS9zY2EtY2xpZW50
Mi5jcmwwIAYDVR0RBBkwF4EVY2FsZXN0eW9Ac2NpZW50aWEubmV0MCMGA1UdEgQcMBqGGGh0dHA6
Ly93d3cuc3RhcnRzc2wuY29tLzBUBgNVHSAETTBLMAwGCisGAQQBgbU3BgEwOwYLKwYBBAGBtTcB
AgQwLDAqBggrBgEFBQcCARYeaHR0cDovL3d3dy5zdGFydHNzbC5jb20vcG9saWN5MA0GCSqGSIb3
DQEBCwUAA4IBAQBb8EIsoUN/tgUgQqrNXNtlksPep84kx5yRBgr71uf3ITLddGtzfDBj6KdZUoy7
SG3MQkyOkvYmXBClj23rv8Iol48/3oi9XWZw5EV3uHrRse1TzQgMPZE0hZsDgkqXVoxMQfk55ndj
ZIHMfSknhdnqSP5zZ4TCmDEKLppPMDcQSSrjilnbthpxlIJzeGeEFtrh6ssh/oF6mUaEGFcd8kx9
RS51K1gtH4J36y4E6pKB7EdxG2+0yVzAIta8dkD/BiMCKRWhp1EmzQ2uIh2nX5y8t4e2xHHuiy11
Yeq6UTW/JmfxF4xcbkNK/rv9ISBg9K+mZtg2QXr+P/CJBtej2RLUMYIEfjCCBHoCAQEwgYkwdTEL
MAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKTAnBgNVBAsTIFN0YXJ0Q29tIENl
cnRpZmljYXRpb24gQXV0aG9yaXR5MSMwIQYDVQQDExpTdGFydENvbSBDbGFzcyAyIENsaWVudCBD
QQIQPZ6tDP/RHLwcz1F+2kRADzANBglghkgBZQMEAgMFAKCCAcUwGAYJKoZIhvcNAQkDMQsGCSqG
SIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTYwNjA0MDE1MTMzWjBPBgkqhkiG9w0BCQQxQgRA3FV8
WXYJ0EdWXy56QB9LvQ2GD2zu8jC9SgylkqvZV2BmPFdLS1K80vRzcwwthwSasXkscQUdAAlEyZN7
8/gbxTCBmgYJKwYBBAGCNxAEMYGMMIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENv
bSBMdGQuMSkwJwYDVQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UE
AxMaU3RhcnRDb20gQ2xhc3MgMiBDbGllbnQgQ0ECED2erQz/0Ry8HM9RftpEQA8wgZwGCyqGSIb3
DQEJEAILMYGMoIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSkwJwYD
VQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMaU3RhcnRDb20g
Q2xhc3MgMiBDbGllbnQgQ0ECED2erQz/0Ry8HM9RftpEQA8wDQYJKoZIhvcNAQEBBQAEggIAripb
012zqn27kHzAsSDFhmhA7Hn3RO6+ooGb/JztiZ/HQ3ElW/SUGEJaTBmP1A64POR4Vze/BICoiYwS
43NnCsCSZJuiMURHhkm6y9gAHvTySWvp+np2gbSM1wSirJWaXYhuEtxmfqbCKt3y2V4Y8TN6RLa+
wc5n2SxK2Oj3FHHciv9boSDKRi4tpmkN/4C5dXABwqrc7yMGHnJvClG6pvUrF5+Nub6htEuoV9sV
CQBBTuuVpUOXrKZo60Fm7F8yGuIri8ZalDnxznoV7cT0GKuHdSMcUdDfNJGkRDZiL5zIxEu6IR53
aWc0ZpQjXFMYKi6/LbH4ijjZ6ZuUpbT2o0BnYaFkhiXyegIK/Gqpq2FSWbPg1F7LLGVKdJcQSkdj
DyvdeeGZyUHrmS46gCAPBsdFcZAmKIMbNQwGB0C/nuqdxtlME0u0cK39WrEpsBfZSNdOwg0bCzI3
FE5TSxhIP1TSL7xE2pMpfSvjCOkr1abwvCSN14zTuVwZoiEvhyHCDKZf4CCmVUsyFwvzHCd2OBf4
TVGzV9/IBDIBK07kIs7zsSyhK9BcqL4GGaK+axxkN4bh5wKvyyJDO6qoKsZanX0EA7e0P2PPX4A8
6dc/vwnL/b73spzNrvRtrqTJeDqYgQOvVfHCVFk9dsfKd6Oad89V3ffIG7Ew8zwkPVLIGJEAAAAA
AAA=


--=-KV8UjhBTuvC/Oie2gZOQ--

