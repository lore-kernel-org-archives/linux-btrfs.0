From: Tomasz Torcz <tomek@pipebreaker.pl>
Subject: Re: btrfs not iSCSI-target safe?
Date: Thu, 23 Jul 2009 15:28:52 +0200
Message-ID: <20090723132852.GA23960@mother.pipebreaker.pl>
References: <20090722112706.GA7374@mother.pipebreaker.pl> <20090722144031.GC29886@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090722144031.GC29886@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 22, 2009 at 10:40:31AM -0400, Chris Mason wrote:
> On Wed, Jul 22, 2009 at 01:27:06PM +0200, Tomasz Torcz wrote:
> > 
> >   Hi,
> > 
> > I tried to export file from btrfs volume using iSCSI target.
> > As soon as some initiator have read it over network, server
> > oopsed: http://www.kerneloops.org/submitresult.php?number=557979
> >  Kernel is Fedora's 2.6.29.6-213.fc11.x86_64. I'm aware that
> > target iSCSI functionality is out-of-tree (I'm using iscsitarget-0.4.17-3),
> > so it may not be safe. But is there any known incompatibility
> > between iscsi-target and btrfs?
> 
> Sorry, I don't know of any problems between btrfs and iscsi.  Is the
> iscsi target configured to use linux aio?  That could be the problem.

  I'm not sure, I'm a mere user. This target software seems to read
files from kernelspace, which as I understand is frowned upon.
  If you are interested, sourcecode is at http://iscsitarget.sourceforge.net/
Ooops occured in fileio_make_request(), in iscsitarget-0.4.17/kernel/file-io.c
file.

-- 
Tomasz Torcz                 "God, root, what's the difference?"
xmpp: zdzichubg@chrome.pl         "God is more forgiving."

