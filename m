Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775F740D587;
	Tue, 14 Jul 2026 22:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784068729; cv=none; b=iEyyHFjEYNqgsH73fsnKRVgkmldfvVMzLpzu/J9L4mhvtDnRwYYv6993D5wjPBlCd5MJlQpqX+4TEO+R3qglBxTb5ZADUJ+ZvjyC7JPaHzVZAq239xuG4E5LAASPRZaK5xubK2Lx5X+RAPjWRK9tYQyt9w12tC6H9OEUXWtaNUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784068729; c=relaxed/simple;
	bh=LJe35bK0mzDSFPnx/5/NFotbF5eoBo5IaJRpCsrYQpg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rx3XpDytrZ6ot7bqiZM1LfgndBN3Oxu5cYoHeWdrdKJqIggGiqGG619Nl+CAN6qj630D8Q7kaVajd22HXWgAaG3RcVQd9GrArMk7Wmxb2WF9W5sewzDARlDnaPebyYUfVCvMDGF2XaIoXvUU5zMDMYyRSrPmvh9GaiGVV1JcF8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QaGszAno; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QaGszAno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D08E1F00A3A;
	Tue, 14 Jul 2026 22:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784068724;
	bh=wocZItaHyRLjC3MCrhPOlfgjSr56QAjEgZfydFBvyek=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=QaGszAno1wudFc2DEMwrCf1QRAfwpOZkXpnLrMSUiwSyqrXtzdSDgRp7iF1Vr1O3i
	 3Effe0cEbapf4ELXi0r5Kcro6mSBfpust3315ndakU6JY3oaZK5UJhQyAad+7A5y4J
	 eMgfn/9K4g+ZBKjABLsI6ocVluLcY5qhM+k1QWUxShlv7kbPNovpKzhMh+5VGaw3Oz
	 ZWqmo42veNeEZ6Z755kuZtnmxuHsYn5pSz67nifNQoRJLFwO8v58YrXwLmHolb3cJe
	 bBls8d+K0Rg+XmTMt+jA5C90scgcLfeDcFzx7rql3xjRrAJHzHkWk2AqRjsKPxodGt
	 /3bpiJxw5mcqg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id CEE62CE0430; Tue, 14 Jul 2026 15:38:43 -0700 (PDT)
Date: Tue, 14 Jul 2026 15:38:43 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Boris Burkov <boris@bur.io>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [BUG] fs/btrfs: KASAN "args" initialization gripe in
 btrfs_ioctl_get_csums()
Message-ID: <44261d8e-4361-4592-9fcf-b5c8d56220ba@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <b2c3772b-f4f1-41a1-8fc2-468c4ac896e8@paulmck-laptop>
 <c4392627-feb6-4353-bf59-eb152997af72@gmx.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c4392627-feb6-4353-bf59-eb152997af72@gmx.com>

On Wed, Jul 15, 2026 at 07:25:49AM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/7/15 06:02, Paul E. McKenney 写道:
> > Hello!
> > 
> > This should be considered at least as much a bug report as a fix.  Though
> > this "fix" does make KASAN happy, so there is that.  ;-)
> > 
> > The following compiler diagnostic appears when building with KASAN on ARM:
> > 
> > In file included from ./include/asm-generic/rwonce.h:26,
> >                   from ./arch/arm64/include/asm/rwonce.h:81,
> >                   from ./include/linux/compiler.h:369,
> >                   from ./include/linux/array_size.h:5,
> >                   from ./include/linux/kernel.h:16,
> >                   from fs/btrfs/ioctl.c:6:
> > In function ‘instrument_copy_from_user_before’,
> >      inlined from ‘_inline_copy_from_user’ at ./include/linux/uaccess.h:184:2,
> >      inlined from ‘copy_from_user’ at ./include/linux/uaccess.h:222:9,
> >      inlined from ‘btrfs_ioctl_get_csums.isra’ at fs/btrfs/ioctl.c:5220:6:
> > ./include/linux/kasan-checks.h:38:27: warning: ‘args’ may be used uninitialized [-Wmaybe-uninitialized]
> >     38 | #define kasan_check_write __kasan_check_write
> > ./include/linux/instrumented.h:146:9: note: in expansion of macro ‘kasan_check_write’
> >    146 |         kasan_check_write(to, n);
> >        |         ^~~~~~~~~~~~~~~~~
> > fs/btrfs/ioctl.c: In function ‘btrfs_ioctl_get_csums.isra’:
> > ./include/linux/kasan-checks.h:20:6: note: by argument 1 of type ‘const volatile void *’ to ‘__kasan_check_write’ declared here
> >     20 | bool __kasan_check_write(const volatile void *p, unsigned int size);
> >        |      ^~~~~~~~~~~~~~~~~~~
> > fs/btrfs/ioctl.c:5201:43: note: ‘args’ declared here
> >   5201 |         struct btrfs_ioctl_get_csums_args args;
> >        |                                           ^~~~
> > 
> > Fix (or at least suppress) this by initializing "args" to "{ 0 }".
> 
> This is a little weird, as @args is immediately written with
> copy_from_user().

I was wondering about that myself.  Perhaps it refuses to assume that
the entirety of args is overwritten?

> So I'd say this may be specific to certain compiler version.
> Mind to provide the name and version of the compiler?

gcc version 11.5.0 20240719 (Red Hat 11.5.0-14) (GCC)

> But still, initializing the structure to zero makes no harm.
> 
> I'll convert the report into a proper commit during merge.
> 
> Reviewed-by: Qu Wenruo <wqu@suse.com>

Thank you very much!

							Thanx, Paul

> Thanks,
> Qu
> 
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> > 
> > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > index 9d47d16394fc56..1e28f1411e20f8 100644
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -5198,7 +5198,7 @@ static int btrfs_ioctl_get_csums(struct file *file, void __user *argp)
> >   	struct btrfs_inode *inode = BTRFS_I(vfs_inode);
> >   	struct btrfs_fs_info *fs_info = inode->root->fs_info;
> >   	struct btrfs_root *root = inode->root;
> > -	struct btrfs_ioctl_get_csums_args args;
> > +	struct btrfs_ioctl_get_csums_args args = { 0 };
> >   	BTRFS_PATH_AUTO_FREE(path);
> >   	const u64 ino = btrfs_ino(inode);
> >   	const u32 csum_size = fs_info->csum_size;
> > 
> 
