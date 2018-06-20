Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42147 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932153AbeFTQ6s (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 12:58:48 -0400
Date: Wed, 20 Jun 2018 18:55:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "dsterba@suse.cz" <dsterba@suse.cz>,
        "nborisov@suse.com" <nborisov@suse.com>,
        "dsterba@suse.com" <dsterba@suse.com>, "clm@fb.com" <clm@fb.com>,
        "jeffm@suse.com" <jeffm@suse.com>, "jbacik@fb.com" <jbacik@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: Fix a C compliance issue
Message-ID: <20180620165556.GF24375@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180615223659.32420-1-bart.vanassche@wdc.com>
 <838e73e8-e9b8-6075-1d69-79bc65c15b0c@suse.com>
 <20180618092633.GH24375@twin.jikos.cz>
 <14645aca-930b-2d7d-a7d6-6893f7cfcbbd@suse.com>
 <c8f558835c1a767e24c00b7c3508a48a4d886cc4.camel@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c8f558835c1a767e24c00b7c3508a48a4d886cc4.camel@wdc.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 20, 2018 at 04:44:54PM +0000, Bart Van Assche wrote:
> On Mon, 2018-06-18 at 12:31 +0300, Nikolay Borisov wrote:
> > On 18.06.2018 12:26, David Sterba wrote:
> > > On Sat, Jun 16, 2018 at 01:28:13PM +0300, Nikolay Borisov wrote:
> > > > I'd rather not see more printk being added. Nothing prevents from having
> > > > the fmt string being passed to pr_info.
> > > 
> > > So you mean to do
> > > 
> > > +	static const char fmt[] = "Btrfs loaded, crc32c=%s"
> > > +	pr_info(fmt);
> > 
> > Pretty much, something along the lines of
> > 
> > pr_info(fmt, crc32c_impl).
> > 
> > printk requires having the KERN_INFO in the format string, which I see
> > no point in doing, correct me if I'm wrong?
> 
> You should know that what you proposed doesn't compile because pr_info()
> relies on string concatenation and hence requires that its first argument is
> a string constant instead of a const char pointer. Anyway, I will rework this
> patch such that it uses pr_info() instead of printk().

Right, the pr_info(fmt,...) does not compile. The closest version I got to is
below. It does not look pretty, but I can't think of a better version right
now.

--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2369,7 +2369,8 @@ static __cold void btrfs_interface_exit(void)
 
 static void __init btrfs_print_mod_info(void)
 {
-       static const char fmt[] = KERN_INFO "Btrfs loaded, crc32c=%s"
+       static const char fmt1[] = "Btrfs loaded, crc32c=";
+       static const char fmt2[] =
 #ifdef CONFIG_BTRFS_DEBUG
                        ", debug=on"
 #endif
@@ -2383,7 +2384,7 @@ static void __init btrfs_print_mod_info(void)
                        ", ref-verify=on"
 #endif
                        "\n";
-       printk(fmt, crc32c_impl());
+       pr_info("%s%s%s", fmt1, crc32c_impl(), fmt2);
 }
 
 static int __init init_btrfs_fs(void)
