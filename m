Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6561A682A;
	Fri, 31 Jul 2026 11:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785496499; cv=none; b=XEMwgEXsroUa/qI1byBwGY4CYN0nRDT3bo5L82tX/FnTOgTCKYmnEKyaYT0HXnnKrHCqdFR+UWoFruqJqc00vmdjWGs1DSe3W0OvEeLbSM1KmDkCX1WT1AmqmUItCDLx8w1ju3gLgu63KO72bL0dTSFfa6KmcSSHnBytnSHehVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785496499; c=relaxed/simple;
	bh=aSNGevJN8/ZmHIDT3tLA+KPz/D1FAuzNnLYAz2i6JHo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cWtjntbhDA+RiZ5h4gCLbLQrn9Lq4JNJx6N0SKAIXO355PmKQ8N6WGMWFuPvkAf0BRTYaYJ/f6mmZ4kM6t2T/gKAv6WjsrJ56/lI4JWQgkXYvTmiHKqXyh4n6Ntg9y958mcoOKLIYlIYo7/Acv0/R7Mxnh95eAe6908KRnA6H1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=E/7DUHL7; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="E/7DUHL7"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66V8IA6b1326995;
	Fri, 31 Jul 2026 11:14:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Ob2dZn
	JVD5fi7ovXD+qVgjH1jboNzgmr577AC814CXQ=; b=E/7DUHL7BXHFVC3ujl08Ks
	TfycNRVHVzn6co5yurMs/QuHuTbzM2VLJ7W/InnYpHx7InmFH7T7geGHoNX4IaAU
	qphfndAxnggwcF7gh8R5DmYyPQNUQWH+RpyVc5dEESPPuzGSjDCd+jPH5AxKA1CK
	z7+X162fI5o/Ta3R1MRtgSuL77J+NAN/4YApkP/V5x3bLO6Bj/R9lUWBKWbg0m7i
	aLziU7XPtBpTrEcOltC8IyTfSSjMOXE5CKNv0A+pRm7jy+hy7OIqDgAv1DqdQ8vm
	/9IqiCtFU+1FZ4BOXKc89AelevcLdao82G+pNxt4KK2o/LDtOtSTokcCHw1qc8Uw
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmv0y4qgr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jul 2026 11:14:53 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66VBBGVE032452;
	Fri, 31 Jul 2026 11:14:52 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fna5yfc3r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jul 2026 11:14:52 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66VBEopV30933308
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jul 2026 11:14:50 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C5FA920040;
	Fri, 31 Jul 2026 11:14:50 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9EB6220043;
	Fri, 31 Jul 2026 11:14:50 +0000 (GMT)
Received: from [9.224.77.173] (unknown [9.224.77.173])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 31 Jul 2026 11:14:50 +0000 (GMT)
Message-ID: <6a5c7341-6e88-4eaf-8311-0de81b3d1015@linux.ibm.com>
Date: Fri, 31 Jul 2026 13:14:50 +0200
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Lockdep circular dependency: btrfs_swap_activate() calls
 sysfs_notify()
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <782c4d5c-d93b-42b3-b4ca-58deb3d8a894@linux.ibm.com>
 <11be35c2-7ede-4c83-b21f-39e52c3b04a2@gmx.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <11be35c2-7ede-4c83-b21f-39e52c3b04a2@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: e-2H2Rd8V2V33uzF8JK20zU53la4jjbT
X-Proofpoint-ORIG-GUID: QG9K73kb8tabnaEqsNEPj1y02ew0vn-V
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDA4MSBTYWx0ZWRfXx+7XqTZ2sfls
 WvjQ0ebYagY3jHzy4p4qKMbmhY+fDgFGYmxhvJGKiN0PSUiNEbOTr93sh8hLED1f2HCYX6gEc8c
 dO2ilamBXHfq3K+dJl+aqqxw8thLNzU=
