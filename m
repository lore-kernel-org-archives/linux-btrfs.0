From: hu.taoo@gmail.com
Subject: Re: Using SSDs for caching?
Date: Fri, 19 Jun 2009 10:36:12 +0800
Message-ID: <20090619023612.GA7291@localhost>
References: <D3FA806D-C1A1-455F-A4E0-81AAD3E5C615@karlsbakk.net> <20090618155530.GA16819@mother.pipebreaker.pl> <DD311555-2AA3-4487-998F-C232FF3690F1@karlsbakk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <DD311555-2AA3-4487-998F-C232FF3690F1@karlsbakk.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 18, 2009 at 07:25:46PM +0200, Roy Sigurd Karlsbakk wrote:
> On 18. juni. 2009, at 17.55, Tomasz Torcz wrote:
> 
> > On Thu, Jun 18, 2009 at 03:56:23PM +0200, Roy Sigurd Karlsbakk wrote:
> >> I have heard/read about systems from Sun and NetApp using SDs for
> >> caching. Sun uses different SDs for read and write caching (one being
> >> faster for reads and the other for writes). The storage solution from
> >> Sun is based on Solaris with ZFS.
> >>
> >> I know too little about filesystems design to know exactly how they  
> >> do
> >> this, but can someone think of a way this could be implemented in  
> >> btrfs?
> >
> >  Linux already has second-level? cache layer, it called FS-Cache.  
> > For now,
> > the sole user is NFS. btrfs could take advantage of FS-Cache also.
> 
> 
> I googled around a bit for this, but couldn't find anything useful.  
> Where can I find anything about this second (or fifth) level caching?

Will this help? http://www.linux-mag.com/cache/7378/1.html

