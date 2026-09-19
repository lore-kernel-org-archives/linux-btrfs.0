Received: from calculus.sigma-star.at (calculus.sigma-star.at [188.245.196.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355261D4606
	for <linux-btrfs@vger.kernel.org>; Sat, 19 Sep 2026 13:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.245.196.96
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789825232; cv=none; b=QrpFv+7Mz9Bc9Hdyjsp6DjQbWaRbOtJh9+zjOfqS8fPhD8OMydtvw9vJXfMp+VaM5kTUqL/qBFODKUzKt76sVOlcDDBVsZDaj+IMvYRbdYnA9PWbH+Wmd+MmR0pBWr0CeUD2BKQ85SS9l5DKDfHHc24FJufWWJvdWA0ePo4JnMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789825232; c=relaxed/simple;
	bh=vaGiCQEBIaTlFQxMElIkWsCcLhDnsF7xkZkK8EasDOM=;
	h=From:To:Cc:Subject:Message-ID:Date:MIME-Version:Content-Type; b=GMguCR/pluHbUM1th4jh+noBM71Prtf4xfY2P/9bQ+zV62tY1EsGhJh7r1bKIsnxauvXbPyvOQb4+ljq2vd/ANtYwSxLZonmdnTGYAC21dgqoj/+MCmZ42C/k5oUpVTirQbdH1M0x1yXpCrJ2fIG6oAnuV5zbLEYJ8T+NY2FFP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nod.at; spf=fail smtp.mailfrom=nod.at; dkim=permerror (0-bit key) header.d=nod.at header.i=@nod.at header.b=rCyTm51Z; dkim=pass (2048-bit key) header.d=nod.at header.i=@nod.at header.b=KemLDqLi; arc=none smtp.client-ip=188.245.196.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nod.at
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nod.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=nod.at header.i=@nod.at header.b="rCyTm51Z";
	dkim=pass (2048-bit key) header.d=nod.at header.i=@nod.at header.b="KemLDqLi"
DKIM-Signature: v=1; a=ed25519-sha256; s=v1-ed25519-20260901; d=nod.at; c=relaxed/relaxed; r=y;
	h=Date:Message-ID:Subject:To:From; t=1789825227; bh=w2p/Lun+PtViBLAXr7CIgIO
	ZC/n2LJiKlxu7G/p3v8g=; b=rCyTm51ZsDhnzNBXsAHwmaXm585nas2dxDFS+eFTreJ1n2O5AK
	LrA6umgWgkN1AzGo+Vz9Eu95e8wulEF7/TCg==;
DKIM-Signature: v=1; a=rsa-sha256; s=v1-rsa-20260901; d=nod.at; c=relaxed/relaxed; r=y;
	h=Date:Message-ID:Subject:To:From; t=1789825227; bh=w2p/Lun+PtViBLAXr7CIgIO
	ZC/n2LJiKlxu7G/p3v8g=; b=KemLDqLixlnUlYdbAiQ2bkjtXHwi7YbG7CPipMoOADEJcq4C0Y
	N9IKnJrFYNfJc4ypvlL6rq8VhIHIRhqBNWpFIhjbLMYVU7ipCOjEYnXBlZyl58JAzRp+Ju3h/pu
	agZbnYCp2NmqkQlBm/bP87ekdBgqnIzflnrRKxZcQZ5krcZ6CqjnbL9yuifJ0zDsq7gry6wpZzp
	bTFSxcbVpzWZkl5L6vPLDFhzt/0DpdhSr6TpZMhOjca38lanHCb85tTwLQPBtUUPVikmFShi0zv
	DfyvC6WtrluTAMQvVXJuaGDHgJkdZzlXM6kfcRJse+eRoio+I76l78nwVAxP7LgfhYQ==;
From: "Richard Weinberger" <richard@nod.at>
To: <linux-btrfs@vger.kernel.org>
Cc: <johannes.thumshirn@wdc.com>
Subject: qgroup rescan worker makes suspend fail
Message-ID: <mu8fq8a8.b9a9a1ae-dd6b-45a4-a415-5db853d61536@nod.at>
Date: Sat, 19 Sep 2026 13:40:27 +0000
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Once in a while, suspending my laptop just causes the screen to freeze.
Initially, I thought Linux had crashed, but it usually recovers after 2 minu=
tes,
though the suspend doesn't actually happen. You can imagine this can be very
unfortunate when you just close the laptop lid and pack the laptop into your
bag...

After the problem started occurring more frequently, I investigated and foun=
d
that the qgroup rescan worker is the problem. In dmesg, logs like these can
usually be found:

[246013.777637] [ T278489] Freezing remaining freezable tasks
[246033.780538] [ T278489] Freezing remaining freezable tasks failed after 2=
0.003 seconds (0 tasks refusing to freeze, wq_busy=3D1):
[246033.780576] [ T278489] Showing freezable workqueues that are still busy:
[246033.780582] [ T278489] workqueue events_freezable: flags=3D0x104
[246033.780590] [ T278489]   pwq 10: cpus=3D2 node=3D0 flags=3D0x0 nice=3D0 =
active=3D0 refcnt=3D2
[246033.780609] [ T278489]     inactive: pci_pme_list_scan
[246033.780642] [ T278489] workqueue btrfs-endio-meta: flags=3D0xe
[246033.780649] [ T278489]   pwq 57: cpus=3D0-13 node=3D0 flags=3D0x4 nice=
=3D0 active=3D0 refcnt=3D2
[246033.780660] [ T278489]     inactive: simple_end_io_work [btrfs]
[246033.781183] [ T278489] workqueue btrfs-qgroup-rescan: flags=3D0x2000e
[246033.781189] [ T278489]   pwq 56: cpus=3D0-13 flags=3D0x4 nice=3D0 active=
=3D1 refcnt=3D16
[246033.781199] [ T278489]     in-flight: 205929:btrfs_work_helper [btrfs] f=
or 111s
[246033.781721] [ T278489] workqueue wg-kex-wginterproc: flags=3D0x6
[246033.781726] [ T278489]   pwq 57: cpus=3D0-13 node=3D0 flags=3D0x4 nice=
=3D0 active=3D0 refcnt=3D2
[246033.781736] [ T278489]     inactive: wg_packet_handshake_send_worker [wi=
reguard]

My first thought was that the worker is likely not freezable, but it is.
The problem is that the whole qgroup rescan is a single work item.
In my case, such a scan can take up to 10 minutes, even though I have a
fast NVMe SSD installed...

Wouldn't it make sense to have rescan_should_stop() return true when
suspend starts? I think using a pm notifier could help here.
What do you think?

Thanks,
//richard
