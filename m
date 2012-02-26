From: Fahrzin Hemmati <fahhem2@gmail.com>
Subject: Re: filesystem full when it's not?  out of inodes?  huh?
Date: Sat, 25 Feb 2012 18:37:24 -0800
Message-ID: <4F499AE4.80908@gmail.com>
References: <jic3e1$gpe$1@dough.gmane.org> <4F499498.1040006@gmail.com> <jic4m8$j6g$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <jic4m8$j6g$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 2/25/2012 6:16 PM, Brian J. Murrell wrote:
>> Others might know of a way of changing the allocation size to less than
>> 1GB, but otherwise I recommend switching to something more stable like
>> ext4/reiserfs/etc.
> So btrfs is still not yet suitable to be a root/usr/var filesystem, even
> in kernel 3.0.0?
>
> b.
>
Nope, still in heavy development, though you should upgrade to 3.2. 
Also, the devs mentioned in several places it's not friendly to small 
drives, and I'm pretty sure 5GB is considered tiny.

I don't think you need to separate /usr out to it's own disk. You could 
instead create a single drive with multiple subvolumes for /, /var, 
/usr, etc. When you have Ubuntu use btrfs for /, it creates @ and @home 
for / and /home, respectively, so it's a common phenomenon if you look 
for help.

--Farz
