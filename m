From: Curtis Jones <curtis.jones@gmail.com>
Subject: Re: btrfs open_ctree failed (after recent Ubuntu update)
Date: Sat, 18 Feb 2012 21:47:35 -0500
Message-ID: <FA65D86B-2BF3-49C9-941D-04AFF239523D@gmail.com>
References: <455D7450-3946-478A-9021-6B01A4D7FB9B@gmail.com> <201202191000.34819.chris@csamuel.org>
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Chris Samuel <chris@csamuel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201202191000.34819.chris@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I don't want to push this too far in the direction of being an Ubuntu support thread; but do you happen to know of any convenient methods for installing a 3.2.x kernel on Ubuntu? I'd like to minimize the chance of screwing up my existing Ubuntu installation....

Thanks for your help.

--
Curtis Jones
curtisjones.us
404.492.6437




On Feb 18, 2012, at 18.00.27, Chris Samuel wrote:

> On Sunday 19 February 2012 07:34:22 Curtis Jones wrote:
> 
>> Any help would be appreciated. Thank you. Please CC me on any
>> replies.
>> 
>> Linux veriton 3.0.0-16-generic-pae #28-Ubuntu SMP Fri Jan 27
>> 19:24:01 UTC 2012 i686 i686 i386 GNU/Linux
> 
> That's a fairly old kernel in btrfs terms, you may want to try the 
> latest 3.2.x kernel from the Ubuntu Mainline Kernel PPA here:
> 
> http://kernel.ubuntu.com/~kernel-ppa/mainline/
> 
> If that doesn't work out you can try the latest 3.3 RC there too.
> 
> I'm running the 64-bit 3.2.5 kernel from there on Kubuntu 11.10 and it 
> is fine (modulo boot time complaints about the apparmour stuff).
> 
> cheers,
> Chris
> -- 
> Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
> 
> This email may come with a PGP signature as a file. Do not panic.
> For more info see: http://en.wikipedia.org/wiki/OpenPGP

