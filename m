From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Checksums and self-healing roadmap
Date: Tue, 1 Apr 2008 13:41:15 -0400
Message-ID: <200804011341.15923.chris.mason@oracle.com>
References: <1205846009.8520.14.camel@s1.crocom.com.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: btrfs-devel@oss.oracle.com, linux-btrfs@vger.kernel.org
Return-path: <btrfs-devel-bounces@oss.oracle.com>
In-Reply-To: <1205846009.8520.14.camel@s1.crocom.com.pl>
List-Unsubscribe: <http://oss.oracle.com/mailman/listinfo/btrfs-devel>,
	<mailto:btrfs-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/btrfs-devel>
List-Post: <mailto:btrfs-devel@oss.oracle.com>
List-Help: <mailto:btrfs-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <http://oss.oracle.com/mailman/listinfo/btrfs-devel>,
	<mailto:btrfs-devel-request@oss.oracle.com?subject=subscribe>
Errors-To: btrfs-devel-bounces@oss.oracle.com
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 18 March 2008, Tomasz Torcz wrote:
> Hi,
>
>   I've read btrfs roadmap and skimmed through the code trying to learn
> about self-healing in btrfs. Sadly I found none. If I understand
> correctly, upon detecting checksum error btrfs will only report it via
> printk() (in csum_tree_block()). Self-healing is most important feature
> of ZFS for me.

Correct, we currently only report errors without taking corrective actions.

>
> As far as I understand, to have self healing in btrfs, first multiple
> devices spanning and configuration like raid1 must be implemented. Also
> multiples copies per subvolume (via btrfsctl I suppose) would be nice to
> have. Device spanning is in Roadmap. But what with other features? When
> they're planned?

Support for multiple devices exists today in the unstable trees, and it 
currently includes simple device concatenation and raid0.  Raid1 is in 
progress, and should be done shortly.  The plan is to stabilize all of this 
code over the month of April and release v0.14 with it at the end of the 
month.

-chris
