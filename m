Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44486 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532AbcEMJYs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 May 2016 05:24:48 -0400
Date: Fri, 13 May 2016 11:24:13 +0200
From: David Sterba <dsterba@suse.cz>
To: btrfs@oss.m-berberich.de
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com
Subject: Re: [PATCH] btrfs-progs: added quiet-option for scripts
Message-ID: <20160513092413.GW29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160512114131.GO29353@twin.jikos.cz>
 <1463082565-17924-1-git-send-email-btrfs@oss.m-berberich.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1463082565-17924-1-git-send-email-btrfs@oss.m-berberich.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Thu, May 12, 2016 at 09:49:25PM +0200, btrfs@oss.m-berberich.de wrote:
> From: M G Berberich <btrfs@oss.m-berberich.de>
> 
> -q,--quiet to prevent status-messages on stderr
> --verbose as alternative for -v
> moved 'Mode NO_FILE_DATA enabled' message to stderr
> changed default for g_verbose to 1

added the signed-off-by line and did the following tweaks and applied, thanks.

--- a/cmds-send.c
+++ b/cmds-send.c
@@ -44,8 +44,10 @@
 #include "send.h"
 #include "send-utils.h"

-/* default is 1 for historical reasons
-   changing may break scripts */
+/*
+ * Default is 1 for historical reasons, changing may break scripts that expect
+ * the 'At subvol' message.
+ */
 static int g_verbose = 1;

 struct btrfs_send {
@@ -445,7 +447,7 @@ int cmd_send(int argc, char **argv)
                        g_verbose++;
                        break;
                case 'q':
-                       g_verbose--;
+                       g_verbose = 0;
                        break;
                case 'e':
                        new_end_cmd_semantic = 1;
@@ -630,7 +632,8 @@ int cmd_send(int argc, char **argv)
        }

        if ((send_flags & BTRFS_SEND_FLAG_NO_FILE_DATA) && g_verbose > 1)
-               fprintf(stderr, "Mode NO_FILE_DATA enabled\n");
+               if (g_verbose > 1)
+                       fprintf(stderr, "Mode NO_FILE_DATA enabled\n");

        for (i = optind; i < argc; i++) {
                int is_first_subvol;
@@ -721,9 +724,6 @@ const char * const cmd_send_usage[] = {
        "which case 'btrfs send' will determine a suitable parent among the",
        "clone sources itself.",
        "\n",
-       "-v, --verbose    Enable verbose debug output. Each occurrence of",
-       "                 this option increases the verbose level more.",
-       "-q, --quiet      suppress messages to stderr.",
        "-e               If sending multiple subvols at once, use the new",
        "                 format and omit the end-cmd between the subvols.",
        "-p <parent>      Send an incremental stream from <parent> to",
@@ -737,6 +737,8 @@ const char * const cmd_send_usage[] = {
        "                 does not contain any file data and thus cannot be used",
        "                 to transfer changes. This mode is faster and useful to",
        "                 show the differences in metadata.",
-       "--help           display this help and exit",
+       "-v|--verbose     enable verbose output to stderr, each occurrence of",
+       "                 this option increases verbosity",
+       "-q|--quiet       suppress all messages, except errors",
        NULL
 };