X-Authority-Analysis: v=2.4 cv=dYuwG3Xe c=1 sm=1 tr=0 ts=6a6c83ae cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=wzoQSPUL0_mIP6tuFVYA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDA4MSBTYWx0ZWRfX+j4GtVz5Lrq5
 6A89K+o7Om+Au3zpPuXJtdV2/vZzxlk/vwBQ0H03GmGUZoymMKAmyED9xU3vWReXdaKYNUHgafE
 pZ+nNgWxk+NJ+c+DYMvviP6fQ/Gw/HNmuI/+9O7anThe4lAYE89L9Rw0QlhVPjW9yfMXla3uHDM
 /7Zl0/416fTlydG5CW6kcNafOV304iLL+2UIMw0iN81lkfcQVaDyDT7HYWLHz5FJMom1cQCna9w
 8hb1Kk5kbsHwITQyemW0QEyYHZFGCZLG87Y+qEgv3IPoE0K3bY5m/vy954etr4EOyZxIvGTQMFL
 4cFBqz73UgftB58/sjVUhYyouPAB9oNTGMDEXI6qmMEWbdRRovc0Ya9GeXY6X58S1Su2AbjRtsv
 sqc3gYlbOLDFnFbW/JlnbJ5hysNLWwxYd96gO6HBKmylWbHdXxtpK14wGv/pGtBKGbz3xbvnVX+
 tZTWD2iW38Sj10UiP2w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_03,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 clxscore=1015 phishscore=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310081



Am 31.07.26 um 13:12 schrieb Qu Wenruo:
> 
> 
> 在 2026/7/31 20:27, Christian Borntraeger 写道:
>> One or more of the following files ( btrfs-swapon-kernfs-repro.sh ) violates IBM policy and all attachment(s) have been removed from the message.

Oh.


Lets try this:
#!/bin/bash
# Reproducer for the lockdep circular dependency
#
#   &root->kernfs_rwsem --> sb_pagefaults --> &ei->i_mmap_lock
#
# btrfs_swap_activate() calls btrfs_exclop_finish() -> sysfs_notify() ->
# kernfs_rwsem while holding the inode's i_mmap_lock for write, while
# kernfs_fop_readdir() holds kernfs_rwsem across filldir64() (-> mmap_lock)
# and a btrfs write fault goes mmap_lock -> sb_pagefaults -> i_mmap_lock.
#
#
# Must be run as root, on a kernel with CONFIG_PROVE_LOCKING and
# CONFIG_DEBUG_ATOMIC_SLEEP.  Run it on an unpatched kernel to see the splat,
# and on a patched one to confirm it is gone.
#
# Usage: ./btrfs-swapon-kernfs-repro.sh [existing-btrfs-mountpoint]
#
# With no argument a 512M loopback btrfs image is created under /var/tmp and
# removed again at the end.  With an argument, that existing single-device
# btrfs mount is used and only the test files inside it are removed.
#
# Exit codes: 0 = no splat (expected with the fix), 1 = reproduced,
#             2 = inconclusive (setup problem, or lockdep already off).

set -u

IMG=""
LOOP=""
MNT=""
OWN_FS=0
SWAPFILE=""
SWAP_ON=0
SWAPON_OK=0

msg()  { printf '[repro] %s\n' "$*"; }
fail() { printf '[repro] ERROR: %s\n' "$*" >&2; exit 2; }

cleanup() {
	set +e
	[ "$SWAP_ON" = 1 ] && { msg "swapoff $SWAPFILE"; swapoff "$SWAPFILE"; }
	if [ "$OWN_FS" = 1 ]; then
		[ -n "$MNT" ]  && umount "$MNT" 2>/dev/null && rmdir "$MNT"
		[ -n "$LOOP" ] && losetup -d "$LOOP" 2>/dev/null
		[ -n "$IMG" ]  && rm -f "$IMG"
	elif [ -n "$MNT" ]; then
		# Only ever the two files this script created, never a bare path.
		[ -n "$SWAPFILE" ] && rm -f "$SWAPFILE"
		rm -f "$MNT/lockdep-mmap.dat"
	fi
}
trap cleanup EXIT

# ---------------------------------------------------------------- checks ---

[ "$(id -u)" = 0 ] || fail "must be run as root"

for t in mkfs.btrfs losetup mkswap swapon swapoff chattr dmesg \
	 truncate stat find dd sync mount umount; do
	command -v "$t" >/dev/null || fail "missing tool: $t"
done

[ -e /proc/lockdep_stats ] || fail \
	"no /proc/lockdep_stats -- kernel lacks CONFIG_PROVE_LOCKING, nothing to see"

