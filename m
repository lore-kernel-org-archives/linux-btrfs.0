Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA9F344044;
	Tue, 16 Jun 2026 11:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781610095; cv=none; b=jyxs3nmVMS77eEPwmCnmTD5El3de29ziAPgoI96/jIelQXXT+7FAIyrc6cz40xDcHhkCI9SM1N+lf0yNg2gUV2oS8GnW0kr5qky+5heL/m0loqsi2Rk6RamzjqEtM4VG/4M3up/nhVMuq2AAwleeL10B3TWLPqMH0ffub42mPgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781610095; c=relaxed/simple;
	bh=uMVV6FC+YT9Se007cWu/G9hzM6AAEvhAvdGHGOGIQTE=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=kCaVusQ5pEIupG4heb1vdxMrfI2gF7lGKqQ+YrcQ9EIxK3eyQ1FutFxg5/bc4JFXhlW7REzspUvv3mhd3Xns+5lj4OZCidZYwho4IprJbcKtZyjs9HILgMC0ZfJqGIJNLoqqRHkMvvh0rmkKZj9DhBg/1v4Bz3kouya1J1pDNDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jkr5LsB7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jkr5LsB7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 927D61F000E9;
	Tue, 16 Jun 2026 11:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781610093;
	bh=BFF9lnixtLL6jBvccpp+mzGlZOXCLEMPen+20k157J0=;
	h=From:Subject:Date:To:Cc;
	b=Jkr5LsB7XW+SF3c8t5csxnGIotzrww44nkpTtkrlHORLO0yZ9J/EzHqejNIuoebOE
	 qZIqM6fHXt65ISSJMQkKaCwyHRYHWpGpKFcXdAVc0cKYeFlxyys4mciZw0sq13JIvm
	 MdFNUfygt9enCyxEZOUNcGx3336xKft9A2dt6xEGU4OysNI0BXqc3zrk3enswee9nM
	 xah8uMrPtmQj08wxGIvNHjbmOupUeyAOHK1EPhzyuzFcg2cEZsNk8RUHZjGzYwt52o
	 IdRuYgHAGtEECjjGHKSLWVVsWRgTLcnvRkKtEmaV/T1tJDrpye9c4ZrackA7N4cC4B
	 PUNuuifJNI3Uw==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH 0/7] btrfs: error-path fixes for device add and replace
Date: Tue, 16 Jun 2026 13:41:09 +0200
Message-Id: <20260616-work-btrfs-preexisting-fixes-v1-0-c4abe2f6d4f0@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAFY2MWoC/yWMQQ6CMBBFr0Jm7UQg0qRexbhoyxRGk2JmqpIQ7
 m6Ly/f/y9tASZgUrs0GQh9WXlKB7tRAmF2aCHksDH3bm9Z0Br+LPNFniYovIVpZM6cJI6+k6C+
 dtYO11owDlEQxjqMUbvc/69s/KOTarIZ3SujFpTDX6Qif4yKYaM2w7z/fCXxpoQAAAA==
X-Change-ID: 20260616-work-btrfs-preexisting-fixes-b419959996d5
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
 Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Filipe Manana <fdmanana@suse.com>, Naohiro Aota <naota@elisp.net>, 
 linux-btrfs@vger.kernel.org, Anand Jain <anand.jain@oracle.com>, 
 Stefan Behrens <sbehrens@giantdisaster.de>, linux-fsdevel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16-dev-4090c
X-Developer-Signature: v=1; a=openpgp-sha256; l=1635; i=brauner@kernel.org;
 h=from:subject:message-id; bh=uMVV6FC+YT9Se007cWu/G9hzM6AAEvhAvdGHGOGIQTE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQZmmXd2qgZf0k7QH+Z2Cv9767yfS9X+Zs9vvrHNVVbu
 dZzquyJjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgInw5DEyzPloOjevLLYwKfLt
 28YHfRp7Y7edPOO44JOn62+dKUE99owMjyxqT3Qc/lkde1ZXrt/4sekPOc53ZR2xOvmvTi5ye5/
 NAwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

I'm not a btrfs developer so I've exhausted my expertise on this. All of
this is falling out of some work to actually create a device to
superblock hashtable that surfaced a bunch of pre-existing bugs.

Seven independent, long-standing bugs on the btrfs device add and device
replace error paths. They were found by auditing these paths (in the
course of unrelated work on block-device freeze handling), not from a
reported crash: each is reachable only on a rare allocation/error path or
a narrow race window.

Based on btrfs/for-next.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Christian Brauner (7):
      btrfs: wait for an RCU grace period before freeing a device on add error
      btrfs: don't unwind a committed device on the seeding add error path
      btrfs: drain replace writes before freeing the target on start failure
      btrfs: drain replace writes before freeing the target on cancel
      btrfs: don't leave dev-replace STARTED after an early finishing failure
      btrfs: destroy the target device when mark_block_group_to_copy() fails
      btrfs: keep the exclusive op held while a dev-replace is suspended in-mount

 fs/btrfs/dev-replace.c | 66 +++++++++++++++++++++++++++++++++++++++-----------
 fs/btrfs/dev-replace.h |  3 ++-
 fs/btrfs/fs.c          | 17 +++++++++++++
 fs/btrfs/fs.h          |  2 ++
 fs/btrfs/ioctl.c       |  9 +++++--
 fs/btrfs/volumes.c     |  7 +++---
 6 files changed, 84 insertions(+), 20 deletions(-)
---
base-commit: e73be5d3d53715f11246f9e43a05b5cd67750bb6
change-id: 20260616-work-btrfs-preexisting-fixes-b419959996d5

