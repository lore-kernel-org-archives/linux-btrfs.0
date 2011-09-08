From: C Anthony Risinger <anthony@xtfx.me>
Subject: Re: Btrfs moved my root tree off the end of the device
Date: Thu, 8 Sep 2011 00:20:29 -0500
Message-ID: <CAGAVQTForUYuKO2r7iKnbBrbGC8iExdQ=ki1LwHwjdsr0vS7GQ@mail.gmail.com>
References: <loom.20110908T005218-836@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Justin Gottula <justin@jgottula.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20110908T005218-836@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 7, 2011 at 6:33 PM, Justin Gottula <justin@jgottula.com> wrote:
>
> Hi,
>
> I recently created a Btrfs volume on top of a software (mdadm) raid5 array
> (since Btrfs currently lacks raid5 support at the FS level). On this 640 GB
> volume, I stored a ~400 GB tar file. After a couple weeks of use, I used 'btrfs
> defragment' on this file in an effort to (a) defrag and (b) compress the file. I
> made sure I was using the latest version of the userspace utilities (Btrfs
> v0.19-35-g1b444cd-dirty) as well as kernel 3.0.

did you use the integration branch, ie:

http://git.darksatanic.net/repo/btrfs-progs-unstable.git

... this has the latest code for the time being.  looks like
`integration-20110805` is the most recent head.

> <snip>
>
> At this point, I took a disk image and dived in, and in doing so discovered that
> somehow, there were CHUNK_ITEMs in the chunk tree that referred to physical
> address ranges that were entirely outside of the device (matching up to the
> ranges showing up in the kernel log over and over). Evidently, the filesystem
> driver thought it should move the root tree onto a chunk that existed at a
> nonexistant offset in the device. I checked the superblocks and verified that
> the total_bytes fields matched up correctly to the actual device size, which
> leaves me wondering how those chunks ever got there.

i could be way of base here, but your report reminded me of:

[thread] http://www.spinics.net/lists/linux-btrfs/index.html#12121

-----------------------------------------------
extent data backref root 5 objectid 258 offset 18446744073709543424 count 1
extent data backref root 5 objectid 257 offset 0 count 1

> So I think we have to live with this defect, just fix relocation for
> the negative offset case ?

I prefer fixing relocation.
-----------------------------------------------

... which, if i understood correctly, surfaced some issues with
relocation that could cause the offset to be grossly inaccurate (eg.
off the device completely?)

could of course be completely unrelated :-)

-- 

C Anthony
