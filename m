From: Dave Jones <davej@redhat.com>
Subject: Re: btrfs io errors on 3.4rc1
Date: Tue, 3 Apr 2012 13:16:33 -0400
Message-ID: <20120403171632.GA25334@redhat.com>
References: <20120402223350.GA16907@redhat.com>
 <20120402223919.GB18000@shiny.nikko.sjc.wayport.net>
 <20120402225131.GB16907@redhat.com>
 <20120402235021.GA20070@shiny.msi.event>
 <20120403014722.GA618@redhat.com>
 <20120403142607.GA14083@ds.suse.cz>
 <20120403162023.GA7227@redhat.com>
 <20120403163343.GD14083@ds.suse.cz>
 <20120403165055.GA10975@redhat.com>
 <20120403170750.GB10975@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: David Sterba <dsterba@suse.cz>,
	Chris Mason <chris.mason@oracle.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org, jeffm@suse.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120403170750.GB10975@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 03, 2012 at 01:07:50PM -0400, Dave Jones wrote:

 >  > wait, what...
 >  > 
 >  >  535         memset(trans, 0, sizeof(*trans));
 >  >  536         kmem_cache_free(btrfs_trans_handle_cachep, trans);
 >  >  537 
 >  >  538         if (throttle)
 >  >  539                 btrfs_run_delayed_iputs(root);
 >  >  540 
 >  >  541         if (trans->aborted ||
 >  >  542             root->fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR) {
 >  >  543                 return -EIO;
 >  >  544         }
 >  > 
 >  > that looks like a pretty clear use-after-free.
 > 
 > Ok, trying this..

Yep that fixes it.  Chris I'll mail it to you again with a proper sign-off.

thanks for the help chasing this down David.

	Dave
 
