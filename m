From: Chris Baines <cbaines8@gmail.com>
Subject: Re: bad tree block problems
Date: Tue, 20 Dec 2011 23:39:44 +0000
Message-ID: <CAGGGvRucivqjTz4X7LNdTo_Nx_oXY9wOor4f7zbnbCf_+-XKPw@mail.gmail.com>
References: <CAGGGvRtNCvt9LYvZE1ZEE9tYCS95KLTUdKKXnqDzm8vHbO-vfg@mail.gmail.com>
 <20111220233637.GP19266@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Chris Baines <cbaines8@gmail.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111220233637.GP19266@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On 20 December 2011 23:36, Chris Mason <chris.mason@oracle.com> wrote:
> On Tue, Dec 20, 2011 at 10:34:20PM +0000, Chris Baines wrote:
>> Hello,
>>
>> I am having problems with my btrfs filesystem, I have a 1TB RAID-1
>> setup that I use as /home. When accessing certain programs, or moving
>> large amounts of data, I often get errors looking like the one
>> attached, after I get the error, /home becomes unusable and I reboot.
>> I have tried running scrub, but it aborts (output given in the
>> attachment).
>>
>> I am using the 3.2.0-rc4 kernel (as distributed in Debian) at the
>> moment, but this may not have been the kernel I was using when I first
>> started getting the errors.
>
> It looks like you have both virtual box and nvidia loaded here, so it is
> hard to tell exactly where this problem came from.
>
> Could you please grab the latest btrfs-progs and do a:
>
> btrfs inspect logical 714427781120 /home
>
> This will tell us a little more about the bad block.
>
> -chris
>

How do I do this exactly, do I build a kernel from git?

Thanks,

Chris
