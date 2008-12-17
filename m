From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] fix wrong value returned from btrfs_listxattr when
 buffer is too small
Date: Wed, 17 Dec 2008 10:22:20 -0500
Message-ID: <1229527340.27170.33.camel@think.oraclecorp.com>
References: <a37615150812121436w57f43184g71b297369f3923e1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Yehuda Sadeh Weinraub <yehudasa@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <a37615150812121436w57f43184g71b297369f3923e1@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2008-12-12 at 14:36 -0800, Yehuda Sadeh Weinraub wrote:
> Fix bug, btrfs_listxattr doesn't return an error when the buffer size
> is too small (ret was overridden).
> 

Thank you, I've applied this one locally and will push it out.

-chris


