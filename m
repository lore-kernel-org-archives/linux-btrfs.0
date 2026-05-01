Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3C713D638
	for <linux-btrfs@vger.kernel.org>; Fri,  1 May 2026 09:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777628458; cv=none; b=g0UA4hPXmA4NM6Xic0xVG5+iCvf6e6JY5HFlQZLJTSc3Q0jFWOkeUVZcYRElNmCM4g5jRoEsm2wI4BWeO+QZ6EnjYsTeQKEEjSiRbJXbqY6sPuA7W+iVswzBecNdwHxe7NE3CCINk+G7JtCCVBf1HCt1AV0J72ZpEKv5H/rhRNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777628458; c=relaxed/simple;
	bh=3xKS/ScBwPijYxLhldl4z0kXfIjdJxiF9/QKlHmrthE=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=laud1KTB8p4r0Sz5aZPbLAEw7XXvEZFYNcRMKJzp8qEZTqJ8GXCdDWgqD6VJlwy0DjwyZXJdZHLCf//jk6EgM0XT/MUxrGsC0v2q8EZN/7pbrRrrvJjNyqtBTAgiJ32CSXg9U0cmQo1ZkvoRztkXYUzSup/iM8Ha/ZGLfnynfic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=maxchernoff.ca; spf=pass smtp.mailfrom=maxchernoff.ca; dkim=pass (2048-bit key) header.d=maxchernoff.ca header.i=@maxchernoff.ca header.b=PApEEkHj; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=maxchernoff.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=maxchernoff.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=maxchernoff.ca header.i=@maxchernoff.ca header.b="PApEEkHj"
Message-ID: <22a4a11e1933a7b07cee7d6896098a5b251cb755.camel@maxchernoff.ca>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxchernoff.ca;
	s=key1; t=1777628452;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=w1a+OUNiVIZoonK154EY30162Z9M3u0GJptfDM0KlaE=;
	b=PApEEkHjdz5K1PRY/0vbewO2og9UeMjZltyw1QrAuwNOTzS85WdneW+/Lmtfqt1FEnJArj
	yHuZpOehJyBO3vFSsQU6asjVD7/1aLuIjBa87/iQdun35BppdgCtaV+mjHiceYHpOa9p1k
	2ejOPGDUF95Nz3owJWS/IET2MpX6bKW6ycBjOnOaxeeZF/hPaEa59rmcMjKlj3dkRjBSCn
	xxNf1RpeRC9VEF3bosUXrerrwliasfcadMARl8CQUeF4nlCV/1swnU+VYBf+mUOo5BwNGj
	VcTrQ1wkETl0GZqwT06o7Ttk8NEOeIWKt/KZn2wa8kkcsK+Ih/PiL4L2B0tl7A==
Subject: Enabling qgroups causes 2+ minute hangs
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Max Chernoff <git@maxchernoff.ca>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Max Chernoff <git@maxchernoff.ca>
Date: Fri, 01 May 2026 03:40:41 -0600
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT

Hi all,

(please keep me cc'd as I'm not subscribed)

Yesterday, I accidentally enabled qgroups on my root filesystem, and I
started experiencing severe system hangs. When I disabled the quotas
again, the problem went away completely.

I'm currently using "btrfs-progs v6.19.1" with "Linux
6.19.14-200.fc43.x86_64" on Fedora 43 x86_64. I have "/boot/" and "/" in
the same btrfs filesystem, which is on 2 NVMe disks with RAID0 data and
RAID1 metadata. I have a swap partition on both disks, and I'm not using
a swap file. When I booted into the "initrd" for my rescue kernel
("6.15.8-200.fc42.x86_64"), I saw the exact same issue. My filesystem
has 309 snapshots and 17 subvolumes; 45238 is the largest subvolume ID.
I'm using "snapper" and "btrfsmaintenance", but no other btrfs-related
programs. The /proc/mounts entry is

    /dev/nvme0n1p3 / btrfs rw,seclabel,noatime,compress=3Dzstd:1,ssd,discar=
d=3Dasync,space_cache=3Dv2,subvolid=3D5,subvol=3D/ 0 0

