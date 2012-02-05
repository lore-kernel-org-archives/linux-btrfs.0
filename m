From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: subvolume info in /proc/mounts
Date: Mon, 6 Feb 2012 06:38:38 +0700
Message-ID: <CAG1y0scGVbmpTDBehrz79RCMY_HqBEtLwf_wALvbp4EBq3bzKQ@mail.gmail.com>
References: <13975aa6fbfab9c845a2582c043aa938.squirrel@webmail01.edunet.gr>
	<20120204214430.GA15350@twin.jikos.cz>
	<2ed5fe028fdcfd3d53cf217e13b827d9.squirrel@webmail01.edunet.gr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Nikos Voutsinas <nvoutsin@noc.edunet.gr>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <2ed5fe028fdcfd3d53cf217e13b827d9.squirrel@webmail01.edunet.gr>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 5, 2012 at 5:30 PM, Nikos Voutsinas <nvoutsin@noc.edunet.gr> wrote:
>>> If not, what is the formal way to find out which subvolume is mounted;
>>
>> Not right now, see detailed answer to a similar question:
>> http://permalink.gmane.org/gmane.comp.file-systems.btrfs/15385

> Assuming that pools with multiple subvolumes and/or snapshots is the way
> of doing things in btrfs, the subvolume info is required for the every day
> administration.

For simple administration, /etc/mtab (or the output of mount) as
mentioned in David's link should work.

-- 
Fajar
