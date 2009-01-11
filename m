From: "Qinghuang Feng" <qhfeng.kernel@gmail.com>
Subject: Re: [PATCH] btrfs & squashfs: Move btrfs and squashfsto's magic number to <linux/magic.h>
Date: Mon, 12 Jan 2009 02:06:07 +0800
Message-ID: <21d34cad0901111006j68d92314t60f910cd400d4474@mail.gmail.com>
References: <496a31c9.04506e0a.03e0.0963@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Phillip Lougher" <phillip@lougher.demon.co.uk>,
	"Chris Mason" <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Andrew Morton" <akpm@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <496a31c9.04506e0a.03e0.0963@mx.google.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 12, 2009 at 1:52 AM, Qinghuang Feng <qhfeng.kernel@gmail.com> wrote:
> Use the standard magic.h for btrfs and squashfs.
>
The patch can't be split to two pieces, otherwise it will conflict
because magic.h would be
modified twice.
So I also send it to akpm, he must have a good idea.