I have snapper set to take hourly snapshots, and this has worked
perfectly for the past 5 years. But once I enabled qgroups, whenever
snapper took a new snapshot, the system became mostly
unresponsive---complex programs froze completely, and I was unable to
launch any new programs. "Alt+Sysrq" still worked, and I was usually
able to switch to an already-open VT, but I was unable to log in to a
new VT. The lockups only lasted 10-15 minutes, and "dmesg" and
"journalctl" showed nothing relevant before, during, or after.

Booting between lockups was fine, but if I tried to reboot during a
lockup, then it got stuck while shutting down, but I was able to force
it with "Alt+Sysrq". When I turned the computer back on, it would get
stuck at

    Starting initrd-switch-root.service - Switch Root...

and adding "rd.debug debug" to the kernel cmdline gave no further
output. After waiting 10+ minutes, the system would eventually boot
though. Trying to boot into "rescue" or "emergency" gave the exact same
results.

Booting into "rd.rescue" worked correctly though. Mounting the root as
read-only and as read-write both worked fine, and unmounting as
read-only worked fine, but trying to unmount as read-write hung for at
least 5 minutes (before I gave up).

When the system is hanging, I saw that the "btrfs-clean" (and
occasionally "btrfs-transaction") kernel threads were taking up >100% of
the CPU. This happened both when booted into the main system and when
booted into the "initrd" with the root mounted as read-write, but not
when mounted as read-only.

To measure the freezes more quantitatively, I ran the following script:

    #!/bin/sh
    set -eu

    # Use busybox in tmpfs to make sure that we aren't reading off of the r=
oot
    # filesystem during the tests.
    bb=3D"$XDG_RUNTIME_DIR/busybox"
    cp --force "$(which busybox)" "$bb"

    while true; do
        "$bb" time -f 'real:%e kernel:%S user:%U' "$bb" sh -c "$bb date > ~=
/test.txt" 2>&1
        "$bb" sleep 1
    done | ts -i 'delta:%.s' | ts '%Y-%m-%d %H:%M:%S' | "$bb" tee -a ~/time=
-reads.log

