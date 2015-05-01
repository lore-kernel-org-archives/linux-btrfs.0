Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:35433 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbbEAMZj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 May 2015 08:25:39 -0400
Received: by igbyr2 with SMTP id yr2so37539956igb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 01 May 2015 05:25:38 -0700 (PDT)
Message-ID: <554370B2.7060601@gmail.com>
Date: Fri, 01 May 2015 08:25:22 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: [REGRESSION] Hang during backup with rsync
References: <1943792.PglQ59K4TH@merkaba> <pan$b4d5f$f3e14022$274533d9$ff98a48f@cox.net>
In-Reply-To: <pan$b4d5f$f3e14022$274533d9$ff98a48f@cox.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms080902020705030005040008"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms080902020705030005040008
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-04-30 21:48, Duncan wrote:
> Martin Steigerwald posted on Thu, 30 Apr 2015 19:29:57 +0200 as excerpt=
ed:
>
>> The hang was: Mouse pointer in KDE not movable anymore, Ctrl-Alt-F1 ha=
d
>> no effect. I waited for a minute at least. Maybe it would have reacted=

>> after a longer time, but I wanted my machine back. Disks where idle, i=
f
>> I remember correctly. After reboot both filesystems mount okay.
>
> This response is in regard to what to do at an apparent hang, and has
> nothing directly to do with btrfs...
>
> Two comments:
>
> 1) Depending on your graphics hardware and driver config, a modern
> "KMS" (kernel modesetting) setup is more likely to "soft" hang in X mod=
e
> and not switch back to text mode, even when the system is otherwise not=

> hung and a VT switch would have worked fine pre-KMS-era.
>
> While I'm no kernel or graphics expert, the problem from here /seems/ t=
o
> be that a modern KMS kernel generally uses high-res framebuffer mode at=

> the CLI as well, and because the basic kernel handling is unified
> framebuffer and kernel-mode-switching for both X and CLI modes, switchi=
ng
> from X to CLI doesn't involve switching to the entirely separate VGA mo=
de
> driver and with it the forced hardware reset that it used to.  Without
> that driver switch and forced reset, even if the switch actually occurs=

> successfully in terms of what you might type, what is actually displaye=
d
> may remain frozen, such that if you only have a local session, you
> generally have to reboot anyway, but if you already have a CLI login
> going in the VT you tried to switch to or can login blind, sometimes yo=
u
> can at least manage a controlled reboot, by doing an init 6 or systemct=
l
> reboot or whatever, even if the display is frozen and shows nothing.  O=
f
> course it doesn't always work, but given the chance to avoid an unclean=

> shutdown, try it and see.
>
> So no response at an attempted VT switch (your ctrl-alt-F1) doesn't mea=
n
> what it used to...
>
Something else to try in this case is Ctrl-Alt-Backspace, (Most linux=20
distros have that configured to outright kill X running on the current=20
VT) followed by Ctrl-Alt-Delete, which defaults on all modern distros to =

be equivalent to running 'shutdown -r now' from a root shell.
Also, you may try Alt-SysRq-V, which is supposed to 'restore the=20
framebuffer console' (except on ARM systems, where it is used to dump=20
the contents of hardware tracing modules).
> 2) Along the same lines, there's the kernel's magic-sysrequest (sysrq/s=
rq)
> functionality.  Assuming you have it enabled in your kernel, you can tr=
y
> a series of alt-sysrq-key sequences and very possibly use that to avoid=

