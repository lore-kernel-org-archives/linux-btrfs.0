From: "Dipl.-Ing. Michael Niederle" <mniederle@gmx.at>
Subject: Re: btrfs subvol find-modified
Date: Fri, 26 Mar 2010 21:22:07 +0100
Message-ID: <20100326212207.424db8af@simplux>
References: <20100326111807.24dcc2f0@simplux>
	<20100326132219.GF16453@think>
	<20100326195147.146db06e@simplux>
	<20100326193642.GC13680@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100326193642.GC13680@think>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Chris!

> Add an optional timestamp field to filter
> files that have changed since a given timestamp.

Is there a possibility to derive the timestamp directly from the generation
number?

If we have a "-e"-switch for printing extent-information we could also have
another switch to decide whether to print directory-information or not and
combine find-new and find-modified into a single command.

Meanwhile I have implemented the (very simple) command

btrfs subvolume max-gen <path>
	Print the highest generation number in a filesystem.

Greetings, Michael
