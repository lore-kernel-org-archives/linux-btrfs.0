From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] Add Documentation/filesystem/btrfs.txt, remove old
	COPYING and INSTALL
Date: Wed, 7 Jan 2009 14:45:57 +0100
Message-ID: <ac3eb2510901070545q1a7e4f75s920276640ca6a525@mail.gmail.com>
References: <1231320915.30643.32.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1231320915.30643.32.camel@macbook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 7, 2009 at 10:35, David Woodhouse <dwmw2@infradead.org> wrote:
> Lifted the first paragraphs of btrfs.txt straight from the wiki...

> +debug-tree: print all of the FS metadata in text form.  Example:

Can we please rename that tool and prefix everything with btrfs*,
before anything gets merged into mainline. It's really annoying to
have specialized tools with completely generic names packaged.

Ext2 did the same with "debugfs", now we would get a "debug-tree". :)

Thanks,
Kay
