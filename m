Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2EC53793A9
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Jun 2026 19:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781292290; cv=none; b=ds4Ow2ThbRJRUeADqn6GSiJRRoE6T/VOQfxR7sdQVS+0yaI6JldqGhsV6NRh1FSBPytTSELOgV2UZ+QX4q9l32vTzMw4z+h2QSLhNyWagt2PT2twvDsnDHluAm9KkOUjQ2sxKMu4GZxYHvbXsLbHiJXuWQSoLEv/bWasUaA662M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781292290; c=relaxed/simple;
	bh=fvzl5V7IX5iOnqdHlPFaGNqKIBK3SDsoj+RGM9dyjl8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TSm7j1P7Q0acwJHJt3TY+LOJMusaEGdMOiMY5FuQFVNC1BUHEpK73/sgBOfjjxf+bR82IDYw0o73EZ1i/EAU4NxH0quzEhQlKAaOL26QG3AvGvGH/b6BMiQ+Z0x1hrqT2nm4BsaeynDF3ViiDeCv5AVOfmcnK2ODXBjUhu0uOak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DmIEPocQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DmIEPocQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD91C1F00A3D
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Jun 2026 19:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781292287;
	bh=EuAYtsjMxx5O10gJ4eUY5ZyW4DEIpbXGGqCHAwRC2Rs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=DmIEPocQgmHs0/w88uygEV1qni2tuNY/GFSM70uZyLJrtMZAqUDSDPBQUrNY6gSNc
	 Vt8Ey4t7de12tnMrS4JPBmS17tBENE1bvMn7k5FBPcD70E9TaItcVgGqpoE0Ggdhks
	 cJ2afwoWd3XN/H8bwHTnaifAA5hrvOBuP5Eb2g6sE405561bhJ4bytcdF1cQ19snVQ
	 8KpG1LzoI66kyfRKYRHEtkIPU/k73Sk2gPzzZ/sZrf66pS3uJUTa7Fvb83KuraVLAo
	 gsOUv6insld2kjWXM3k8BauNd2w8j5JAYQmiEsW8atC8IZx/x47shlKbAJWhS/Tw7M
	 DNgygh5Uuk4Rw==
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-68ced97b6eeso2136690a12.0
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Jun 2026 12:24:47 -0700 (PDT)
X-Gm-Message-State: AOJu0Yyhpp78aAtbVj8sbiYQynsKIZyQS+TFAa4nnjWP51evv35KOG/J
	bRGa0phXYgcxfss07lmXvYfldlWq0aV1asXTMVlWrXav1hKITbPJxmJn5a9SujrfV7u3SJBc4ZM
	vJj4fhQYcKobzt2pLSXRJ20S66sv/xHI=
X-Received: by 2002:a17:906:8471:b0:bf4:475f:ca8 with SMTP id
 a640c23a62f3a-bfe2acf85bcmr126392166b.35.1781292286307; Fri, 12 Jun 2026
 12:24:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <62602395bf1488aa81645ea59e22405d6c06d3f7.1781263239.git.fdmanana@suse.com>
 <202606122155.6ncF2GHC-lkp@intel.com>
In-Reply-To: <202606122155.6ncF2GHC-lkp@intel.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 12 Jun 2026 20:24:08 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7ORUToy22PWoAHvi1JvwH2Boy2V7YTqOcYs=t36MZjAQ@mail.gmail.com>
X-Gm-Features: AVVi8CfUYskqqKSF68FpW96oT0wj_YaCmXA-X6E-1L5KL7Vt5ErRYPQKhnN6P8k
Message-ID: <CAL3q7H7ORUToy22PWoAHvi1JvwH2Boy2V7YTqOcYs=t36MZjAQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] btrfs: fix memory barrier order in reloc_root_is_dead()
To: kernel test robot <lkp@intel.com>
Cc: linux-btrfs@vger.kernel.org, llvm@lists.linux.dev, 
	oe-kbuild-all@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 12, 2026 at 8:13=E2=80=AFPM kernel test robot <lkp@intel.com> w=
