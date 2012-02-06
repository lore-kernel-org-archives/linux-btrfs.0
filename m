From: Karel Zak <kzak@redhat.com>
Subject: Re: subvolume info in /proc/mounts
Date: Mon, 6 Feb 2012 10:52:34 +0100
Message-ID: <20120206095234.GA19469@x2.net.home>
References: <13975aa6fbfab9c845a2582c043aa938.squirrel@webmail01.edunet.gr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Nikos Voutsinas <nvoutsin@noc.edunet.gr>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <13975aa6fbfab9c845a2582c043aa938.squirrel@webmail01.edunet.gr>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 04, 2012 at 08:40:51PM +0200, Nikos Voutsinas wrote:
> There was a patch to include the subvolume mount option into /proc/mounts.
> Did that make it into the kernel;
> 
> If not, what is the formal way to find out which subvolume is mounted;

 see /proc/self/mountinfo there is 'fs root' column, for bind mounts
 and btrfs subvolumes is there '/<path>' (and '/' for normal mounts).

 findmnt(8) uses the path in SOURCE column, for example /dev/sda1[/subvolume].

    Karel


-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