which gave me the following results (all the elided times are 1 second):

    [...]
    2026-04-30 17:55:33 delta:1.002839 real:0.00 kernel:0.00 user:0.00
    2026-04-30 17:55:34 delta:1.002585 real:0.00 kernel:0.00 user:0.00
    2026-04-30 17:55:40 delta:6.169116 real:5.16 kernel:0.00 user:0.00
    2026-04-30 17:55:43 delta:3.227686 real:2.22 kernel:0.00 user:0.00
    2026-04-30 17:57:53 delta:130.211634 real:129.21 kernel:0.00 user:0.00
    2026-04-30 17:58:00 delta:6.771055 real:5.76 kernel:0.00 user:0.00
    2026-04-30 17:58:07 delta:6.938813 real:5.93 kernel:0.00 user:0.00
    2026-04-30 18:00:43 delta:155.816819 real:154.81 kernel:0.00 user:0.00
    2026-04-30 18:00:44 delta:1.002916 real:0.00 kernel:0.00 user:0.00
    2026-04-30 18:00:45 delta:1.003044 real:0.00 kernel:0.00 user:0.00
    [...]
    2026-04-30 18:00:50 delta:1.002643 real:0.00 kernel:0.00 user:0.00
    2026-04-30 18:00:56 delta:6.015252 real:5.01 kernel:0.00 user:0.00
    2026-04-30 18:00:57 delta:1.003057 real:0.00 kernel:0.00 user:0.00
    [...]
    2026-04-30 18:01:25 delta:1.003564 real:0.00 kernel:0.00 user:0.00
    2026-04-30 18:01:26 delta:1.002711 real:0.00 kernel:0.00 user:0.00
    2026-04-30 18:03:20 delta:114.606827 real:113.60 kernel:0.00 user:0.00
    2026-04-30 18:03:21 delta:1.003087 real:0.00 kernel:0.00 user:0.00
    2026-04-30 18:03:22 delta:1.002655 real:0.00 kernel:0.00 user:0.00
    [...]
    2026-04-30 18:03:51 delta:1.002898 real:0.00 kernel:0.00 user:0.00
    2026-04-30 18:06:02 delta:131.139355 real:130.13 kernel:0.00 user:0.00
    2026-04-30 18:06:03 delta:1.003131 real:0.00 kernel:0.00 user:0.00
    [...]
    2026-04-30 18:55:33 delta:1.003722 real:0.00 kernel:0.00 user:0.00
    2026-04-30 18:55:38 delta:5.352721 real:4.35 kernel:0.00 user:0.00
    2026-04-30 18:55:41 delta:3.060421 real:2.05 kernel:0.00 user:0.00
    2026-04-30 18:57:42 delta:120.278858 real:119.27 kernel:0.00 user:0.00
    2026-04-30 18:57:48 delta:6.371515 real:5.37 kernel:0.00 user:0.00
    2026-04-30 18:57:55 delta:6.858136 real:5.85 kernel:0.00 user:0.00
    2026-04-30 18:58:44 delta:49.099334 real:48.09 kernel:0.00 user:0.00
    2026-04-30 18:58:45 delta:1.414115 real:0.41 kernel:0.00 user:0.00
    2026-04-30 19:00:23 delta:97.499004 real:96.49 kernel:0.00 user:0.00
    2026-04-30 19:00:26 delta:2.701334 real:1.70 kernel:0.00 user:0.00
    2026-04-30 19:00:27 delta:1.265323 real:0.26 kernel:0.00 user:0.00
    2026-04-30 19:00:34 delta:7.264837 real:6.26 kernel:0.00 user:0.00
    2026-04-30 19:02:52 delta:137.679866 real:136.67 kernel:0.00 user:0.00
    2026-04-30 19:02:56 delta:4.076251 real:3.07 kernel:0.00 user:0.00
    2026-04-30 19:03:32 delta:36.097353 real:35.09 kernel:0.00 user:0.00
    2026-04-30 19:05:24 delta:112.509576 real:111.50 kernel:0.00 user:0.00
    2026-04-30 19:05:25 delta:1.002256 real:0.00 kernel:0.00 user:0.00
    [...]

There are no obvious signs of corruption: "btrfs scrub" completed
successfully, and the SMART data looks okay:

    $ sudo btrfs scrub status --human-readable /
    UUID:             c95a9dcb-1da8-4773-9dc3-a3d6e42e7cd1
    Scrub started:    Thu Apr 30 03:17:21 2026
    Status:           finished
    Duration:         0:09:31
    Total to scrub:   1.28TiB
    Rate:             2.30GiB/s
    Error summary:    no errors found

    $ sudo smartctl --all /dev/nvme0
    [...]
    SMART overall-health self-assessment test result: PASSED
    [...]

    $ sudo smartctl --all /dev/nvme1
    [...]
    SMART overall-health self-assessment test result: PASSED
    [...]

    $ sudo btrfs device stats /
    [/dev/nvme1n1p3].write_io_errs    0
    [/dev/nvme1n1p3].read_io_errs     0
    [/dev/nvme1n1p3].flush_io_errs    0
    [/dev/nvme1n1p3].corruption_errs  0
    [/dev/nvme1n1p3].generation_errs  0
    [/dev/nvme0n1p2].write_io_errs    0
    [/dev/nvme0n1p2].read_io_errs     0
    [/dev/nvme0n1p2].flush_io_errs    0
    [/dev/nvme0n1p2].corruption_errs  0
    [/dev/nvme0n1p2].generation_errs  0

My filesystem also has lots of free space:

    $ sudo btrfs filesystem usage -T /
    Overall:
        Device size:		   1.81TiB
        Device allocated:		   1.36TiB
        Device unallocated:		 455.32GiB
        Device missing:		     0.00B
        Device slack:		     0.00B
        Used:			   1.28TiB
        Free (estimated):		 489.53GiB	(min: 261.87GiB)
        Free (statfs, df):		 489.53GiB
        Data ratio:			      1.00
        Metadata ratio:		      2.00
        Global reserve:		 512.00MiB	(used: 0.00B)
        Multiple profiles:		        no

                      Data      Metadata System
    Id Path           RAID0     RAID1    RAID1     Unallocated Total     Sl=
