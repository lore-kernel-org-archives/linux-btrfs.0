Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5192403B00
	for <linux-btrfs@vger.kernel.org>; Sat, 10 Oct 2026 10:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791629687; cv=none; b=iyZm/J+HHh7aInrlq42HLXUXXJSl4PXAOraRS3Pbj3a8sSgkr6hreOfjxtm9cutFP6j15dQw0P6yiUCpde/odd0NpS701H3Mgh+wE4RjKS0yC5KQ52JqfwSC3PpEIPrmVv4nSgLE58hnsLTo+wItVWsyw2VA8RwKroatsSZnaAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791629687; c=relaxed/simple;
	bh=Lx4pYf7ox2ftKijZw338RFHnP5fJrmBZaR9iQNhr5fE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TXQbdUQE4DdULvicCdI7DDKa+2IYUzQqe7fkRUY7QsbMOgCGMYNIp+UGNpxekQUUH4ifq7WsYF0p/tUPtzsQfrjFE3In3eOnZAde547MMTXGuVfSuN2vngNS2Vu5gvvFrPR3OO6bHEcGMKPHTzK6ZEWSfX/DW+LuQjMinECAgXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cs.unc.edu; spf=pass smtp.mailfrom=cs.unc.edu; dkim=pass (2048-bit key) header.d=cs.unc.edu header.i=@cs.unc.edu header.b=m2mxfjzZ; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cs.unc.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.unc.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cs.unc.edu header.i=@cs.unc.edu header.b="m2mxfjzZ"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-91b52ba422cso8029556d6.2
        for <linux-btrfs@vger.kernel.org>; Sat, 10 Oct 2026 03:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.unc.edu; s=google; t=1791629684; x=1792234484; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=q++ROavf5Dntc+2Fvf5HgOibvKYoyzYPl6CilCM+dkk=;
        b=m2mxfjzZix1oEhOzoj2ZW6wmgD/o7IARnsVTgaza9BEdIbkJlDHdOKp2llm1VeL1w9
         5cOBxOU/GXJQyS59F0dnsvFnAVPqUun5GhQFN8BNDR+2xvqkDxkk+mxTPadUvMM1/I1a
         vV5UVqtxe6aR9PKJFaMdwBWdakGebYKkWC4UE+EBNiNLIXzKDCuGlSK4ZtRtyQY5VBvM
         sRUcnTX4ay7aMQgVsaQ0twmv1JWWjZOYREWM8oao4QAM0/bM972lFeFgLlR8I2kJrIZX
         0N42M1k4r66epuESs0wx1a4iJdKfLBcX/az8MfGO6yUzhW+/S4W0DclOAr+iGLhKPsmt
         llug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791629684; x=1792234484;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q++ROavf5Dntc+2Fvf5HgOibvKYoyzYPl6CilCM+dkk=;
        b=zUr8zchLeNsKw+iA7pqazyi7xOJDYFtsp6u1VwJbEVK2/N0V4VKpZzeB9e0kFsZTe+
         E24aOKSkjWws5v+L0k6Pfga+7vOTZdFyWvvUFF+vP/CLVTU1hOQAzS1w4kPQt//6o1Zy
         YsgF2neyoMxm/9q0yhIGE/4wEMoHKx0xlFCpprwo1xRYo7uwYGk+wpq4WOeZLntp6N6E
         YrEmCa2UN02ErpQmYc8c59kigKDER1ETEhhU1e+EPALzaBeJCZEysCS2yhA2yLyAwDxd
         j5OXgWuz8BrneydfD80HNYtF0nBovq6LBi3E/rrzPcxdiBBGtI0/iwF2t/0u2E1UoHiK
         mo2g==
X-Forwarded-Encrypted: i=1; AKwUvBzT6OqQnCLt5j8jqy4q2r/mWSoGWXBdjOdBNhXo+UA7o0JAT0emXSPHvrFlhoRVVY2rEhUbN4q+h1v3Sg==@vger.kernel.org
X-Gm-Message-State: AFq9FYL4Z+nimhLwlUc0Rewcj2pVKhVSO3cCpjWL2F9abuBtAqsf5/Wc
	KfcTdIqqkL88qAmV/RJcs0xbe/VmqoaNMK0B+aFKpdDdncMfFimVBh/IO6Rp/xKxQg==
