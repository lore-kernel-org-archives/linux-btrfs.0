Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55188 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758157AbdJMN7K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Oct 2017 09:59:10 -0400
Date: Fri, 13 Oct 2017 15:57:24 +0200
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.cz>
Cc: Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 04/21] btrfs: add ref-verify mount option
Message-ID: <20171013135724.GQ3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1506714245-23072-1-git-send-email-jbacik@fb.com>
 <1506714245-23072-5-git-send-email-jbacik@fb.com>
 <20171013135336.GP3521@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171013135336.GP3521@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 13, 2017 at 03:53:36PM +0200, David Sterba wrote:
> On Fri, Sep 29, 2017 at 03:43:48PM -0400, Josef Bacik wrote:
> > This adds the infrastructure for turning ref verify on and off for a
> > mount, to be used by a later patch.
> > 
> > Signed-off-by: Josef Bacik <jbacik@fb.com>
> 
> Reviewed-by: David Sterba <dsterba@suse.com>

I've added this hunk so we get the config options recorded at module load time.

@@ -2332,6 +2332,9 @@ static void btrfs_print_mod_info(void)
 #endif
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
                        ", integrity-checker=on"
+#endif
+#ifdef CONFIG_BTRFS_FS_REF_VERIFY
+                       ", ref-verify=on"
 #endif
                        "\n",
                        btrfs_crc32c_impl());
