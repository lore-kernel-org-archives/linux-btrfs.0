From: Chester <somethingsome2000@gmail.com>
Subject: Re: btrfs unmountable after failed suspend
Date: Wed, 8 Feb 2012 13:22:19 -0600
Message-ID: <CAAE6i0ggEyVGh94L7n00Mm-YZTq26de2kZspU+AQKiaA=JD+8g@mail.gmail.com>
References: <CAAE6i0g4VVpy7FduBHCY33Nt_iSOh39-9i2KWqA0fXETQUKLPA@mail.gmail.com>
 <CAAE6i0jEaXmgmnmyUOrOr+5RyvPce25QZFALan+JBQ80K=UwNQ@mail.gmail.com>
 <CAAE6i0hXA7rzZ=VCnezfyHQFn=+UcfrmUsfR-GQZcgvxFW+qJQ@mail.gmail.com> <20120208125536.GI16796@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Chester <somethingsome2000@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120208125536.GI16796@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 8, 2012 at 6:55 AM, Chris Mason <chris.mason@oracle.com> wr=
ote:
> On Tue, Feb 07, 2012 at 06:10:15PM -0600, Chester wrote:
>> This is dmesg mounted with -o ro,recovery
>> [ =A0 20.957392] exe used greatest stack depth: 4920 bytes left
>> [ =A0145.340317] device label BtrfsLinux devid 1 transid 332442 /dev=
/sda6
>> [ =A0145.341702] btrfs: enabling auto recovery
>> [ =A0145.341803] btrfs: disk space caching is enabled
>> [ =A0152.457967] btrfs: corrupt leaf, bad key order:
>> block=3D653297209344,root=3D1, slot=3D7
>> [ =A0152.487933] btrfs: corrupt leaf, bad key order:
>> block=3D653297209344,root=3D1, slot=3D7
>> [ =A0152.488326] ------------[ cut here ]------------
>> [ =A0152.488549] kernel BUG at fs/btrfs/extent-tree.c:5797!
>
> Well, this isn't good. =A0If you can run btrfs-zero-log it'll get pas=
t
> this part, but I'd suggest a fsck run to see if there are other
> corrupted blocks.
I've already tried the -o recovery option at mount. I was told it does
the same as btrfs-zero-log (but probably less destructive). Just a
quick question: Will the release of btrfsck later this month be able
to fix these corruptions?
>
> Bad key ordering is usually from memory corruption, so this block
> probably isn't alone.
Yeah. Could be from using zcache. I haven't had a problem with it
until I tried to suspend to RAM though.
>
> -chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
