From: Leszek Ciesielski <skolima@gmail.com>
Subject: Re: btrfs no csum found for inode X start 0
Date: Fri, 26 Feb 2010 21:53:24 +0100
Message-ID: <23a15591002261253t46b0d79cq1142140b8292b7ab@mail.gmail.com>
References: <23a15591002242352r665ffddax479d4cbfd8c88cdb@mail.gmail.com>
	 <23a15591002250134m753cd437jb14e320d2e8b39b3@mail.gmail.com>
	 <20100226004530.GD29451@think>
	 <23a15591002260251g507833ddk92125246c6de2658@mail.gmail.com>
	 <20100226161934.GD12841@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Leszek Ciesielski <skolima@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100226161934.GD12841@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 26, 2010 at 5:19 PM, Chris Mason <chris.mason@oracle.com> w=
rote:
> On Fri, Feb 26, 2010 at 11:51:35AM +0100, Leszek Ciesielski wrote:
>> On Fri, Feb 26, 2010 at 1:45 AM, Chris Mason <chris.mason@oracle.com=
> wrote:
>> > On Thu, Feb 25, 2010 at 10:34:22AM +0100, Leszek Ciesielski wrote:
>> >> (My previous post seems to have been discarded because of the
>> >> attachment size, I'm resending it without the dmesg output - whic=
h can
>> >> be found @ http://pastebin.com/T0J3z59j )
>> >>
>> >> Hi,
>> >>
>> >> yesterday I updated my kernel (clean clone from
>> >> mason/btrfs-unstable.gi), pulling in the single latest change I h=
ave
>> >> been missing ( http://git.kernel.org/?p=3Dlinux/kernel/git/mason/=
btrfs-unstable.git;a=3Dcommit;h=3D3f6fae9559225741c91f1320090b285da1413=
290
>> >> ) and adding my patch from http://patchwork.kernel.org/patch/8154=
7/ .
>> >> Previous kernel version (without my patch - could this be my faul=
t?)
>> >> has been running fine for 14 days, but after recompiling and
>> >> rebooting, my dmesg output is full of "btrfs no csum found for in=
ode
>> >> 386 start 0" and "btrfs csum failed ino 386 extent 65191274496 cs=
um
>> >> 1851253866 wanted 0 mirror 1" and "btrfs csum failed ino 82619 of=
f
>> >> 8749056 csum 2686054019 private 0",
>> >
>> > Yes, but did you verify your data?
>>
>> Part of the data stored on the volume consisted of video recordings =
-
>> after copying out and back onto the volume, they play back fine,
>> without video or audio glitches. Which I am aware does not mean they
>> are intact, just "good enough to work". I had also some important da=
ta
>> there, which is backed up to another location - I will verify it's
>> integrity with rsync during the weekend.
>>
>> >
>> > I don't think your patch alone could have caused this. =A0Has anyt=
hing
>> > else strange been happening on this machine?
>>
>> Not really. The FS was created with metadata=3Dmirror data=3Dmirror =
on a
>> single drive, then a second (larger) drive was added and the fs was
>> rebalanced. Compression is enabled. No problems until the last kerne=
l
>> update. After the recovery - no new csum failures.
>
> Ok, what does btrfsck say about the FS now?
>
> -chris
>

49MB of errors, 3.5MB compressed file. So I guess it's not too good
;-) Log uploaded here:
http://cid-3e1bf92365ec19a2.skydrive.live.com/self.aspx/.Public/btrfscf=
k.txt.gz
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
