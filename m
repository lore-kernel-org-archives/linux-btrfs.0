Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793210151;
	b=0pW9BsOOjCL1H1a6gL/ExHdcUoZMegfaoGp48XL5cd1bGCh0F//GRBIeHUXaFjnlsfER
	 RMQfblS32iGZQa4TQWCqfIyzAoFIYepM5hGL01XkTHG0SFHcPAaRpm48EdLwA7DOWIv2a
	 CqbQPZRl16LPyEMp8OryrfOsWgANUAXpBXcH5SHQVnTc8Vr5irZ0HvHaR/QEBnVJFJX5X
	 nV4gKRD1T6S978IG82p34ybXSa3Ilrlk2Q1q5KaZy7ZFZRmZWi6jMwFY81hLZvKY+lynW
	 1ZTqcOQkD/A4dQXlP16bUwioQDL4jsBEuEzrdZpo3JBL+v5tARu+WMOWMm3Ykr+7LrA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210151;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=yVEY6mnRFZ2IK2UMOXQoNDcDcdPm/HNq0wlvqqtWByo=;
	b=izWZBEOb9uxMDowgnOoB7u3WGkM6sOBT0H0WI+MeKD/Ka/YSfXBFWxK9VvC+HJD44fs0
	 6HbYTkWsCWWvHbnsKJWj0ud6MLqtYo9NKPauPEQ7vU1Y3T9QC8gbD9uHzC6ZLcd6oPlcl
	 /kyOfnA8fk4DEkV8LUM53f7rHzAL8x/ZSW5T6Jdt2KljBJSlwL1lFIqcm0XdEhDHRiwnp
	 q5HTCVQ4O5h6LkcwG4g8I6w/c1mrx6Qn5/aPeLk6AF+7iaV0nrAWzRqVvFDKZOxbrjBza
	 6lXcwc7NOr8Ourcj7n0ciLV/mxcITomNA0Zc2oyKJnPygr0t2pQVKgTSdV1XAS7vezQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GSb1uLp8;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC8F606A325;
	Wed, 28 Oct 2026 17:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GSb1uLp8
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793210151;
	b=acOBkZhTEuQEOmIdJUTIq5yUzZ+VmlPwt3Hgg8zoVjx8YyN7QxBlwxKm0OwnYoSnVO8h
	 YZgCmaHYED7xaleNZs28SZKYfM2yoyT61ZimwZzbw9GAYnIJ6508ZR0ZjwreTeEohmkjT
	 R09yzUJ5hG5q5RmZWw45ea8fcprNJl/CowuWlC1GQx/WF9zSlDOpRB63GDEs/OuFi19Pw
	 CDmqO9jzomc0XZgdNfqrRNGw/8DFKDodHpQ9cRDVoBqtPW8mNO7Pl0X1Pi446bIZ/FaJY
	 WMDrrwWZS7dNrfsLtAgrA3+GUCathmrPxNFElLsWPTVbrSrEFJ3hnLn+JycpzQo5JMQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793210151;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=yVEY6mnRFZ2IK2UMOXQoNDcDcdPm/HNq0wlvqqtWByo=;
	b=K7d0jGQSxkMKEjW/AZto4cOI28FqYD3+Y5RXBUJ9Efl25Nh5lvw3GHQF7aVeJzYdfla/
	 Iec/J/AE6cU2EUoMlmjhZFA//8pmAjMBroKHQmSym2u/SJop0vXJN0WZvQxFKmFNZ4t58
	 ysjjHW7yXd6QbzkWWzA+AgDyWSLkt+OyH3/GbqzaR8ZduQ6++lJ8HW5zeV33UmQglZ831
	 k3i5R2E0FwSU5bDx+FwBLReO2J8DTuw+Brx3n84rTYOuYE/Cw4/ZZN38q9IuTNVsUrnNP
	 6pZkL9T/an1x5BtKj83/7wpDcHAbL2xljcbRXFJ8xcJoGqD6iLlZyJ1eJQqEGJEfk4A==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id DE3361F01829;
	Wed, 28 Oct 2026 17:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793210151;
	bh=yVEY6mnRFZ2IK2UMOXQoNDcDcdPm/HNq0wlvqqtWByo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=GSb1uLp8BiuH9yo/BxS27wd2Spgb2cZUf+/Q6AssZ7JWg6DzeoNym94O95gKJqkEL
	 JUNM7ygvQu6gxc/JK7G0YOMtplbyhbfnhKrXRf6dKb7gh/G+/uu638ssvj8RicL53n
	 MLDpjTL1ZtE1HhCPyxtoNi8uIrgTFSvjNfVMQF235nNzTDyh1GQRRG3cuhskR5KGMn
	 3diz0IyWhpS61yAwMJs8bS7EA0IKyvpABgrpkPXIrjrW1A7KpoSjvjgw6akbUvMUoU
	 vDvUimday/kXbw16YZdN40J3WU1vgrX4WUzi/52gQlJP2eftDcV+7XDtpxhshjm/xs
	 +AaVKSEpyKlAQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 6A2A7454E3;
	Wed, 28 Oct 2026 17:55:50 +0000 (UTC)
