From: Sander <sander@humilis.net>
Subject: Re: Setting options permanently?
Date: Mon, 30 Jan 2012 08:18:13 +0100
Message-ID: <20120130071813.GA12780@attic.humilis.net>
References: <4F22BCCC.5090800@danisch.de>
 <CAAE6i0gSG4xuyJFQrmfFNh3ojF4GBbsgk7LsN+1XD=9Mp5rSUQ@mail.gmail.com>
 <4F234616.6020407@danisch.de>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chester <somethingsome2000@gmail.com>, linux-btrfs@vger.kernel.org
To: Hadmut Danisch <hadmut@danisch.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F234616.6020407@danisch.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hadmut Danisch wrote (ao):
> I currently don't see how to repair this afterwards without removing the
> uncompressed files and writing new ones, which on the other hand spoils
> hte memory saving effect of using snapshots instead of copies.

As also mentioned by Li Zefan, you can use defrag. But this will indeed
not work nicely with snapshots. And you need more free space than the
largest file on the filesystem.

find / -xdev -execdir btrfs filesystem defrag -czlib {} +

	Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
