From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Updated btrfs/crypto snappy interface ready for merging
Date: Tue, 17 Jan 2012 09:46:50 +0100
Message-ID: <20120117084650.GP11715@one.firstfloor.org>
References: <1326414530-10789-1-git-send-email-andi@firstfloor.org> <20120116135442.GA28487@shiny> <4F1534FD.30707@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F1534FD.30707@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

> It's because decompressing inline extents always fails. I've fixed it
> and will send the patch out in a new mail thread.

Thanks for fixing.

> 
> But seems there's bug in lib snappy code, which makes the decompressed
> data doesn't quite match the original data.
> 
> Simply copy a file to a btrfs filesystem with snappy enabled, and clear
> page cache, and check the file:

Hmm weird, I have never seen this. Do you have a reproducer?

The basic compression code is quite well tested, I have a reasonable
unit test.

-Andi
