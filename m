From: planetf1 <bugs@cherrybyte.me.uk>
Subject: Re: Resizing a btrfs managed partition
Date: Thu, 25 Feb 2010 16:11:43 +0000
Message-ID: <hm67fv$8ff$1@dough.gmane.org>
References: <hm3dai$pnl$1@dough.gmane.org> <201002241858.12343.kreijack@libero.it>
Reply-To: bugs@cherrybyte.me.uk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201002241858.12343.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/24/2010 05:58 PM, Goffredo Baroncelli wrote:

> a) resize the underling partition (with fdisk)
> b) resize the filesystem (with btrfsctl -r<size>  <path-to-filesystem>).

Thanks for the reply. These steps worked fine :-) Just got used to using 
gparted for many years rather than carefully writing down cylinder 
start/end numbers ....


