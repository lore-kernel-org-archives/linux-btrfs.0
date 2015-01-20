Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:40132 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060AbbATM2D (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Jan 2015 07:28:03 -0500
Date: Tue, 20 Jan 2015 12:27:59 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: brett.king@commandict.com.au
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Recovery options for FS forced readonly due to 3.17 snapshot bug
Message-ID: <20150120122759.GM32182@carfax.org.uk>
References: <zarafa.54be46da.4c2a.173b20d60cef42a6@mascot.commandict.com.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KjJb61kpjaVQeLm7"
In-Reply-To: <zarafa.54be46da.4c2a.173b20d60cef42a6@mascot.commandict.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--KjJb61kpjaVQeLm7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 20, 2015 at 11:15:22PM +1100, brett.king@commandict.com.au wrote:
> Hi,
> My FS has been forced readonly by the early 3.17 snapshot bug. After much reading, I'm looking for validation of some recovery scenarios:
> 
> 1) btrfsck --repair under a later kernel.

   Kernel won't make a difference here, only the version of the btrfs
progs you're using, which should be "as recent as possible", but at
least 3.17 (best to try one of the 3.18.x releases).

   It's entirely possible that you've got a different issue as well
which is preventing the btrfs check from repairing the FS.

> 2) replacing the devices one by one under a later kernel, effectively removing the corruption.

   This won't work -- the FS would still try to migrate the broken
metadata.

> 3) Just copying data across from the readonly source to a new FS created under a later kernel.

   That would work.

> Option 1 with check only (not repair) segfaults and coredumps on 3.18 (see below) .. are there some other options needed here or perhaps patches pending to rectify this ?
> 
> Option 2 would be better than nothing, as I get to keep my snapshots and don't need any more surplus drives than 2x units of the largest size (data is RAID1).
> 
> Option 3 is a fallback and basically forfeits the source FS including snapshots, is guaranteed to work (I can read the data fine), however requires 1:1 capacity in new disks to achieve.
> 
> So being unable to complete a btrfsck check and generally scared off by a btrfsck -repair, will option 2 work ? I.E. can I still replace devices on a readonly FS ?
> 
> And are there any other options ?
> 
> Note the FS is very nearly full of data - I did also get continuous disk activity due to this high utilisation triggering the endless reclaim unused extent routine, for a few days prior to it being forced readonly.
> 
> [root@array ~]# uname -r
> 3.18.2-200.fc21.x86_64
> 
> (upgraded since getting the issue)
> 
> [root@array ~]# btrfsck /dev/sdm
> <snip>
> parent transid verify failed on 40198674350080 wanted 1623837 found 1622986
> Ignoring transid failure
> Segmentation fault (core dumped)

   Even at its worst, this should not be segfaulting. This should be
considered a bug in btrfs check at the very least.

   Hugo.

