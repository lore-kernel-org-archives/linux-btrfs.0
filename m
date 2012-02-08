From: Felix Blanke <felixblanke@gmail.com>
Subject: Re: Btrfs out of inodes becomes corrupt
Date: Wed, 08 Feb 2012 10:00:43 +0100
Message-ID: <4F3239BB.2070805@gmail.com>
References: <b0ee762c11692ea16e81a34469311c14@localhost> <20120205195742.GC19330@carfax.org.uk> <201202081741.13243.chris@csamuel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Chris Samuel <chris@csamuel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201202081741.13243.chris@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 2/8/12 7:41 AM, Chris Samuel wrote:
> On Monday 06 February 2012 06:57:42 Hugo Mills wrote:
>
>>> This al under debian  with kernel 2.6.32-5.
>>
>>     Aargh.
>>
>>     You are aware that this is an insanely old version of the brtfs
>> code, and it has major flaws in it?
>
> As someone who runs his work laptop with a 2.6.32 laptop and btrfs for
> /home I'll bite at this one - I've held off updating after reading the
> issues people were reporting on the list with newer kernels that did
> not appear to be present in 2.6.32 (indeed IIRC a particular problem
> from that time could only be solved at the time be remounting the
> filesystem with 2.6.32, at which point newer kernels could access it
> again).   It's served me very well, it "just works" (so far at least).
>
> It's now sounding that 3.2 is probably stable enough for me to
> consider updating to the next KUbuntu release when it comes out.
>
> NB:  Yes, I do make nightly backups, and no, I don't run the
> filesystem at anything close to even a quarter full (not that that
> guarantees anything, or is even particularly deliberate).
>
> cheers,
> Chris

Ofc you can be one of the lucky users who doesn't hit a bug on .32. Imho 
that isn't an argument for not upgrading.
There are new bugs in 3.2, but on the other hand there are hundreds of 
fixed bugs, new features etc.

Especially using alpha releases of software without upgrading whenever 
there is a chance to seems very strange to me :)

Kind regards,
Felix Blanke
