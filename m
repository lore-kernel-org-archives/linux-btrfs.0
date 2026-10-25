Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792948956;
	b=UglQ3bINHXn7VIT85o3jQdMpDv/zOOKxIHNNEA27Z5cBwFrdI/TzF4yqLqKTXEVCgJjx
	 Usp7uGP7HR9sT6fxP5b6BLv0/3E2vYV+IAPjhwnHEXc5HZHBWN5HcK9aQ980d6T8U8bZg
	 MWYB9rb5ExYkjrzm0ND9uZtPT8Z8WIxpImMt9IIt6sBpVwRrllZjsx3scIKhqIexC7SOJ
	 VSXKY47l105rf0lBh8BtxNcvPciobU1GyJEg0GqGIOff/5Rbctgrop0roO4sg6i8pQRTw
	 /h5amSG8ux06dKRPjPQFxnO7XSiP8bAgRPrkjwyk+H/Pmg2rFA2QdDaBVL+xOu+QH+Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792948956;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=IYktqvR9gwXXxuYOBAkhLZsB3ZcIwbWeiU0WdHED43M=;
	b=xfs/I1PA7dgxZsBZpae4p0OvNtDD3DK4VmWQ6fqgd4Z2EWLwH68p9/1bUPMXSSSfPXZc
	 Fy8hUJsfvKFlR0PcVdTXkpZyrjr2dz5WhzItMAu7M6TcsG3d4LfR88RWGahp9LHp1hK30
	 7yFt8AQlkdtL3cVOFRmuOmgzU5KzJv2mKu/V76FBXxxIDKtA/n1bTw6fDL4lwsitJFydm
	 xKZKpwAemnBxSJq8Lde6Ytjuvn94aq1/RI7u/7o3Q/BpShKhxa27L+dDQ77HmLqSQpq7N
	 rqYx/qtqLiwi8pZepftlioqiQU3qvvLYEoB93dJ8NbtH7LJbLyezA0u3GxVwkZmIjRQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bxCUeihU;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C505F606A31A;
	Sun, 25 Oct 2026 17:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bxCUeihU
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792948955;
	b=1dzbpF1SSVh6n0+TKlNIlx1+5PPkHgH71yV1MDzGng7z7bmpoKX1kLAABhhHYLRoEWzz
	 5GqzzVdlyThaww9YimMZ96s7B9W9nORDBBTjj6hqNUBAHuDibPzoD/ohBNAzdhtb8Op9r
	 vB5fg0/JdJlH1V+XcWN4e8xIcxFl4xQzXBSfcZN01aUj8g8GT3WqESQSFt1l4geUcyeM/
	 2WNF90t0KCn3eQeVxw6VLJgZvuxSZRjCggsRCuhOhmc2I173ieJYuf8qAedXjG5WbF5t0
	 DLqNVyeLTozEI/S82Q48NlYg/O+Ek9gXjr0xzAPe0mOIak6esBq+sqX6EN6JwPnKmcA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792948955;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=IYktqvR9gwXXxuYOBAkhLZsB3ZcIwbWeiU0WdHED43M=;
	b=MC7EbC9YTHPJ5zg6fE31qFK0NQWfHRThyg05PIKYodLsNqJIwQBQGNLH8lxLS2u88rzM
	 AQLtEM5UwLVLgz8/gDTqcKh42I7PitFv2WGQWxV4fJwSCEZTiHYX/uGwhBMhyy51GQlWh
	 1uJV9lgjXDsCgstonANZrUui/bJDD9de/MhLvgST5KKYZCSVOeKELpjzvszQHKXhqmfL3
	 JYI7v6ZlcQO85kQSJrio1B0O8XGk/JJbgEf2wcIiwJXfzOxY3ZsvtJaMNx5IpxRacDuE0
	 y7WekLXvFjsRwC6ekw3SAohPYsH4WpM9L77Bjt5B3Np2hDzaK0D9KHh3JZhskuevS5g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id D3B9C1F01828;
	Sun, 25 Oct 2026 17:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792948955;
	bh=IYktqvR9gwXXxuYOBAkhLZsB3ZcIwbWeiU0WdHED43M=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=bxCUeihUbGn9BXhJnQP1Ptx2vyiCeVGuJAkLxv4urYJ4pf//qhXjarelay0Rq4e1c
	 W0WeOcaLbR2glQUyFxRO2tD3xVzXnG2FOcJmc9jH4MDCr4B+naQ7dg6q5p7LrJWGUq
	 n7Ove6gyc8/9uj87uwGtEid45Zd0UF6SxMQwD5FmHkqFPPFhettmGuM1rtlILuo8HS
	 kzzEtQhmZwMAXHsJK14bbZ5o0ocLVfghTi+taNSai1i6Woxt/aSe3T4VPp8EoucvTS
	 A04eOm+a33u/VX2BTvRwsbwd3v2eephQkVw2mnMtQynlLOkankq8Ydibatr9l0jUro
	 XYd73bq+Z1KcA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 3357C44A80;
	Sun, 25 Oct 2026 17:22:34 +0000 (UTC)
