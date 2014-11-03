Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.plaintext.sk ([85.248.156.6]:33648 "EHLO
	shiva.plaintext.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbaKCOJP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Nov 2014 09:09:15 -0500
Date: Mon, 3 Nov 2014 15:09:11 +0100 (GMT+01:00)
From: LuVar <luvar@plaintext.sk>
To: Zygo Blaxell <zblaxell@furryterror.org>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <1959259002.1771415023751082.JavaMail.root@shiva>
In-Reply-To: <20141030160004.GK17395@hungrycats.org>
Subject: Re: btrfs deduplication and linux cache management
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for nice and "replicate at home yourself" example. On my machine it is behaving precisely like in your:

<code>
root@blackdawn:/home/luvar# sync; sysctl vm.drop_caches=1
vm.drop_caches = 1
root@blackdawn:/home/luvar# time cat /home/luvar/programs/adt-bundle-linux/sdk/system-images/android-L/default/armeabi-v7a/userdata.img > /dev/null 
real    0m6.768s
user    0m0.016s
sys     0m0.599s

root@blackdawn:/home/luvar# time cat /home/luvar/programs/android-sdk-linux/system-images/android-L/default/armeabi-v7a/userdata.img > /dev/null 
real    0m5.259s
user    0m0.018s
sys     0m0.695s

root@blackdawn:/home/luvar# time cat /home/luvar/programs/adt-bundle-linux/sdk/system-images/android-L/default/armeabi-v7a/userdata.img > /dev/null 
real    0m0.701s
user    0m0.014s
sys     0m0.288s

root@blackdawn:/home/luvar# time cat /home/luvar/programs/android-sdk-linux/system-images/android-L/default/armeabi-v7a/userdata.img > /dev/null
real    0m0.286s
user    0m0.013s
sys     0m0.272s
</code>

If you would mind asking, is there any plan to optimize this behaviour? I know that btrfs is not like ZFS (whole system from blockdevice, through cache, to VFS), so vould be possible to implement such optimization without major patch in linux block cache/VFS cache?

Thanks, have a nice day,
--
LuVar


----- "Zygo Blaxell" <zblaxell@furryterror.org> wrote:

> On Thu, Oct 30, 2014 at 10:26:07AM +0100, luvar@plaintext.sk wrote:
> > Hi,
> > I want to ask, if deduplicated file content will be cached in linux
> kernel just once for two deduplicated files.
> > 
> > To explain in deep:
> >  - I use btrfs for whole system with few subvolumes with some
> compression on some subvolumes.
> >  - I have two directories with eclipse SDK with slightly differences
> (same version, different config)
> >  - I assume that given directories is deduplicated and so two
> eclipse installations take place on hdd like one would (in rough
> estimation)
> >  - I will start one of given eclipse
> >  - linux kernel will cache all opened files during start of eclipse
> (I have enough free ram)
> >  - I am just happy stupid linux user:
> >     1. will kernel cache file content after decompression? (I think
> yes)
> >     2. cached data will be in VFS layer or in block device layer?
> 
> My guess based on behavior is the VFS layer.  See below.
> 
> >  - When I will lunch second eclipse (different from first, but
> deduplicated from first) after first one:
> >     1. will second start require less data to be read from HDD?
> 
> No.
> 
> >     2. will be metadata for second instance read from hdd? (I asume
> yes)
> 
> Yes (how could it not?).
> 
> >     3. will be actual data read second time? (I hope not)
> 
> Unfortunately, yes.
> 
> This is my test:
> 
> 1.  Create a file full of compressible data that is big enough to
> take
> a few seconds to read from disk, but not too big to fit in RAM:
> 
> 	yes $(date) | head -c 500m > a
> 
> 2.  Create a "deduplicated" (shared extent) copy of same:
> 
> 	cp --reflink=always a b
> 
> 	(use filefrag -v to verify both files have same physical extents)
> 
> 3.  Drop caches
> 
> 	sync; sysctl vm.drop_caches=1
> 
> 4.  Time reading both files with cold and hot cache:
> 
> 	time cat a > /dev/null
> 	time cat b > /dev/null
> 	time cat a > /dev/null
> 	time cat b > /dev/null
> 
> Ideally, the first 'cat a' would load the file back from disk, so it
> will take a long time, and the other three would be very fast as the
> shared extent data would already be in RAM.
> 
> That is what happens on 3.17.1:
> 
> 	time cat a > /dev/null
> 	real    0m18.870s
> 	user    0m0.017s
> 	sys     0m3.432s
> 
> 	time cat b > /dev/null
> 	real    0m16.931s
> 	user    0m0.007s
> 	sys     0m3.357s
> 
> 	time cat a > /dev/null
> 	real    0m0.141s
> 	user    0m0.001s
> 	sys     0m0.136s
> 
> 	time cat b > /dev/null
> 	real    0m0.121s
> 	user    0m0.002s
> 	sys     0m0.116s
> 
> Above we see that reading 'b' the first time takes almost as long as
> 'a'.
> The second reads are cached, so they finish two orders of magnitude
> faster.
> 
> That suggests that deduplicated extents are read and cached as
> entirely
> separate copies of the data.  The sys time for the first read of 'b'
> would imply separate decompression as well.
> 
> Compare the above result with a hardlink, which might behave more
> like
> what we expect:
> 
> 	rm -f b
> 	ln a b
> 	sync; sysctl vm.drop_caches=1
> 
> 	time cat a > /dev/null
> 	real    0m20.262s
> 	user    0m0.010s
> 	sys     0m3.376s
> 
> 	time cat b > /dev/null
> 	real    0m0.125s
> 	user    0m0.003s
> 	sys     0m0.120s
> 
> 	time cat a > /dev/null
> 	real    0m0.103s
> 	user    0m0.004s
> 	sys     0m0.097s
> 
> 	time cat b > /dev/null
> 	real    0m0.098s
> 	user    0m0.002s
> 	sys     0m0.091s
> 
> Above we clearly see that we read 'a' from disk only once, and use
> the
> cache three times.
