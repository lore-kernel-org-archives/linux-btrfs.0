Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99D450AC31
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 14:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790778359; cv=none; b=icExkiIG0+J6aONb8tgej13FgYko+nvkva0pcjHn19GwJJQwG59GHJ76nVYRtX74120fuZGE2XkK79vC6sEjLfb6NcyUL53dGYTELcScaTzmpiRb8OJ6Rt5Lun9DCwypJ+3mVaqvucT1bWVfnywIROUbrb/gB2r0YArprd8G7d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790778359; c=relaxed/simple;
	bh=+GyKcebat9k6Nl1+Ey8NxlMy4OgQZBw+Js9wkQWIkuA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PPUhL0L7b0UCya2Zw+/MQfKHmTJLt5Q2zQ8Zm1/8d4aonJuQW7PAmvto/lPaLef5qfP9WavoeD3I1CMkEbQldfWqbGjRMt3FSZwjPWnLVmGLmEpKV2qsGrJBU6vsqOaxSsy/PZEmo6cHjJKP+O0RUIljGEa9jB18a8VC+4bkJ/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dfl1kBPY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dfl1kBPY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7677F1F0089C
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 14:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790778348;
	bh=40LhHKjrhrd3v+NVzKTdqSOlMm0HMGOo5aG4lavlt4s=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=Dfl1kBPYTlHlhjQLpil/H1WqVkwNGtr5C1WJUk77L890BRxYspE+YnLlViUGoCBbF
	 ktVpjmkUqq6zIOOrsJM/cJ7Jq8s+4KMDLny6KiIXJw5iV4BO5uh0w+XlZQ2hCKXSxD
	 AyXwyxqnJmtNeREGnKeu59DChcdO0EcgxL0I2kzHu9nLtWw+vlcQUq6jKr8WGxDTW4
	 Avsnhw5khmwoVljFalHbjPNXAE+ri8/6gH1aTHvVG5muv5Y2VxT7AyO0ySnnvshhQI
	 R/42sIDdX/cyg73OcX+ZsQTR9OrEQ5eZoPWVjdQmsO4k0eYQymzJ3xJ+x/NDYEBbDB
	 JkxkhJ7aymmIg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/5] btrfs: avoid overhead when logging messages if fs state is clean
Date: Wed, 30 Sep 2026 15:25:38 +0100
Message-ID: <df9f45b0a78e2ec5b5a4d8fc3b4f8f5992ede839.1790772326.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1790772326.git.fdmanana@suse.com>
References: <cover.1790772326.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

If the fs state does not have any errors and is not in some special state
(like emergency shutdown or mounted with rescue options), then in
btrfs_state_to_string() we end up doing a memcpy() into the buffer and
then later just undo that work by setting the buffer's first element to
the NUL terminator, since fs_info->fs_error is 0 and there is no bit set
in fs_info->fs_state.

Improve on this by returning early if there's no error in the fs and the
fs state is clean, which is the expected scenario for a healthy fs that is
not mounted with special options like the rescue options.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/messages.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/messages.c b/fs/btrfs/messages.c
index c42a12139377..0704be7be871 100644
--- a/fs/btrfs/messages.c
+++ b/fs/btrfs/messages.c
@@ -33,27 +33,27 @@ static const char fs_state_chars[] = {
 static void btrfs_state_to_string(const struct btrfs_fs_info *info, char *buf)
 {
 	unsigned int bit;
-	bool states_printed = false;
 	unsigned long fs_state = READ_ONCE(info->fs_state);
 	char *curr = buf;
 
+	if (likely(BTRFS_FS_ERROR(info) == 0 && fs_state == 0)) {
+		*curr = 0;
+		return;
+	}
+
 	memcpy(curr, STATE_STRING_PREFACE, sizeof(STATE_STRING_PREFACE));
 	curr += sizeof(STATE_STRING_PREFACE) - 1;
 
-	if (unlikely(BTRFS_FS_ERROR(info))) {
+	if (BTRFS_FS_ERROR(info))
 		*curr++ = 'E';
-		states_printed = true;
-	}
 
 	for_each_set_bit(bit, &fs_state, BTRFS_FS_STATE_COUNT) {
-		if (fs_state_chars[bit]) {
+		if (fs_state_chars[bit])
 			*curr++ = fs_state_chars[bit];
-			states_printed = true;
-		}
 	}
 
-	/* If no states were printed, reset the buffer */
-	if (!states_printed)
+	/* If nothing printed, ensure we return an empty string. */
+	if (curr == (buf + sizeof(STATE_STRING_PREFACE) - 1))
 		curr = buf;
 
 	*curr = 0;
-- 
2.47.2

