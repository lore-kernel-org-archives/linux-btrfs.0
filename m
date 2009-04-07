From: Chris Mason <chris.mason@oracle.com>
Subject: Re: measuring btrfs compression
Date: Mon, 06 Apr 2009 23:18:33 -0400
Message-ID: <1239074313.17426.1.camel@think.oraclecorp.com>
References: <e6ac15e50904052332h2ca9b0e3ube8ceb89ca25d0f1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: mp3geek <mp3geek@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <e6ac15e50904052332h2ca9b0e3ube8ceb89ca25d0f1@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2009-04-06 at 18:32 +1200, mp3geek wrote:
> Just wondering how do I measure the compression used in btrfs?

I'm afraid the best way right now is to compare the storage reported in
the FS by df with the sizes of the files reported by du.

We need to add an ioctl that reports on the actual size of the
compressed file.

-chris


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

