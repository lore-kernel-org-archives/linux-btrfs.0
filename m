Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay03.ispgateway.de ([80.67.31.37]:34257 "EHLO
        smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755769AbcH1RSs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Aug 2016 13:18:48 -0400
Received: from p4fce2f0a.dip0.t-ipconnect.de ([79.206.47.10] helo=[127.0.0.1])
        by smtprelay03.ispgateway.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.84)
        (envelope-from <hendrik@friedels.name>)
        id 1be3jC-00065n-FN
        for linux-btrfs@vger.kernel.org; Sun, 28 Aug 2016 19:18:38 +0200
From: "Hendrik Friedel" <hendrik@friedels.name>
To: "Btrfs BTRFS" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs check "Couldn't open file system" after error in transaction.c
Date: Sun, 28 Aug 2016 17:18:35 +0000
Message-Id: <em2efafb29-0071-4820-9248-cb2b9551d0fe@laptophendrik>
In-Reply-To: <em54d2d608-3b06-4e46-b795-214cf333e788@laptophendrik>
References: <em54d2d608-3b06-4e46-b795-214cf333e788@laptophendrik>
Reply-To: "Hendrik Friedel" <hendrik@friedels.name>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

some more info:
The system is Debian jessie with kernel 4.6.0 and btrfs-tools 4.6.

I did go through the recovery steps from the wiki:
-btrfs scrub to detect issues on live filesystems
see my original mail. Is aborted immediately

-look at btrfs detected errors in syslog (look at Marc's blog above on 
how to use sec.pl to do this)
see my original mail

-mount -o ro,recovery to mount a filesystem with issues
does work, but I get many errors like this one
[  325.360115] BTRFS info (device sdd): no csum found for inode 1703 
start 2072977408

-btrfs-zero-log might help in specific cases. Go read Btrfs-zero-log
I would like to get your ok and instructions on this first

-btrfs restore will help you copy data off a broken btrfs filesystem. 
See its page: Restore
see above. Recovering the data does seem to work with ro,recovery.
By the way: can I be sure somehow that the Data is correct when I read 
it this way, despite the "no csum found for inode" ?

-btrfs check --repair, aka btrfsck is your last option if the ones above 
have not worked.
Does not work:
"Couldn't open file system"

I also went through Marcs page:
http://marc.merlins.org/perso/btrfs/post_2014-03-19_Btrfs-Tips_-Btrfs-Scrub-and-Btrfs-Filesystem-Repair.html
but without further hints.

So I have now these objectives:
-If possible repair the filesystem
-Understand the reason behind the issue and prevent it in future
-If not possible to repair the filesystem:
    -understand if the data that I read from the drive is valid or 
corrupted

I'd appreciate your help on this.

Greetings,
Hendrik


------ Originalnachricht ------
Von: "Hendrik Friedel" <hendrik@friedels.name>
An: "Btrfs BTRFS" <linux-btrfs@vger.kernel.org>
Gesendet: 28.08.2016 12:04:18
Betreff: btrfs check "Couldn't open file system" after error in 
transaction.c