> [root@array ~]# btrfs fi sh /export/archive/
> Label: 'archive'  uuid: 22c7663a-93ca-40a6-9491-26abaa62b924
>         Total devices 8 FS bytes used 18.07TiB
>         devid    1 size 5.46TiB used 5.46TiB path /dev/sdm
>         devid    2 size 3.64TiB used 3.64TiB path /dev/sdc
>         devid    3 size 3.64TiB used 3.64TiB path /dev/sdd
>         devid    4 size 5.46TiB used 5.46TiB path /dev/sdl
>         devid    5 size 4.55TiB used 4.55TiB path /dev/sdb
>         devid    8 size 4.55TiB used 4.55TiB path /dev/sdj
>         devid    9 size 4.55TiB used 4.55TiB path /dev/sdk
>         devid   10 size 4.55TiB used 4.55TiB path /dev/sde
> 
> Btrfs v3.18.1
> 
> [root@array ~]# df -h /export/archive/
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/sdm         19T   19T  123G 100% /export/archive
> 
> [root@array ~]# btrfs fi df /export/archive/
> Data, RAID1: total=18.17TiB, used=18.05TiB
> System, RAID1: total=32.00MiB, used=3.00MiB
> Metadata, RAID1: total=23.00GiB, used=22.49GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> [root@array ~]# dmesg |grep -i btrfs |less
> [    2.044134] Btrfs loaded
> [    2.046327] BTRFS: device label array devid 1 transid 289965 /dev/sda4
> [    2.472321] BTRFS info (device sda4): disk space caching is enabled
> [    2.513784] BTRFS: detected SSD devices, enabling SSD mode
> [    2.985877] BTRFS info (device sda4): disk space caching is enabled
> [    3.520737] BTRFS: device label archive devid 5 transid 1623944 /dev/sdf
> [    3.544394] BTRFS: device label archive devid 3 transid 1623944 /dev/sdh
> [    3.544553] BTRFS: device label archive devid 10 transid 1623944 /dev/sdi
> [    3.544957] BTRFS: device label archive devid 2 transid 1623944 /dev/sdg
> [    3.614636] BTRFS: device label archive devid 9 transid 1623944 /dev/sdc
> [    3.663006] BTRFS: device label archive devid 8 transid 1623944 /dev/sdb
> [    3.663092] BTRFS: device label archive devid 4 transid 1623944 /dev/sdd
> [    3.685397] BTRFS: device label archive devid 1 transid 1623944 /dev/sde
> [    3.701732] BTRFS info (device sde): disk space caching is enabled
> [    3.903413] BTRFS: bdev /dev/sde errs: wr 2805, rd 1548, flush 0, corrupt 0, gen 0
> [    3.903421] BTRFS: bdev /dev/sdd errs: wr 2805, rd 0, flush 0, corrupt 0, gen 0
> [    3.903426] BTRFS: bdev /dev/sdb errs: wr 2805, rd 33, flush 0, corrupt 0, gen 0
> [    3.903430] BTRFS: bdev /dev/sdc errs: wr 2806, rd 0, flush 0, corrupt 0, gen 0
> [ 1432.231219] BTRFS: space cache generation (1623006) does not match inode (1623943)
> [ 1432.231283] BTRFS warning (device sde): failed to load free space cache for block group 57021632675840, rebuild it now
> [ 1434.603652] BTRFS (device sde): parent transid verify failed on 57022998740992 wanted 1623896 found 1622991
> [ 1434.608726] BTRFS (device sde): parent transid verify failed on 57022998740992 wanted 1623896 found 1622991
> [ 1434.919115] BTRFS (device sde): parent transid verify failed on 57022584373248 wanted 1623923 found 1622990
> [ 1434.937616] BTRFS (device sde): parent transid verify failed on 57022584373248 wanted 1623923 found 1622990
> [ 1434.937658] WARNING: CPU: 0 PID: 1571 at fs/btrfs/super.c:260 __btrfs_abort_transaction+0x54/0x120 [btrfs]()
> [ 1434.937660] BTRFS: Transaction aborted (error -5)
> [ 1434.937662] Modules linked in: binfmt_misc pl2303 iTCO_wdt iTCO_vendor_support intel_rapl x86_pkg_temp_thermal coretemp kvm_intel vfat fat kvm crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi snd_hda_intel snd_hda_controller mei_me snd_hda_codec mei ir_xmp_decoder ir_lirc_codec snd_seq lirc_dev ir_mce_kbd_decoder ir_sharp_decoder ir_sanyo_decoder i2c_i801 ir_sony_decoder lpc_ich ir_jvc_decoder snd_hwdep mfd_core ir_rc6_decoder ir_rc5_decoder ir_nec_decoder snd_seq_device snd_pcm i2c_hid tpm_tis tpm rc_rc6_mce i2c_designware_platform nuvoton_cir dw_dmac i2c_designware_core dw_dmac_core rc_core snd_timer snd soundcore nfsd auth_rpcgss nfs_acl lockd grace sunrpc btrfs xor i915 raid6_pq e1000e i2c_algo_bit drm_kms_helper drm
> [ 1434.937732] Workqueue: events_unbound btrfs_async_reclaim_metadata_space [btrfs]
> [ 1434.937779]  [<ffffffffa026c284>] __btrfs_abort_transaction+0x54/0x120 [btrfs]
> [ 1434.937795]  [<ffffffffa028a38a>] btrfs_run_delayed_refs.part.64+0x12a/0x280 [btrfs]
> [ 1434.937811]  [<ffffffffa028a4f7>] btrfs_run_delayed_refs+0x17/0x20 [btrfs]
> [ 1434.937829]  [<ffffffffa029b5c7>] btrfs_commit_transaction+0x407/0xa20 [btrfs]
> [ 1434.937843]  [<ffffffffa02823fa>] flush_space+0x9a/0x4e0 [btrfs]
> [ 1434.937857]  [<ffffffffa0281e90>] ? btrfs_get_alloc_profile+0x30/0x40 [btrfs]
> [ 1434.937870]  [<ffffffffa02822c4>] ? can_overcommit+0x54/0xf0 [btrfs]
> [ 1434.937883]  [<ffffffffa0282925>] btrfs_async_reclaim_metadata_space+0xe5/0x200 [btrfs]
> [ 1434.937920] BTRFS: error (device sde) in btrfs_run_delayed_refs:2792: errno=-5 IO failure
> [ 1434.937972] BTRFS info (device sde): forced readonly
> [ 1434.937975] BTRFS warning (device sde): Skipping commit of aborted transaction.
> [ 1434.937978] BTRFS: error (device sde) in cleanup_transaction:1607: errno=-5 IO failure
> [ 1435.424679] BTRFS (device sde): parent transid verify failed on 29792056147968 wanted 1623936 found 1623004
> [ 1435.522805] BTRFS (device sde): parent transid verify failed on 29792056999936 wanted 1623936 found 1623004
> [ 1435.565828] BTRFS (device sde): parent transid verify failed on 29792057737216 wanted 1623936 found 1623004
> [ 1435.651292] BTRFS (device sde): parent transid verify failed on 29790951227392 wanted 1623935 found 1623003
> [ 1435.718304] BTRFS (device sde): parent transid verify failed on 29790914019328 wanted 1623935 found 1623003
> [ 1435.754679] BTRFS (device sde): parent transid verify failed on 29790914592768 wanted 1623935 found 1623003
> [ 1439.616104] BTRFS (device sde): parent transid verify failed on 29793154777088 wanted 1623936 found 1623005
> [ 1439.622553] BTRFS (device sde): parent transid verify failed on 29796082139136 wanted 1623939 found 1622980
> [ 1439.635702] BTRFS (device sde): parent transid verify failed on 29795165683712 wanted 1623938 found 1623007
> [ 1439.639677] BTRFS (device sde): parent transid verify failed on 29796037656576 wanted 1623939 found 1622980
> [ 1439.644303] BTRFS (device sde): parent transid verify failed on 29792017874944 wanted 1623936 found 1623004
> [ 1439.653535] BTRFS (device sde): parent transid verify failed on 29795102965760 wanted 1623939 found 1623007
> [ 1439.663393] BTRFS (device sde): parent transid verify failed on 29793354055680 wanted 1623937 found 1623005
> [ 1439.666222] BTRFS (device sde): parent transid verify failed on 29795590062080 wanted 1623939 found 1623007
> [ 1439.677759] BTRFS (device sde): parent transid verify failed on 29798681542656 wanted 1623943 found 1622983
> [ 1439.693965] BTRFS (device sde): parent transid verify failed on 29795888676864 wanted 1623939 found 1623007
> [ 1444.624351] BTRFS (device sde): parent transid verify failed on 29799304413184 wanted 1623943 found 1622984
> [ 1444.640856] BTRFS (device sde): parent transid verify failed on 29794051571712 wanted 1623937 found 1623005
> [ 1444.654402] BTRFS (device sde): parent transid verify failed on 29796307681280 wanted 1623940 found 1622980
> [ 1444.667444] BTRFS (device sde): parent transid verify failed on 29796331765760 wanted 1623940 found 1622980
> [ 1444.677949] BTRFS (device sde): parent transid verify failed on 29795524362240 wanted 1623939 found 1623007
> [ 1444.687418] BTRFS (device sde): parent transid verify failed on 29799375421440 wanted 1623943 found 1622984
> [ 1444.694611] BTRFS (device sde): parent transid verify failed on 29797253136384 wanted 1623941 found 1622981
> [ 1444.708855] BTRFS (device sde): parent transid verify failed on 29796242833408 wanted 1623940 found 1622980
> [ 1444.717589] BTRFS (device sde): parent transid verify failed on 29795054223360 wanted 1623939 found 1623007
> [ 1444.719838] BTRFS (device sde): parent transid verify failed on 29797253316608 wanted 1623941 found 1622981
> 
> The FS mounts RW fine on boot, until a write is actually attempted, at which point it spits these errors - ultimately the write doesn't get committed & the FS gets forced readonly.
> 
> Thanks in advance !

