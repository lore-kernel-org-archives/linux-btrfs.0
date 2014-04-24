Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from SD88.btc-net.bg ([212.39.90.88]:55803 "HELO sd88.btc-net.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751789AbaDXVXr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Apr 2014 17:23:47 -0400
From: =?utf-8?B?0J/Qu9Cw0LzQtdC9INCf0LXRgtGA0L7Qsg==?=
	<plamen@petrovi.no-ip.info>
To: "'Chris Murphy'" <lists@colorremedies.com>
Cc: "'Marc MERLIN'" <marc@merlins.org>, <linux-btrfs@vger.kernel.org>
References: <000001cf5f19$ac92b2b0$05b81810$@petrovi.no-ip.info> <20140423185413.GF26949@merlins.org> <001401cf5f27$17cae590$4760b0b0$@petrovi.no-ip.info> <20140423191546.GG26949@merlins.org> <000501cf5fe1$55198590$ff4c90b0$@petrovi.no-ip.info> <20140424173317.GI7884@merlins.org>  <002301cf5fee$346fefc0$9d4fcf40$@petrovi.no-ip.info> <8953EAE6-E8DD-40DC-B485-128BE7CB4BA1@colorremedies.com>
In-Reply-To: <8953EAE6-E8DD-40DC-B485-128BE7CB4BA1@colorremedies.com>
Subject: RE: Can anyone boot a system using btrfs root with linux 3.14 or newer?
Date: Fri, 25 Apr 2014 00:23:26 +0300
Message-ID: <000201cf6003$6decaf30$49c60d90$@petrovi.no-ip.info>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0003_01CF601C.933C3120"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multipart message in MIME format.

------=_NextPart_000_0003_01CF601C.933C3120
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable

> -----Original Message-----
> From: Chris Murphy [mailto:lists@colorremedies.com]
> Sent: Friday, April 25, 2014 12:06 AM
> To: =D0=9F=D0=BB=D0=B0=D0=BC=D0=B5=D0=BD =
=D0=9F=D0=B5=D1=82=D1=80=D0=BE=D0=B2
> Cc: 'Marc MERLIN'; linux-btrfs@vger.kernel.org
> Subject: Re: Can anyone boot a system using btrfs root with linux 3.14 =
or
> newer?
>=20
>=20
> On Apr 24, 2014, at 12:51 PM, =D0=9F=D0=BB=D0=B0=D0=BC=D0=B5=D0=BD =
=D0=9F=D0=B5=D1=82=D1=80=D0=BE=D0=B2 <plamen@petrovi.no-ip.info>
> wrote:
> >
> > I booted 3.14.1 using sda3 as root, and then tried mounting sda2. It =
went
> OK, here is what dmesg said:
> > [   12.412465] Btrfs loaded
>=20
> For me, with Btrfs not compiled in the kernel, and with an initramfs, =
on SSD I
> get Btrfs loaded at 2.4 seconds. On HDD, it still happens by 6-7 =
seconds.
>=20

Well, the actual time doesn't matter - I use this monolithic kernel on =
both virtual machines as well as a physical server. Up until 3.13.x this =
arrangement worked flawlessly, now for 3.14.x - everything will be the =
same except me using BTRFS...

> So without an initrd and with btrfs compiled into the kernel I'd =
expect to see
> Btrfs loaded before 12.4 seconds. Is this an SSD? Or HDD, or hardware =
raid?

The most recent dmesg dumps were from a virtual machine.

>=20
> I'd like to see the dmesg from the beginning, until "Btrfs Loaded", =
for both
> 3.13.11 and 3.14.1 (via serial console output). I think the clue is in =
the part
> before Btrfs loaded.

I will try to provide these, but it will have to wait for tomorrow as =
currently my monolithic kernel .config does not support serial ports, so =
I will have to reconfigure, recompile both 3.13.x and 3.14.x to test =
them and provide the requested data.

>=20
> Also can you post a diff of the config file for the working 3.13.11 =
and not
> working 3.14.1 kernels?

The requested diff was posted earlier, reattaching once more.
---------------------------------
Plamen Petrov


------=_NextPart_000_0003_01CF601C.933C3120
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

------=_NextPart_000_0003_01CF601C.933C3120--

