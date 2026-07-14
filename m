Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5C337E5D6;
	Tue, 14 Jul 2026 20:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784061146; cv=none; b=DHSAfz+O4iD0rEF6YVWxCkhwKRpiHkXee/tZsKqnKBNoOxg3A+oEy01yIU4WMPNf4p41SjVrXy40wSCY/WQkO4rvWGuH7SPgr2I7MdLPlfaWPG3qXwzkZNibwxgyK6k7s/k3fhvMlP8ekmBAs6OOCj3d1rckwOjIwyXiKqXgHz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784061146; c=relaxed/simple;
	bh=2fbSrGJ8HMyEzdAmvSrPXAGvTUEnVtkOL6V8+0cpdjc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=usvlVaJO+4NRARaK6dWGs8eSUFtctOmjRh/k2lCUZ+LsIv5VBhM3ICuNnyUcovQ+ymY0v93KAIyjZahzPbtI7YLSrlq8Pb+LqOmhtGqpY2gj68QPmSEK0ORag2tuOymx6GLfmGnBpGHPGrY8syhD2qXJtFLCEoEKeS/d9BoGN2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mp2He8Vo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mp2He8Vo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78491F000E9;
	Tue, 14 Jul 2026 20:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784061144;
	bh=6APc8Hb9fKF5IErNUElSad3eSdlmNvvKHBtPNcPr7AI=;
	h=Date:From:To:Cc:Subject:Reply-To;
	b=Mp2He8VoJL22HFWiBI/XaW5oIIunQJErv2ySsVDE4/gO2jj5k6pa8d/DneGVrea9q
	 dzt8LsIfxJPyjdPV4AtjuHxTUt+BMeQIeKUsmdTFK7vjgtW53fKOiaHpWBwLMloOWQ
	 2TZQ4J0BIRm9l9iktJQOWGtjgVtLHxMrFnKGv3uEt0xkILBumcr/VeqMVyjJ99tY3V
	 X6ukeCURJ5KtSKoq0aixXqaAGBLPTh0wTOXTdLt19UZQuNfKVi8cyG2gQVoAkSM/E9
	 iLyzEgcvP6cRb429U7SYs572TtPDRuaZGGVdyBqMSbHPNoP3HCzjtq6RUzrLgAwTAp
	 nuP97+YGirzTg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 98A49CE054B; Tue, 14 Jul 2026 13:32:24 -0700 (PDT)
Date: Tue, 14 Jul 2026 13:32:24 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Boris Burkov <boris@bur.io>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [BUG] fs/btrfs: KASAN "args" initialization gripe in
 btrfs_ioctl_get_csums()
Message-ID: <b2c3772b-f4f1-41a1-8fc2-468c4ac896e8@paulmck-laptop>
Reply-To: paulmck@kernel.org
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hello!

This should be considered at least as much a bug report as a fix.  Though
this "fix" does make KASAN happy, so there is that.  ;-)

The following compiler diagnostic appears when building with KASAN on ARM:

In file included from ./include/asm-generic/rwonce.h:26,
                 from ./arch/arm64/include/asm/rwonce.h:81,
                 from ./include/linux/compiler.h:369,
                 from ./include/linux/array_size.h:5,
                 from ./include/linux/kernel.h:16,
                 from fs/btrfs/ioctl.c:6:
In function ‘instrument_copy_from_user_before’,
    inlined from ‘_inline_copy_from_user’ at ./include/linux/uaccess.h:184:2,
    inlined from ‘copy_from_user’ at ./include/linux/uaccess.h:222:9,
    inlined from ‘btrfs_ioctl_get_csums.isra’ at fs/btrfs/ioctl.c:5220:6:
./include/linux/kasan-checks.h:38:27: warning: ‘args’ may be used uninitialized [-Wmaybe-uninitialized]
   38 | #define kasan_check_write __kasan_check_write
./include/linux/instrumented.h:146:9: note: in expansion of macro ‘kasan_check_write’
  146 |         kasan_check_write(to, n);
      |         ^~~~~~~~~~~~~~~~~
fs/btrfs/ioctl.c: In function ‘btrfs_ioctl_get_csums.isra’:
./include/linux/kasan-checks.h:20:6: note: by argument 1 of type ‘const volatile void *’ to ‘__kasan_check_write’ declared here
   20 | bool __kasan_check_write(const volatile void *p, unsigned int size);
      |      ^~~~~~~~~~~~~~~~~~~
fs/btrfs/ioctl.c:5201:43: note: ‘args’ declared here
 5201 |         struct btrfs_ioctl_get_csums_args args;
      |                                           ^~~~

Fix (or at least suppress) this by initializing "args" to "{ 0 }".

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9d47d16394fc56..1e28f1411e20f8 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -5198,7 +5198,7 @@ static int btrfs_ioctl_get_csums(struct file *file, void __user *argp)
 	struct btrfs_inode *inode = BTRFS_I(vfs_inode);
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct btrfs_root *root = inode->root;
-	struct btrfs_ioctl_get_csums_args args;
+	struct btrfs_ioctl_get_csums_args args = { 0 };
 	BTRFS_PATH_AUTO_FREE(path);
 	const u64 ino = btrfs_ino(inode);
 	const u32 csum_size = fs_info->csum_size;
