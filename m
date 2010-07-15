From: Chris Mason <chris.mason@oracle.com>
Subject: Re: csum errors
Date: Thu, 15 Jul 2010 15:03:09 -0400
Message-ID: <20100715190309.GI8623@think>
References: <201007081627.24654.johannes.hirte@fem.tu-ilmenau.de>
 <201007111428.10005.johannes.hirte@fem.tu-ilmenau.de>
 <201007131423.59415.johannes.hirte@fem.tu-ilmenau.de>
 <201007152030.18431.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201007152030.18431.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 15, 2010 at 08:30:17PM +0200, Johannes Hirte wrote:
> Am Dienstag 13 Juli 2010, 14:23:58 schrieb Johannes Hirte:
> > ino 1959333 off 898342912 csum 4271223884 private 4271223883
> 
> I think, this is a different error. I've only seen them on filesystems from my 
> Opteron system. It seems that the recorded csums are wrong and it looks to me 
> like rounding errors. The data itself should be correct, as I've tested one 
> affected file via md5sum against the original on another filesystem.
> Any ideas what is going wrong here?

Are you doing data mirroring?

We can map that block and do a raw read off the device to see what the
data blocks actually contain.

-chris
