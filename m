Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43711 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964943AbaGAXLD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Jul 2014 19:11:03 -0400
Date: Wed, 2 Jul 2014 01:11:01 +0200
From: David Sterba <dsterba@suse.cz>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: move the check_argc_* functions into
 utils.c
Message-ID: <20140701231101.GT1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20140627123528.GC1553@twin.jikos.cz>
 <1404100452-8894-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1404100452-8894-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 30, 2014 at 11:54:11AM +0800, Gui Hecheng wrote:
> To let the independent tools(e.g. btrfs-image, btrfs-convert, etc.)
> share the convenience of check_argc_* functions, just move it into
> utils.c.
> Also add a new function "set_argv0" to set the correct tool name:
> 	*btrfs-image*: too few arguments
> 
> The original btrfs* tools work as before.

Good cleanup, but I don't like to see the utils.c pull the commands.h,
the argv0 or argument helpers are selfcontained, so the relevant
definitions shloud be moved to utils.h .

Moved ARGV0_BUF_SIZE -> utils.h
Removed check_argc_* protoypes from command.h

Trivial changes, I made them myself, no need to resend the patch.

The diff:
--- a/commands.h
+++ b/commands.h
@@ -14,8 +14,6 @@
  * Boston, MA 021110-1307, USA.
  */

-#define ARGV0_BUF_SIZE 64
-
 struct cmd_struct {
        const char *token;
        int (*fn)(int, char **);
@@ -62,10 +60,6 @@ struct cmd_group {
 /* btrfs.c */
 int prefixcmp(const char *str, const char *prefix);

-int check_argc_exact(int nargs, int expected);
-int check_argc_min(int nargs, int expected);
-int check_argc_max(int nargs, int expected);
-
 int handle_command_group(const struct cmd_group *grp, int argc,
                         char **argv);

diff --git a/utils.h b/utils.h
index 20e5a2200052..e29ab936cd81 100644
--- a/utils.h
+++ b/utils.h
@@ -39,6 +39,8 @@

 #define BTRFS_UUID_UNPARSED_SIZE       37

+#define ARGV0_BUF_SIZE 64
+
 int check_argc_exact(int nargs, int expected);
 int check_argc_min(int nargs, int expected);
 int check_argc_max(int nargs, int expected);
---