ack
    -- -------------- --------- -------- --------- ----------- --------- --=
---
     1 /dev/nvme1n1p3 649.00GiB 48.00GiB  32.00MiB   236.84GiB 933.87GiB   =
  -
     2 /dev/nvme0n1p2 649.00GiB 48.00GiB  32.00MiB   218.48GiB 915.51GiB   =
  -
    -- -------------- --------- -------- --------- ----------- --------- --=
---
       Total            1.27TiB 48.00GiB  32.00MiB   455.32GiB   1.81TiB 0.=
00B
       Used             1.23TiB 23.23GiB 128.00KiB

I ran "btrfs check --readonly" from the "initrd", and here are the
results:

    $ btrfs check --readonly --progress /dev/nvme0n1p3
    Opening filesystem to check...
    Checking filesystem on /dev/nvme0n1p3
    UUID: c95a9dcb-1da8-4773-9dc3-a3d6e42e7cd1
    [1/7] checking root items                      (0:00:08 elapsed, 123958=
21 items checked)
    [2/7] checking extents                         (0:02:07 elapsed, 152213=
9 items checked)
    [3/7] checking free space tree                 (0:00:08 elapsed, 699 it=
ems checked)
    [4/7] checking fs roots                        (0:06:19 elapsed, 134598=
2 items checked)
    [5/7] checking csums (without verifying data)  (0:00:12 elapsed, 289014=
4 items checked)
    [6/7] checking root refs                       (0:00:00 elapsed, 331 it=
ems checked)
    ERROR: failed to add qgroup relation, member=3D20768 parent=3D717761190=
61238848: No such file or directory
    ERROR: loading qgroups from disk: -2
    [7/7] checking quota groups                    (0:00:00 elapsed)
    ERROR: failed to check quota groups
    found 1383420903546 bytes used, error(s) found
    total csum bytes: 1250854052
    total tree bytes: 24933187584
    total fs tree bytes: 22152527872
    total extent tree bytes: 1297121280
    btree space waste bytes: 4820245506
    file data blocks allocated: 21729234993152
    referenced 2309334016000
    extent buffer leak: start 1315779461128 len 16384
    extent buffer leak: start 1315762536448 len 16384

    $ btrfs check --readonly --progress /dev/nvme1n1p3
    Opening filesystem to check...
    Checking filesystem on /dev/nvme1n1p2
    UUID: c95a9dcb-1da8-4773-9dc3-a3d6e42e7cd1
    [1/7] checking root items                      (0:00:08 elapsed, 123958=
21 items checked)
    [2/7] checking extents                         (0:02:06 elapsed, 152213=
9 items checked)
    [3/7] checking free space tree                 (0:00:09 elapsed, 699 it=
ems checked)
    [4/7] checking fs roots                        (0:06:17 elapsed, 134598=
2 items checked)
    [5/7] checking csums (without verifying data)  (0:00:12 elapsed, 289014=
4 items checked)
    [6/7] checking root refs                       (0:00:00 elapsed, 331 it=
ems checked)
    ERROR: failed to add qgroup relation, member=3D280768 parent=3D71776119=
061238848: No such file or directory
    ERROR: loading qgroups from disk: -2
    [7/7] checking quota groups                    (0:00:00 elapsed)
    extent buffer leak: start 1315779461128 len 16384
    extent buffer leak: start 1315762536448 len 16384
    found 1383420903546 bytes used, error(s) found
    total csum bytes: 1250854052
    total tree bytes: 24933187584
    total fs tree bytes: 22152527872
    total extent tree bytes: 1297121280
    btree space waste bytes: 4820245506
    file data blocks allocated: 21729234993152
    referenced 2309334016000

    $ btrfs check --readonly --progress --check-data-csum /dev/nvme0n1p3
    Opening filesystem to check...
    Checking filesystem on /dev/nvme0n1p3
    UUID: c95a9dcb-1da8-4773-9dc3-a3d6e42e7cd1
    [1/7] checking root items                      (0:00:08 elapsed, 123958=
21 items checked)
    [2/7] checking extents                         (0:02:08 elapsed, 152213=
9 items checked)
    [3/7] checking free space tree                 (0:00:08 elapsed, 699 it=
ems checked)
    [4/7] checking fs roots                        (0:06:17 elapsed, 134598=
2 items checked)
    [5/7] checking csums against data              (0:16:23 elapsed, 289014=
4 items checked)
    [6/7] checking root refs                       (0:00:00 elapsed, 331 it=
ems checked)
    failed to add qgroup relation, member=3D28768 parent=3D7177611906123884=
