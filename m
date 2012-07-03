Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:48319 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755447Ab2GCPwS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Jul 2012 11:52:18 -0400
Date: Tue, 3 Jul 2012 17:52:12 +0200
From: David Sterba <dave@jikos.cz>
To: Hugo Mills <hugo@carfax.org.uk>,
        =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>,
        linux-btrfs@vger.kernel.org
Subject: Re: BTRFS fsck apparent errors
Message-ID: <20120703155212.GG5326@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <4FF30B55.6060205@petaramesh.org>
 <20120703152208.GA28701@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120703152208.GA28701@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 03, 2012 at 04:22:08PM +0100, Hugo Mills wrote:
>    Correct, by default it just checks the filesystem. Just to be sure:
> the filesystems in question weren't mounted, were they?

fsck will refuse to run on a mounted filesystem, though in case of a
read-only mount it might be useful during debugging, I'm using this
patch

--- a/btrfsck.c
+++ b/btrfsck.c
@@ -3474,6 +3474,7 @@ static struct option long_options[] = {
        { "repair", 0, NULL, 0 },
        { "init-csum-tree", 0, NULL, 0 },
        { "init-extent-tree", 0, NULL, 0 },
+       { "force", 0, NULL, 0 },
        { 0, 0, 0, 0}
 };

@@ -3484,12 +3485,13 @@ int main(int ac, char **av)
        struct btrfs_fs_info *info;
        struct btrfs_trans_handle *trans = NULL;
        u64 bytenr = 0;
-       int ret;
+       int ret = 0;
        int num;
        int repair = 0;
        int option_index = 0;
        int init_csum_tree = 0;
        int rw = 0;
+       int force = 0;

        while(1) {
                int c;
@@ -3516,6 +3518,9 @@ int main(int ac, char **av)
                        printf("Creating a new CRC tree\n");
                        init_csum_tree = 1;
                        rw = 1;
+               } else if (option_index == 4) {
+                       printf("Skip mount checks\n");
+                       force = 1;
                }

        }
@@ -3527,7 +3532,7 @@ int main(int ac, char **av)
        radix_tree_init();
        cache_tree_init(&root_cache);

-       if((ret = check_mounted(av[optind])) < 0) {
+       if(!force && (ret = check_mounted(av[optind])) < 0) {
                fprintf(stderr, "Could not check mount status: %s\n", strerror(-ret));
                return ret;
        } else if(ret) {

