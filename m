Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from psi.thgersdorf.net ([176.9.98.78]:48975 "EHLO mail.psioc.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849Ab3FBP5G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 2 Jun 2013 11:57:06 -0400
Message-ID: <51AB691A.90605@dieterries.net>
Date: Sun, 02 Jun 2013 17:47:38 +0200
From: Dieter Ries <lists@dieterries.net>
MIME-Version: 1.0
To: Ian Kumlien <pomac@demius.net>
CC: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 2/6] Btrfs-progs: add btrfsck functionality to btrfs
References: <1360283822-23452-1-git-send-email-pomac@demius.net> <1360283822-23452-3-git-send-email-pomac@demius.net>
In-Reply-To: <1360283822-23452-3-git-send-email-pomac@demius.net>
Content-Type: multipart/mixed;
 boundary="------------060509040305060208000306"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060509040305060208000306
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi everybody,

Am 08.02.2013 01:36, schrieb Ian Kumlien:
> diff --git a/cmds-check.c b/cmds-check.c
> index 71e98de..8e4cce0 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c

[...]

> @@ -3574,7 +3579,8 @@ int main(int ac, char **av)
>  				       (unsigned long long)bytenr);
>  				break;
>  			case '?':
> -				print_usage();
> +			case 'h':
> +				usage(cmd_check_usage);
>  		}
>  		if (option_index == 1) {
>  			printf("enabling repair mode\n");

For this to have any effect, 'h' must be added to getopt_long(), see
attached patch 1.

However, this results in btrfsck -h and --help doing different things:

--help prints the usage message to stdout and exits with exit(0).
-h prints the usage message to stderr and exits with exit(129).

I made a patch to fix this, see attached patch 2.
What it doesn't fix though is, that -h/--help and -? don't do the same
thing. This is more complicated, as getop_long returns '?' for unknown
options.

Cheers,

Dieter

--------------060509040305060208000306
Content-Type: text/x-patch;
 name="0001-Btrfs-progs-Fix-btrfsck-btrfs-check-h.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-Btrfs-progs-Fix-btrfsck-btrfs-check-h.patch"

>From 11aabdb018aed3c5b6a1616178883fd879152856 Mon Sep 17 00:00:00 2001
From: Dieter Ries <mail@dieterries.net>
Date: Sun, 2 Jun 2013 17:30:09 +0200
Subject: [PATCH 1/2] Btrfs-progs: Fix 'btrfsck/btrfs check -h'

For the '-h' option to be usable, getopts_long() has to know it.

Signed-off-by: Dieter Ries <mail@dieterries.net>
---
 cmds-check.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index 1e5e005..ff9298d 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4065,7 +4065,7 @@ int cmd_check(int argc, char **argv)
 
 	while(1) {
 		int c;
-		c = getopt_long(argc, argv, "as:", long_options,
+		c = getopt_long(argc, argv, "ahs:", long_options,
 				&option_index);
 		if (c < 0)
 			break;
-- 
1.8.1.3


--------------060509040305060208000306
Content-Type: text/x-patch;
 name="0002-Btrfs-progs-Fix-help-to-h-inconsistency-in-btrfsck-b.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-Btrfs-progs-Fix-help-to-h-inconsistency-in-btrfsck-b.pa";
 filename*1="tch"

>From 52d9e47bfa0936a14baa48e8ad6ecdd820295809 Mon Sep 17 00:00:00 2001
From: Dieter Ries <mail@dieterries.net>
Date: Sun, 2 Jun 2013 17:32:15 +0200
Subject: [PATCH 2/2] Btrfs-progs: Fix '--help' to '-h' inconsistency in
 btrfsck/btrfs check

This patch fixes the following inconsistency between calling
btrfsck/btrfs check with the -h or --help options:
--help prints the usage message to stdout and exits with exit(0).
-h prints the usage message to stderr and exits with exit(129).

To achieve this, usage_command_usagestr() is made avalilable via
commands.h.

Signed-off-by: Dieter Ries <mail@dieterries.net>
---
 cmds-check.c | 5 ++++-
 commands.h   | 2 ++
 help.c       | 2 +-
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index ff9298d..093c859 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4078,8 +4078,11 @@ int cmd_check(int argc, char **argv)
 				       (unsigned long long)bytenr);
 				break;
 			case '?':
-			case 'h':
 				usage(cmd_check_usage);
+				break;
+			case 'h':
+				usage_command_usagestr(cmd_check_usage, "check", 1, 0);
+				exit(0);
 		}
 		if (option_index == 1) {
 			printf("enabling repair mode\n");
diff --git a/commands.h b/commands.h
index 15c616d..814452f 100644
--- a/commands.h
+++ b/commands.h
@@ -73,6 +73,8 @@ extern const char * const generic_cmd_help_usage[];
 void usage(const char * const *usagestr);
 void usage_command(const struct cmd_struct *cmd, int full, int err);
 void usage_command_group(const struct cmd_group *grp, int all, int err);
+void usage_command_usagestr(const char * const *usagestr,
+				const char *token, int full, int err);
 
 void help_unknown_token(const char *arg, const struct cmd_group *grp);
 void help_ambiguous_token(const char *arg, const struct cmd_group *grp);
diff --git a/help.c b/help.c
index 6d04293..effb72e 100644
--- a/help.c
+++ b/help.c
@@ -102,7 +102,7 @@ static int usage_command_internal(const char * const *usagestr,
 	return ret;
 }
 
-static void usage_command_usagestr(const char * const *usagestr,
+void usage_command_usagestr(const char * const *usagestr,
 				   const char *token, int full, int err)
 {
 	FILE *outf = err ? stderr : stdout;
-- 
1.8.1.3


--------------060509040305060208000306--
