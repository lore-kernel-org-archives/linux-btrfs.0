From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs unmountable after failed suspend
Date: Wed, 8 Feb 2012 15:26:58 -0500
Message-ID: <20120208202658.GH8384@shiny>
References: <CAAE6i0g4VVpy7FduBHCY33Nt_iSOh39-9i2KWqA0fXETQUKLPA@mail.gmail.com>
 <CAAE6i0jEaXmgmnmyUOrOr+5RyvPce25QZFALan+JBQ80K=UwNQ@mail.gmail.com>
 <CAAE6i0hXA7rzZ=VCnezfyHQFn=+UcfrmUsfR-GQZcgvxFW+qJQ@mail.gmail.com>
 <20120208125536.GI16796@shiny>
 <CAAE6i0ggEyVGh94L7n00Mm-YZTq26de2kZspU+AQKiaA=JD+8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chester <somethingsome2000@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAE6i0ggEyVGh94L7n00Mm-YZTq26de2kZspU+AQKiaA=JD+8g@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 08, 2012 at 01:22:19PM -0600, Chester wrote:
> On Wed, Feb 8, 2012 at 6:55 AM, Chris Mason <chris.mason@oracle.com> =
wrote:
> > On Tue, Feb 07, 2012 at 06:10:15PM -0600, Chester wrote:
> >> This is dmesg mounted with -o ro,recovery
> >> [ =A0 20.957392] exe used greatest stack depth: 4920 bytes left
> >> [ =A0145.340317] device label BtrfsLinux devid 1 transid 332442 /d=
ev/sda6
> >> [ =A0145.341702] btrfs: enabling auto recovery
> >> [ =A0145.341803] btrfs: disk space caching is enabled
> >> [ =A0152.457967] btrfs: corrupt leaf, bad key order:
> >> block=3D653297209344,root=3D1, slot=3D7
> >> [ =A0152.487933] btrfs: corrupt leaf, bad key order:
> >> block=3D653297209344,root=3D1, slot=3D7
> >> [ =A0152.488326] ------------[ cut here ]------------
> >> [ =A0152.488549] kernel BUG at fs/btrfs/extent-tree.c:5797!
> >
> > Well, this isn't good. =A0If you can run btrfs-zero-log it'll get p=
ast
> > this part, but I'd suggest a fsck run to see if there are other
> > corrupted blocks.
> I've already tried the -o recovery option at mount. I was told it doe=
s
> the same as btrfs-zero-log (but probably less destructive). Just a

It does zero the log, but looks like it does so a little too late.  The
mount -o recovery code zeros it if we failed to read some of the tree
roots, but you're hitting the tree log before we fail.  Long story
short, you need to btrfs-zero-log ;)

> quick question: Will the release of btrfsck later this month be able
> to fix these corruptions?

=46ixing the key ordering is pretty easy, I can do that here.  But I'll
need to see the fsck output to say if the rest is fixed in the current
code.

> >
> > Bad key ordering is usually from memory corruption, so this block
> > probably isn't alone.
> Yeah. Could be from using zcache. I haven't had a problem with it
> until I tried to suspend to RAM though.

Could be, I'd suggest running with CONFIG_DEBUG_PAGE_ALLOC.  You might
also just have bad ram.

-chris

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
