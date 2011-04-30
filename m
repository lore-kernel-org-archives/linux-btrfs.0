From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: Premature -ENOSPC on btrfs?
Date: 30 Apr 2011 02:12:00 +0200
Message-ID: <BkqztSPD1uB@helmut.hullen.de>
References: <20110429234805.GA20579@tux1.beaverton.ibm.com>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110429234805.GA20579@tux1.beaverton.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Darrick,

Du meintest am 29.04.11:


> First, I create a 1GB test fs, format it,

in which way? RAID0, RAID1, mix or something else?

> Strangely, df reports that free space remains, and I can even create
> a second file to fill the empty space, so clearly the fs isn't full
> yet.

"df" tells, how much space is at least usable. Depending on your special  
formatting options there may be more space available.

Viele Gruesse!
Helmut