> an entirely uncontrolled shutdown, even when major functionality upto a=
nd
> including all of userspace is non-functional.
>
> There's enough explanations written and googlable on the subject that
> I'll avoid a full explanation here, but the main point I have to make i=
s
> that in addition to often allowing a semi-controlled shutdown/reboot, b=
y
> using the keys in the prescribed sequence and noting at which point (if=

> any) you actually get a response, you get at least some indication of h=
ow
> badly your system was actually locked up.
So, this is great advice in theory, except that a large majority of=20
distributions targeted at enterprise level usage (Fedora, Ubuntu, RHEL,=20
SuSE, CentOS, etc) have this functionality disabled at runtime by=20
default 'for security' (which is BS, because if an attacker has the kind =

of access required to use SysRq, then he has sufficient access to be=20
able to bring the system to it's knees through other methods as well).
> What I'd try first, right after the VT switch didn't work, is alt-srq-k=
=2E
> Called the secure-term sequence as it can be used to help avoid suspect=
ed
> keyloggers of certain (but not all) types, this tells the kernel to for=
ce-
> kill anything running on your current VT and reset it.  This can be use=
d
> to kill an unresponsive X, for instance, and normally you'll get
> automatically switched to a CLI login, either due to automatic switchin=
g
> back to a previous VT (in the case of X on its own VT), or to automatic=

> respawning of the login after the kernel kills it along with whatever
> else you were doing if you were already at the CLI.
>
> This alt-srq-k sequence is thus a good first fallback if ctrl-alt-Fx
> appears to do nothing, since it apparently forces the VT reset that
> switching to a VGAmode CLI used to, that switching to a KMS mode CLI
> doesn't.
>
> If that doesn't work, it's time for the usual REISUB sequence,
>
> * alt-srq-r (unraw the input, take out of X mode)
>
> * alt-srq-e (tErminate, aka SIGTERM, all of userspace, allowing anythin=
g
> still alive to terminate gracefully if it can)
>
> * alt-srq-i (kIll, aka SIGKILL, all userspace, forcefully killing
> anything that ignored the SIGTERM but still allowing the kernel to do
> normal cleanup if it can)
>
> (Tho from my own experience, if the K and R sequences don't help, then
> the E and I sequences aren't likely to do much either, as they're
> probably locked up bad enough that nothing will be gained, but OTOH,
> nothing is lost by trying them, either.)
>
I've found that sometimes Alt-SysRq-J is needed at this point in the=20
sequence to get things to correctly write data out (it resumes I/O to=20
filesystems that have been frozen with the fsfreeze command or ioctl),=20
and it has no negative impact if not needed, so it's generally a good=20
idea to just use it anyway.
> * alt-srq-s (Sync, force an emergency sync to storage of anything still=

> write-cached)
>
> alt-srq-s can be used at any time, without disrupting normal operation
> except for any I/O triggered by the forced sync.  I've come to use it
> regularly immediately before I do anything that I think /might/ trigger=

> system instability, so everything's synced before I try it, just in
> case.  Think of this as a forced version of the sync command.
>
> * alt-srq-u (remoUnt read-only, forcing all still functional filesystem=
s
> read-only)
>
> The S and U steps are critical to a semi-controlled shutdown, and where=

> they work, can often mean the difference between a filesystem with no
> errors on reboot as the kernel saved and cleanly mounted read-only to t=
he
> extent it could, and various filesystem corruptions, if these steps
> weren't done or if the kernel was badly enough corrupted it was afraid =
to
> write anything lest it make the problem worse.
>
> * alt-srq-b (reBoot, force a reboot without any further cleanup).
>

Secondarily, for the sake of completeness, you can also use Alt-SysRq-o=20
in place of Alt-SysRq-b to (try) to get the system to power off instead=20
of reboot.  Also, it's significant to note that the exact keys used vary =

depending on the keymap loaded in the kernel, on a Dvorak keyboard for=20
example, the sequence is instead P.COGX (which IIRC is the same sequence =

of scancodes as on QWERTY keyboards).  Furthermore, if you were running=20
under X, you may need to add the Ctrl key to the combination to get it=20
properly acknowledged.

It's worth mentioning also that many laptop keyboards (and some other=20
modern keyboards) need you to use Ctrl-Alt-PrintScreen (or even some=20
other odd key combination, for example the Dell laptop that I'm typing=20
this on needs Fn-Alt-Home) instead of Alt-SysRq