8: No such file or directory
    ERROR: loading qgroups from disk: -2
    ERROR: failed to check quota groups
    [7/7] checking quota groups                    (0:00:00 elapsed)

    extent buffer leak: start 1315779461128 len 16364
    extent buffer leak: start 1315762536448 len 16384
    found 1383420903546 bytes used, error(s) found
    total csum bytes: 1250854052
    total tree bytes: 24933187584
    total fs tree bytes: 22152527872
    total extent tree bytes: 1297121280
    btree space waste bytes: 4820245506
    file data blocks allocated: 21729234993152
    referenced 2309334016000

    $ btrfs check --readonly --progress --qgroup-report /dev/nvme0n1p3
    ERROR: failed to add qgroup relation, member=3D20768 parent=3D717761190=
61238048: No such file or directory
    ERROR: loading qgroups from disk: -2
    extent buffer leak: start 1315779461120 len 16384
    extent buffer leak: start 1315762536448 len 16394
    Opening filesystem to check...
    Checking filesystem on /dev/nvme0n1p3
    UUID: c95a9dcb-1da8-4773-9dc3-a3d6e42e7cd1
    Print quota groups report for /dev/nvme0n1p3
    UUID: c95a9dcb-1da8-4773-9dc3-a3d6e42e7cd1

    $ btrfs check --readonly --progress --qgroup-report /dev/nvme1n1p2
    ERROR: failed to add qgroup relation, member=3D20768 parent=3D717761190=
61238048: No such file or directory
    ERROR: loading gqgroups from disk: -2
    extent buffer leak: start 1315779461120 len 16384
    extent buffer leak: start 1315762536448 len 16384
    Opening filesystem to check...
    Checking filesystem on /dev/nvme1n1p2
    UUID: c95a9dcb-1da8-4773-9dc3-a3d6e42e7cd1
    Print quota groups report for /dev/nvme1n1p2
    UUID: c95a9dcb-1da8-4773-9dc3-a3d6e42e7cd1

When booted into the main system, "btrfs qgroup show" ran without any
errors:

    $ sudo btrfs qgroup show /
    Qgroupid    Referenced    Exclusive   Path
    --------    ----------    ---------   ----
    0/5           56.69GiB    102.11MiB   <toplevel>
    0/256         25.44GiB     12.11MiB   home
    0/257         71.98GiB     71.98GiB   var
    0/258          1.71MiB      1.71MiB   snapshots
    0/261         26.01GiB     23.00GiB   home/max/.local
    0/262        589.32GiB    589.26GiB   home/max/Games
    0/263         41.70GiB     41.43GiB   home/max/.cache
    0/264        240.00KiB    240.00KiB   home/.snapshots
    [...]
    255/20768     16.00KiB     16.00KiB   <0 member qgroups>

I realize that enabling qgroups on a large filesystem with a bunch of
snapshots is going to be rather slow and I/O intensive, but 2 minute
hangs on writes and 10 minute hangs on unmounting seems fairly
problematic to me. Or if it's not feasible to fix this, would it at
least be possible to print something like

    WARNING: qgroups enabled on a filesystem with lots of snapshots, expect=
 poor performance

to dmesg to make it easier to debug?

Let me know if you want me to run any more commands, share full system
logs, or anything else. I'm also comfortable building a kernel if you
want me to test any patches.

Thanks,
-- Max
