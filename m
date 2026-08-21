Received: from poodle.tulip.relay.mailchannels.net (poodle.tulip.relay.mailchannels.net [23.83.218.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D073F9A0B
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Aug 2026 19:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.83.218.249
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787341381; cv=none; b=FbmhRZb30VMxIDy8F4CRkkbmVIIYLrWSxyOi1vrJ9TrzDhOwT9cYyYOUsG+SGEoiB/H1Q0Z/bEhHBy0wPRz3fJu70udboQCZ+iv2m/hTMrhFIYe426SoeKf7duuaqkzag0P5sWIUZetSxGbt+FyR1Z8UvQy8IoJ2V6zW8eT9dWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787341381; c=relaxed/simple;
	bh=ajla4zCmyAOFb7noiIUNbn3vmAV3qV2vEoOLFbARnFc=;
	h=Message-ID:Subject:From:To:Date:Content-Type:MIME-Version; b=q53StHMm8VaHlrcMDyrFsgnHAmzH2QVOQnU2d9xYipVP5hpxP9D/T1jzYls/zVEE+QastrkG9eTbWU9/fCHIVZOwsEgP9p4sn3G9Va8PXZ9k10sactCbdLZfA3wjg91uyuiTj4kEBIVcnrN0lGVAQR4H3FEszXjjuS/uEt8EzjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org; spf=pass smtp.mailfrom=scientia.org; arc=none smtp.client-ip=23.83.218.249
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 515054C25A7
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Aug 2026 19:34:08 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (100-96-5-82.trex-nlb.outbound.svc.cluster.local [100.96.5.82])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 6A4114C2093
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Aug 2026 19:34:07 +0000 (UTC)
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Imminent-Industry: 24d3a249240cc63c_1787340848166_2939617791
X-MC-Loop-Signature: 1787340848166:2756503569
X-MC-Ingress-Time: 1787340848165
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.96.5.82 (trex/8.0.2);
	Fri, 21 Aug 2026 19:34:08 +0000
Received: from ipbcc0feaa.dynamic.kabel-deutschland.de ([188.192.254.170]:64876 helo=heisenberg.fritz.box)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <calestyo@scientia.org>)
	id 1wxV09-0000000BlMB-2lsY
	for linux-btrfs@vger.kernel.org;
	Fri, 21 Aug 2026 19:34:05 +0000
Message-ID: <5b5830426d82194331a07b44e9b212958120edbc.camel@scientia.org>
Subject: after creating a snapshot, subvol can't be remounted ro, but
 unmounted
From: Christoph Anton Mitterer <calestyo@scientia.org>
To: linux-btrfs@vger.kernel.org
Date: Fri, 21 Aug 2026 21:34:05 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-10+b1 
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-AuthUser: calestyo@scientia.org

Hey.

I've experience this for ages and was always too lazy to report it (and
it's not really big problem anyway):

That's all one btrfs, with a subvol at <fsroot>/data/ which is mounted
a / and the <fsroot>/ being a noauto,ro mountpoint at /data/system/.


root@heisenberg:~# mount /data/system/
root@heisenberg:~# cd /data/system/
root@heisenberg:/data/system# btrfs subvolume snapshot -r data/ snapshots/d=
ata/2026-08-21_1_live/
ERROR: Could not create subvolume: Read-only file system
root@heisenberg:/data/system# mount -o remount,rw /data/system/
root@heisenberg:/data/system# btrfs subvolume snapshot -r data/ snapshots/d=
ata/2026-08-21_1_live/
Create readonly snapshot of 'data/' in 'snapshots/data/2026-08-21_1_live/'

After I created a snapshot, I cannot remount,ro it anymore (even if I
wait longer and try multiple times:

root@heisenberg:/data/system# mount -o remount,ro /data/system/
mount: /data/system: mount point is busy.
       dmesg(1) may have more information after failed mount system call.

even if I cd somewhere else:

root@heisenberg:/data/system# cd
root@heisenberg:~# mount -o remount,ro /data/system/
mount: /data/system: mount point is busy.
       dmesg(1) may have more information after failed mount system call.

But what immediately works (even wit cwd /data/system/) is unmounting:

root@heisenberg:~# umount /data/system=20
root@heisenberg:~#=20


No idea whether this might be caused by any higher-level stuff (udisks
or so?) but my intuitive guess was that it might actually be something
in the fs itself.

Thanks,
Chris.
