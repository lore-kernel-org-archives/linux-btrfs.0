From: Chris Mason <chris.mason@oracle.com>
Subject: Re: feature request: read/write priorities on multiple
	devices/raid1
Date: Thu, 25 Sep 2008 12:15:02 -0400
Message-ID: <1222359302.7028.38.camel@think.oraclecorp.com>
References: <1553.85.177.90.248.1222334375.squirrel@webmail.schleiser.de>
	 <1222348238.7028.31.camel@think.oraclecorp.com>
	 <f058a9c30809250831r5479c4fcyac4deade9ddfda0e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Kaspar Schleiser <kaspar@schleiser.de>, linux-btrfs@vger.kernel.org
To: Miguel Sousa Filipe <miguel.filipe@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <f058a9c30809250831r5479c4fcyac4deade9ddfda0e@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2008-09-25 at 16:31 +0100, Miguel Sousa Filipe wrote:
> Hi all,
> 
> On Thu, Sep 25, 2008 at 2:10 PM, Chris Mason <chris.mason@oracle.com> wrote:
> > On Thu, 2008-09-25 at 11:19 +0200, Kaspar Schleiser wrote:
> >> Hello everybody!
> >>
> >> This is my first post on the list, let me know if I'm not following any
> >> rules.
> >>
> >> What do you think about adding priorities for raid1 arrays?
> >>
> >> For example, always use /dev/ram0 (ramdisk) for reading/writing, but
> >> nonetheless write everything additionally on /dev/sda1. Restore to
> >> /dev/ram0 after mount if it is empty.
> >>
> >
> > I don't plan on adding support for non-persistent storage, but there
> > will be the idea of a fast frontend device that is basically a cache for
> > slower devices.
> 
> Something like yet another caching/buffer layer between the buffer
> cache and the storage devices?
> 

Not really a caching layer, more of a block allocation group that when
full migrates old blocks to a different block allocation group.

> I recall reading something similiar to that in a listing of new
> features of a recent revision of ZFS ?
> 

Sorry, no idea.

-chris