>Hello,
>
>I have a filesystem (three disks with no raid) that I can still mount 
>ro, but I cannot check or scrub it.
>In dmesg I see:
>[So Aug 28 11:33:22 2016] BTRFS error (device sde): parent transid 
>verify failed on 22168481054720 wanted 1826943 found 1828546
>[So Aug 28 11:33:22 2016] BTRFS warning (device sde): Skipping commit 
>of aborted transaction.
>(more complete at the end of this mail)
>
>What I did up to now in order to recover:
>- mount ro,recovery 
>(http://marc.merlins.org/perso/btrfs/post_2014-03-19_Btrfs-Tips_-Btrfs-Scrub-and-Btrfs-Filesystem-Repair.html)
>that works.
>btrfs check will lead to  "Couldn't open file system"
>
>root@homeserver:~# btrfs scrub start /mnt/test
>scrub started on /mnt/test, fsid a8af3832-48c7-4568-861f-e80380dd7e0b 
>(pid=18953)
>root@homeserver:~# btrfs scrub status /mnt/test
>scrub status for a8af3832-48c7-4568-861f-e80380dd7e0b
>        scrub started at Sun Aug 28 12:02:46 2016 and was aborted after 
>00:00:00
>        total bytes scrubbed: 0.00B with 0 errors
>
>First thing to do now is probably to check the backups. But is there a 
>way to repair this filesystem?
>
>Besides this: What could be the reason for this error?
>Scrubs were regular and good. There was no power loss and also smartctl 
>looks fine on all three drives.
>
>Greetings,
>Hendrik
>
>
>root@homeserver:~# btrfs fi show
>Label: 'BigStorage'  uuid: a8af3832-48c7-4568-861f-e80380dd7e0b
>        Total devices 3 FS bytes used 7.66TiB
>        devid    1 size 2.73TiB used 2.72TiB path /dev/sde
>        devid    2 size 2.73TiB used 2.72TiB path /dev/sdc
>        devid    3 size 2.73TiB used 2.73TiB path /dev/sdd
>
>
>[   98.534830] BTRFS error (device sde): parent transid verify failed 
>on 22168481054720 wanted 1826943 found 1828546
>[   98.534866] BTRFS error (device sde): parent transid verify failed 
>on 22168481054720 wanted 1826943 found 1828546
>[   98.534891] BTRFS error (device sde): parent transid verify failed 
>on 22168481054720 wanted 1826943 found 1828546
>[   98.534920] BTRFS warning (device sde): Skipping commit of aborted 
>transaction.
>[   98.534921] ------------[ cut here ]------------
>[   98.534939] WARNING: CPU: 1 PID: 3643 at 
>/home/zumbi/linux-4.6.4/fs/btrfs/transaction.c:1771 
>cleanup_transaction+0x96/0x300 [btrfs]
>[   98.534940] BTRFS: Transaction aborted (error -5)
>[   98.534940] Modules linked in: xt_nat(E) xt_tcpudp(E) veth(E) 
>ftdi_sio(E) usbserial(E) ipt_MASQUERADE(E) nf_nat_masquerade_ipv4(E) 
>xfrm_user(E) xfrm_algo(E) iptable_nat(E) nf_conntrack_ipv4(E) 
>nf_defrag_ipv4(E) nf_nat_ipv4(E) xt_addrtype(E) iptable_filter(E) 
>ip_tables(E) xt_conntrack(E) x_tables(E) nf_nat(E) nf_conntrack(E) 
>br_netfilter(E) bridge(E) stp(E) llc(E) cpufreq_stats(E) 
>cpufreq_userspace(E) cpufreq_conservative(E) cpufreq_powersave(E) 
>binfmt_misc(E) nfsd(E) auth_rpcgss(E) nfs_acl(E) nfs(E) lockd(E) 
>grace(E) fscache(E) sunrpc(E) snd_hda_codec_hdmi(E) iTCO_wdt(E) 
>iTCO_vendor_support(E) stv6110x(E) lnbp21(E) intel_rapl(E) 
>x86_pkg_temp_thermal(E) intel_powerclamp(E) coretemp(E) kvm_intel(E) 
>kvm(E) irqbypass(E) crct10dif_pclmul(E) crc32_pclmul(E) 
>ghash_clmulni_intel(E) cryptd(E) pcspkr(E) serio_raw(E)
>[   98.534963]  snd_hda_codec_realtek(E) snd_hda_codec_generic(E) 
>i2c_i801(E) i915(E) stv090x(E) snd_hda_intel(E) snd_hda_codec(E) 
>snd_hda_core(E) snd_hwdep(E) snd_pcm(E) drm_kms_helper(E) ngene(E) 
>ddbridge(E) snd_timer(E) snd(E) lpc_ich(E) mei_me(E) dvb_core(E) 
>mfd_core(E) drm(E) soundcore(E) mei(E) i2c_algo_bit(E) shpchp(E) 
>evdev(E) battery(E) tpm_tis(E) video(E) tpm(E) processor(E) button(E) 
>fuse(E) autofs4(E) btrfs(E) xor(E) raid6_pq(E) dm_mod(E) md_mod(E) 
>hid_generic(E) usbhid(E) hid(E) sg(E) sd_mod(E) ahci(E) libahci(E) 
>crc32c_intel(E) libata(E) psmouse(E) scsi_mod(E) fan(E) thermal(E) 
>xhci_pci(E) xhci_hcd(E) fjes(E) e1000e(E) ptp(E) pps_core(E) 
>ehci_pci(E) ehci_hcd(E) usbcore(E) usb_common(E)
>[   98.534988] CPU: 1 PID: 3643 Comm: btrfs-transacti Tainted: G        
>     E   4.6.0-0.bpo.1-amd64 #1 Debian 4.6.4-1~bpo8+1
>[   98.534989] Hardware name:                  /DH87RL, BIOS 
>RLH8710H.86A.0325.2014.0417.1800 04/17/2014
>[   98.534990]  0000000000000286 00000000007b2061 ffffffff813124c5 
>ffff8804a15f3d40
>[   98.534992]  0000000000000000 ffffffff8107af94 ffff8804e884ac10 
>ffff8804a15f3d98
>[   98.534993]  ffff8804b9bbc500 00000000fffffffb ffff8804e884ac10 
>00000000fffffffb
>[   98.534995] Call Trace:
>[   98.535000]  [<ffffffff813124c5>] ? dump_stack+0x5c/0x77
>[   98.535003]  [<ffffffff8107af94>] ? __warn+0xc4/0xe0
>[   98.535005]  [<ffffffff8107b00f>] ? warn_slowpath_fmt+0x5f/0x80
>[   98.535014]  [<ffffffffc02c28b6>] ? cleanup_transaction+0x96/0x300 
>[btrfs]
>[   98.535017]  [<ffffffff810bb6c0>] ? wait_woken+0x90/0x90
>[   98.535026]  [<ffffffffc02c3663>] ? 
>btrfs_commit_transaction+0x2b3/0xa30 [btrfs]
>[   98.535028]  [<ffffffff810bb6c0>] ? wait_woken+0x90/0x90
>[   98.535036]  [<ffffffffc02be76e>] ? transaction_kthread+0x1ce/0x1f0 
>[btrfs]
>[   98.535043]  [<ffffffffc02be5a0>] ? 
>btrfs_cleanup_transaction+0x590/0x590 [btrfs]
>[   98.535045]  [<ffffffff81099ecf>] ? kthread+0xdf/0x100
>[   98.535048]  [<ffffffff815c8772>] ? ret_from_fork+0x22/0x40
>[   98.535049]  [<ffffffff81099df0>] ? kthread_park+0x50/0x50
>[   98.535050] ---[ end trace 91a2f65df3d53d48 ]---
>[   98.535055] BTRFS: error (device sde) in cleanup_transaction:1771: 
>errno=-5 IO failure
>[   98.535059] BTRFS: error (device sde) in btrfs_drop_snapshot:9061: 
>errno=-5 IO failure
>[   98.535060] BTRFS info (device sde): forced readonly
>[   98.535571] BTRFS info (device sde): delayed_refs has NO entry
>[  689.672724] BTRFS info (device sde): disk space caching is enabled
>[  689.672727] BTRFS error (device sde): Remounting read-write after 
>error is not allowed
>[ 1124.707300] BTRFS info (device sde): disk space caching is enabled
>[ 1124.707303] BTRFS error (device sde): Remounting read-write after 
>error is not allowed


---
Diese E-Mail wurde von Avast Antivirus-Software auf Viren geprüft.
https://www.avast.com/antivirus

