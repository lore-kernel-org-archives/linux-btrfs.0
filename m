From: Michael Raskin <a0091f122@rambler.ru>
Subject: Re: Btrfs warnings: -rc2
Date: Fri, 17 Jul 2009 00:32:28 +0400
Message-ID: <4A5F8E5C.4050904@rambler.ru>
References: <4A5F3AD9.5040005@rambler.ru> <20090716183250.GC3883@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Michael Raskin <a0091f122@rambler.ru>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090716183250.GC3883@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> 
> Could you please touch foo ; ls -lai foo and send us the results.  Yan
> Zheng has a theory that it is related to inode numbers

4873317 -rw-r--r-- 1 root root 0 Jul 17 00:29 foo

dmesg is clean

creating/deleting 2 files gives the same result (with even larger inodes
each time, although foo is deleted already). The same for ghost files.
dmesg is clean.
