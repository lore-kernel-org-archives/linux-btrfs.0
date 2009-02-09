From: Chris Mason <chris.mason@oracle.com>
Subject: Re: 2.6.29-rc4: possible circular locking dependency at
 btrfs_try_spin_lock
Date: Mon, 09 Feb 2009 09:47:00 -0500
Message-ID: <1234190820.1262.0.camel@think.oraclecorp.com>
References: <a4423d670902090443v2c0da60g9c8ac4792586b044@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Alexander Beregalov <a.beregalov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <a4423d670902090443v2c0da60g9c8ac4792586b044@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2009-02-09 at 15:43 +0300, Alexander Beregalov wrote:
> Hi
> Is it false positive lockdep warning?
> 

Interesting, lockdep must be smarter in linux-next.  It's a false
positive, I'll try to fix it up.

-chris


