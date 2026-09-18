Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9C74EDCDF
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 12:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789734502; cv=none; b=Kvy3pMghNPag5W5wXoodwzDzQWlIv6bCPNDrI9QoarsBGf7J5lLvlpS3alkiFcTeiXHH1oAcwWXKlzWKrZsd37ukrz5USZ9Mi5ft6iagX+vv9EJYpifjPRh0H5IsnwRjTxF1CPJ2FH0BBVmmgCMLDzit5FeivEakWbupQCZf0A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789734502; c=relaxed/simple;
	bh=LuNYxrYb1aSxc04GCkJ7xde/y+H+Ej0XzLZiXsbfjVg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=YBbGvGKD2+0s63ApVbNgXrTvsujl3x4nKsB7rUQHPPAWKtWhJFf8cSvMMlN2KCgdcZKYVSZ0F2ZS/kr9HH2+oDH/aNRcNrywJSqPfqJg4PLpi4spddNHXj3UOvCYVlsf1Dg1rFx+y2y221OfsITxWVkybg3vWIIwFQ4Ah5wQ+9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GybRvveK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GybRvveK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD1C1F0089A
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 12:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789734499;
	bh=U/HAG92naUe8U7LmYb1GfBrcEP4AQ1OiY4zwzRTknkc=;
	h=From:To:Subject:Date;
	b=GybRvveKzWPY4Pd06zngFqOivzuDZzDVRf4kcjGMas1z0YGl7eDaxpXiM95AkyzHj
	 U8Sjp7DVvAWXX6vEkDoreltoLhrey+bLvGmQ8AaTgrkWoKUHxYrtvmo0yyCpTGX9g4
	 cLrGNxpUwRpZ45U4iLqpI7RJsDMDZsQWxoSwtxsut+zZdShfdb0awQK1s6u82I9f6b
	 b7XrQVLf7s8Z3sgpS9tILZZBVx5wltoD4MrzXyWw0aVB/jb5a/4xLNiTMRbl6f41SL
	 0PPmVjhsWjZp3NpfMuyAUIdAK4qj+sSqhb9TMTWKyE6qmjfdBRfJ+prWjna84xhUAN
	 U0xWZVk4YdIvw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] btrfs: a couple fixes for record_root_in_trans()
Date: Fri, 18 Sep 2026 13:28:08 +0100
Message-ID: <cover.1789734239.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Fix a couple issues in record_root_in_trans / btrfs_record_root_in_trans()
detected by Gemini, plus add a lockdep assertion.

Filipe Manana (3):
  btrfs: clear BTRFS_ROOT_IN_TRANS_SETUP on early exit from record_root_in_trans()
  btrfs: fix barrier usage in btrfs_record_root_in_trans()
  btrfs: assert reloc mutex is held in record_root_in_trans()

 fs/btrfs/transaction.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

-- 
2.47.2

