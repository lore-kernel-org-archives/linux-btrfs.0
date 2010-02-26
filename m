From: Leszek Ciesielski <skolima@gmail.com>
Subject: Re: btrfs no csum found for inode X start 0
Date: Fri, 26 Feb 2010 11:51:35 +0100
Message-ID: <23a15591002260251g507833ddk92125246c6de2658@mail.gmail.com>
References: <23a15591002242352r665ffddax479d4cbfd8c88cdb@mail.gmail.com>
	 <23a15591002250134m753cd437jb14e320d2e8b39b3@mail.gmail.com>
	 <20100226004530.GD29451@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Leszek Ciesielski <skolima@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100226004530.GD29451@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 26, 2010 at 1:45 AM, Chris Mason <chris.mason@oracle.com> w=
rote:
> On Thu, Feb 25, 2010 at 10:34:22AM +0100, Leszek Ciesielski wrote:
>> (My previous post seems to have been discarded because of the
>> attachment size, I'm resending it without the dmesg output - which c=
an
>> be found @ http://pastebin.com/T0J3z59j )
>>
>> Hi,
>>
>> yesterday I updated my kernel (clean clone from
>> mason/btrfs-unstable.gi), pulling in the single latest change I have
>> been missing ( http://git.kernel.org/?p=3Dlinux/kernel/git/mason/btr=
fs-unstable.git;a=3Dcommit;h=3D3f6fae9559225741c91f1320090b285da1413290
>> ) and adding my patch from http://patchwork.kernel.org/patch/81547/ =
=2E
>> Previous kernel version (without my patch - could this be my fault?)
>> has been running fine for 14 days, but after recompiling and
>> rebooting, my dmesg output is full of "btrfs no csum found for inode
>> 386 start 0" and "btrfs csum failed ino 386 extent 65191274496 csum
>> 1851253866 wanted 0 mirror 1" and "btrfs csum failed ino 82619 off
>> 8749056 csum 2686054019 private 0",
>
> Yes, but did you verify your data?

Part of the data stored on the volume consisted of video recordings -
after copying out and back onto the volume, they play back fine,
without video or audio glitches. Which I am aware does not mean they
are intact, just "good enough to work". I had also some important data
there, which is backed up to another location - I will verify it's
integrity with rsync during the weekend.

>
> I don't think your patch alone could have caused this. =A0Has anythin=
g
> else strange been happening on this machine?

Not really. The FS was created with metadata=3Dmirror data=3Dmirror on =
a
single drive, then a second (larger) drive was added and the fs was
rebalanced. Compression is enabled. No problems until the last kernel
update. After the recovery - no new csum failures.

>
> The fact that all your files are wrong is especially strange. =A0Have=
 you
> ever mounted this FS with mount -o nodatasum?

Only once, after the problem occured - yesterday, when I was trying to
copy the data out. Only read access was performed (although the fs was
mounted rw).

Regards,

Leszek 'skolima' Ciesielski
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
