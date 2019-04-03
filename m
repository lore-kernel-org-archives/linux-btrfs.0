Return-Path: <SRS0=QfkU=SF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1784C4360F
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 02:18:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84E602084B
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 02:18:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfDCCSZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 22:18:25 -0400
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:44101 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726130AbfDCCSZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Apr 2019 22:18:25 -0400
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail03.adl6.internode.on.net with ESMTP; 03 Apr 2019 12:48:22 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1hBVTn-00078i-6d; Wed, 03 Apr 2019 13:18:19 +1100
Date:   Wed, 3 Apr 2019 13:18:19 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     fdmanana@kernel.org
Cc:     fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH v2 1/7] fsstress: allow fsync on directories too
Message-ID: <20190403021819.GW23020@dastard>
References: <20190401125018.10009-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190401125018.10009-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Apr 01, 2019 at 01:50:18PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Currently the fsync function can only be performed against regular files.
> Allow it to operate on directories too, to increase test coverage and
> allow for chances of finding bugs in a filesystem's implementation of
> fsync against directories.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
> 
> V2: Added helper functions to open and close files or directories.

not exactly what I meant, more below....
> 
>  ltp/fsstress.c | 42 +++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 39 insertions(+), 3 deletions(-)
> 
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index 2223fd7d..1169b840 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
> @@ -303,6 +303,7 @@ int	attr_remove_path(pathname_t *, const char *, int);
>  int	attr_set_path(pathname_t *, const char *, const char *, const int, int);
>  void	check_cwd(void);
>  void	cleanup_flist(void);
> +void	close_file_or_dir(int, DIR *);
>  int	creat_path(pathname_t *, mode_t);
>  void	dcache_enter(int, int);
>  void	dcache_init(void);
> @@ -324,6 +325,7 @@ void	make_freq_table(void);
>  int	mkdir_path(pathname_t *, mode_t);
>  int	mknod_path(pathname_t *, mode_t, dev_t);
>  void	namerandpad(int, char *, int);
> +int	open_file_or_dir(pathname_t *, int, DIR **);
>  int	open_path(pathname_t *, int);
>  DIR	*opendir_path(pathname_t *);
>  void	process_freq(char *);
> @@ -852,6 +854,15 @@ cleanup_flist(void)
>  	}
>  }
>  
> +void
> +close_file_or_dir(int fd, DIR *dir)
> +{
> +	if (dir)
> +		closedir(dir);
> +	else
> +		close(fd);
> +}
> +
>  int
>  creat_path(pathname_t *name, mode_t mode)
>  {
> @@ -1385,6 +1396,30 @@ namerandpad(int id, char *buf, int i)
>  }
>  
>  int
> +open_file_or_dir(pathname_t *name, int flags, DIR **dir)
> +{
> +	int fd;
> +
> +	fd = open_path(name, flags);
> +	if (fd < 0 && errno == EISDIR) {
> +		*dir = opendir_path(name);

Why this function, and not just open(O_DIRECTORY)?
None of the code that uses this function actually uses the DIR *
that is returned, just the fd that is extracted from it. So why no
just open() the directory directly and avoid having all the mess
with dir streams that aren't needed?


> +		if (*dir) {
> +			fd = dirfd(*dir);
> +			if (fd < 0) {
> +				int e = errno;
> +
> +				closedir(*dir);
> +				*dir = NULL;
> +				errno = e;
> +			}
> +		}
> +	} else {
> +		*dir = NULL;
> +	}
> +	return fd;

Excessive nesting. I think this should be as simple as:

	fd = open_path(name, flags);
	if (fd < 0 && errno != EISDIR) {
		return -1;
	return open_path(name, flags | O_DIRECTORY);

And the close_file_or_dir() function is completely unnecessary.


> +
> +int
>  open_path(pathname_t *name, int oflag)
>  {
>  	char		buf[NAME_MAX + 1];
> @@ -3440,15 +3475,16 @@ fsync_f(int opno, long r)
>  	pathname_t	f;
>  	int		fd;
>  	int		v;
> +	DIR             *dir;
>  
>  	init_pathname(&f);
> -	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
> +	if (!get_fname(FT_REGFILE | FT_DIRm, r, &f, NULL, NULL, &v)) {
>  		if (v)
>  			printf("%d/%d: fsync - no filename\n", procid, opno);
>  		free_pathname(&f);
>  		return;
>  	}
> -	fd = open_path(&f, O_WRONLY);
> +	fd = open_file_or_dir(&f, O_WRONLY, &dir);
>  	e = fd < 0 ? errno : 0;
>  	check_cwd();
>  	if (fd < 0) {

This whole hunk - from init_pathname to check_cwd - was what I was
suggesting you factor out, not just the open_path() code.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
