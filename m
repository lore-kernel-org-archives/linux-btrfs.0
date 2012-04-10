From: David Sterba <dave@jikos.cz>
Subject: Re: [RFC] [PATCH 2/2] Btrfs: move over to use ->update_time
Date: Tue, 10 Apr 2012 09:48:01 +0200
Message-ID: <20120410074801.GE11041@twin.jikos.cz>
References: <1332771031-3337-1-git-send-email-josef@redhat.com>
 <1332771031-3337-2-git-send-email-josef@redhat.com>
 <CALLzPKbs7ALeP9sM2OorMiMFCXGs26oPM9=EjBny0NiQi0orSQ@mail.gmail.com>
 <20120404174300.GB2097@localhost.localdomain>
 <1333561669.12904.0.camel@falcor>
 <CALLzPKYvPqi=9dboZDh4Gm0Poouoa2ZY7K3hbhS9bmkiK6nFAQ@mail.gmail.com>
 <20120404181622.GC2097@localhost.localdomain>
 <20120409151605.GA6482@fieldses.org>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>,
	"Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
	linux-btrfs@vger.kernel.org, hch@infradead.org
To: "J. Bruce Fields" <bfields@fieldses.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120409151605.GA6482@fieldses.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 09, 2012 at 11:16:05AM -0400, J. Bruce Fields wrote:
> > Nobody yet, I'm going to send a patch shortly that will support this.  Thanks,
> 
> Great.  It would also be far preferable if it was just always on (at
> least by default) rather than requiring a mount option.

[looks into Josef's patch] it is, no mount option needed.


david
