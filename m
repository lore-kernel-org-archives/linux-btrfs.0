Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:46810 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751227AbbAWX3r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Jan 2015 18:29:47 -0500
Date: Fri, 23 Jan 2015 18:29:40 -0500
From: Zygo Blaxell <zblaxell@furryterror.org>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: 3.19-rc5: Bug 91911: [REGRESSION] rm command hangs big time with
 deleting a lot of files at once
Message-ID: <20150123232934.GA14858@hungrycats.org>
References: <2506104.3YBgc9qdaM@merkaba>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
In-Reply-To: <2506104.3YBgc9qdaM@merkaba>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 23, 2015 at 03:01:28PM +0100, Martin Steigerwald wrote:
> Hi!
>=20
> Anyone seen this?
>=20
> Reported as:
>=20
> https://bugzilla.kernel.org/show_bug.cgi?id=3D91911

I have seen something like this since 3.15.

I've also seen its cousin, which gets stuck in evict_inode, but the stacks
of the hanging processes start from renameat2() instead of unlinkat().
I haven't seen the renameat2() variant of this bug since 3.18-rc6.

> I just want to get rid of some 127000+ akonadi lost+found files, any dele=
te=20
> command I start just gets rid of some thousands and then hangs.
>=20
> merkaba:~> btrfs fi df /home
> Data, RAID1: total=3D160.92GiB, used=3D111.09GiB
> System, RAID1: total=3D32.00MiB, used=3D48.00KiB
> Metadata, RAID1: total=3D5.99GiB, used=3D2.49GiB
> GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
> merkaba:~> btrfs fi sh /home
> Label: 'home'  uuid: [=E2=80=A6]
>         Total devices 2 FS bytes used 113.58GiB
>         devid    1 size 170.00GiB used 166.94GiB path /dev/mapper/msata-
> home
>         devid    2 size 170.00GiB used 166.94GiB path /dev/mapper/sata-
> home
>=20
> Btrfs v3.18
>=20
>=20
> merkaba:/home/ms/.local/share/akonadi#1> find file_lost+found | wc -l =20
> 110070
> merkaba:/home/ms/.local/share/akonadi> find file_lost+found -delete &
> [4] 2660
> merkaba:/home/ms/.local/share/akonadi> find file_lost+found | wc -l =20
> 101645
> merkaba:/home/ms/.local/share/akonadi> find file_lost+found -delete &
> [5] 2663
> merkaba:/home/ms/.local/share/akonadi> find file_lost+found -delete &
> [6] 2664
> merkaba:/home/ms/.local/share/akonadi> find file_lost+found | wc -l =20
> 91369
> merkaba:/home/ms/.local/share/akonadi> find file_lost+found | wc -l
> 89844
> merkaba:/home/ms/.local/share/akonadi> find file_lost+found | wc -l
> 88042
> merkaba:/home/ms/.local/share/akonadi> find file_lost+found -delete &
> [7] 2671
> merkaba:/home/ms/.local/share/akonadi> uname -a
> Linux merkaba 3.19.0-rc5-tp520-trim-all-bgroups+ #18 SMP PREEMPT Mon Jan=
=20
> 19 09:58:33 CET 2015 x86_64 GNU/Linux
> merkaba:/home/ms/.local/share/akonadi> find file_lost+found -delete &
> [8] 2694
> merkaba:/home/ms/.local/share/akonadi> find file_lost+found -delete &
> [9] 2700
> merkaba:/home/ms/.local/share/akonadi> find file_lost+found | wc -l =20
> 67278
> merkaba:/home/ms/.local/share/akonadi> find file_lost+found | wc -l
> 65244
> merkaba:/home/ms/.local/share/akonadi> find file_lost+found | wc -l
> 63713
> merkaba:/home/ms/.local/share/akonadi> find file_lost+found | wc -l
> 62725
> merkaba:/home/ms/.local/share/akonadi> find file_lost+found | wc -l
> 62213
> merkaba:/home/ms/.local/share/akonadi> find file_lost+found | wc -l
> 61213
> merkaba:/home/ms/.local/share/akonadi> find file_lost+found -delete &
> [10] 2715
> merkaba:/home/ms/.local/share/akonadi> find file_lost+found | wc -l =20
> 60470
> merkaba:/home/ms/.local/share/akonadi> find file_lost+found -delete &
> [11] 2718
> merkaba:/home/ms/.local/share/akonadi> find file_lost+found | wc -l =20
> 53303
>=20
>=20
> merkaba:/home/ms/.local/share/akonadi> find file_lost+found | wc -l
> 51396
> merkaba:/home/ms/.local/share/akonadi> find file_lost+found | wc -l
> 51396
> merkaba:/home/ms/.local/share/akonadi> find file_lost+found | wc -l
> 51396
>=20
>=20
> merkaba:/home/ms/.local/share/akonadi> ps aux | grep find
> ms        2647  0.4  0.2  43096 36204 pts/3    D+   14:45   0:00 find=20
> file_lost+found -delete
> root      2651  0.3  0.2  42568 35688 pts/0    DN   14:45   0:00 find=20
> file_lost+found -delete
> root      2654  2.7  0.2  44544 35652 pts/0    DN   14:46   0:05 find=20
> file_lost+found -delete
> root      2657  0.3  0.2  44016 35048 pts/0    DN   14:46   0:00 find=20
> file_lost+found -delete
> root      2660  2.1  0.1  39136 32280 pts/0    DN   14:46   0:03 find=20
> file_lost+found -delete
> root      2663  0.2  0.1  36760 29988 pts/0    DN   14:46   0:00 find=20
> file_lost+found -delete
> root      2664  3.3  0.1  36760 29888 pts/0    DN   14:46   0:05 find=20
> file_lost+found -delete
> root      2671  0.9  0.1  33856 26984 pts/0    DN   14:46   0:01 find=20
> file_lost+found -delete
> root      2694  1.1  0.1  32404 25380 pts/0    DN   14:47   0:01 find=20
> file_lost+found -delete
> root      2700  4.0  0.1  30952 24064 pts/0    DN   14:47   0:04 find=20
> file_lost+found -delete
> root      2715  0.3  0.1  26200 19332 pts/0    DN   14:47   0:00 find=20
> file_lost+found -delete
> root      2718  4.1  0.1  26068 19068 pts/0    DN   14:47   0:02 find=20
> file_lost+found -delete
> root      2840  0.0  0.0  12672  1592 pts/0    S+   14:49   0:00 grep find
> merkaba:/home/ms/.local/share/akonadi> ps aux | grep rm =20
> root       113  0.0  0.0      0     0 ?        S<   14:41   0:00=20
> [acpi_thermal_pm]
> root       290  0.0  0.0      0     0 ?        S<   14:41   0:00 [btrfs-
> rmw]
> root       803  0.0  0.0      0     0 ?        S<   14:41   0:00 [btrfs-
> rmw]
> root       835  0.0  0.0      0     0 ?        S<   14:41   0:00 [btrfs-
> rmw]
> dirmngr   1565  0.0  0.0  17880  2192 ?        Ss   14:41   0:00=20
> /usr/bin/dirmngr --daemon --sh
> ms        2615  0.4  0.2  36276 32432 pts/1    D+   14:43   0:01 rm -r=20
> file_lost+found
> root      2842  0.0  0.0  12676  1544 pts/0    S+   14:49   0:00 grep rm
>=20
>=20
> Until it eventually completes:
>=20
> merkaba:/home/ms/.local/share/akonadi> find file_lost+found -delete &
> [20] 2858
> merkaba:/home/ms/.local/share/akonadi> find file_lost+found | wc -l =20
> 8998
> merkaba:/home/ms/.local/share/akonadi> find file_lost+found | wc -l =20
> 240
> merkaba:/home/ms/.local/share/akonadi>=20
> [20]  + done       find file_lost+found -delete
> merkaba:/home/ms/.local/share/akonadi> find file_lost+found | wc -l
> find: "file_lost+found": Datei oder Verzeichnis nicht gefunden
> 0
>=20
>=20
> I see these in dmesg:
>=20
> [  240.145442] INFO: task rm:2615 blocked for more than 120 seconds.
> [  240.145456]       Tainted: G           O   3.19.0-rc5-tp520-trim-all-
> bgroups+ #18
> [  240.145461] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s=20
> this message.
> [  240.145466] rm              D ffff88034c3fbc68     0  2615   2589=20
> 0x00000000
> [  240.145480]  ffff88034c3fbc68 0000000000000002 ffff88040bdf6180=20
> ffff88034c3fbfd8
> [  240.145490]  ffff88035ad9b0c0 0000000000012d00 ffff88035ad9b0c0=20
> ffff88034c3fbc78
> [  240.145499]  0000000000000000 ffff8803787de080 ffff8803790547fc=20
> ffff88034c3fbcd8
> [  240.145508] Call Trace:
> [  240.145527]  [<ffffffff814b7d16>] schedule+0x64/0x66
> [  240.145622]  [<ffffffffc05361c4>] lock_extent_bits+0x103/0x18b [btrfs]
> [  240.145633]  [<ffffffff8106ecb5>] ? finish_wait+0x5f/0x5f
> [  240.145693]  [<ffffffffc0527f5e>] btrfs_evict_inode+0x14a/0x420 [btrfs]
> [  240.145711]  [<ffffffff81151aec>] evict+0xa8/0x150
> [  240.145719]  [<ffffffff811521c6>] iput+0x128/0x131
> [  240.145743]  [<ffffffffc05c0577>] ecryptfs_evict_inode+0x29/0x2d [ecry=
ptfs]
> [  240.145760]  [<ffffffffc05c054e>] ? ecryptfs_show_options+0x11e/0x11e=
=20
> [ecryptfs]
> [  240.145768]  [<ffffffff81151aec>] evict+0xa8/0x150
> [  240.145776]  [<ffffffff811521c6>] iput+0x128/0x131
> [  240.145786]  [<ffffffff811497bf>] do_unlinkat+0x151/0x1f0
> [  240.145795]  [<ffffffff8100cf94>] ? user_exit+0x13/0x15
> [  240.145803]  [<ffffffff8100e24e>] ? syscall_trace_enter_phase1+0x57/0x=
12a
> [  240.145811]  [<ffffffff8100e565>] ? syscall_trace_leave+0xcb/0x108
> [  240.145820]  [<ffffffff8114a313>] SyS_unlinkat+0x24/0x26
> [  240.145828]  [<ffffffff814bac92>] system_call_fastpath+0x12/0x17
> [  300.753192] mce: [Hardware Error]: Machine check events logged
> [  360.164930] INFO: task rm:2615 blocked for more than 120 seconds.
> [  360.164935]       Tainted: G           O   3.19.0-rc5-tp520-trim-all-
> bgroups+ #18
> [  360.164936] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s=20
> this message.
> [  360.164937] rm              D ffff88034c3fbc68     0  2615   2589=20
> 0x00000000
> [  360.164941]  ffff88034c3fbc68 0000000000000002 ffff88040bdf6180=20
> ffff88034c3fbfd8
> [  360.164944]  ffff88035ad9b0c0 0000000000012d00 ffff88035ad9b0c0=20
> ffff88034c3fbc78
> [  360.164946]  0000000000000000 ffff8803787de080 ffff8803790547fc=20
> ffff88034c3fbcd8
> [  360.164949] Call Trace:
> [  360.164956]  [<ffffffff814b7d16>] schedule+0x64/0x66
> [  360.164992]  [<ffffffffc05361c4>] lock_extent_bits+0x103/0x18b [btrfs]
> [  360.164995]  [<ffffffff8106ecb5>] ? finish_wait+0x5f/0x5f
> [  360.165011]  [<ffffffffc0527f5e>] btrfs_evict_inode+0x14a/0x420 [btrfs]
> [  360.165016]  [<ffffffff81151aec>] evict+0xa8/0x150
> [  360.165019]  [<ffffffff811521c6>] iput+0x128/0x131
> [  360.165026]  [<ffffffffc05c0577>] ecryptfs_evict_inode+0x29/0x2d [ecry=
ptfs]
> [  360.165030]  [<ffffffffc05c054e>] ? ecryptfs_show_options+0x11e/0x11e=
=20
> [ecryptfs]
> [  360.165032]  [<ffffffff81151aec>] evict+0xa8/0x150
> [  360.165034]  [<ffffffff811521c6>] iput+0x128/0x131
> [  360.165037]  [<ffffffff811497bf>] do_unlinkat+0x151/0x1f0
> [  360.165041]  [<ffffffff8100cf94>] ? user_exit+0x13/0x15
> [  360.165043]  [<ffffffff8100e24e>] ? syscall_trace_enter_phase1+0x57/0x=
12a
> [  360.165045]  [<ffffffff8100e565>] ? syscall_trace_leave+0xcb/0x108
> [  360.165048]  [<ffffffff8114a313>] SyS_unlinkat+0x24/0x26
> [  360.165051]  [<ffffffff814bac92>] system_call_fastpath+0x12/0x17
> [  360.165053] INFO: task find:2647 blocked for more than 120 seconds.
> [  360.165055]       Tainted: G           O   3.19.0-rc5-tp520-trim-all-
> bgroups+ #18
> [  360.165056] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s=20
> this message.
> [  360.165057] find            D ffff8803bea5fcb8     0  2647   2631=20
> 0x00000000
> [  360.165059]  ffff8803bea5fcb8 0000000000000002 ffff880409ab0000=20
> ffff8803bea5ffd8
> [  360.165061]  ffff88035ad99860 0000000000012d00 ffff88035ad99860=20
> ffff8803bea5fcc8
> [  360.165064]  0000000000000000 ffff880347279f48 ffff8800a108573c=20
> ffff8803bea5fd28
> [  360.165066] Call Trace:
> [  360.165069]  [<ffffffff814b7d16>] schedule+0x64/0x66
> [  360.165085]  [<ffffffffc05361c4>] lock_extent_bits+0x103/0x18b [btrfs]
> [  360.165087]  [<ffffffff8106ecb5>] ? finish_wait+0x5f/0x5f
> [  360.165101]  [<ffffffffc0527f5e>] btrfs_evict_inode+0x14a/0x420 [btrfs]
> [  360.165105]  [<ffffffff81151aec>] evict+0xa8/0x150
> [  360.165107]  [<ffffffff811521c6>] iput+0x128/0x131
> [  360.165110]  [<ffffffff8114e6aa>] __dentry_kill+0x113/0x17d
> [  360.165112]  [<ffffffff8114e84a>] dput+0x136/0x15e
> [  360.165115]  [<ffffffff8113e635>] __fput+0x16a/0x181
> [  360.165117]  [<ffffffff8113e67a>] ____fput+0x9/0xb
> [  360.165120]  [<ffffffff810569e5>] task_work_run+0x85/0x9c
> [  360.165122]  [<ffffffff810028d7>] do_notify_resume+0x5b/0x82
> [  360.165124]  [<ffffffff814baeff>] int_signal+0x12/0x17
> [  480.184844] INFO: task rm:2615 blocked for more than 120 seconds.
> [  480.184859]       Tainted: G           O   3.19.0-rc5-tp520-trim-all-
> bgroups+ #18
> [  480.184863] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s=20
> this message.
> [  480.184868] rm              D ffff88034c3fbc68     0  2615   2589=20
> 0x00000000
> [  480.184881]  ffff88034c3fbc68 0000000000000002 ffff88040bdf6180=20
> ffff88034c3fbfd8
> [  480.184891]  ffff88035ad9b0c0 0000000000012d00 ffff88035ad9b0c0=20
> ffff88034c3fbc78
> [  480.184900]  0000000000000000 ffff8803787de080 ffff8803790547fc=20
> ffff88034c3fbcd8
> [  480.184910] Call Trace:
> [  480.184929]  [<ffffffff814b7d16>] schedule+0x64/0x66
> [  480.185024]  [<ffffffffc05361c4>] lock_extent_bits+0x103/0x18b [btrfs]
> [  480.185034]  [<ffffffff8106ecb5>] ? finish_wait+0x5f/0x5f
> [  480.185096]  [<ffffffffc0527f5e>] btrfs_evict_inode+0x14a/0x420 [btrfs]
> [  480.185112]  [<ffffffff81151aec>] evict+0xa8/0x150
> [  480.185121]  [<ffffffff811521c6>] iput+0x128/0x131
> [  480.185145]  [<ffffffffc05c0577>] ecryptfs_evict_inode+0x29/0x2d [ecry=
ptfs]
> [  480.185161]  [<ffffffffc05c054e>] ? ecryptfs_show_options+0x11e/0x11e=
=20
> [ecryptfs]
> [  480.185169]  [<ffffffff81151aec>] evict+0xa8/0x150
> [  480.185177]  [<ffffffff811521c6>] iput+0x128/0x131
> [  480.185186]  [<ffffffff811497bf>] do_unlinkat+0x151/0x1f0
> [  480.185195]  [<ffffffff8100cf94>] ? user_exit+0x13/0x15
> [  480.185203]  [<ffffffff8100e24e>] ? syscall_trace_enter_phase1+0x57/0x=
12a
> [  480.185211]  [<ffffffff8100e565>] ? syscall_trace_leave+0xcb/0x108
> [  480.185220]  [<ffffffff8114a313>] SyS_unlinkat+0x24/0x26
> [  480.185228]  [<ffffffff814bac92>] system_call_fastpath+0x12/0x17
> [  480.185236] INFO: task find:2647 blocked for more than 120 seconds.
> [  480.185241]       Tainted: G           O   3.19.0-rc5-tp520-trim-all-
> bgroups+ #18
> [  480.185245] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s=20
> this message.
> [  480.185249] find            D ffff8803bea5fcb8     0  2647   2631=20
> 0x00000000
> [  480.185284]  ffff8803bea5fcb8 0000000000000002 ffff880409ab0000=20
> ffff8803bea5ffd8
> [  480.185293]  ffff88035ad99860 0000000000012d00 ffff88035ad99860=20
> ffff8803bea5fcc8
> [  480.185302]  0000000000000000 ffff880347279f48 ffff8800a108573c=20
> ffff8803bea5fd28
> [  480.185311] Call Trace:
> [  480.185321]  [<ffffffff814b7d16>] schedule+0x64/0x66
> [  480.185382]  [<ffffffffc05361c4>] lock_extent_bits+0x103/0x18b [btrfs]
> [  480.185390]  [<ffffffff8106ecb5>] ? finish_wait+0x5f/0x5f
> [  480.185444]  [<ffffffffc0527f5e>] btrfs_evict_inode+0x14a/0x420 [btrfs]
> [  480.185458]  [<ffffffff81151aec>] evict+0xa8/0x150
> [  480.185467]  [<ffffffff811521c6>] iput+0x128/0x131
> [  480.185474]  [<ffffffff8114e6aa>] __dentry_kill+0x113/0x17d
> [  480.185481]  [<ffffffff8114e84a>] dput+0x136/0x15e
> [  480.185491]  [<ffffffff8113e635>] __fput+0x16a/0x181
> [  480.185499]  [<ffffffff8113e67a>] ____fput+0x9/0xb
> [  480.185506]  [<ffffffff810569e5>] task_work_run+0x85/0x9c
> [  480.185514]  [<ffffffff810028d7>] do_notify_resume+0x5b/0x82
> [  480.185521]  [<ffffffff814baeff>] int_signal+0x12/0x17
> [  480.185528] INFO: task find:2651 blocked for more than 120 seconds.
> [  480.185533]       Tainted: G           O   3.19.0-rc5-tp520-trim-all-
> bgroups+ #18
> [  480.185537] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s=20
> this message.
> [  480.185540] find            D ffff880099213cb8     0  2651   2562=20
> 0x00000000
> [  480.185548]  ffff880099213cb8 0000000000000002 ffffffff81a16500=20
> ffff880099213fd8
> [  480.185557]  ffff88035ad98000 0000000000012d00 ffff88035ad98000=20
> ffff880099213cc8
> [  480.185565]  0000000000001000 ffff880347594340 ffff8803516131ec=20
> ffff880099213d28
> [  480.185574] Call Trace:
> [  480.185583]  [<ffffffff814b7d16>] schedule+0x64/0x66
> [  480.185640]  [<ffffffffc05361c4>] lock_extent_bits+0x103/0x18b [btrfs]
> [  480.185689]  [<ffffffff8106ecb5>] ? finish_wait+0x5f/0x5f
> [  480.185758]  [<ffffffffc0527f5e>] btrfs_evict_inode+0x14a/0x420 [btrfs]
> [  480.185797]  [<ffffffff81151aec>] evict+0xa8/0x150
> [  480.185821]  [<ffffffff811521c6>] iput+0x128/0x131
> [  480.185844]  [<ffffffff8114e6aa>] __dentry_kill+0x113/0x17d
> [  480.185867]  [<ffffffff8114e84a>] dput+0x136/0x15e
> [  480.185890]  [<ffffffff8113e635>] __fput+0x16a/0x181
> [  480.185913]  [<ffffffff8113e67a>] ____fput+0x9/0xb
> [  480.185930]  [<ffffffff810569e5>] task_work_run+0x85/0x9c
> [  480.185938]  [<ffffffff810028d7>] do_notify_resume+0x5b/0x82
> [  480.185947]  [<ffffffff814baeff>] int_signal+0x12/0x17
> [  480.185956] INFO: task find:2654 blocked for more than 120 seconds.
> [  480.185965]       Tainted: G           O   3.19.0-rc5-tp520-trim-all-
> bgroups+ #18
> [  480.185971] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s=20
> this message.
> [  480.185976] find            D ffff880330453cb8     0  2654   2562=20
> 0x00000000
> [  480.185987]  ffff880330453cb8 0000000000000002 ffff88040ba96180=20
> ffff880330453fd8
> [  480.185999]  ffff88035d029860 0000000000012d00 ffff88035d029860=20
> ffff880330453cc8
> [  480.186010]  0000000000002000 ffff8803472f4028 ffff8800a10871ec=20
> ffff880330453d28
> [  480.186022] Call Trace:
> [  480.186034]  [<ffffffff814b7d16>] schedule+0x64/0x66
> [  480.186093]  [<ffffffffc05361c4>] lock_extent_bits+0x103/0x18b [btrfs]
> [  480.186104]  [<ffffffff8106ecb5>] ? finish_wait+0x5f/0x5f
> [  480.186164]  [<ffffffffc0527f5e>] btrfs_evict_inode+0x14a/0x420 [btrfs]
> [  480.186191]  [<ffffffff81151aec>] evict+0xa8/0x150
> [  480.186221]  [<ffffffff811521c6>] iput+0x128/0x131
> [  480.186243]  [<ffffffff8114e6aa>] __dentry_kill+0x113/0x17d
> [  480.186252]  [<ffffffff8114e84a>] dput+0x136/0x15e
> [  480.186262]  [<ffffffff8113e635>] __fput+0x16a/0x181
> [  480.186272]  [<ffffffff8113e67a>] ____fput+0x9/0xb
> [  480.186281]  [<ffffffff810569e5>] task_work_run+0x85/0x9c
> [  480.186290]  [<ffffffff810028d7>] do_notify_resume+0x5b/0x82
> [  480.186316]  [<ffffffff814baeff>] int_signal+0x12/0x17
> [  480.186325] INFO: task find:2657 blocked for more than 120 seconds.
> [  480.186332]       Tainted: G           O   3.19.0-rc5-tp520-trim-all-
> bgroups+ #18
> [  480.186348] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s=20
> this message.
> [  480.186353] find            D ffff880327f23cb8     0  2657   2562=20
> 0x00000000
> [  480.186370]  ffff880327f23cb8 0000000000000002 ffff88040b811860=20
> ffff880327f23fd8
> [  480.186381]  ffff88035d3f9860 0000000000012d00 ffff88035d3f9860=20
> ffff880327f23cc8
> [  480.186393]  0000000000001000 ffff880353fb3e98 ffff88037664042c=20
> ffff880327f23d28
> [  480.186404] Call Trace:
> [  480.186416]  [<ffffffff814b7d16>] schedule+0x64/0x66
> [  480.186472]  [<ffffffffc05361c4>] lock_extent_bits+0x103/0x18b [btrfs]
> [  480.186483]  [<ffffffff8106ecb5>] ? finish_wait+0x5f/0x5f
> [  480.186543]  [<ffffffffc0527f5e>] btrfs_evict_inode+0x14a/0x420 [btrfs]
> [  480.186560]  [<ffffffff81151aec>] evict+0xa8/0x150
> [  480.186570]  [<ffffffff811521c6>] iput+0x128/0x131
> [  480.186579]  [<ffffffff8114e6aa>] __dentry_kill+0x113/0x17d
> [  480.186589]  [<ffffffff8114e84a>] dput+0x136/0x15e
> [  480.186601]  [<ffffffff8113e635>] __fput+0x16a/0x181
> [  480.186633]  [<ffffffff8113e67a>] ____fput+0x9/0xb
> [  480.186676]  [<ffffffff810569e5>] task_work_run+0x85/0x9c
> [  480.186705]  [<ffffffff810028d7>] do_notify_resume+0x5b/0x82
> [  480.186716]  [<ffffffff814baeff>] int_signal+0x12/0x17
> [  480.186727] INFO: task find:2660 blocked for more than 120 seconds.
> [  480.186734]       Tainted: G           O   3.19.0-rc5-tp520-trim-all-
> bgroups+ #18
> [  480.186740] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s=20
> this message.
> [  480.186745] find            D ffff88031f127cb8     0  2660   2562=20
> 0x00000000
> [  480.186757]  ffff88031f127cb8 0000000000000002 ffff88040bdd8000=20
> ffff88031f127fd8
> [  480.186794]  ffff88035d110000 0000000000012d00 ffff88035d110000=20
> ffff88031f127cc8
> [  480.186806]  0000000000000000 ffff8803d31091e0 ffff8803792a8bcc=20
> ffff88031f127d28
> [  480.186820] Call Trace:
> [  480.186833]  [<ffffffff814b7d16>] schedule+0x64/0x66
> [  480.186900]  [<ffffffffc05361c4>] lock_extent_bits+0x103/0x18b [btrfs]
> [  480.186932]  [<ffffffff8106ecb5>] ? finish_wait+0x5f/0x5f
> [  480.186997]  [<ffffffffc0527f5e>] btrfs_evict_inode+0x14a/0x420 [btrfs]
> [  480.187022]  [<ffffffff81151aec>] evict+0xa8/0x150
> [  480.187038]  [<ffffffff811521c6>] iput+0x128/0x131
> [  480.187055]  [<ffffffff8114e6aa>] __dentry_kill+0x113/0x17d
> [  480.187070]  [<ffffffff8114e84a>] dput+0x136/0x15e
> [  480.187085]  [<ffffffff8113e635>] __fput+0x16a/0x181
> [  480.187099]  [<ffffffff8113e67a>] ____fput+0x9/0xb
> [  480.187112]  [<ffffffff810569e5>] task_work_run+0x85/0x9c
> [  480.187126]  [<ffffffff810028d7>] do_notify_resume+0x5b/0x82
> [  480.187139]  [<ffffffff814baeff>] int_signal+0x12/0x17
> [  480.187154] INFO: task find:2663 blocked for more than 120 seconds.
> [  480.187167]       Tainted: G           O   3.19.0-rc5-tp520-trim-all-
> bgroups+ #18
> [  480.187173] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s=20
> this message.
> [  480.187186] find            D ffff88031ba9fcb8     0  2663   2562=20
> 0x00000000
> [  480.187202]  ffff88031ba9fcb8 0000000000000002 ffff88040b810000=20
> ffff88031ba9ffd8
> [  480.187215]  ffff88035d3f8000 0000000000012d00 ffff88035d3f8000=20
> ffff88031ba9fcc8
> [  480.187227]  0000000000001000 ffff8803468b75a8 ffff8800a2df22ac=20
> ffff88031ba9fd28
> [  480.187240] Call Trace:
> [  480.187264]  [<ffffffff814b7d16>] schedule+0x64/0x66
> [  480.187332]  [<ffffffffc05361c4>] lock_extent_bits+0x103/0x18b [btrfs]
> [  480.187345]  [<ffffffff8106ecb5>] ? finish_wait+0x5f/0x5f
> [  480.187419]  [<ffffffffc0527f5e>] btrfs_evict_inode+0x14a/0x420 [btrfs]
> [  480.187453]  [<ffffffff81151aec>] evict+0xa8/0x150
> [  480.187465]  [<ffffffff811521c6>] iput+0x128/0x131
> [  480.187477]  [<ffffffff8114e6aa>] __dentry_kill+0x113/0x17d
> [  480.187491]  [<ffffffff8114e84a>] dput+0x136/0x15e
> [  480.187505]  [<ffffffff8113e635>] __fput+0x16a/0x181
> [  480.187518]  [<ffffffff8113e67a>] ____fput+0x9/0xb
> [  480.187529]  [<ffffffff810569e5>] task_work_run+0x85/0x9c
> [  480.187540]  [<ffffffff810028d7>] do_notify_resume+0x5b/0x82
> [  480.187551]  [<ffffffff814baeff>] int_signal+0x12/0x17
>=20
>=20
> I attach an sysrq-t thing.=20
>=20
> Ciao,
> --=20
> Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
> GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlTC2V4ACgkQgfmLGlazG5xWAACgvuvutG98aqRS8EXUoixH7sxJ
yjIAniSjq7v6JiPwuJavjx+7RJGsLapl
=8DEJ
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
