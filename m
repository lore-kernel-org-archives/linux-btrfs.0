From: Fahrzin Hemmati <fahhem2@gmail.com>
Subject: Re: filesystem full when it's not?  out of inodes?  huh?
Date: Sat, 25 Feb 2012 20:05:13 -0800
Message-ID: <4F49AF79.4020706@gmail.com>
References: <jic3e1$gpe$1@dough.gmane.org> <4F499498.1040006@gmail.com> <jic4m8$j6g$1@dough.gmane.org> <4F499AE4.80908@gmail.com> <jicait$grq$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <jicait$grq$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 2/25/2012 7:57 PM, Brian J. Murrell wrote:
> On 12-02-25 09:37 PM, Fahrzin Hemmati wrote:
>> Nope, still in heavy development, though you should upgrade to 3.2.
> I recall being told I should upgrade to 2.6.36 (or was it .37 or .38) at
> one time.  Seems like one should always upgrade.  :-/
It's a new, in-development filesystem. Until they say "It's stable, have 
fun", you should upgrade. If you follow any other filesystem before 
they've marked it stable and you'll get the same responses.
>> Also, the devs mentioned in several places it's not friendly to small
>> drives, and I'm pretty sure 5GB is considered tiny.
> But it won't ever get taken serious if it can't be used on "regular"
> filesystems.  I shouldn't have to allocate an 80G filesystem for 3G of
> data just so that the filesystem isn't "tiny".
All filesystems have their own pros and cons; btrfs, at least while 
in-development doesn't support small filesystems. Again, nobody's 
responded to the contrary, but there may be a way to changing the 
default allocation size to less than 1GB, making your use case viable. I 
recommend Google.
>> I don't think you need to separate /usr out to it's own disk. You could
>> instead create a single drive with multiple subvolumes for /, /var,
>> /usr, etc.
> The point is to separate filesystems which can easily fill with
> application data growth from filesystems that can have more fatal
> effects by being filled.
>
> That said, I don't think having /var as a subvolume in the same pool as
> / and /usr achieves that usage isolation, does it?  Isn't /var still
> allowed to consume all of the space that it, / and /usr share with them
> all being subvolumes in the same pool?
>
>> When you have Ubuntu use btrfs for /, it creates @ and @home
>> for / and /home, respectively,
> Yes, I had noticed that.  I also didn't immediately see anything that
> prevents /home from filling / as I describe above.
>
> Cheers,
> b.
>

No, at least not yet, nor am I aware of any plans for subvolume quotas, 
though I could be wrong. If you wish to use a small space for your /usr, 
you can either wait for btrfs to support your use-case (or find out how 
to change allocation size), or use another filesystem that already does.

--Farz
