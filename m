From: "Nikos Voutsinas" <nvoutsin@noc.edunet.gr>
Subject: Re: subvolume info in /proc/mounts
Date: Sun, 5 Feb 2012 12:30:42 +0200
Message-ID: <2ed5fe028fdcfd3d53cf217e13b827d9.squirrel@webmail01.edunet.gr>
References: <13975aa6fbfab9c845a2582c043aa938.squirrel@webmail01.edunet.gr>
    <20120204214430.GA15350@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain;charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: dave@jikos.cz
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120204214430.GA15350@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

> Hi,
>
> On Sat, Feb 04, 2012 at 08:40:51PM +0200, Nikos Voutsinas wrote:
>> There was a patch to include the subvolume mount option into
>> /proc/mounts.
>> Did that make it into the kernel;
>
> I havent' seen such patch, do you have a link?
>
>> If not, what is the formal way to find out which subvolume is mounted;
>
> Not right now, see detailed answer to a similar question:
> http://permalink.gmane.org/gmane.comp.file-systems.btrfs/15385
>
> In short, possible but not implemented.
>

It's quite old, but what was this about;

http://thread.gmane.org/gmane.comp.file-systems.btrfs/4487

Assuming that pools with multiple subvolumes and/or snapshots is the way
of doing things in btrfs, the subvolume info is required for the every day
administration.

