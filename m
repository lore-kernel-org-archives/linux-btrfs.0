From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH v2] Btrfs: allow mount -o remount,compress=no
Date: Mon, 16 Apr 2012 16:42:35 +0200
Message-ID: <20120416144233.GC20982@twin.jikos.cz>
References: <20120406102232.GH14256@twin.jikos.cz>
 <1334582871-3670-1-git-send-email-arnd@arndnet.de>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dave@jikos.cz, chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Arnd Hannemann <arnd@arndnet.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1334582871-3670-1-git-send-email-arnd@arndnet.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 16, 2012 at 03:27:51PM +0200, Arnd Hannemann wrote:
> Btrfs allows to turn on compression on a mounted and used filesystem
> by issuing mount -o remount,compress=lzo.
> This patch allows to turn compression off again
> while the filesystem is mounted. As suggested by David Sterba
> if the compress-force option was set, it is implicitly cleared
> if compression is turned off.
> 
> Signed-off-by: Arnd Hannemann <arnd@arndnet.de>

Tested-by: David Sterba <dsterba@suse.cz>

worked perfectly, remounting back and forth with compress=lzo =no
-force=lzo etc, checked output via 'mount'.


david
