From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Unable to mount btrfs after crash
Date: Mon, 13 Apr 2009 09:28:28 -0400
Message-ID: <1239629308.24841.2.camel@think.oraclecorp.com>
References: <EE151463-E687-43D0-91E0-02003C32972F@hachre.de>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Harald Glatt <mail@hachre.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <EE151463-E687-43D0-91E0-02003C32972F@hachre.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2009-04-12 at 02:03 +0200, Harald Glatt wrote:
> Hi,
> 
> I have set up a btrfs within a 200 GB file that I mount via -o loop.
> 
> It worked fine so far but today it crashed when there was alot of  
> concurrent writing/reading going on.
> I'm testing it with a torrent client, so the data is really irrelevant  
> - but it's a good amount of stress.
> 

Loopback is somewhat tricky because the kernel loopback driver only
writes into the page cache of the underlying file in the host
filesystem.  So, the filesystem inside the loopback file thinks it has
written things to disk but in reality it is just in cache.

If you crash in the middle of all of this, you're going to see
significant corruptions of the FS inside the loopback file.

-chris


