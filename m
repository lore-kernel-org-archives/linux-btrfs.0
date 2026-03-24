Received: from mail-yw1-f193.google.com (mail-yw1-f193.google.com [209.85.128.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DBF426F288
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 23:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774395349; cv=none; b=Bl5TgJTbjT4RDFTrPPieE6nhNl0C4TbXvL6JT94pNL5sP4v5rCGu3pz/lJa0SXXw/ULU+i3QxZZ50pMaJkeGiTsVWc13aUmcIzFJjIx4oWx55JQlY8Dmlkx/uF6ZzzYPLihV90L80fMsYKnkaCPrD/br4iSCyjgXssjAzyRjYNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774395349; c=relaxed/simple;
	bh=OlnWONV7vtI0jkh1MVDBOg7id/lZsJdSS0E0HIh11FU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=nCF9nW58tvSbTtSkkSo6Yc14F2pA5F8SXbxdIocqcdMnoDCTQ1WXxK0nQ4M9ow3BywPAg+cIo9Q5wP8ErGg6TCxMB01HEPnNbnp1Aos0bhgk7ALtI9lHXEususLSRoh+by2W4sRBSs/ZeLkwFkOoSbj1RFOM6j4Fwx4K2Ni70zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=s8cgvjr4; arc=none smtp.client-ip=209.85.128.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s8cgvjr4"
Received: by mail-yw1-f193.google.com with SMTP id 00721157ae682-79ac94fc3ffso13017437b3.2
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 16:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774395347; x=1775000147; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=X4j9exYXikKMf9Jq8Bqv4dXvEt+fRX5x2qoW0diZ7N8=;
        b=s8cgvjr4cgRfHiNOLmkZ5m6iKFf8fIfmS6JVm7b3fxPU9aWi+prLgdY28bJUlnN2/D
         3iquc7uHKOCmlAxNU7nJ/gI17KqFMf2R0Se2kSDZMhdFdy9gqocen6JAtVMviAb9tsaw
         f1ZdAnaZZDw+vSbVMOOPLS9/S36Y/f5QVf1W3pizffegNk1roTgI1TxsO2xPqv5o+S4a
         VHPSuVvsKczX0BpcuJO7/VQ0WsXRx7AhfWtc3cnlE6u0DJVhMG4CT9sqImADW7huK9Px
         /NpKrgfPmAhEnJSI3vVrCIRgkSH+Ec4/meE23JVLvZTUqiVGogjvaMiAtYzCBSNSrM/5
         beyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774395347; x=1775000147;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X4j9exYXikKMf9Jq8Bqv4dXvEt+fRX5x2qoW0diZ7N8=;
        b=dcaamcqZbfM/nwwIpZ7l9H+pT594z38B1t6ILi7NPtzTZsBsYjfVEPLtKtQygLBERZ
         xP3iWO07r0lwxnEkEbsq1XDYD/plzKd0KlF9846t3v8bCICOAsCPSgKQUNJX/jSlc0WU
         SkYqlXk69tWnrf4tKBV64q3B1OsSqV7mfnEZDiJ1g98LCx4fr5KtD13t+DGrkP3j231A
         jMJjGXBCeHclYMgUCBVUg4lf123RWVp4UliLb6BEcnqxEQtGKZPFJW1qugqM68sXv3RP
         +7Ewd+lcjEO3XzbMz4PkVJ34utvJDyZC6DlYTmQ9EK2SG7J/0qFAPB/Q2vl3bbXc2ckc
         ExtQ==
X-Gm-Message-State: AOJu0Yy2xDjwQXo003ix64hPS3leBewG4VN8PzICLWaej81j+hQvoxAw
	gYM8qB7wvIPTdOdoGXtlMlxd4+kA/JxUItuVh8YVoDL86jDOZI+rceX1q59rMLI0
X-Gm-Gg: ATEYQzydM1RjQuoAVtZTrjp1vmAyPwQNOpMlW9sNIWkBcVIERHtl1ISJigbngibvE5p
	jCPtUkfGU4ggoJgFQN4GXlM7727ryhnYAtT/6d4x/1vCn6vk4y6bQf4omerAZpOZH2wfJp+QU0F
	aLlrIvs25QL61w/4oHNFSYQxGgFzmzxYhTa2BwWNWCbV0sVE0qjqo1khFyexGSJ65zydl/SY4NH
	7T98sx4sszwZ+cLjLWRpYsghMXwAwM1I2Gj4Q/IsTdD2KSrpbTcBMdaN9MyQ9NdDvuwgV2l8FSa
	CB/6ReTpJJj4bWmZIpSFktMIVLVcY/QgoVasqmqcPhX4h57IjTKjuUB+ClaIfPYBHs0BE+Hl5kx
	GMjzNwLj4q6s35856h452f+NXi90jrEavfOZgJvtCJChO5jtfR8eWmDmPOJJKe24LSwGc1jCVlw
	FPK5divqAehso5FvQtZw==
X-Received: by 2002:a05:690c:d18:b0:793:b660:fbf7 with SMTP id 00721157ae682-79acf2e9a7dmr17807037b3.9.1774395347189;
        Tue, 24 Mar 2026 16:35:47 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:11::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-79acabe4788sm12143987b3.35.2026.03.24.16.35.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 16:35:46 -0700 (PDT)
From: Leo Martins <loemra.dev@gmail.com>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH] generic/747: handle ENOSPC gracefully during write/delete cycles
Date: Tue, 24 Mar 2026 16:33:26 -0700
Message-ID: <efcb3c8470bf099534fec1c1745780eba445e111.1774394322.git.loemra.dev@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

generic/747 consistently fails on btrfs in my fstests setup, with an
~88% failure rate across multiple runs on kernels ranging from v6.9 to
v7.0-rc5. This is not a regression but a pre-existing issue since the
test was added.

The test fills a filesystem to 95% then does mixed write/delete cycles,
using statfs to decide whether to write or delete. However, statfs
f_bavail may overestimate the actual available space. On btrfs, the
statfs implementation documents its estimate as "a close approximation"
(fs/btrfs/super.c). At high fill levels the discrepancy between what
statfs reports and what the filesystem can actually allocate becomes
significant, causing dd to hit ENOSPC even though statfs indicated
there was room.

This is not a filesystem bug. The filesystem correctly rejects the
write when it cannot reserve space. The test's purpose is to stress
garbage collection through write/delete churn, not to validate space
accounting.

Handle ENOSPC by cleaning up the partial file and making room:

In _direct_fillup: break out of the fill loop (we're full enough).
In _mixed_write_delete: delete a file to free space and retry. If
writes fail 10 consecutive times, _fail the test as that indicates a
real filesystem issue rather than a transient statfs discrepancy.

Redirect dd stderr to seqres.full so errors are preserved for
debugging without polluting the expected output.

Signed-off-by: Leo Martins <loemra.dev@gmail.com>
---
 tests/generic/747 | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/tests/generic/747 b/tests/generic/747
index 44834186..35de3ccb 100755
--- a/tests/generic/747
+++ b/tests/generic/747
@@ -35,11 +35,7 @@ _create_file() {
 
 	POSIXLY_CORRECT=yes dd if=/dev/zero of=${file_name} \
 		bs=${bs} count=$(( $file_sz / ${bs} )) \
-		status=none $dd_extra  2>&1
-
-	if [ $? -ne 0 ]; then
-		_fail "Failed writing $file_name"
-	fi
+		status=none $dd_extra  2>>$seqres.full
 }
 
 _total_M() {
@@ -69,7 +65,10 @@ _direct_fillup () {
 	while [ $(_used_percent) -lt $fill_percent ]; do
 		local fsz=$(_get_random_fsz)
 
-		_create_file $testseq $fsz "oflag=direct conv=fsync"
+		if ! _create_file $testseq $fsz "oflag=direct conv=fsync"; then
+			rm ${SCRATCH_MNT}/data_${testseq}
+			break
+		fi
 		testseq=$((${testseq} + 1))
 	done
 }
@@ -79,14 +78,25 @@ _mixed_write_delete() {
 	local total_M=$(_total_M)
 	local to_write_M=$(( ${overwrite_percentage} * ${total_M} / 100 ))
 	local written_M=0
+	local enospc_retries=0
+	local max_enospc_retries=10
 
 	while [ $written_M -lt $to_write_M ]; do
 		if [ $(_used_percent) -lt $fill_percent ]; then
 			local fsz=$(_get_random_fsz)
 
-			_create_file $testseq $fsz "$dd_extra"
-			written_M=$((${written_M} + ${fsz}/${M}))
-			testseq=$((${testseq} + 1))
+			if ! _create_file $testseq $fsz "$dd_extra"; then
+				rm ${SCRATCH_MNT}/data_${testseq}
+				_delete_random_file
+				enospc_retries=$((enospc_retries + 1))
+				if [ $enospc_retries -ge $max_enospc_retries ]; then
+					_fail "failed to write after $max_enospc_retries consecutive ENOSPC attempts"
+				fi
+			else
+				written_M=$((${written_M} + ${fsz}/${M}))
+				testseq=$((${testseq} + 1))
+				enospc_retries=0
+			fi
 		else
 			_delete_random_file
 		fi
-- 
2.52.0

