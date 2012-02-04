From: David Sterba <dave@jikos.cz>
Subject: Re: subvolume info in /proc/mounts
Date: Sat, 4 Feb 2012 22:44:30 +0100
Message-ID: <20120204214430.GA15350@twin.jikos.cz>
References: <13975aa6fbfab9c845a2582c043aa938.squirrel@webmail01.edunet.gr>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Nikos Voutsinas <nvoutsin@noc.edunet.gr>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <13975aa6fbfab9c845a2582c043aa938.squirrel@webmail01.edunet.gr>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Sat, Feb 04, 2012 at 08:40:51PM +0200, Nikos Voutsinas wrote:
> There was a patch to include the subvolume mount option into /proc/mounts.
> Did that make it into the kernel;

I havent' seen such patch, do you have a link?

> If not, what is the formal way to find out which subvolume is mounted;

Not right now, see detailed answer to a similar question:
http://permalink.gmane.org/gmane.comp.file-systems.btrfs/15385

In short, possible but not implemented.


david
