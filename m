From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH V5 2/2] btrfs: implement delayed inode items operation
Date: Sat, 26 Mar 2011 19:58:10 -0400
Message-ID: <1301183781-sup-1324@think>
References: <4D8B2DEB.1000001@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Itaru Kitayama <kitayama@cl.bb4u.ne.jp>,
	Ito <t-itoh@jp.fujitsu.com>, David Sterba <dave@jikos.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4D8B2DEB.1000001@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Miao Xie's message of 2011-03-24 07:41:31 -0400:
> Changelog V4 -> V5:
> - Fix the race on adding the delayed node to the inode, which is spotted by
>   Chris Mason.
> - Merge Chris Mason's incremental patch into this patch.
> - Fix deadlock between readdir() and memory fault, which is reported by
>   Itaru Kitayama.

This does do much better than v4, but I'm still hitting oom with
stress.sh -n 50.  I tried a bunch of variations but haven't been able to
get it quite right.  I think I need to hold off on this one and get the
2.6.39 pull request out.

I'll setup a .40 tree that has this in it and we can fix the ooms.  This
is a great base for the work, and I'd like to add more items to the
delay, especially the initial inode insertions.

-chris
