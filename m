Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41376 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965790AbeFRJ3Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Jun 2018 05:29:24 -0400
Date: Mon, 18 Jun 2018 11:26:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Bart Van Assche <bart.vanassche@wdc.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>
Subject: Re: [PATCH] btrfs: Fix a C compliance issue
Message-ID: <20180618092633.GH24375@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180615223659.32420-1-bart.vanassche@wdc.com>
 <838e73e8-e9b8-6075-1d69-79bc65c15b0c@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <838e73e8-e9b8-6075-1d69-79bc65c15b0c@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 16, 2018 at 01:28:13PM +0300, Nikolay Borisov wrote:
> 
> 
> On 16.06.2018 01:36, Bart Van Assche wrote:
> > The C programming language does not allow to use preprocessor statements
> > inside macro arguments (pr_info() is defined as a macro). Hence rework
> > the pr_info() statement in btrfs_print_mod_info() such that it becomes
> > compliant. This patch allows tools like sparse to analyze the BTRFS
> > source code.
> > 
> > Fixes: 62e855771dac ("btrfs: convert printk(KERN_* to use pr_* calls")
> > Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> > Cc: Jeff Mahoney <jeffm@suse.com>
> > Cc: David Sterba <dsterba@suse.com>
> > ---
> >  fs/btrfs/super.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> > index 81107ad49f3a..dd4980df5b8e 100644
> > --- a/fs/btrfs/super.c
> > +++ b/fs/btrfs/super.c
> > @@ -2369,7 +2369,7 @@ static __cold void btrfs_interface_exit(void)
> >  
> >  static void __init btrfs_print_mod_info(void)
> >  {
> > -	pr_info("Btrfs loaded, crc32c=%s"
> > +	static const char fmt[] = KERN_INFO "Btrfs loaded, crc32c=%s"
> >  #ifdef CONFIG_BTRFS_DEBUG
> >  			", debug=on"
> >  #endif
> > @@ -2382,8 +2382,8 @@ static void __init btrfs_print_mod_info(void)
> >  #ifdef CONFIG_BTRFS_FS_REF_VERIFY
> >  			", ref-verify=on"
> >  #endif
> > -			"\n",
> > -			crc32c_impl());
> > +			"\n";
> > +	printk(fmt, crc32c_impl());
> 
> I'd rather not see more printk being added. Nothing prevents from having
> the fmt string being passed to pr_info.

So you mean to do

+	static const char fmt[] = "Btrfs loaded, crc32c=%s"
+	pr_info(fmt);

?
