From: Chris Mason <chris.mason@oracle.com>
Subject: Re: crc32c implementation on x86 with SSE4.2... CONFIG_BTRFS_HW_SUM
Date: Thu, 16 Oct 2008 09:49:04 -0400
Message-ID: <1224164944.6938.61.camel@think.oraclecorp.com>
References: <f058a9c30810160640r3a8c8427hc8b35d6881583fb5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Miguel Sousa Filipe <miguel.filipe@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <f058a9c30810160640r3a8c8427hc8b35d6881583fb5@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2008-10-16 at 14:40 +0100, Miguel Sousa Filipe wrote:
> Hi there,
> 
> I noticed that btrfs, in the git tree, has its own implementation of
> crc32c for x86 with SSE4.2 that implement a crc32 instruction.. it
> appears.
> Its protected by a ifdef CONFIG_BTRFS_HW_SUM, and if we're executing
> on the right cpu, that will bypass the kernel implementation of
> crc32c.
> 

The Btrfs support for intel's faster crc32c came from a patch intel
posted to linux-kernel.  I just hacked it up a bit at the time because I
didn't want to wait for mainline to include the work.

I don't see intel's patches in mainline yet, but I know there was a plan
to get them there.

-chris