From: Luca Stefani via B4 Relay <devnull+luca.stefani.ge1.gmail.com@kernel.org>
Date: Wed, 28 Oct 2026 18:55:49 +0100
Subject: [PATCH 1/2] btrfs: account partially completed discards
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
Message-Id: <20261028-b4-btrfs-fitrim-interruption-v1-1-bf5c53738b3a@gmail.com>
References: <20261028-b4-btrfs-fitrim-interruption-v1-0-bf5c53738b3a@gmail.com>
In-Reply-To: <20261028-b4-btrfs-fitrim-interruption-v1-0-bf5c53738b3a@gmail.com>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
 Luca Stefani <luca.stefani.ge1@gmail.com>
Cc: Robbie Ko <robbieko@synology.com>, Filipe Manana <fdmanana@suse.com>, 
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793210149; l=2358;
 i=luca.stefani.ge1@gmail.com; s=20261028; h=from:subject:message-id;
 bh=F8Pv6qkXxT7wewljV2XNrswlKdtAJgpfaMISGxrcbhU=;
 b=+2gdX7sfz1h0qgzIpAuAL6fcd6qg9uioKN7l5daPZivzQYYj9AoiKdo6Wa+usHadZ3K6F0llM
 pY2vmhhMZxWBC3D/CtV6lD9mGMraSPSEUdx6NAn3kupD90Dn+Tp9bOZ
X-Developer-Key: i=luca.stefani.ge1@gmail.com; a=ed25519;
 pk=0OIKU9oiaC0ALN4kqvw7ZbPFXqsBLvWm7MhEDYv3PyI=
X-Endpoint-Received: by B4 Relay for luca.stefani.ge1@gmail.com/20261028
 with auth_id=1347
X-Original-From: Luca Stefani <luca.stefani.ge1@gmail.com>
Reply-To: luca.stefani.ge1@gmail.com
Content-Transfer-Encoding: 7bit

From: Luca Stefani <luca.stefani.ge1@gmail.com>

A discard can complete part of a range before a later chunk is interrupted
or fails. btrfs_issue_discard() reports the bytes already discarded, but
its callers only accumulate those bytes when the entire operation succeeds.

Link: https://lore.kernel.org/20261028-btrfs-fitrim-freezer-v1-1-0ad1d58aa94d@zliang.me/
Signed-off-by: Luca Stefani <luca.stefani.ge1@gmail.com>
---
 fs/btrfs/extent-tree.c      | 5 ++---
 fs/btrfs/free-space-cache.c | 5 ++---
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9b0a5c6b96f3..242db255cf1c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1463,6 +1463,7 @@ int btrfs_discard_extent(struct btrfs_fs_info *fs_info, u64 bytenr,
 				continue;
 
 			ret = do_discard_extent(stripe, &bytes);
+			discarded_bytes += bytes;
 			if (ret) {
 				/*
 				 * Keep going if discard is not supported by the
@@ -1471,8 +1472,6 @@ int btrfs_discard_extent(struct btrfs_fs_info *fs_info, u64 bytenr,
 				if (ret != -EOPNOTSUPP)
 					break;
 				ret = 0;
-			} else {
-				discarded_bytes += bytes;
 			}
 		}
 		kfree(stripes);
@@ -6703,6 +6702,7 @@ static int btrfs_trim_free_extents_throttle(struct btrfs_device *device,
 
 		ret = btrfs_issue_discard(device->bdev, start, len,
 					  &bytes);
+		*trimmed += bytes;
 		if (!ret)
 			btrfs_set_extent_bit(&device->alloc_state, start,
 					     start + bytes - 1, CHUNK_TRIMMED, NULL);
@@ -6712,7 +6712,6 @@ static int btrfs_trim_free_extents_throttle(struct btrfs_device *device,
 			break;
 
 		start += len;
-		*trimmed += bytes;
 		trim_len += len;
 		if (trim_len >= BTRFS_MAX_TRIM_LENGTH) {
 			*ret_next_pos = start;
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index bff6e5b372d6..a85806bcf87a 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2415,10 +2415,9 @@ static int do_trimming(struct btrfs_block_group *block_group,
 	spin_unlock(&space_info->lock);
 
 	ret = btrfs_discard_extent(fs_info, start, bytes, &trimmed, false);
-	if (!ret) {
-		*total_trimmed += trimmed;
+	*total_trimmed += trimmed;
+	if (!ret)
 		trim_state = BTRFS_TRIM_STATE_TRIMMED;
-	}
 
 	if (reserved_start < start)
 		__btrfs_add_free_space(block_group, reserved_start,

-- 
2.56.0


