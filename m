From: dima <dolenin@parallels.com>
Subject: Re: Corrupt file in subvolume
Date: Tue, 11 Oct 2011 13:30:31 +0000 (UTC)
Message-ID: <loom.20111011T152551-357@post.gmane.org>
References: <loom.20111010T040355-185@post.gmane.org> <20111010103723.GE17912@twin.jikos.cz> <loom.20111010T124733-121@post.gmane.org> <20111010112917.GG17912@twin.jikos.cz> <loom.20111010T141734-588@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I have upgraded to 3.1 rc8.
I created a new subvolume for /home, copied the files there from the old
subvolume and deleted the old subvolume. It looks like the space has been
reclaimed fine.

Though when doing btrfsck I am still getting the same error
failed to find block number 150121762816

