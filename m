From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs unmountable after failed suspend
Date: Wed, 8 Feb 2012 07:55:36 -0500
Message-ID: <20120208125536.GI16796@shiny>
References: <CAAE6i0g4VVpy7FduBHCY33Nt_iSOh39-9i2KWqA0fXETQUKLPA@mail.gmail.com>
 <CAAE6i0jEaXmgmnmyUOrOr+5RyvPce25QZFALan+JBQ80K=UwNQ@mail.gmail.com>
 <CAAE6i0hXA7rzZ=VCnezfyHQFn=+UcfrmUsfR-GQZcgvxFW+qJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chester <somethingsome2000@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAE6i0hXA7rzZ=VCnezfyHQFn=+UcfrmUsfR-GQZcgvxFW+qJQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 07, 2012 at 06:10:15PM -0600, Chester wrote:
> This is dmesg mounted with -o ro,recovery
> [   20.957392] exe used greatest stack depth: 4920 bytes left
> [  145.340317] device label BtrfsLinux devid 1 transid 332442 /dev/sda6
> [  145.341702] btrfs: enabling auto recovery
> [  145.341803] btrfs: disk space caching is enabled
> [  152.457967] btrfs: corrupt leaf, bad key order:
> block=653297209344,root=1, slot=7
> [  152.487933] btrfs: corrupt leaf, bad key order:
> block=653297209344,root=1, slot=7
> [  152.488326] ------------[ cut here ]------------
> [  152.488549] kernel BUG at fs/btrfs/extent-tree.c:5797!

Well, this isn't good.  If you can run btrfs-zero-log it'll get past
this part, but I'd suggest a fsck run to see if there are other
corrupted blocks.

Bad key ordering is usually from memory corruption, so this block
probably isn't alone.

-chris