-- 
Hugo Mills             | My code is never released, it escapes from the git
hugo@... carfax.org.uk | repo and kills a few beta testers on the way out
http://carfax.org.uk/  |
PGP: 65E74AC0          |                                             Diablo-D3

--KjJb61kpjaVQeLm7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUvknPAAoJEFheFHXiqx3k16oQALs0FJBS3sGz5dPuGfVza39K
+EOAgpPa1KRRO1JUI9s6IemHKPSDlDitGz4/1zjKWr/djXTq9I6Lb+Avj+xn6ipq
GRfjOMLtZqMTOd9gK027c8xcK5Kc2CxaoGv34uq+fykzOIUXwteMyiXIS6Su1R03
ZfWQFMjs9+6RyP7e20JCzxjsYUgQtL80raSsExpkq5Na0QUSHwcNET6q1WbZ6PN1
HY7ADTkRBQmXqslsKLnpDhg7jQ6qP+W0fp6LHXfAiJd8cbCLfwUOPHi+KM5qyQSf
0OG7KitpYLFYRi+fMB8bCmKnrgzCj0HkxsuABcRVG+SqltDSg2n8xAiNN5Hra8Ut
Ngsln7DoAqxI4hkIQAqtiKZp/vQFFLKsH3SqQEdBs5yFhvOx8ENZFDkFMgzypMJH
oThoEzxAxyK8TJ+Zj5ILVq84c8p1hehH0Ftp2liyfNU5m9nyWMo2MSzCMLrh9Ifa
utDqVzpxi9Yf/JA3Xst+C/bnxnDkahQUALPJQdTutBy0KRictOpDK1Ypz5hLRR/v
o4DtpjvXLGkEWuirKJTUXJiV/6zKxzNCB3VSIp4M9ep4RUi0TvwZBQTfmuaf5SP+
S0quitO0RiyGEXttrTdvkjW/VlQldpk0qCZ74+omalLiO6LbXXa+24Mqblz4F+hQ
IdH5THUVQ1+m8SdBdwaV
=R+Rj
-----END PGP SIGNATURE-----

--KjJb61kpjaVQeLm7--