# A previous splat disables lockdep for the rest of the boot ("INFO: lockdep
# is turned off").  Nothing will be reported after that, so bail out early
# rather than report a bogus PASS.
if grep -qE '^ *debug_locks: *0' /proc/lockdep_stats; then
	fail "lockdep is already turned off (earlier splat this boot) -- reboot first"
fi

# Edge #1 of the cycle needs the might_fault() annotation in filldir64().
KCONF=""
for c in /proc/config.gz "/boot/config-$(uname -r)"; do
	[ -e "$c" ] && { KCONF="$c"; break; }
done
if [ -n "$KCONF" ]; then
	if [ "${KCONF##*.}" = gz ]; then RDCONF="zcat"; else RDCONF="cat"; fi
	$RDCONF "$KCONF" | grep -q '^CONFIG_DEBUG_ATOMIC_SLEEP=y' || msg \
		"WARNING: CONFIG_DEBUG_ATOMIC_SLEEP is not set -- filldir64() will not
          annotate mmap_lock and the cycle cannot be detected"
else
	msg "note: could not find the kernel config, not checking DEBUG_ATOMIC_SLEEP"
fi

MMAP_HELPER=""
if command -v python3 >/dev/null; then
	MMAP_HELPER=python3
elif command -v cc >/dev/null; then
	MMAP_HELPER=cc
else
	fail "need python3 or cc to do the mmap write fault"
fi

msg "kernel $(uname -r), lockdep active"

# Cursor for the verdict.  Taken before the first step, not just before
# swapon: if some earlier boot activity already registered the
# i_mmap_lock -> kernfs_rwsem edge, the cycle is completed by the mmap or
# the readdir step below instead, and the splat has to be caught there too.
DMESG_LINES=$(dmesg | wc -l)

# ------------------------------------------------------------ test btrfs ---