rote:
>
> Hi Filipe,
>
> kernel test robot noticed the following build errors:
>
> [auto build test ERROR on kdave/for-next]
> [also build test ERROR on linus/master v7.1-rc7 next-20260611]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/fdmanana-kernel-or=
g/btrfs-fix-reloc-root-cleanup-in-merge_reloc_roots/20260612-202603
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git f=
or-next
> patch link:    https://lore.kernel.org/r/62602395bf1488aa81645ea59e22405d=
6c06d3f7.1781263239.git.fdmanana%40suse.com
> patch subject: [PATCH 2/2] btrfs: fix memory barrier order in reloc_root_=
is_dead()
> config: x86_64-kexec (https://download.01.org/0day-ci/archive/20260612/20=
2606122155.6ncF2GHC-lkp@intel.com/config)
> compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project f=
43d6834093b19baf79beda8c0337ab020ac5f17)
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20260612/202606122155.6ncF2GHC-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202606122155.6ncF2GHC-lkp=
@intel.com/
>
> All errors (new ones prefixed by >>):
>
> >> fs/btrfs/relocation.c:1928:6: error: call to undeclared function 'clea=
r_reloc_root'; ISO C99 and later do not support implicit function declarati=
ons [-Wimplicit-function-declaration]
>     1928 |                                         clear_reloc_root(root)=
;
>          |                                         ^
>    fs/btrfs/relocation.c:1928:6: note: did you mean 'create_reloc_root'?
>    fs/btrfs/relocation.c:631:27: note: 'create_reloc_root' declared here
>      631 | static struct btrfs_root *create_reloc_root(struct btrfs_trans=
_handle *trans,
>          |                           ^
>    1 error generated.

This is because it depends on a patch that is in the giithub for-next
branch but not yet in Linus' tree or linux-next:

https://lore.kernel.org/linux-btrfs/cf84f1a217c719e25b6b69e4298dd7afd36c942=
7.1781194426.git.fdmanana@suse.com/
https://github.com/btrfs/linux/commits/for-next/


>
>
> vim +/clear_reloc_root +1928 fs/btrfs/relocation.c
>
>   1867
>   1868  static noinline_for_stack
>   1869  void merge_reloc_roots(struct reloc_control *rc)
>   1870  {
>   1871          struct btrfs_fs_info *fs_info =3D rc->extent_root->fs_inf=
o;
>   1872          struct btrfs_root *root;
>   1873          struct btrfs_root *reloc_root;
>   1874          LIST_HEAD(reloc_roots);
>   1875          bool found =3D false;
>   1876          int ret =3D 0;
>   1877  again:
>   1878          root =3D rc->extent_root;
>   1879
>   1880          /*
>   1881           * this serializes us with btrfs_record_root_in_transacti=
on,
>   1882           * we have to make sure nobody is in the middle of
>   1883           * adding their roots to the list while we are
>   1884           * doing this splice
>   1885           */
>   1886          mutex_lock(&fs_info->reloc_mutex);
>   1887          list_splice_init(&rc->reloc_roots, &reloc_roots);
>   1888          mutex_unlock(&fs_info->reloc_mutex);
>   1889
>   1890          while (!list_empty(&reloc_roots)) {
>   1891                  found =3D true;
>   1892                  reloc_root =3D list_first_entry(&reloc_roots, str=
uct btrfs_root, root_list);
>   1893
>   1894                  root =3D btrfs_get_fs_root(fs_info, reloc_root->r=
oot_key.offset,
>   1895                                           false);
>   1896                  if (btrfs_root_refs(&reloc_root->root_item) > 0) =
{
>   1897                          if (WARN_ON(IS_ERR(root))) {
>   1898                                  /*
>   1899                                   * For recovery we read the fs ro=
ots on mount,
>   1900                                   * and if we didn't find the root=
 then we marked
>   1901                                   * the reloc root as a garbage ro=
ot.  For normal
>   1902                                   * relocation obviously the root =
should exist in
>   1903                                   * memory.  However there's no re=
ason we can't
>   1904                                   * handle the error properly here=
 just in case.
>   1905                                   */
>   1906                                  ret =3D PTR_ERR(root);
>   1907                                  goto out;
>   1908                          }
>   1909                          if (WARN_ON(root->reloc_root !=3D reloc_r=
oot)) {
>   1910                                  /*
>   1911                                   * This can happen if on-disk met=
adata has some
>   1912                                   * corruption, e.g. bad reloc tre=
e key offset.
>   1913                                   */
>   1914                                  ret =3D -EINVAL;
>   1915                                  goto out;
>   1916                          }
>   1917                          ret =3D merge_reloc_root(rc, root);
>   1918                          btrfs_put_root(root);
>   1919                          if (ret) {
>   1920                                  if (list_empty(&reloc_root->root_=
list))
>   1921                                          list_add_tail(&reloc_root=
->root_list,
>   1922                                                        &reloc_root=
s);
>   1923                                  goto out;
>   1924                          }
>   1925                  } else {
>   1926                          if (!IS_ERR(root)) {
>   1927                                  if (root->reloc_root =3D=3D reloc=
_root) {
> > 1928                                          clear_reloc_root(root);
>   1929                                          /* Drop the ref for root-=
>reloc_root. */
>   1930                                          btrfs_put_root(reloc_root=
);
>   1931                                  }
>   1932                                  btrfs_put_root(root);
>   1933                          }
>   1934
>   1935                          list_del_init(&reloc_root->root_list);
>   1936                          /* Don't forget to queue this reloc root =
for cleanup */
>   1937                          list_add_tail(&reloc_root->reloc_dirty_li=
st,
>   1938                                        &rc->dirty_subvol_roots);
>   1939                  }
>   1940          }
>   1941
>   1942          if (found) {
>   1943                  found =3D false;
>   1944                  goto again;
>   1945          }
>   1946  out:
>   1947          if (ret) {
>   1948                  btrfs_handle_fs_error(fs_info, ret, NULL);
>   1949                  free_reloc_roots(&reloc_roots);
>   1950
>   1951                  /* new reloc root may be added */
>   1952                  mutex_lock(&fs_info->reloc_mutex);
>   1953                  list_splice_init(&rc->reloc_roots, &reloc_roots);
>   1954                  mutex_unlock(&fs_info->reloc_mutex);
>   1955                  free_reloc_roots(&reloc_roots);
>   1956          }
>   1957
>   1958          /*
>   1959           * We used to have
>   1960           *
>   1961           * BUG_ON(!RB_EMPTY_ROOT(&rc->reloc_root_tree.rb_root));
>   1962           *
>   1963           * here, but it's wrong.  If we fail to start the transac=
tion in
>   1964           * prepare_to_merge() we will have only 0 ref reloc roots=
, none of which
>   1965           * have actually been removed from the reloc_root_tree rb=
 tree.  This is
>   1966           * fine because we're bailing here, and we hold a referen=
ce on the root
>   1967           * for the list that holds it, so these roots will be cle=
aned up when we
>   1968           * do the reloc_dirty_list afterwards.  Meanwhile the roo=
t->reloc_root
>   1969           * will be cleaned up on unmount.
>   1970           *
>   1971           * The remaining nodes will be cleaned up by put_reloc_co=
ntrol().
>   1972           */
>   1973  }
>   1974
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
