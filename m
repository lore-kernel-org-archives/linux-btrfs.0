From: C Anthony Risinger <anthony@extof.me>
Subject: Re: [RFC-PATCH] Re: mounting arbitrary directories
Date: Sun, 28 Nov 2010 04:07:18 -0600
Message-ID: <-3532760747667207688@unknownmsgid>
References: <AANLkTi=7LY6y3BvGgkyYBTLwu=SYJjZZhL8kHusCn_vs@mail.gmail.com> <1290918133.14274.20.camel@nayuki>
Mime-Version: 1.0 (iPhone Mail 7D11)
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Calvin Walton <calvin.walton@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1290918133.14274.20.camel@nayuki>
List-ID: <linux-btrfs.vger.kernel.org>

On Nov 27, 2010, at 10:22 PM, Calvin Walton <calvin.walton@gmail.com>
wrote:

> On Sat, 2010-11-27 at 21:19 -0600, C Anthony Risinger wrote:
>> i have read just recently and in the past that btrfs supports COW for
>> _any_ file/directory (this is reflinks, yes?), and today i
>> accidentally noticed that i can mount a directory as well (if it's in
>> the top level volume at least).
>>
>> eg. if i have a "regular" directory (not a subvolume) in the top-
>> level:
>>
>> /__boot
>>
>> i can mount it with:
>>
>> mount -o subvol=__boot /dev/sda /mnt
>
> The 'subvol' option actually works using the same mechanism as a bind
> mount. The fact that it works using a directory is purely a
> coincidence
> - I would not expect it to be officially supported, and you shouldn't
> rely on it.
>
>> i am working on an update to my initramfs hook that will utilize
>> extlinux, and this property to provide seamless kernel level system
>> rollbacks, and i want to make sure it's safe to do this.
>
> To handle system rollbacks, you really should be using subvolumes and
> snapshots, not regular directories.
>
>> also, is there a way to target an arbitrary directory?  does "subvol"
>> support paths yet, or maybe via "subvolid" somehow?  essentially i
>
> I don't think that it would be very hard to make subvol= support a
> path
> instead of only one level deep. Actually, I think I could make a patch
> for that myself... I've included it here. Mildly tested, but I'm not
> really a kernel programmer and might have missed something -
> particularly with regards to the locking.
>
>> just want to mount a directory inside a snapshot at /boot, so when
>> users upgrade there kernels, the images are visible to extlinux
>> (which
>> cannot yet peek inside or use subvolumes, so it has to be a regular
>> directory in the top-level volume)
>
> Ah, this is the first I've heard that extlinux doesn't support reading
> files in subvolumes. That's an unfortunate limitation :/

Hrrrm... Well I thought I'd be clever and use this little trick one
time to update my kernel... Anyways I oops out like 3 times in a row
(last func was <something>.clone in each IIRC) and now I'm stuck with
only my mobile since my server isn't set up yet and my  SSD just
failed on my netbook yesterday :-(

Sooooo, if anyone can help me recover this partition long enough to
grab a few things... I would be most grateful :-) I think I have
everything critical, but I'd rather take another look :-) Right now I
can't mount; mount is failing w/bad superblock.

/me promises to never recklessly sabotage himself after being warned <
6 hrs earlier

C Anthony [mobile]
