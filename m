From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [RFC] [PATCH 2/2] Btrfs: move over to use ->update_time
Date: Wed, 04 Apr 2012 13:47:47 -0400
Message-ID: <1333561669.12904.0.camel@falcor>
References: <1332771031-3337-1-git-send-email-josef@redhat.com>
	 <1332771031-3337-2-git-send-email-josef@redhat.com>
	 <CALLzPKbs7ALeP9sM2OorMiMFCXGs26oPM9=EjBny0NiQi0orSQ@mail.gmail.com>
	 <20120404174300.GB2097@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
	linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
	linux-btrfs@vger.kernel.org, hch@infradead.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120404174300.GB2097@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2012-04-04 at 13:43 -0400, Josef Bacik wrote:
> On Wed, Apr 04, 2012 at 08:24:19PM +0300, Kasatkin, Dmitry wrote:
> > Hello,
> > 
> > Mimi and I working on IMA/EVM (security/integrity) and it uses
> > i_version for checking if file content has been changed.
> > extX file systems support i_version updates with mounting file system
> > with "iversion" option or via kernel command line parameter
> > "i_version"
> > 
> > It seems iversion option is not recognized when mounting btrfs.
> > I see this patchset deals with i_version update as well..
> > Can you please give an advice how to use i_version with btrfs?
> >
> 
> Oh good somebody uses this?  We actually have a ->sequence thing we use for
> this, the grand idea was to make it smarter about telling nfs when something
> changed, but if you guys use i_version we could probably get rid of our in-core
> sequence and use the normal inodes i_version and then just store it in our
> sequence field on disk.  I'll do it without a mount option tho so it just works,
> does that sound good to you?  Thanks,
> 
> Josef 

Sounds really good!

thanks,

Mimi

