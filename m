From: C Anthony Risinger <anthony@extof.me>
Subject: Re: [RFC-PATCH] Re: mounting arbitrary directories
Date: Sun, 28 Nov 2010 03:41:40 -0600
Message-ID: <AANLkTinMbZuE64QgZFxWHm69zyixwZEiuMVuF9tztHJ9@mail.gmail.com>
References: <AANLkTi=7LY6y3BvGgkyYBTLwu=SYJjZZhL8kHusCn_vs@mail.gmail.com>
	<1290918133.14274.20.camel@nayuki>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Calvin Walton <calvin.walton@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1290918133.14274.20.camel@nayuki>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 27, 2010 at 10:22 PM, Calvin Walton <calvin.walton@gmail.co=
m> wrote:
> On Sat, 2010-11-27 at 21:19 -0600, C Anthony Risinger wrote:
>> i have read just recently and in the past that btrfs supports COW fo=
r
>> _any_ file/directory (this is reflinks, yes?), and today i
>> accidentally noticed that i can mount a directory as well (if it's i=
n
>> the top level volume at least).
>>
>> eg. if i have a "regular" directory (not a subvolume) in the top-lev=
el:
>>
>> /__boot
>>
>> i can mount it with:
>>
>> mount -o subvol=3D__boot /dev/sda /mnt
>
> The 'subvol' option actually works using the same mechanism as a bind
> mount. The fact that it works using a directory is purely a coinciden=
ce
> - I would not expect it to be officially supported, and you shouldn't
> rely on it.

ok, good to know.

>> i am working on an update to my initramfs hook that will utilize
>> extlinux, and this property to provide seamless kernel level system
>> rollbacks, and i want to make sure it's safe to do this.
>
> To handle system rollbacks, you really should be using subvolumes and
> snapshots, not regular directories.

i do use snapshots, but the kernels cannot be read from them by
extlinux.  i must manually sync to either the top level btrfs root or
separate boot partition(s); this is required to handle kernel
upgrades... else you end up running a kernel against modules/etc.
built against an older/newer version.  the only other way i could
think of was to use a permanent intermediary kernel with the sole
purpose of mounting the btrfs device, and kexec'ing the correct kernel
within a snapshot.

>> also, is there a way to target an arbitrary directory? =A0does "subv=
ol"
>> support paths yet, or maybe via "subvolid" somehow? =A0essentially i
>
> I don't think that it would be very hard to make subvol=3D support a =
path
> instead of only one level deep. Actually, I think I could make a patc=
h
> for that myself... I've included it here. Mildly tested, but I'm not
> really a kernel programmer and might have missed something -
> particularly with regards to the locking.

nice, something like this is a good addition!  if it's really that
simple it should definitely be included.

>> just want to mount a directory inside a snapshot at /boot, so when
>> users upgrade there kernels, the images are visible to extlinux (whi=
ch
>> cannot yet peek inside or use subvolumes, so it has to be a regular
>> directory in the top-level volume)
>
> Ah, this is the first I've heard that extlinux doesn't support readin=
g
> files in subvolumes. That's an unfortunate limitation :/

well i actually thought it was working... but i ended up wasting
several hours only to learn that extlinux could "kind of" see them.
basically, usually the first snapshot appeared correct, but it was
really a recursive link back on itself.  sometimes snapshots would be
missing pieces -- seems to be related to COW; i think extlinux could
only see the chunks in snapshots that were still shared with the
top-level volume... but that's a observational guess.

needless to say, it really tripped me up for awhile until i remembered
the "rosh.c32" module and manually peeked around a bit :-)

C Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
