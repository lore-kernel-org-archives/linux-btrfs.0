From: Maciej Marcin Piechotka <uzytkownik2@gmail.com>
Subject: Regression in btrfs-next: BUG at fs/btrfs/super.c:984!
Date: Sat, 01 Oct 2011 23:43:10 +0200
Message-ID: <1317505390.2071.4.camel@picard>
Reply-To: uzytkownik2@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-ripemd160";
	protocol="application/pgp-signature"; boundary="=-40yoPcuwylhDQ8PmTEIA"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--=-40yoPcuwylhDQ8PmTEIA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

After merging btrfs-next patches (chris' btrfs-3.0 branch) I get
following error:

[ 9799.199495] ------------[ cut here ]------------
[ 9799.199511] kernel BUG at fs/btrfs/super.c:984!
[ 9799.199524] invalid opcode: 0000 [#1] PREEMPT SMP=20
[ 9799.199539] CPU 1=20
[ 9799.199542] Modules linked in: cpufreq_stats btrfs zlib_deflate
libcrc32c microcode reiserfs arc4 snd_hda_codec_conexant uvcvideo
cdc_ether usbnet videodev v4l2_compat_ioctl32 cdc_acm cdc_wdm btusb
snd_hda_intel iwlagn bluetooth mac80211 snd_hda_codec snd_hwdep snd_pcm
cfg80211 snd_timer snd soundcore snd_page_alloc e1000e thinkpad_acpi
hwmon rfkill nvram zcache(PC) zram(C) rtc_cmos tp_smapi thinkpad_ec
psmouse fscache kvm_intel kvm loop configs ipv6 autofs4 uhci_hcd
firewire_ohci sdhci_pci firewire_core sr_mod ehci_hcd sdhci mmc_core
crc_itu_t cdrom sd_mod usbcore
[ 9799.199657]=20
[ 9799.199669] Pid: 2263, comm: df Tainted: P         C  3.0.4-ck1+ #1
LENOVO 2242CTO/2242CTO
[ 9799.199686] RIP: 0010:[<ffffffffa032b682>]  [<ffffffffa032b682>]
btrfs_statfs+0x108/0x3a9 [btrfs]
[ 9799.199716] RSP: 0018:ffff8800414f9de8  EFLAGS: 00010246
[ 9799.199728] RAX: ffff880129bf8000 RBX: ffff8800414f9f00 RCX:
ffff880129bfa30c
[ 9799.199742] RDX: ffff880129c8e240 RSI: 000000009123683e RDI:
0000000000000000
[ 9799.199756] RBP: ffff880129bf8000 R08: ffffffff810d1ad0 R09:
0000000000000203
[ 9799.199769] R10: ffff88012254eab0 R11: 0000000000000203 R12:
ffff88011ba433c0
[ 9799.199783] R13: 0000000000000000 R14: 0000000000885fa0 R15:
ffff880129bfa368
[ 9799.199797] FS:  00007f15983f7700(0000) GS:ffff88013bc80000(0000)
knlGS:0000000000000000
[ 9799.199811] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 9799.199824] CR2: 00000000015fa008 CR3: 000000008e5d5000 CR4:
00000000000406e0
[ 9799.199838] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[ 9799.199851] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[ 9799.199865] Process df (pid: 2263, threadinfo ffff8800414f8000, task
ffff8800b8426780)
[ 9799.199878] Stack:
[ 9799.199889]  ffff8800414f9ed8 ffffffff810d1ad0 ffff88013162e4f8
ffffffff00000000
[ 9799.199906]  ffff880129f3c900 ffff88012cdf3800 ffff880129bf8000
0000000c430fe005
[ 9799.199923]  0000000000000000 ffff880132b0f540 ffff88011badc958
ffff880129bfa3c0
[ 9799.199940] Call Trace:
[ 9799.199955]  [<ffffffff810d1ad0>] ? user_path_at+0x55/0x7b
[ 9799.199971]  [<ffffffff810e5f2c>] ? statfs_by_dentry+0x46/0x5d
[ 9799.199985]  [<ffffffff810e5f56>] ? vfs_statfs+0x13/0x8b
[ 9799.199999]  [<ffffffff810d1ad0>] ? user_path_at+0x55/0x7b
[ 9799.200006]  [<ffffffff810e5ffe>] ? user_statfs+0x30/0x48
[ 9799.200006]  [<ffffffff810e6068>] ? sys_statfs+0x12/0x2b
[ 9799.200006]  [<ffffffff8136607b>] ? system_call_fastpath+0x16/0x1b
[ 9799.200006] Code: 18 48 89 33 4c 89 6b 20 48 89 43 08 48 8b 44 24 28
48 8b 80 20 01 00 00 48 8b 90 b8 23 00 00 48 89 44 24 30 8b 7a 30 85 ff
75 02 <0f> 0b 48 63 ff be 50 00 00 00 48 89 54 24 20 48 c1 e7 05 e8 56=20
[ 9799.200006] RIP  [<ffffffffa032b682>] btrfs_statfs+0x108/0x3a9
[btrfs]
[ 9799.200006]  RSP <ffff8800414f9de8>
[ 9799.221655] ---[ end trace 327e64ade405e154 ]---

PS. It might happened that it was caused by parition mounted read-only
on read-only block device.

--=-40yoPcuwylhDQ8PmTEIA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAABAwAGBQJOh4lyAAoJEJIdee2Vr4aPWYEQAKpbDogxEHb+grmebxWzA39q
oRIhpnB9ATLMYmN86rJcZ62vnjytyZcU9s3NenoxMh5p+GqUDtTViFrW1/vICrV9
zhTd8B//AANL1YL0XuKP950FE2fPOkO8ItT7A10fgqDKVikfYoGtXuYYVSaGlXVM
hWlKFVjw7kqJcFVw7wipF4/fD+TADl5fcTOBWUoGsjJoHqeXVqEjrSk/7BzzOyNZ
ZSEJnlvTo3J4ffOnDuzgDqUe1CkE+CK0KSh2VNv+UZhg9j8CnDxu604pvLqTQ5qm
7x2oJHMyq0ukUikEOZjY86MfKR7n0ZSjFpEndcMYETYjv7rfwomsNFVefzQoQ3Vg
jV26+af1HPuMBSDa4Un+UEyEQfnsiigmLjDQWbrELYM1XgyFLVKlmX6ewYmjTTXG
oXu+NlkMgnicgQwn+yHTJ9Y+xVzpqUOXLkixb3Tl90ivCR4/xlGzfRGKMNthflyq
uLY5Os+woLwR7rpxvs85E0+S5eFOZE/77azfN2ZFwzJk5KtRU9C1x0zytI1twIQN
VvfkaH9U7VGrKhNad+93WjqhYnz33QLa6G6s1ZWcxd68vk1Ab/QqjNj8RW9B8cIZ
aN/hYxaUmiPaJ2js3XWE5dH15vSXBRR7PIvvnJupBoMBjWrjANfjyJrffJTgeae7
+BwJN7kacWQuRA9S4gpJ
=y1XQ
-----END PGP SIGNATURE-----

--=-40yoPcuwylhDQ8PmTEIA--


