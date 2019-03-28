Return-Path: <SRS0=ig1K=R7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E8E0C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 21:48:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D7852173C
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 21:48:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbfC1Vsn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Mar 2019 17:48:43 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:2933 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726891AbfC1Vsn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Mar 2019 17:48:43 -0400
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail06.adl2.internode.on.net with ESMTP; 29 Mar 2019 08:18:40 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1h9ct5-0008DO-Fc; Fri, 29 Mar 2019 08:48:39 +1100
Date:   Fri, 29 Mar 2019 08:48:39 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     fdmanana@kernel.org
Cc:     fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH 2/7] fsstress: add operation for setting xattrs on files
 and directories
Message-ID: <20190328214839.GM26298@dastard>
References: <20190328185404.28879-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190328185404.28879-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 28, 2019 at 06:54:04PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Currently fsstress does not exercise creating, reading or deleting xattrs
> on files or directories. This change adds support for setting xattrs on
> files and directories, using only the xattr user namespace (the other
> namespaces are not general purpose and are used for security, capabilities,
> ACLs, etc). This adds a counter for each file entry structure that keeps
> track of the number of xattrs set for the file entry, and each new xattr
> has a name that includes the counter's value (example: "user.x4").
> Values for the xattrs have at most 100 bytes, which is much more than
> the maximum size supported for all major filesystems.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  ltp/fsstress.c | 150 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 141 insertions(+), 9 deletions(-)
> 
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index cc4f520e..03e40eb6 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
> @@ -27,6 +27,7 @@
>  io_context_t	io_ctx;
>  #endif
>  #include <sys/syscall.h>
> +#include <sys/xattr.h>
>  
>  #ifndef FS_IOC_GETFLAGS
>  #define FS_IOC_GETFLAGS                 _IOR('f', 1, long)
> @@ -85,6 +86,7 @@ typedef enum {
>  	OP_RESVSP,
>  	OP_RMDIR,
>  	OP_SETATTR,
> +	OP_SETXATTR,
>  	OP_SPLICE,
>  	OP_STAT,
>  	OP_SYMLINK,
> @@ -110,6 +112,7 @@ typedef struct opdesc {
>  typedef struct fent {
>  	int	id;
>  	int	parent;
> +	int     xattr_counter;
>  } fent_t;
>  
>  typedef struct flist {
> @@ -195,6 +198,7 @@ void	rename_f(int, long);
>  void	resvsp_f(int, long);
>  void	rmdir_f(int, long);
>  void	setattr_f(int, long);
> +void	setxattr_f(int, long);
>  void	splice_f(int, long);
>  void	stat_f(int, long);
>  void	symlink_f(int, long);
> @@ -246,6 +250,7 @@ opdesc_t	ops[] = {
>  	{ OP_RESVSP, "resvsp", resvsp_f, 1, 1 },
>  	{ OP_RMDIR, "rmdir", rmdir_f, 1, 1 },
>  	{ OP_SETATTR, "setattr", setattr_f, 0, 1 },
> +	{ OP_SETXATTR, "setxattr", setxattr_f, 4, 1 },

Ok, now that I see this, the penny drops - you can't do this as
it changes the CLI interface in a way that will make existing
scripts do something entirely different to what they used to do.

i.e. "-f setxattr=n" is used to specify the frequency of this
specific operation. It used to control the project ID setting, now
with this change it controls extended attribute frequency. There are
some tests that actually use "-f setxattr=n" (and who knows how many
custom test scripts using fsstress built from fstests), so I don't
think we should be renaming existing operations to something else
and then reusing the name for a new type of operation like this....

I certainly agree with the idea of adding extended attributes to
fsstress, just not this way...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
