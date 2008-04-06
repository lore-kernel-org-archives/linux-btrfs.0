From: Bron Gondwana <brong@fastmail.fm>
Subject: Re: BTRFS and old kernels.
Date: Sun, 6 Apr 2008 11:31:45 +1000
Message-ID: <20080406013145.GA25252@brong.net>
References: <f058a9c30804051213j4276cc88j92a8222dd4115e39@mail.gmail.com>
	<20080406005712.GA24967@brong.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: btrfs-devel@oss.oracle.com, linux-btrfs@vger.kernel.org
To: Bron Gondwana <brong@fastmail.fm>
Return-path: <btrfs-devel-bounces@oss.oracle.com>
In-Reply-To: <20080406005712.GA24967@brong.net>
List-Unsubscribe: <http://oss.oracle.com/mailman/listinfo/btrfs-devel>,
	<mailto:btrfs-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/btrfs-devel>
List-Post: <mailto:btrfs-devel@oss.oracle.com>
List-Help: <mailto:btrfs-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <http://oss.oracle.com/mailman/listinfo/btrfs-devel>,
	<mailto:btrfs-devel-request@oss.oracle.com?subject=subscribe>
Errors-To: btrfs-devel-bounces@oss.oracle.com
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 06, 2008 at 10:57:12AM +1000, Bron Gondwana wrote:
> On Sat, Apr 05, 2008 at 08:13:47PM +0100, Miguel Sousa Filipe wrote:
> > My question is, is there sill interestest in having btrfs compatible
> > with older kernels (like, 2.6.20 or 2.6.18)?
> > I'll post (or repost) patches that I need for btrfs-unstable to
> > build/work on this ppc system of mine.
> 
> It sort of depends who you ask.  Personally, I see value in being
> compatible with as wide range of kernels as possible in a development
> filesystem that you want people to be testing.  But then I'm not
> doing any btrfs development, so I don't count for much.

I guess I should justify this a bit....

ASSUME: I have a bunch of production Debian Etch machines running
        the latest Debian Etch production kernel (2.6.18-6-amd64 
        sounds like a convincing sort of version number) and I want
        to benchmark/test btrfs in my environment.

CASE 1: I can upgrade the kernel on this system to 2.6.24+ and make
        sure all my hardware still works as expected, upgrade my 
        udev/hal/whatever to be compatible.  Possibly backport some
        userland tools that use new interfaces now... sounds like
        a whole pile of fun^H^H^Hwork.

CASE 2: I can build a standalone btrfs module against my current
        kernel and test, having changed nothing but the filesystem.


I know which one I would trust to give me a better idea of how
stable/performant[1] btrfs is on my platform.


(this all assuming that there aren't architectural changes in the
 intervening layers that make btrfs not work properly on the older
 kernels, but ext3/xfs/jfs/reiserfs/name-your-poison seem to have
 all remained stable right through those transitions[2].)

Bron.


[1] screw you http://boulter.com/blog/2004/08/19/performant-is-not-a-word/
    and friends...
        
[2] ok, there have been some exceptions to that, for example:
    http://oss.sgi.com/projects/xfs/faq.html#dir2
