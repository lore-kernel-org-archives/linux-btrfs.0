From: Bron Gondwana <brong@fastmail.fm>
Subject: Re: BTRFS and old kernels.
Date: Sun, 6 Apr 2008 10:57:12 +1000
Message-ID: <20080406005712.GA24967@brong.net>
References: <f058a9c30804051213j4276cc88j92a8222dd4115e39@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: btrfs-devel@oss.oracle.com, linux-btrfs@vger.kernel.org
To: Miguel Sousa Filipe <miguel.filipe@gmail.com>
Return-path: <btrfs-devel-bounces@oss.oracle.com>
In-Reply-To: <f058a9c30804051213j4276cc88j92a8222dd4115e39@mail.gmail.com>
List-Unsubscribe: <http://oss.oracle.com/mailman/listinfo/btrfs-devel>,
	<mailto:btrfs-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/btrfs-devel>
List-Post: <mailto:btrfs-devel@oss.oracle.com>
List-Help: <mailto:btrfs-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <http://oss.oracle.com/mailman/listinfo/btrfs-devel>,
	<mailto:btrfs-devel-request@oss.oracle.com?subject=subscribe>
Errors-To: btrfs-devel-bounces@oss.oracle.com
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 05, 2008 at 08:13:47PM +0100, Miguel Sousa Filipe wrote:
> My question is, is there sill interestest in having btrfs compatible
> with older kernels (like, 2.6.20 or 2.6.18)?
> I'll post (or repost) patches that I need for btrfs-unstable to
> build/work on this ppc system of mine.

It sort of depends who you ask.  Personally, I see value in being
compatible with as wide range of kernels as possible in a development
filesystem that you want people to be testing.  But then I'm not
doing any btrfs development, so I don't count for much.

Other people, well - Christoph Hellwig had this to say a little
while back in <20080207044835.GC4140@lst.de> (rewrapped):

  On Wed, Feb 06, 2008 at 05:14:51PM -0500, Jeff Mahoney wrote:
  > -----BEGIN PGP SIGNED MESSAGE-----
  > Hash: SHA1
  >
  >  Kernels prior to 2.6.19 don't export file_ra_state_init().
  >  This patch adds the file_ra_state_init() from 2.6.18.

  Please put this somewhere else, a separate file and hopefully 
  only in your backports tree.  This is kernels from stoneage
  after all, not just one or two revisions back.

Bron ( not being particularly helpful or even answering your 
       question really )
