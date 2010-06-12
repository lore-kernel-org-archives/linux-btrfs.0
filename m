From: Sage Weil <sage@newdream.net>
Subject: Re: reflinked file size incorrect
Date: Sat, 12 Jun 2010 15:41:21 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.1006121511310.12125@cobra.newdream.net>
References: <20100612164848.GB16863@3e8.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Jim Ursetto <jim@3e8.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100612164848.GB16863@3e8.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 12 Jun 2010, Jim Ursetto wrote:
> Both `cp --reflink` and `bcp` sometimes round the file size up to the next
> 4k boundary, with the balance consisting of null bytes.  At first glance
> this behavior occurs for source file size > 3916 bytes.  I have tried this
> with stock btrfs from kernel 2.6.35-rc2 and 2.6.35-rc1 -- specifically,
> Ubuntu 2.6.35-2.3~lucid1-server and 2.6.35-1.1~lucid1-server.
> Any ideas?

This bug is new in 2.6.35-rc1 from a22285a6 (Btrfs: Integrate metadata 
reservation with start_transaction).  Just sent a patch fixing this up to 
the list.

sage
