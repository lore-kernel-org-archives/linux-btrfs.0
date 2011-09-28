From: David Sterba <dave@jikos.cz>
Subject: Re: File compression control, again.
Date: Wed, 28 Sep 2011 23:09:20 +0200
Message-ID: <20110928210920.GG22205@twin.jikos.cz>
References: <loom.20110927T185853-434@post.gmane.org> <4E827C41.1000805@cn.fujitsu.com> <loom.20110928T162942-40@post.gmane.org>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Artem <artemciy@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20110928T162942-40@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 28, 2011 at 02:50:13PM +0000, Artem wrote:
> Li Zefan <lizf <at> cn.fujitsu.com> writes:
> > See this "Per file/directory controls for COW and compression":
> > 
> > 	http://marc.info/?l=linux-btrfs&m=130078867208491&w=2
> 
> Thanks again!
> I wrote a program to see if ioctl compression control works
> ( https://gist.github.com/1248085 )

you have to call IOC_GETFLAGS first, then

flags |= FS_NOCOMP_FL;

27  int flags = compression ? FS_COMPR_FL : FS_NOCOMP_FL;
28  int ret = ioctl (fd, FS_IOC_SETFLAGS, &flags);

else all other flags will be dropped.


david