if [ $# -ge 1 ]; then
	MNT="$1"
	[ -d "$MNT" ] || fail "$MNT is not a directory"
	[ "$(stat -f -c %T "$MNT")" = btrfs ] || fail "$MNT is not btrfs"
	msg "using existing btrfs at $MNT"
else
	OWN_FS=1
	IMG=$(mktemp /var/tmp/btrfs-swapon-repro.XXXXXX.img) || fail "mktemp failed"
	MNT=$(mktemp -d /var/tmp/btrfs-swapon-repro.XXXXXX.mnt) || fail "mktemp failed"
	msg "creating 512M btrfs image $IMG"
	truncate -s 512M "$IMG"                     || fail "truncate failed"
	LOOP=$(losetup --find --show "$IMG")        || fail "losetup failed"
	mkfs.btrfs -q -f "$LOOP"                    || fail "mkfs.btrfs failed"
	# No compression: a compressed swap file is rejected by btrfs.
	mount -o compress=no "$LOOP" "$MNT"         || fail "mount failed"
	msg "mounted $LOOP on $MNT"
fi

# ------------------------------------ edges #2/#3: mmap write fault on btrfs --
# handle_mm_fault -> do_page_mkwrite -> btrfs_page_mkwrite
#   -> sb_start_pagefault()            [sb_pagefaults]
#   -> down_read(&BTRFS_I(inode)->i_mmap_lock)
# Both the do_fault (first touch is a write) and the do_wp_page (read first,
# then write) variants are exercised.

MMAPFILE="$MNT/lockdep-mmap.dat"
dd if=/dev/zero of="$MMAPFILE" bs=4096 count=64 status=none || fail "dd failed"
sync

msg "dirtying a btrfs file mapping (mmap_lock -> sb_pagefaults -> i_mmap_lock)"
if [ "$MMAP_HELPER" = python3 ]; then
	python3 - "$MMAPFILE" <<-'EOF' || fail "mmap helper failed"
		import mmap, os, sys
		fd = os.open(sys.argv[1], os.O_RDWR)
		m = mmap.mmap(fd, 4096 * 64)
		m[0:8] = b"lockdep!"          # write fault on an absent page (do_fault)
		_ = m[8192]                   # populate clean ...
		m[8192:8200] = b"lockdep!"    # ... then dirty it (do_wp_page)
		m.flush()
		m.close()
		os.close(fd)
	EOF
else
	HELPER=$(mktemp -d)
	cat > "$HELPER/mw.c" <<-'EOF'
		#include <fcntl.h>
		#include <stdio.h>
		#include <sys/mman.h>
		#include <unistd.h>
		int main(int argc, char **argv)
		{
			size_t len = 4096 * 64;
			char *p;
			int fd = open(argv[1], O_RDWR);

			if (fd < 0)
				return perror("open"), 1;
			p = mmap(NULL, len, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
			if (p == MAP_FAILED)
				return perror("mmap"), 1;
			p[0] = 'x';                  /* do_fault */
			(void)*(volatile char *)(p + 8192);
			p[8192] = 'x';               /* do_wp_page */
			msync(p, len, MS_SYNC);
			munmap(p, len);
			close(fd);
			return 0;
		}
	EOF
	cc -O2 -o "$HELPER/mw" "$HELPER/mw.c" || fail "compiling the mmap helper failed"
	"$HELPER/mw" "$MMAPFILE" || fail "mmap helper failed"
	rm -rf "$HELPER"
fi

# ------------------------------------------- edge #1: kernfs readdir + fault --
# kernfs_fop_readdir() holds kernfs_rwsem for read across the whole emit loop
# and calls filldir64() -> __might_fault() -> mmap_lock.  Any getdents on a
# sysfs directory registers it.

msg "reading sysfs directories (kernfs_rwsem -> mmap_lock)"
for d in /sys/fs/btrfs /sys/class/net /sys/block /sys/devices/system/cpu; do
	[ -d "$d" ] && ls -fU "$d" >/dev/null 2>&1
done
find /sys/fs/btrfs -maxdepth 3 >/dev/null 2>&1

# ------------------------------------------- edge #0: swapon on btrfs (bang) --
# btrfs_swap_activate() holds i_mmap_lock for write across
# btrfs_exclop_finish() -> sysfs_notify() -> kernfs_find_and_get_ns()
#   -> down_read(&root->kernfs_rwsem)
#
# The swap file has to satisfy every btrfs_swap_activate() precondition:
# NODATACOW and NODATASUM (both from chattr +C on a still empty file), not
# compressed, no holes, no inline extent, not shared.  fallocate() is not
# used on purpose -- the extents are written out for real.

SWAPFILE="$MNT/lockdep-swapfile"
msg "creating swap file $SWAPFILE"
rm -f "$SWAPFILE"
touch "$SWAPFILE"                 || fail "touch failed"
chattr +C "$SWAPFILE"             || fail "chattr +C failed (needs NODATACOW)"
chmod 600 "$SWAPFILE"
dd if=/dev/zero of="$SWAPFILE" bs=1M count=64 status=none || fail "dd failed"
sync
mkswap "$SWAPFILE" >/dev/null     || fail "mkswap failed"

msg "swapon -- this is the call that closes the cycle"
if swapon -p 0 "$SWAPFILE"; then
	SWAP_ON=1
	SWAPON_OK=1
	msg "swapon succeeded"
else
	msg "swapon FAILED -- check the btrfs_warn above for which precondition"
	msg "(the lockdep edge is taken on the error paths too, so keep reading)"
fi

sleep 1

# ------------------------------------------------------------------ verdict --

NEW=$(dmesg | tail -n +$((DMESG_LINES + 1)))

if printf '%s\n' "$NEW" | grep -q "possible circular locking dependency"; then
	printf '%s\n' "$NEW" | sed -n '/possible circular locking dependency/,$p'
	if printf '%s\n' "$NEW" | grep -q "kernfs_rwsem"; then
		msg "REPRODUCED: the expected cycle, kernfs_rwsem is in the chain"
		exit 1
	fi
	msg "INCONCLUSIVE: a circular dependency was reported, but without"
	msg "kernfs_rwsem -- that is a different bug, compare against more.txt"
	exit 2
fi

msg "no lockdep splat"
if grep -qE '^ *debug_locks: *0' /proc/lockdep_stats; then
	msg "INCONCLUSIVE: lockdep turned itself off during the run"
	exit 2
fi
if [ "$SWAPON_OK" = 0 ]; then
	msg "INCONCLUSIVE: swapon did not get far enough, fix that first"
	exit 2
fi
msg "PASS: the i_mmap_lock -> kernfs_rwsem edge was not taken"
msg "(expected on a kernel carrying btrfs-swapon-kernfs-fix.patch)"
exit 0
