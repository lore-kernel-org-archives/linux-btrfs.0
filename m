Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:51835 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab3HaX4H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 Aug 2013 19:56:07 -0400
Received: by mail-we0-f171.google.com with SMTP id p57so2671908wes.2
        for <linux-btrfs@vger.kernel.org>; Sat, 31 Aug 2013 16:56:05 -0700 (PDT)
Message-ID: <1377993349.5004.38.camel@pc-steven.LAN>
Subject: Re: Device delete returns "unable to go below four devices on
 raid10" on 5 drive setup
From: Steven Post <redalert.commander@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs@vger.kernel.org
Date: Sun, 01 Sep 2013 01:55:49 +0200
In-Reply-To: <A4758013-22BA-4552-B391-9492B42D85C5@colorremedies.com>
References: <1377943975.5426.17.camel@pc-steven.LAN>
	 <A4758013-22BA-4552-B391-9492B42D85C5@colorremedies.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-RTEdppQGfKlq+DAo4YQm"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-RTEdppQGfKlq+DAo4YQm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2013-08-31 at 11:42 -0600, Chris Murphy wrote:
> On Aug 31, 2013, at 4:12 AM, Steven Post <redalert.commander@gmail.com> w=
rote:
> >=20
> > The system is running Debian Wheezy (kernel 3.2.0-4-amd64 #1 SMP Debian
> > 3.2.46-1 x86_64).
> >=20
> > Is this something known (and possibly resolved in a later version), or
> > should I open a bug report about it?
>=20
> Try 3.10 or 3.11 before filing a bug on it.

I don't intend on upgrading the first machine at this point, but I'll
see if I can reproduce this on the second machine which is running
Debian Testing (Jessie), that one has a 3.10.7 kernel. Hugo Mills
suggested using a kernel from experimental, but I don't feel comfortable
at running that at this point, as that would be a 3.11-rc4 kernel, I
might consider it if the 3.11 release became available in 'unstable' (I
understand that Linus might release 3.11 this weekend) .
I might also consider running the 3.10 kernel from backports on the
first machine if that would be necessary for some reason, but we'll see.

>=20
> > Could it be that the device removal
> > was completed, but still shows as part of the array for some reason?
>=20
> Yes. It might take a few minutes after the chunks are reallocated for the=
 device to be removed from the volume. I've had some cases where even a reb=
oot was needed for the information in fi sh to refresh.

I see, so that might be normal behaviour. Although we're several hours
later now and there has been a reboot after the first time the "unable
to go below four drives" error. I did start a balance operation after
the reboot, we'll see what that gives. Once that completes, I intend to
try removing the device again with the 'device delete' command, if that
still gives the error I'll just remove the drive from the machine and go
from there.

>=20
>=20
> > The reason for the remove is actually that I want to (gradually) replac=
e
> > the 3TB drives with 1 TB ones, and somewhere in the middle move some of
> > the data of the array, to another machine, that currently has the 1 TB
> > drives which I intend to replace with the 3TB ones.
>=20
> Use a newer kernel for sure. What you suggest should work. If you're test=
ing to see if it does work, and you're prepared for it not working (i.e. to=
tally losing the entire file system) and prepared to find a consistent repr=
oducer if it doesn't work, then have at it.
>=20
> Otherwise, create a whole new btrfs volume with recent kernel and btrfs-p=
rogs on the other machine; and then rsync everything from old to new. Rsync=
 has a checksum option, it will take longer, but you can then be reasonably=
 assured of file integrity.

The plan was to switch 2 or 3 3TB drives with 1TB drives, then move data
using sftp (scp), and then switch the remaining drives, all this time
keeping the raid10 configuration. Except for the first switch on machine
2 as I didn't have the capacity to remove a single drive, so I had to
mount degraded.

As I was handling the second machine (3.10.7 kernel) the filesystem
suddenly became read-only during a device delete missing operation with
the a warning in /var/log/syslog (after already adding a new 3TB
device), I'll add the Call Trace from the log at the end of this message
for reference. After remounting (with -o degraded again) I issued a
balance which completed successfully, then the device delete command
immediately returned and the the filesystem seemed alright, with no sign
of data loss or corruption.

As an aside, I'd rather not recreate the arrays if it can be done
without recreating. On the other hand we're not talking about a mission
critical system, I wouldn't use btrfs for such a system at this point,
but for home use (with backups) or testing, things seem to be in good
shape.

