From: Stephane Chazelas <stephane.chazelas@gmail.com>
Subject: Re: cloning single-device btrfs file system onto multi-device one
Date: Tue, 22 Mar 2011 09:22:59 +0000
Message-ID: <chaz20110322092259.GA4861@seebyte.com>
References: <chaz20110321162450.GB918@seebyte.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <chaz20110321162450.GB918@seebyte.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011-03-21 16:24:50 +0000, Stephane Chazelas:
[...]
> I'm trying to move a btrfs FS that's on a hardware raid 5 (6TB
> large, 4 of which are in use) to another machine with 3 3TB HDs
> and preserve all the subvolumes/snapshots.
[...]

I tried one approach: export a LVM snapshot of the old fs as a
nbd device, mount it from the new machine (/dev/nbd0), then add
the new disks to the FS (btrfs add device) and then delete
/dev/nbd0 which I'd hope would relocate all the extents onto the
new disks.

I did some experiments with some loop devices but got all sorts
of results with different versions of kernels (debian unstable
2.6.37 and 2.6.38 amd64).

Here is what I did:

dd seek=512 bs=1M of=./a < /dev/null
dd seek=256 bs=1M of=./b < /dev/null
dd seek=256 bs=1M of=./c < /dev/null
mkfs.btrfs ./a
losetup /dev/loop0 ./a
losetup /dev/loop1 ./b
losetup /dev/loop2 ./c
mount /dev/loop0 /mnt
yes | head -c 300M > /mnt/test
btrfs device add /dev/loop1 /mnt
btrfs device add /dev/loop2 /mnt
# btrfs filesystem balance /mnt
btrfs device delete /dev/loop0 /mnt

In 2,6,38, upon the "balance" as well as upon the "delete", it
seemed to go in a loop, the system at 70% wait, and some 
btrfs: found 1 extents
2 to 3 times per second in dmesg. I tried leaving it on for a few
hours and it didn't help. The only thing I could do is reboot.
Disk usage of the a, b, c files were not increasing, though
dstat -d showed some disk writing at ~500kB/s (so I suppose it
was writing the same blocks over and over and seeking a lot).

In 2.6.37, I managed to have it working once, though I don't
know how and never managed to reproduce.

Upon the delete, I can see some relocations in dmesg output, but
then:

# btrfs device delete /dev/loop0 /mnt
ERROR: error removing the device '/dev/loop0'
(no error in dmesg)

Upon umount, here is what I find in dmesg:

[...]
[ 1802.357205] btrfs: relocating block group 0 flags 2
[ 1860.193351] ------------[ cut here ]------------
[ 1860.193373] WARNING: at /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/btrfs/volumes.c:544 __btrfs_close_devices+0xb5/0xd0 [btrfs]()
[ 1860.193379] Hardware name: MacBookPro4,1
[ 1860.193382] Modules linked in: btrfs libcrc32c hidp vboxnetadp vboxnetflt vboxdrv ip6table_filter ip6_tables ebtable_nat ebtables acpi_cpufreq mperf cpufreq_powersave cpufreq_userspace cpufreq_conservative cpufreq_stats ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables bridge stp parport_pc ppdev lp parport sco bnep rfcomm l2cap kvm_intel binfmt_misc kvm deflate ctr twofish_generic twofish_x86_64 twofish_common camellia serpent blowfish cast5 des_generic cbc cryptd aes_x86_64 aes_generic xcbc rmd160 sha512_generic sha256_generic sha1_generic hmac crypto_null af_key fuse nfsd exportfs nfs lockd fscache nfs_acl auth_rpcgss sunrpc loop dm_crypt snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd
 _hwdep snd_pcm_oss snd_mixer_oss snd_pcm uvcvideo videodev nouveau btusb bluetooth snd_seq_midi lib80211_crypt_tkip snd_rawmidi snd_seq_midi_event v4l1_compat rfkill snd_seq bcm5974 wl(P) ttm drm_kms_helper v4l2_compat_ioctl32 snd_timer snd_seq_device drm i2c_i801 i2c_algo_bit snd tpm_tis soundcore video snd_page_alloc lib80211 joydev i2c_core tpm tpm_bios battery ac applesmc input_polldev evdev pcspkr mbp_nvidia_bl output power_supply processor thermal_sys button ext4 mbcache jbd2 crc16 raid10 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 raid0 multipath linear md_mod nbd dm_mirror dm_region_hash dm_log dm_mod zlib_deflate crc32c sg sd_mod sr_mod cdrom crc_t10dif hid_apple usbhid hid ata_generic sata_sil24 uhci_hcd ata_piix libata ehci_hcd scsi_mo
 d usbcore sky2 firewire_ohci firewire_core crc_itu_t nls_base [last unloaded: uinput]
[ 1860.193550] Pid: 14808, comm: umount Tainted: P        W   2.6.37-2-amd64 #1
[ 1860.193552] Call Trace:
[ 1860.193561]  [<ffffffff81047084>] ? warn_slowpath_common+0x78/0x8c
[ 1860.193577]  [<ffffffffa0c74a4b>] ? __btrfs_close_devices+0xb5/0xd0 [btrfs]
[ 1860.193593]  [<ffffffffa0c74a83>] ? btrfs_close_devices+0x1d/0x70 [btrfs]
[ 1860.193610]  [<ffffffffa0c53e64>] ? close_ctree+0x2cd/0x32f [btrfs]
[ 1860.193616]  [<ffffffff8110580d>] ? dispose_list+0xa7/0xb9
[ 1860.193627]  [<ffffffffa0c3d1f3>] ? btrfs_put_super+0x10/0x1d [btrfs]
[ 1860.193633]  [<ffffffff810f5c67>] ? generic_shutdown_super+0x5c/0xd4
[ 1860.193638]  [<ffffffff810f5d1e>] ? kill_anon_super+0x9/0x40
[ 1860.193642]  [<ffffffff810f5794>] ? deactivate_locked_super+0x1e/0x3d
[ 1860.193647]  [<ffffffff8110928e>] ? sys_umount+0x2cf/0x2fa
[ 1860.193653]  [<ffffffff81009a12>] ? system_call_fastpath+0x16/0x1b
[ 1860.193656] ---[ end trace 4e4b8320dc6e70cc ]---


I can mount it back, but not if I reload the btrfs module, in which case I get:

[ 1961.328280] Btrfs loaded
[ 1961.328695] device fsid df4e5454eb7b1c23-7a68fc421060b18b devid 1 transid 118 /dev/loop0
[ 1961.329007] btrfs: failed to read the system array on loop0
[ 1961.340084] btrfs: open_ctree failed

I tried using nbds instead of loops (using qemu-nbd -c), and got
the same result (only a lot slower)

I there anything I'm doing wrong? Could the approach I'm trying
work in theory?

regards,
Stephane
