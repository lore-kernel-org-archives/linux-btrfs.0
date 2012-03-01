From: David Sterba <dave@jikos.cz>
Subject: Re: your mail
Date: Thu, 1 Mar 2012 13:58:14 +0100
Message-ID: <20120301125814.GA4334@twin.jikos.cz>
References: <1330599216.71336.YahooMailNeo@web30703.mail.mud.yahoo.com> <1330605662.98275.YahooMailNeo@web30706.mail.mud.yahoo.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"chris.mason@oracle.com" <chris.mason@oracle.com>
To: bella tk <enat_love1@yahoo.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1330605662.98275.YahooMailNeo@web30706.mail.mud.yahoo.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 01, 2012 at 04:41:02AM -0800, bella tk wrote:
> I want to use btrfs defrag tool but before that i want to know how
> much the disk is fragmented. I have tried to use filefrag but it gives
> me FIBMAP:invalid argument for many times.

The only way to trigger FIBMAP on btrfs is to run filefrag with -B
option, but it should use FIEMAP by default and it works. With -v option
it'll list all extents.

> I am using e2fsprogs version 1.42 on debian squeeze. Is there another
> way to find out the level of fragmentation on btrfs filesystem?

For while filesystem fragmentation, you can use the btrfs-filefrags
too that Arne sent to the list some time ago.

If you're interested in file level fragmentation, then filefrag is the
tool to use, but beware that just counting extents is not enough, and
compression makes things more complicated to interpret results
correctly.

Also, defragmentation does unCOW the files (until the snapshot aware
defrag is finished).


david
