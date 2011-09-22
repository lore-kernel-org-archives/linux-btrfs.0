From: Mathieu Chouquet-Stringer <mathieu@csetco.com>
Subject: Re: Btrfs bug with g38867a2 and a question
Date: Thu, 22 Sep 2011 13:35:12 +0200
Message-ID: <20110922113512.GA14364@kashmir>
References: <20110921185350.GA6618@kashmir>
 <4E7A4695.9080106@redhat.com>
 <20110921231055.GN22205@twin.jikos.cz>
 <20110922101344.GA13667@kashmir>
 <20110922110528.GX22205@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	David Sterba <dave@jikos.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110922110528.GX22205@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 22, 2011 at 01:05:28PM +0200, David Sterba wrote:
> On Thu, Sep 22, 2011 at 12:13:44PM +0200, Mathieu Chouquet-Stringer wrote:
> > On Thu, Sep 22, 2011 at 01:10:55AM +0200, David Sterba wrote:
> > > please prefix printk messages with "btrfs: "
> > 
> > Well my computer crashed before I could reboot with the newly compiled
> > kernel.  And now it bugs while it tries to mount the kernel meaning my
> > computer is fscked! :-)
> > 
> > Bug at fs/btrfs/free-space-cache.c:1327
> > 
> > (I have a screenshot if needed)
> 
> Yes please.

There you go:
http://mathieu.csetco.com/btrfs-crash3.jpg

-- 
Mathieu Chouquet-Stringer                         mathieu@csetco.com
            The sun itself sees not till heaven clears.
	             -- William Shakespeare --
