Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f48.google.com ([209.85.219.48]:55240 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965124AbaGBAUm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Jul 2014 20:20:42 -0400
Received: by mail-oa0-f48.google.com with SMTP id m1so11264996oag.7
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Jul 2014 17:20:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140701231101.GT1553@twin.jikos.cz>
References: <20140627123528.GC1553@twin.jikos.cz>
	<1404100452-8894-1-git-send-email-guihc.fnst@cn.fujitsu.com>
	<20140701231101.GT1553@twin.jikos.cz>
Date: Wed, 2 Jul 2014 01:20:41 +0100
Message-ID: <CALOYprWCwP0o0of0FCzrZSw8B5cU8kZT=TQB8RPJ0hXu5fF8nQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] btrfs-progs: move the check_argc_* functions into utils.c
From: WorMzy Tykashi <wormzy.tykashi@gmail.com>
To: dsterba@suse.cz, Gui Hecheng <guihc.fnst@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2 July 2014 00:11, David Sterba <dsterba@suse.cz> wrote:
> On Mon, Jun 30, 2014 at 11:54:11AM +0800, Gui Hecheng wrote:
>> To let the independent tools(e.g. btrfs-image, btrfs-convert, etc.)
>> share the convenience of check_argc_* functions, just move it into
>> utils.c.
>> Also add a new function "set_argv0" to set the correct tool name:
>>       *btrfs-image*: too few arguments
>>
>> The original btrfs* tools work as before.
>
> Good cleanup, but I don't like to see the utils.c pull the commands.h,
> the argv0 or argument helpers are selfcontained, so the relevant
> definitions shloud be moved to utils.h .
>
> Moved ARGV0_BUF_SIZE -> utils.h
> Removed check_argc_* protoypes from command.h
>
> Trivial changes, I made them myself, no need to resend the patch.
>
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hi David,

I'm getting a build failure in integration-20140701 in regard to these changes:

---------
    [CC]     help.o
help.c:23:23: error: 'ARGV0_BUF_SIZE' undeclared here (not in a function)
 static char argv0_buf[ARGV0_BUF_SIZE];
                       ^
help.c:23:13: warning: 'argv0_buf' defined but not used [-Wunused-variable]
 static char argv0_buf[ARGV0_BUF_SIZE];
             ^
Makefile:114: recipe for target 'help.o' failed
make: *** [help.o] Error 1
---------

Looks like help.c just need to include utils.h now too. I tested with
the following patch, and it builds again.

--- a/help.c    2014-07-02 01:14:02.365340224 +0100
+++ b/help.c    2014-07-02 01:13:49.995276342 +0100
@@ -19,6 +19,7 @@
 #include <string.h>

 #include "commands.h"
+#include "utils.h"

 static char argv0_buf[ARGV0_BUF_SIZE];


Cheers,


WorMzy
