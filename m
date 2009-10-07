From: Stefan Hajnoczi <stefanha@gmail.com>
Subject: Re: kernel BUG at fs/btrfs/file.c:528 on Linux 2.6.31.1
Date: Wed, 7 Oct 2009 16:35:37 +0100
Message-ID: <fbd9d3990910070835y1247893et7a258bdb6c8c3f0a@mail.gmail.com>
References: <fbd9d3990910070334j2080a579p25c42d23dbee08c0@mail.gmail.com>
	 <20091007152557.GG3757@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Stefan Hajnoczi <stefanha@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091007152557.GG3757@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 7, 2009 at 4:25 PM, Chris Mason <chris.mason@oracle.com> wr=
ote:
> This oops means that we're trying to insert an extent that already
> exists. =A0I think it is related to the bug in the file clone ioctl t=
hat
> Sage recently fixed. =A0The fix is in the master branch of the
> btrfs-unstable tree.

Thanks for explaining this.  How can I track when this hits vanilla lin=
ux-2.6?

> So, I'd say step one is to make a backup of this data.
>
> Are you able to figure out which of the files is being written at the
> time of the oops? =A0If not we can easily add a message to help nail =
it
> down.
>
> Either way, I'd copy the file that is triggering the problem to a new
> file and delete the old one.

The data wasn't critical, for now I have switched back to ext3.  I
really like the COW copy feature so I intend to get back on btrfs when
I have time to rebuild a kernel with the fix in it.

Stefan
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
