Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from SD88.btc-net.bg ([212.39.90.88]:56498 "HELO sd88.btc-net.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751182AbaDWTiM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Apr 2014 15:38:12 -0400
From: =?UTF-8?B?0J/Qu9Cw0LzQtdC9INCf0LXRgtGA0L7Qsg==?=
	<plamen@petrovi.no-ip.info>
To: "'Marc MERLIN'" <marc@merlins.org>
Cc: <linux-btrfs@vger.kernel.org>
References: <000001cf5f19$ac92b2b0$05b81810$@petrovi.no-ip.info> <20140423185413.GF26949@merlins.org> <001401cf5f27$17cae590$4760b0b0$@petrovi.no-ip.info> <20140423191546.GG26949@merlins.org>
In-Reply-To: <20140423191546.GG26949@merlins.org>
Subject: RE: Can anyone boot a system using btrfs root with linux 3.14 or newer?
Date: Wed, 23 Apr 2014 22:37:44 +0300
Message-ID: <002401cf5f2b$7f8d41b0$7ea7c510$@petrovi.no-ip.info>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0025_01CF5F44.A4DA79B0"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multipart message in MIME format.

------=_NextPart_000_0025_01CF5F44.A4DA79B0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> -----Original Message-----
> From: Marc MERLIN [mailto:marc@merlins.org]
> Sent: Wednesday, April 23, 2014 10:16 PM
> To: =D0=9F=D0=BB=D0=B0=D0=BC=D0=B5=D0=BD =
=D0=9F=D0=B5=D1=82=D1=80=D0=BE=D0=B2
> Cc: linux-btrfs@vger.kernel.org
> Subject: Re: Can anyone boot a system using btrfs root with linux 3.14 =
or
> newer?
>=20
> On Wed, Apr 23, 2014 at 10:06:12PM +0300, =
=D0=9F=D0=BB=D0=B0=D0=BC=D0=B5=D0=BD =
=D0=9F=D0=B5=D1=82=D1=80=D0=BE=D0=B2 wrote:
> > Just to clarify - I am using a monolithic kernel built from source, =
and it has all
> the stuff it needs to support built-in, and then some. And no modules.
> > The sources I'm using are the vanilla kernels from Linus and Greg KH
> downloaded from kernel.org.
>=20
> Ok.
>=20
> > Check out the attached config I am using - it=E2=80=99s a kernel I'm =
running on one
> server and a couple of virtual machines.
>=20
> That's the working .config.
> I suggest you diff that one with the new one you have for 3.14
>=20
> > Until now - copying said config and doing a "make oldconfig" or =
"make
> olddefconfig" and compiling-then-booting worked fine.
>=20
> This should indeed work, this is what I do too.
>=20
> So now, we're kind of guessing. To save us all time, could you capture =
a serial
> console boot from the running 3.13 and then the failing 3.14.

Well, for the details - see for example here:
https://bugzilla.kernel.org/attachment.cgi?id=3D133111
how does a 3.14.1 built the way described earlier fails.

And for that matter - see the whole bugzilla bug entry - I went on and =
bisected this, using the linux-stable git tree, and after that landed me =
on the commit that introduces some "shiny new btrfs feature" for 3.14 - =
I decided my git bisection has gone wrong. And because I reported it on =
April 17-th and since then there has been no activity on the bugzilla =
entry besides me updating it - I posted my problem here, for more eyes =
to see.

>=20
> My guess is that if you diff both you'll likely find what went wrong, =
but if not
> you can post here.

See the result of "diff config-v3.14.1-mix64 config-v3.13.11-mix64" in =
the attached file.

>=20
> As for the btrfs FS format, it has not changed in a way that new =
kernels
> wouldn't be able to mount an FS from a year ago or more.

Good to know! Thanks!

>=20
> Marc
---------------------------------
Plamen Petrov

------=_NextPart_000_0025_01CF5F44.A4DA79B0
Content-Type: text/plain;
	name="diff-3.14.1-to-3.13.11.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="diff-3.14.1-to-3.13.11.txt"

 diff config-v3.14.1-mix64 config-v3.13.11-mix64=0A=
3c3=0A=
< # Linux/x86 3.14.1 Kernel Configuration=0A=
---=0A=
> # Linux/x86 3.13.11 Kernel Configuration=0A=
155a156=0A=
> # CONFIG_UIDGID_STRICT_TYPE_CHECKS is not set=0A=
230,234d230=0A=
< CONFIG_HAVE_CC_STACKPROTECTOR=3Dy=0A=
< # CONFIG_CC_STACKPROTECTOR is not set=0A=
< CONFIG_CC_STACKPROTECTOR_NONE=3Dy=0A=
< # CONFIG_CC_STACKPROTECTOR_REGULAR is not set=0A=
< # CONFIG_CC_STACKPROTECTOR_STRONG is not set=0A=
309d304=0A=
< # CONFIG_XEN_PVH is not set=0A=
358a354=0A=
> CONFIG_MICROCODE_INTEL_LIB=3Dy=0A=
407d402=0A=
< # CONFIG_ZSMALLOC is not set=0A=
419a415=0A=
> # CONFIG_CC_STACKPROTECTOR is not set=0A=
430d425=0A=
< # CONFIG_RANDOMIZE_BASE is not set=0A=
762,763d756=0A=
< # CONFIG_NET_SCH_HHF is not set=0A=
< # CONFIG_NET_SCH_PIE is not set=0A=
794,795c787=0A=
< # CONFIG_CGROUP_NET_PRIO is not set=0A=
< # CONFIG_CGROUP_NET_CLASSID is not set=0A=
---=0A=
> # CONFIG_NETPRIO_CGROUP is not set=0A=
944d935=0A=
< # CONFIG_GENWQE is not set=0A=
997a989=0A=
> # CONFIG_SCSI_AIC7XXX_OLD is not set=0A=
1158d1149=0A=
< CONFIG_DM_BUFIO=3Dy=0A=
1256d1246=0A=
< # CONFIG_I40EVF is not set=0A=
1489d1478=0A=
< CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=3Dy=0A=
1608d1596=0A=
< # CONFIG_I2C_DESIGNWARE_PLATFORM is not set=0A=
1622d1609=0A=
< # CONFIG_I2C_ROBOTFUZZ_OSIF is not set=0A=
1807a1795=0A=
> # CONFIG_CPU_THERMAL is not set=0A=
1811d1798=0A=
< # CONFIG_ACPI_INT3403_THERMAL is not set=0A=
1851d1837=0A=
< # CONFIG_MFD_MAX14577 is not set=0A=
1872d1857=0A=
< # CONFIG_MFD_LP3943 is not set=0A=
1904d1888=0A=
< CONFIG_INTEL_GTT=3Dy=0A=
1928d1911=0A=
< # CONFIG_DRM_I915_UMS is not set=0A=
1940d1922=0A=
< # CONFIG_DRM_BOCHS is not set=0A=
1978d1959=0A=
< # CONFIG_FB_OPENCORES is not set=0A=
2080a2062=0A=
> # CONFIG_HID_LOGITECH_DJ is not set=0A=
2184d2165=0A=
< # CONFIG_USB_MUSB_HDRC is not set=0A=
2186d2166=0A=
< # CONFIG_USB_DWC2 is not set=0A=
2225d2204=0A=
< # CONFIG_USB_OTG_FSM is not set=0A=
2269d2247=0A=
< # CONFIG_RTC_DRV_ISL12057 is not set=0A=
2403d2380=0A=
< CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=3Dy=0A=
2450a2428=0A=
> CONFIG_GENERIC_ACL=3Dy=0A=
2604d2581=0A=
< CONFIG_PANIC_TIMEOUT=3D0=0A=

------=_NextPart_000_0025_01CF5F44.A4DA79B0--