From: Dhruva Gole via B4 Relay <devnull+goledhruva.gmail.com@kernel.org>
Subject: [PATCH v2 0/3] btrfs: add NOCOMPRESS defrag regression coverage
Date: Sun, 25 Oct 2026 17:21:49 +0000
Message-Id: <20261025-b4-btrfs-nocomp-v2-v2-0-628c1986f9b9@gmail.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAK063moC/02OzY6DIBSFX6Vh3Wv40St01feYdAEISlOlAUqma
 Xz3qrOZ5Zec853zIdml4DK5nD4kuRpyiMsG/HwidtLL6CAMGxNOOTLKOzAtmJJ8hiXaOD+hcpD
 GS49CIBeabMVncj78HtKf2x/nl7k7W3bTnvApzlCm5PQhN0oh68wAyvQWWmkQtO0pDG1HNVIUU
 trrOOvwaLbNXTCFXGJ6H7cr24eIjdWlhvWKCdUh0mYMpRnjww1TelX9r39b1/ULkarSx/kAAAA
 =
X-Change-ID: 20261025-b4-btrfs-nocomp-v2-8bf8f633623a
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Anand Jain <asj@kernel.org>, 
 Filipe Manana <fdmanana@suse.com>, Zorro Lang <zlang@kernel.org>, 
 Qu Wenruo <wqu@suse.com>, Dhruva Gole <goledhruva@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792948953; l=1705;
 i=goledhruva@gmail.com; s=remote-20261025; h=from:subject:message-id;
 bh=n/3vRrou5YbrZbVXlPGDJ5JH9mPmNCyJhEtjuKyblUY=;
 b=TF5Be2fLrDmjFsrgaGVtq+0CJ2TckeeXNSMK6gzl6vf8rXeZGO1SlA65WqLezGf9fI4sa+oHm
 KhbxzEKxqirDQo6OETxURIR1OAXtVIA4HQE7V0xfQ8kUtDWSs+/GqR+
X-Developer-Key: i=goledhruva@gmail.com; a=ed25519;
 pk=OBz78Vw5K+/+HyXjxg9mNOV2Bq087eJgHL749H+Xe/k=
X-Endpoint-Received: by B4 Relay for goledhruva@gmail.com/remote-20261025
 with auth_id=1318
X-Original-From: Dhruva Gole <goledhruva@gmail.com>
Reply-To: goledhruva@gmail.com

Add three tests for btrfs filesystem defragment --nocomp: range and EOF
handling, preservation of holes and preallocation, and inline eligibility
and short EOF tails. Check extent layouts and file contents after remount.

Changes in v2 (thanks to Qu Wenruo and Filipe Manana):
- Replace the private helper framework and C ioctl probe with direct
  btrfs-progs, xfs_io and md5sum calls checked against golden output.
- Move the capability probe to _require_btrfs_defrag_nocompress() in
  common/btrfs.
- Use a test-local FIEMAP filter preserving all flags, including INLINE,
  as suggested by Qu; leave the shared filter interface unchanged.
- Improve naming of variables/ filenames to be more descriptive

v1: https://lore.kernel.org/linux-btrfs/b99615bd-9b7c-48b6-ac70-d450a606388c@gmail.com/

Signed-off-by: Dhruva Gole <goledhruva@gmail.com>
---
Dhruva Gole (3):
      btrfs: exercise NOCOMPRESS range and EOF handling
      btrfs: check NOCOMPRESS preserves holes and preallocation
      btrfs: cover NOCOMPRESS inline eligibility and short tails

 common/btrfs        | 14 +++++++++
 tests/btrfs/355     | 76 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/355.out | 45 +++++++++++++++++++++++++++++
 tests/btrfs/356     | 64 ++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/356.out | 28 ++++++++++++++++++
 tests/btrfs/357     | 81 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/357.out | 39 ++++++++++++++++++++++++++
 7 files changed, 347 insertions(+)
---
base-commit: 3e1ee800e52a0f53d7d9a7809be1ffc80ec1788f
change-id: 20261025-b4-btrfs-nocomp-v2-8bf8f633623a

Best regards,
--  
Dhruva Gole <goledhruva@gmail.com>


