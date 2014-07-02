Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:34858 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752165AbaGBBS3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Jul 2014 21:18:29 -0400
Message-ID: <1404263584.31646.0.camel@localhost.localdomain>
Subject: Re: [PATCH 1/2] btrfs-progs: move the check_argc_* functions into
 utils.c
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>
Date: Wed, 2 Jul 2014 09:13:04 +0800
In-Reply-To: <20140701231101.GT1553@twin.jikos.cz>
References: <20140627123528.GC1553@twin.jikos.cz>
	 <1404100452-8894-1-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <20140701231101.GT1553@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2014-07-02 at 01:11 +0200, David Sterba wrote:
> On Mon, Jun 30, 2014 at 11:54:11AM +0800, Gui Hecheng wrote:
> > To let the independent tools(e.g. btrfs-image, btrfs-convert, etc.)
> > share the convenience of check_argc_* functions, just move it into
> > utils.c.
> > Also add a new function "set_argv0" to set the correct tool name:
> > 	*btrfs-image*: too few arguments
> > 
> > The original btrfs* tools work as before.
> 
> Good cleanup, but I don't like to see the utils.c pull the commands.h,
> the argv0 or argument helpers are selfcontained, so the relevant
> definitions shloud be moved to utils.h .
> 
> Moved ARGV0_BUF_SIZE -> utils.h
> Removed check_argc_* protoypes from command.h
> 
> Trivial changes, I made them myself, no need to resend the patch.

Thanks very much David.

> The diff:
> --- a/commands.h
> +++ b/commands.h
> @@ -14,8 +14,6 @@
>   * Boston, MA 021110-1307, USA.
>   */
> 
> -#define ARGV0_BUF_SIZE 64
> -
>  struct cmd_struct {
>         const char *token;
>         int (*fn)(int, char **);
> @@ -62,10 +60,6 @@ struct cmd_group {
>  /* btrfs.c */
>  int prefixcmp(const char *str, const char *prefix);
> 
> -int check_argc_exact(int nargs, int expected);
> -int check_argc_min(int nargs, int expected);
> -int check_argc_max(int nargs, int expected);
> -
>  int handle_command_group(const struct cmd_group *grp, int argc,
>                          char **argv);
> 
> diff --git a/utils.h b/utils.h
> index 20e5a2200052..e29ab936cd81 100644
> --- a/utils.h
> +++ b/utils.h
> @@ -39,6 +39,8 @@
> 
>  #define BTRFS_UUID_UNPARSED_SIZE       37
> 
> +#define ARGV0_BUF_SIZE 64
> +
>  int check_argc_exact(int nargs, int expected);
>  int check_argc_min(int nargs, int expected);
>  int check_argc_max(int nargs, int expected);
> ---


