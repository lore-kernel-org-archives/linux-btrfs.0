Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:34511 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188Ab2IXPMI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Sep 2012 11:12:08 -0400
Date: Mon, 24 Sep 2012 17:12:04 +0200
From: David Sterba <dave@jikos.cz>
To: Hugo Mills <hugo@carfax.org.uk>, Sami Haahtinen <sami@haahtinen.name>,
        linux-btrfs@vger.kernel.org
Subject: Re: Rebuilding chunk root?
Message-ID: <20120924151203.GI14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <CA+nK0aON8yROCGwetiXdEphUf+Ju-BVJ54ooeMOZyUpHy9KDGA@mail.gmail.com>
 <20120924140239.GB6136@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120924140239.GB6136@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 24, 2012 at 03:02:39PM +0100, Hugo Mills wrote:
> > root@sysresccd /root/btrfs-progs % ./btrfsck --super 2 /dev/patience/home
> > using SB copy 2, bytenr 274877906944
> > Check tree block failed, want=139264, have=0
> > Check tree block failed, want=139264, have=0
> > Check tree block failed, want=139264, have=0
> > read block failed check_tree_block
> > Couldn't read chunk root
> > 
> > If I'm interpreting the output correctly, it's trying to read bytes
> > from address 139264, which would fall into the corrupted area.
> 
>    No, I believe the "want=, have=" text is referring to a generation
> ID, not a block number. That's not to say that your chunk tree isn't
> damaged, though -- I'm just clarifying your interpretation of the
> numbers.

  40 static int check_tree_block(struct btrfs_root *root, struct extent_buffer *buf)
  41 {
  42
  43         struct btrfs_fs_devices *fs_devices;
  44         int ret = 1;
  45
  46         if (buf->start != btrfs_header_bytenr(buf)) {
  47                 printk("Check tree block failed, want=%Lu, have=%Lu\n",
  48                        buf->start, btrfs_header_bytenr(buf));
  49                 return ret;
  50         }

No, it's the block address in bytes, 4k-block number 34.

>    Out of interest, does mounting with -o recovery help at all? (I'm
> not expecting it to do much if your chunk tree's gone, but it might do
> something).

The -o recovery has access to the respective tree roots, but the
contents may be destroyed already. The chunk tree is not deep, I can see
height 1 on a 6 disk array (though lightly used, 1 node, 8 leaves) and 3
disk array (1/7 TB used, 1 node, 29 leaves). So it's quite a small
amount of data to destroy the chunktree completely, COW will lower the
chances a bit.

Rebuilding from scratch does not look simple, the available information
is stored in BLOCK_GROUP_ITEMs or INODE_ITEMs and covers portions of the
chunks. Given that the device tree would be probably damaged as well,
the amount of information to do cross-check is not high. Maybe replaying
the chunk creation logic can save some guesswork.


david
