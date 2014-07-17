Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50989 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100AbaGQRtn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Jul 2014 13:49:43 -0400
Date: Thu, 17 Jul 2014 19:49:40 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, viro@zeniv.linux.org.uk,
        clm@fb.com, jbacik@fb.com, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        jeffm@suse.com, fdmanana@suse.com
Subject: Re: [RFC v2 0/2] vfs / btrfs: add support for ustat()
Message-ID: <20140717174940.GR10393@wotan.suse.de>
References: <1405546678-7846-1-git-send-email-mcgrof@do-not-panic.com> <20140717080301.GA14263@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140717080301.GA14263@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 17, 2014 at 01:03:01AM -0700, Christoph Hellwig wrote:
> On Wed, Jul 16, 2014 at 02:37:56PM -0700, Luis R. Rodriguez wrote:
> > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> > 
> > This makes the implementation simpler by stuffing the struct on
> > the driver and just letting the driver iinsert it and remove it
> > onto the sb list. This avoids the kzalloc() completely.
> 
> Again, NAK.  Make btrfs report the proper anon dev_t in stat and
> everything will just work.

Let's consider this userspace case:

        struct stat buf;                                                        
        struct ustat ubuf;                                                      
                                                                                
        /* Find a valid device number */                                        
        if (stat("/", &buf)) {
                fprintf(stderr, "Stat failed: %s\n", strerror(errno));          
                return 1;                                                       
        }                                                                       
                                                                                
        /* Call ustat on it */                                                  
        if (ustat(buf.st_dev, &ubuf)) {                                         
                fprintf(stderr, "Ustat failed: %s\n", strerror(errno));         
                return 1;                                                       
        } 

In the btrfs case it has an inode op for getattr, that is used and we set
the dev to anonymous dev_t. Later ustat will use user_get_super() which
will only be able to work with a userblock if the super block's only
dev_t is assigned to it. Since we have many anonymous to dev_t mapping
to super block though we can't complete the search for btfs and ustat()
fails with -EINVAL. The series expands the number of dev_t's that a super
block can have and allows this search to complete.

  Luis
