Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from v-27-120-84-145.ub-freebit.net ([27.120.84.145]:38613 "EHLO
	mail.reasonset.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbbFOFmH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jun 2015 01:42:07 -0400
Received: from hydrangea (218-45-17-237.flets.kamome.or.jp [218.45.17.237])
	by mail.reasonset.net (Postfix) with ESMTPSA id 487E97C48001
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2015 14:35:49 +0900 (JST)
Date: Mon, 15 Jun 2015 14:35:48 +0900
From: MASAKI Yuhsuke <yek@reasonset.net>
To: linux-btrfs@vger.kernel.org
Subject: Rsync to brtfs subvolume probrem.
Message-Id: <20150615143548.4820538a42593fb70c3a1b76@reasonset.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

I got rsync to remote host freezing problem.

Situation:
* rsync local host btrfs subvolume to remote host subvolume.
* Occured after three month from this system starting up.
* rsync (rsync -auvP --delete-after -e "ssh -i $3" $1 $2 >&2) was frozen up. -P option display update also stopped ( elapsed time so.)
* I could stop rsync with SIGINT on local host but rsync process in remote host didn't stop.
* Never complete rsync.
* I could login with SSH, operate and write/read to btrfs, but couldn't shutdown remote host.
* If stop rsync process in remote host with SIGKILL, I couldn't shutdown.
* It always appears since once appeared.

After reboot,
* The time required of "Building file list" on --delete-after is too short.
* rsync wanted to transfer all directories but not any file in these directories.
* When stop to rsync and re-rsync, already transferred (listed) files.
* It looks files didn't transfer to remote host for me (checked with ssh login.)

S.M.A.R.T. test was PASSED.

When reappeared this issue with btrfs scrubbing, force shutdown and reboot,
* btrfs scrub status reports "running".
* btrfs scrub start -> already running
* btrfs scrub cancel -> not running

Before reboot, scrub didn't progress but counted time.
After reboot, scrub didn't progress and didn't count.

I re-created btrfs.
It worked for a while, but re-appeared after two days.

I solved temporary with btrfsck + btrfs scrub start -f,
but re-appeared at next day.

I retried btrfsck + btrfs scrub start -f.
It finished but btrfs scrub status said:

scrub status for 7ebc7d8d-35c6-4d98-8457-3323c242e9fe
	scrub started at Tue May  5 23:48:36 2015 and finished after 5700 seconds
	total bytes scrubbed: 666.26GiB with 0 errors

But btrfs filesystem df

Data, RAID0: total=2.59TiB, used=2.58TiB
Data, single: total=8.00MiB, used=8.00MiB
System, RAID1: total=8.00MiB, used=160.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, RAID1: total=7.00GiB, used=5.27GiB
Metadata, single: total=8.00MiB, used=0.00
GlobalReserve, single: total=512.00MiB, used=0.00

localhost : Manjaro Linux, 3.19.4-1 x86_64, ASRock FM2+Killer, AMD A10-7700K, 32GB RAM
  4disks GPT total 24TB, btrfs RAID1.
  mount with 
  subvol=xxx,relatime,autodefrag,compress=zlib,space_cache,noauto 
remotehost : CentOS 7, 3.10.0-229.1.2 x86_64, hp ProLiant Server, 
  4disks GPT total 25TB, btrfs RAID0 Data + RAID1 System
  mount with
  noatime,autodefrag,compress-force=lzo,space_cache,subvol=xxx

-----

I was reported same issue.

Situation:
* rsync localhost to localhost.
* Sometime rsync froze up a while, and a moment completely froze up.
* Couldn't kill rsync.
* Not always appears.

He tried with:
* Funtoo Linux, 4.0.1 x86_64 amd64-k10, with defaults,recovery,compress=zlib,inode_cache,space_cache,autodefrag
* SystemRescueCD, 3.14.35
But every over for the same result.

His machine is:
  AMD Phenom II X6 1055T Processor, 8GB RAM.
  single disk 500GB, btrfs single Data + RAID1 System.

### MASAKI Yuhsuke
