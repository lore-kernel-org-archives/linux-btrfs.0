From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:1353
Date: Thu, 8 Jul 2010 17:40:32 +0200
Message-ID: <201007081740.34000.johannes.hirte@fem.tu-ilmenau.de>
References: <201007081627.24654.johannes.hirte@fem.tu-ilmenau.de> <20100708143109.GR15984@think>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	zheng.yan@oracle.com
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100708143109.GR15984@think>
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag 08 Juli 2010, 16:31:09 schrieb Chris Mason:
> Neither Yan nor I have been able to reproduce this locally, but a few
> people have now hit it.  Johannes, are you available to try out a
> debugging kernel to try and track this down?

Sure, just tell me what to do. Is it enough to recompile the kernel with debug 
options enabled or are special debug patches necessary?

regards,
  Johannes