--------------ms080902020705030005040008
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIGuDCC
BrQwggScoAMCAQICAxBuVTANBgkqhkiG9w0BAQ0FADB5MRAwDgYDVQQKEwdSb290IENBMR4w
HAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmlu
ZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0xNTAz
MjUxOTM0MzhaFw0xNTA5MjExOTM0MzhaMGMxGDAWBgNVBAMTD0NBY2VydCBXb1QgVXNlcjEj
MCEGCSqGSIb3DQEJARYUYWhmZXJyb2luN0BnbWFpbC5jb20xIjAgBgkqhkiG9w0BCQEWE2Fo
ZW1tZWxnQG9oaW9ndC5jb20wggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQCdD/zW
2rRAFCLnDfXpWxU1+ODqRVUgzHvrRO7ADUxRo1CBDc3JSX5TIW2OGmQ3DAKGOACp8Z0sgxMc
B05tzAZ/M7m4jajVrwwdVCdrwVGxTdAai7Kwg4ZCVfyMVhcwo8R2eW3QahBx34G0RKumK9sZ
ZQSQ+zULAzpY6uz7T1sAk/erMoivRXF6u8WvOsLkOD1F/Xyv1ZccSUG5YeDgZgc0nZUBvyIp
zXSHjgWerFkrxEM3y2z/Ff3eL1sgGYecV/I1F+I5S01V7Kclt/qRW10c/4JEGRcI1FmrJBPu
BtMYPbg/3Y9LZROYN+mVIFxZxOfrmjfFZ96xt/TaMXo8vcEKtWcNEjhGBjEbfMUEm4aq8ygQ
4MuEcpJc8DJCHBkg2KBk13DkbU2qNepTD6Uip1C+g+KMr0nd6KOJqSH27ZuNY4xqV4hIxFHp
ex0zY7mq6fV2o6sKBGQzRdI20FDYmNjsLJwjH6qJ8laxFphZnPRpBThmu0AjuBWE72GnI1oA
aO+bs92MQGJernt7hByCnDO82W/ykbVz+Ge3Sax8NY0m2Xdvp6WFDY/PjD9CdaJ9nwQGsUSa
N54lrZ2qMTeCI9Vauwf6U69BA42xgk65VvxvTNqji+tZ4aZbarZ7el2/QDHOb/rRwlCFplS/
z4l1f1nOrE6bnDl5RBJyW3zi74P6GwIDAQABo4IBWTCCAVUwDAYDVR0TAQH/BAIwADBWBglg
hkgBhvhCAQ0ESRZHVG8gZ2V0IHlvdXIgb3duIGNlcnRpZmljYXRlIGZvciBGUkVFIGhlYWQg
b3ZlciB0byBodHRwOi8vd3d3LkNBY2VydC5vcmcwDgYDVR0PAQH/BAQDAgOoMEAGA1UdJQQ5
MDcGCCsGAQUFBwMEBggrBgEFBQcDAgYKKwYBBAGCNwoDBAYKKwYBBAGCNwoDAwYJYIZIAYb4
QgQBMDIGCCsGAQUFBwEBBCYwJDAiBggrBgEFBQcwAYYWaHR0cDovL29jc3AuY2FjZXJ0Lm9y
ZzAxBgNVHR8EKjAoMCagJKAihiBodHRwOi8vY3JsLmNhY2VydC5vcmcvcmV2b2tlLmNybDA0
BgNVHREELTArgRRhaGZlcnJvaW43QGdtYWlsLmNvbYETYWhlbW1lbGdAb2hpb2d0LmNvbTAN
BgkqhkiG9w0BAQ0FAAOCAgEAGvl7xb42JMRH5D/vCIDYvFY3dR2FPd5kmOqpKU/fvQ8ovmJa
p5N/FDrsCL+YdslxPY+AAn78PYmL5pFHTdRadT++07DPIMtQyy2qd+XRmz6zP8Il7vGcEDmO
WmMLYMq4xV9s/N7t7JJp6ftdIYUcoTVChUgilDaRWMLidtslCdRsBVfUjPb1bF5Ua31diKDP
e0M9/e2CU36rbcTtiNCXhptMigzuL3zJXUf2B9jyUV8pnqNEQH36fqJ7YTBLcpq3aYa2XbAH
Hgx9GehJBIqwspDmhPCFZ/QmqUXCkt+XfvinQ2NzKR6P3+OdYbwqzVX8BdMeojh7Ig8x/nIx
mQ+/ufstL1ZYp0bg13fyK/hPYSIBpayaC76vzWovkIm70DIDRIFLi20p/qTd7rfDYy831Hjm
+lDdCECF9bIXEWFk33kA97dgQIMbf5chEmlFg8S0e4iw7LMjvRqMX3eCD8GJ2+oqyZUwzZxy
S0Mx+rBld5rrN7LsXwZ671HsGqNeYbYeU25e7t7/Gcc6Bd/kPfA+adEuUGFcvUKH3trDYqNq
6mOkAd8WO/mQadlc3ztS++XDMhmIpfBre9MPAr6usqf+wc+R8Nk9KLK39kEgrqVfzc/fgf8L
MaD4rHnusdg4gca6Yi+kNrm99anw7SwaBrBvULYBp7ixNRUhaYiNW4YjTrYxggShMIIEnQIB
ATCBgDB5MRAwDgYDVQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5v
cmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEW
EnN1cHBvcnRAY2FjZXJ0Lm9yZwIDEG5VMAkGBSsOAwIaBQCgggH1MBgGCSqGSIb3DQEJAzEL
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MDUwMTEyMjUyMlowIwYJKoZIhvcNAQkE
MRYEFL91rZofI1gF0GP+5cxBOoAillHFMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDEG5VMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDEG5V
MA0GCSqGSIb3DQEBAQUABIICADwHL+o/4RBIKZMp4tMbf//L7BGvOoajrqf+vTDDhjtDwSml
KwsSanWf+dhnXGhSV1Rdw9am1SdmP4gPyS6BiB5wFbfuBpEpUN8Lj+lhGyOAWS7mhOrpqvqd
oSVkyrz0skEo4JSLQHUHchJgmCDxr5fwrUWKSAYK94TfiAY/2EVaDHuUx6dBvBk+vg3g1bxj
xnyrftn1LG3Gyyu/dSb2z5OmCi+eg7007yPPb9wjlr/zkCFekWtoGXhVng9JgMHu0Z2AXM3G
hoMISNXffe55jGYsmAEvwswcjvlEwd3ifC4u1DNyuT2krWsQTPUoNgtwvTF9L5yOb/qgRHuw
jLx2AXZZa7ewIlTMJS+wVHvBXbbAk61GL20O9khzesIcfvfvvvmBB+2WpG6V3h3rhP85cJyA
XPg+zzOWbinED+OB1KK7mLPuCDP3nNvT+Te1piq6ZsWC+t3zH5Z/LnJZKxRnhK1ivAUcY3p9
7hr8d5DyEp8zaco0+K4/rS01aIdtiHq/31N1xVR8rNlWfjT7fX+Ebi4lKM5JvkSpnabCxOc0
LWC8ikrqgGjmqgGEdlB9jPhGfwjbuWUbz3W8E8hCvBjuQWsMgPlydqBjBzl6LWdMR/IPIgJB
GywPKkmJuh7dAqPoRUFkRA3w3E5Rlvgz2i2QOEzKPdie2pzOXacMz5gxxy8mAAAAAAAA
--------------ms080902020705030005040008--