>=20
>=20
> Chris Murphy

Thanks to all who replied for your responses.

Best regards,
Steven

PS: I forgot to mention it in my first mail, but please CC me, I'm not
subscribed to the list. I'll try to check the archives to see if I
missed anything though. I see I missed 1 reply on the list, while 1
reply was sent to me directly, and a third didn't even hit the list
archives (yet?) at spinics.net.

PPS: sorry if I seem to be rambling on a bit about everything in a
non-structured e-mail message.

/var/log/syslog (3.10-2-amd64 #1 SMP Debian 3.10.7-1 (2013-08-17)
x86_64):
[16431.789463] btrfs: relocating block group 1573890818048 flags 65
[16456.635819] btrfs: found 3392 extents
[16459.691201] BTRFS error (device sdb) in
btrfs_commit_transaction:1809: errno=3D-5 IO failure (Error while writing
out transaction)
[16459.691207] BTRFS info (device sdb): forced readonly
[16459.691210] BTRFS warning (device sdb): Skipping commit of aborted
transaction.
[16459.691212] ------------[ cut here ]------------
[16459.691252] WARNING:
at /build/linux-kDQkfE/linux-3.10.7/fs/btrfs/super.c:254
__btrfs_abort_transaction+0x4a/0xbe [btrfs]()
[16459.691253] btrfs: Transaction aborted (error -5)
[16459.691254] Modules linked in: rpcsec_gss_krb5 nfsv4 nfnetlink_queue
nfnetlink nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack xt_tcpudp
ip6table_filter ip6_tables ebtable_nat ebtables iptable_filter ip_tables
xt_iprange xt_state nf_conntrack ipt_REJECT xt_mark xt_NFQUEUE x_tables
parport_pc ppdev lp parport bnep rfcomm bluetooth snd_hrtimer pci_stub
vboxpci(O) vboxnetadp(O) cpufreq_userspace cpufreq_conservative
cpufreq_powersave cpufreq_stats vboxnetflt(O) vboxdrv(O) binfmt_misc
nfsd auth_rpcgss oid_registry nfs_acl nfs lockd dns_resolver fscache
sunrpc loop fuse joydev adt7475 hwmon_vid snd_hda_codec_realtek
snd_hda_intel coretemp snd_hda_codec snd_hwdep kvm_intel snd_pcm_oss
snd_mixer_oss kvm snd_pcm snd_page_alloc crc32c_intel snd_seq_midi
snd_seq_midi_event ghash_clmulni_intel snd_rawmidi snd_seq eeepc_wmi
iTCO_wdt asus_wmi iTCO_vendor_support sparse_keymap rfkill evdev
aesni_intel snd_seq_device snd_timer aes_x86_64 ablk_helper cryptd lrw
gf128mul glue_helper microcode pcspkr snd nouveau psmouse serio_raw
i2c_i801 mxm_wmi lpc_ich video mfd_core ttm drm_kms_helper drm mperf
i2c_algo_bit i2c_core soundcore wmi mei_me processor button mei
thermal_sys ext4 crc16 jbd2 mbcache btrfs xor zlib_deflate raid6_pq
crc32c libcrc32c dm_mod hid_generic md_mod usbhid hid sg sd_mod
crc_t10dif ata_generic xhci_hcd ehci_pci ehci_hcd pata_via ata_piix ahci
libahci usbcore usb_common libata r8169 mii scsi_mod
[16459.691308] CPU: 0 PID: 5381 Comm: btrfs Tainted: G           O
3.10-2-amd64 #1 Debian 3.10.7-1
[16459.691309] Hardware name: System manufacturer System Product
Name/P8H67, BIOS 1103 08/12/2011
[16459.691311]  0000000000000000 ffffffff8103bb5f ffff8801f75039f0
00000000fffffffb
[16459.691313]  ffff8801f7503a40 ffff88005ed243b0 ffffffffa01f5500
ffffffff8103bc0a
[16459.691315]  ffffffffa01f7288 0000000000000020 ffff8801f7503a50
ffff8801f7503a10
[16459.691317] Call Trace:
[16459.691323]  [<ffffffff8103bb5f>] ? warn_slowpath_common+0x5b/0x70
[16459.691326]  [<ffffffff8103bc0a>] ? warn_slowpath_fmt+0x47/0x49
[16459.691334]  [<ffffffffa017d657>] ? __btrfs_abort_transaction
+0x4a/0xbe [btrfs]
[16459.691344]  [<ffffffffa019dbbe>] ? cleanup_transaction+0x84/0x24f
[btrfs]
[16459.691347]  [<ffffffff81057c67>] ? abort_exclusive_wait+0x79/0x79
[16459.691357]  [<ffffffffa019d870>] ? btrfs_commit_transaction
+0x866/0x878 [btrfs]
[16459.691359]  [<ffffffff81057c67>] ? abort_exclusive_wait+0x79/0x79
[16459.691368]  [<ffffffffa019e0ae>] ? start_transaction+0x325/0x448
[btrfs]
[16459.691371]  [<ffffffff8105f669>] ? should_resched+0x5/0x23
[16459.691374]  [<ffffffff81384167>] ? mutex_lock+0xa/0x27
[16459.691384]  [<ffffffffa01d3988>] ? prepare_to_relocate+0xc2/0xd0
[btrfs]
[16459.691395]  [<ffffffffa01d7d45>] ? relocate_block_group+0x3d/0x4db
[btrfs]
[16459.691404]  [<ffffffffa01d8327>] ? btrfs_relocate_block_group
+0x144/0x268 [btrfs]
[16459.691415]  [<ffffffffa01b9c23>] ? btrfs_relocate_chunk.isra.59
+0x50/0x3f6 [btrfs]
[16459.691421]  [<ffffffffa017e0eb>] ? btrfs_item_key_to_cpu+0x12/0x30
[btrfs]
[16459.691432]  [<ffffffffa01af0fc>] ? btrfs_get_token_64+0x76/0xc6
[btrfs]
[16459.691442]  [<ffffffffa01b19a1>] ? release_extent_buffer+0x90/0x97
[btrfs]
[16459.691452]  [<ffffffffa01bbea0>] ? btrfs_shrink_device+0x1f8/0x35e
[btrfs]
[16459.691462]  [<ffffffffa01be84b>] ? btrfs_rm_device+0x2b8/0x690
[btrfs]
[16459.691472]  [<ffffffffa01c49ed>] ? btrfs_ioctl+0x8ee/0x197d [btrfs]
[16459.691474]  [<ffffffff810dee28>] ? handle_mm_fault+0x1f1/0x238
[16459.691476]  [<ffffffff81388c33>] ? __do_page_fault+0x32d/0x3cb
[16459.691479]  [<ffffffff81115f74>] ? vfs_ioctl+0x1b/0x25
[16459.691480]  [<ffffffff81116795>] ? do_vfs_ioctl+0x3e8/0x42a
[16459.691482]  [<ffffffff81116825>] ? SyS_ioctl+0x4e/0x79
[16459.691484]  [<ffffffff8138ade9>] ? system_call_fastpath+0x16/0x1b
[16459.691485] ---[ end trace 92cca53f6fe2bc37 ]---
[16459.691487] BTRFS error (device sdb) in cleanup_transaction:1449:
errno=3D-5 IO failure
[16459.691488] delayed_refs has NO entry

--=-RTEdppQGfKlq+DAo4YQm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQEcBAABAgAGBQJSIoKFAAoJEEvSpS1VyfkxswUH/jHi+yae1xL7U6jURx+fiw4A
dWoi9gHjrxPQux+VlobctSxHRQvpfQf55Cgl88saMxd8bxEcSqBPZfiwNKrJPSKN
jHUq5T3oEnM6SkKWNaq6u6z4plPHw1lLW9T9ejlgro1w5N758dKe+f4EjX/atgCQ
5bfDQhTpK/RdiC8wl1cMQpgIn/RNUdVgKqK2cIbqMJpJQUqpU17zB7wT/AM9BtBZ
c4IgUv/TF/JIUYO3nBy/P59/bRdvUPjtnLqSj74iYzj0WF0LlVPtRerFaF6hy0xv
cSW/VRvuQ9nmlzuhWc6vzz/3/+P47kRClUBthQHV1lB4I+28EbqVgu52dmm5v9M=
=YUIc
-----END PGP SIGNATURE-----

--=-RTEdppQGfKlq+DAo4YQm--