X-Gm-Gg: AYBFou2QqdS2mTWj7DaHa2a3NZZdSNPB48snEFg9o+AZmSc4Mi5v9SIvNa5aXw+OOFp
	p9ZKS/D7FqoBMicIRFB5F1OSjATSDk9spP8796HuBAzLdgulzqgQElumVkuZw+g7vBtN+rb4Itw
	Zx8wZCmwi239+PIl3lAjScyODhozjfcVmv3M0B39/zvdgD5s0m9GfRbDLHrRNfAIrCKH/8Hm9ud
	pGsD5iQcTsAZsjvyThxe9YNpnZAx7tHxzj9YA5+oyFi+GAC7PXIaNnqaG8md13UQaVP7gnawY4v
	9dy8iPCpM2gM1Dpu8cE7dqWBTw5c3XezvDQ2tLSZhzYmQ/Yy21pNCwKvSr5Vfp6QntvW6yfsIxA
	8bboF4t5DFeqGC6H5Mcfrsr4K4QT/aP2p36C77b9e92McmlodQvbCrOUBueBEk3ZdbmX/MtXQsw
	AxapEDyCSXVrOGmkzjDjldyQWw8WNXiT8vNgqwTizMlx8oEsV/XTR4QK85TgYAvbDADyjlU9JfW
	T5xp9z3a//yXPEMpUtDDQ==
X-Received: by 2002:a05:620a:17a0:b0:93e:c12c:f13b with SMTP id af79cd13be357-93ec12d085amr605390185a.69.1791629684570;
        Sat, 10 Oct 2026 03:54:44 -0700 (PDT)
Received: from cobra01.cs.unc.edu (cobra01.cs.unc.edu. [152.2.130.143])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93eb9898b5fsm394602785a.32.2026.10.10.03.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 03:54:44 -0700 (PDT)
From: Hengyu Liang <hengyul@cs.unc.edu>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] btrfs: fix chattr failing on nodatasum files that have the compress flag
Date: Sat, 10 Oct 2026 06:54:25 -0400
Message-ID: <20261010105425.165104-1-hengyul@cs.unc.edu>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit cf1afec09e9f ("btrfs: validate properties before setting them")
made btrfs_set_prop() validate a property before setting it. For the
compression property, the validation fails with -EINVAL when the inode
has NODATASUM.

However, a file created on a filesystem mounted with nodatasum has
NODATASUM and still inherits the compress flag from its directory, and
btrfs_fileattr_set() sets the compression property whenever the new
flags include FS_COMPR_FL. As of now, chattr fails on such a file, even
when it only changes another flag.

The issue can be reproduced with:

    mkfs.btrfs -f /dev/sdb
    mount -o nodatasum /dev/sdb /mnt
    mkdir /mnt/dir
    chattr +c /mnt/dir
    touch /mnt/dir/file
    chattr +A /mnt/dir/file

Before commit cf1afec09e9f ("btrfs: validate properties before setting
them"), the last command succeeds.

After that commit, it fails with EINVAL.

This patch will make btrfs_fileattr_set() set the compression property
only when the inode can be compressed.

Fixes: cf1afec09e9f ("btrfs: validate properties before setting them")
Cc: stable@vger.kernel.org # 7.2+
Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
---
 fs/btrfs/ioctl.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 52aab510aea0..347509043f2e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -421,7 +421,12 @@ int btrfs_fileattr_set(struct mnt_idmap *idmap,
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
-	if (comp) {
+	/*
+	 * An inode with NODATASUM can not be compressed but can still have the
+	 * compress flag, inherited from its parent directory. Setting the
+	 * property fails validation for such an inode, so leave it unset.
+	 */
+	if (comp && btrfs_inode_can_compress(inode)) {
 		ret = btrfs_set_prop(trans, inode, "btrfs.compression",
 				     comp, strlen(comp), 0);
 		if (ret)
-- 
2.53.0

