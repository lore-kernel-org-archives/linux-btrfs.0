Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34856 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbbJRJoO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 18 Oct 2015 05:44:14 -0400
Received: by wicll6 with SMTP id ll6so59238846wic.0
        for <linux-btrfs@vger.kernel.org>; Sun, 18 Oct 2015 02:44:12 -0700 (PDT)
Received: from [127.0.0.1] (77-173-215-182.ip.telfort.nl. [77.173.215.182])
        by smtp.googlemail.com with ESMTPSA id p7sm33121452wjf.26.2015.10.18.02.44.09
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 18 Oct 2015 02:44:11 -0700 (PDT)
Message-ID: <562369E8.60709@gmail.com>
Date: Sun, 18 Oct 2015 11:44:08 +0200
From: Dmitry Katsubo <dmitry.katsubo@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Recover btrfs volume which can only be mounded in read-only mode
References: <CAOGcOQE3_ROtk=2kQkjTUkGE1tz=HEzbeZnrWUOPziW=kNNXBQ@mail.gmail.com> <561E6969.40500@oracle.com> <561EBAB1.6030600@gmail.com> <pan$21730$7c1e6fa7$932b1831$daf2c6bb@cox.net> <CAOGcOQGnHaZeiyuqm+rSX=MBNSFnE-JwSmnhTWZVU42FnSgXmA@mail.gmail.com> <pan$e78b7$efe06fb0$f477bf4e$85f224c0@cox.net>
In-Reply-To: <pan$e78b7$efe06fb0$f477bf4e$85f224c0@cox.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 16/10/2015 10:18, Duncan wrote:
> Dmitry Katsubo posted on Thu, 15 Oct 2015 16:10:13 +0200 as excerpted:
> 
>> On 15 October 2015 at 02:48, Duncan <1i5t5.duncan@cox.net> wrote:
>>
>>> [snipped] 
>>
>> Thanks for this information. As far as I can see, btrfs-tools v4.1.2 in
>> now in experimental Debian repo (but you anyway suggest at least 4.2.2,
>> which is just 10 days ago released in master git). Kernel image 3.18 is
>> still not there, perhaps because Debian jessie was frozen before is was
>> released (2014-12-07).
> 
> For userspace, as long as it's supporting the features you need at 
> runtime (where it generally simply has to know how to make the call to 
> the kernel, to do the actual work), and you're not running into anything 
> really hairy that you're trying to offline-recover, which is where the 
> latest userspace code becomes critical...
> 
> Running a userspace series behind, or even more (as long as it's not 
> /too/ far), isn't all /that/ critical a problem.
> 
> It generally becomes a problem in one of three ways: 1) You have a bad 
> filesystem and want the best chance at fixing it, in which case you 
> really want the latest code, including the absolute latest fixups for the 
> most recently discovered possible problems. 2) You want/need a new 
> feature that's simply not supported in your old userspace.  3) The 
> userspace gets so old that the output from its diagnostics commands no 
> longer easily compares with that of current tools, giving people on-list 
> difficulties when trying to compare the output in your posts to the 
> output they get.
> 
> As a very general rule, at least try to keep the userspace version 
> comparable to the kernel version you are running.  Since the userspace 
> version numbering syncs to kernelspace version numbering, and userspace 
> of a particular version is normally released shortly after the similarly 
> numbered kernel series is released, with a couple minor updates before 
> the next kernel-series-synced release, keeping userspace to at least the 
> kernel space version, means you're at least running the userspace release 
> that was made with that kernel series release in mind.
> 
> Then, as long as you don't get too far behind on kernel version, you 
> should remain at least /somewhat/ current on userspace as well, since 
> you'll be upgrading to near the same userspace (at least), when you 
> upgrade the kernel.
> 
> Using that loose guideline, since you're aiming for the 3.18 stable 
> kernel, you should be running at least a 3.18 btrfs-progs as well.
> 
> In that context, btrfs-progs 4.1.2 should be fine, as long as you're not 
> trying to fix any problems that a newer version fixed.  And, my 
> recommendation of the latest 4.2.2 was in the "fixing problems" context, 
> in which case, yes, getting your hands on 4.2.2, even if it means 
> building from sources to do so, could be critical, depending of course on 
> the problem you're trying to fix.  But otherwise, 4.1.2, or even back to 
> the last 3.18.whatever release since that's the kernel version you're 
> targeting, should be fine.
> 
> Just be sure that whenever you do upgrade to later, you avoid the known-
> bad-mkfs.btrfs in 4.2.0 and/or 4.2.1 -- be sure if you're doing the btrfs-
> progs-4.2 series, that you get 4.2.2 or later.
> 
> As for finding a current 3.18 series kernel released for Debian, I'm not 
> a Debian user so my my knowledge of the ecosystem around it is limited, 
> but I've been very much under the impression that there are various 
> optional repos available that you can choose to include and update from 
> as well, and I'm quite sure based on previous discussions with others 
> that there's a well recognized and fairly commonly enabled repo that 
> includes debian kernel updates thru current release, or close to it.
> 
> Of course you could also simply run a mainstream Linus kernel and build 
> it yourself, and it's not too horribly hard to do either, as there's all 
> sorts of places with instructions for doing so out there, and back when I 
> switched from MS to freedomware Linux in late 2001, I learned the skill, 
> at at least the reasonably basic level of mostly taking a working config 
> from my distro's kernel and using it as a basis for my mainstream kernel 
> config as well, within about two months of switching.
> 
> Tho of course just because you can doesn't mean you want to, and for 
> many, finding their distro's experimental/current kernel repos and simply 
> installing the packages from it, will be far simpler.
> 
> But regardless of the method used, finding or building and keeping 
> current with your own copy of at least the lastest couple of LTS 
> releases, shouldn't be /horribly/ difficult.  While I've not used them as 
> actual package resources in years, I do still know a couple rpm-based 
> package resources from my time back on Mandrake (and do still check them 
> in contexts like this for others, or to quickly see what files a package 
> I don't have installed on gentoo might include, etc), and would point you 
> at them if Debian was an rpm-based distro, but of course it's not, so 
> they won't do any good.  But I'd guess a google might. =:^)

Thanks, Duncan. The information you give is of the greatest value for
me. Finally I have decided not to play with the fate and copy the data
off, re-create btrfs and copy it back. That is anyway a good exercise.

>> If I may ask:
>>
>> Provided that btrfs allowed to mount a volume in read-only mode – does
>> it mean that add data blocks are present (e.g. it has assured that add
>> files / directories can be read)
> 
> I'm not /absolutely/ sure I understand your question, here.  But assuming 
> it's what I believe it is... here's an answer in typical Duncan fashion, 
> answering the question... and rather more! =:^)
> 
> In this particular scenario, yes, everything should still be accessible, 
> as at least one copy of every raid1 chunk should exist on a still 
> detected and included device.  This is because of the balance after the 
> loss of the first device, making sure there was two copies of each chunk 
> on remaining devices, before loss of the second device.  But because 
> btrfs device delete missing didn't work, you couldn't remove that first 
> device, even tho you now had two copies of each chunk on existing 
> devices.  So when another device dropped, you had two missing devices, 
> but because of the balance between, you still had at least one copy of 
> all chunks.
> 
> The reason it's not letting you mount read-write is that btrfs sees now 
> two devices missing on a raid1, the one that you actually replaced but 
> couldn't device delete, and the new missing one that it didn't detect 
> this time.  To btrfs' rather simple way of thinking about it, that means 
> anything with one of the only two raid1 copies on each of the two missing 
> devices is now entirely gone, and to avoid making changes that would 
> complicate things and prevent return of at least one of those missing 
> devices, it won't let you mount writable, even in degraded mode.  It 
> doesn't understand that there's actually still at least one copy of 
> everything available, as it simply sees the two missing devices and gives 
> up without actually checking.
> 
> And in the situation where btrfs' fears were correct, where chunks 
> existed with each of the two copies on one of the now missing devices, 
> no, not everything /would/ be accessible, and btrfs forcing read-only 
> mounting is its way of not letting you make the problem even worse, 
> forcing you to copy the data you can actually get to off to somewhere 
> else, while you can still get to it in read-only mode, at least.  Also, 
> of course, forcing the filesystem read-only when there's two devices 
> missing, at least in theory preserves a state where a device might be 
> able to return, allowing repair of the filesystem, while allowing 
> writable could prevent a returning device allowing the healing of the 
> filesystem.
> 
> So in this particular scenario, yes, all your data should be there, 
> intact.  However, a forced read-only mount normally indicates a serious 
> issue, and in other scenarios, it could well indicate that some of the 
> data is now indeed *NOT* accessible.
> 
> Which is where AJ's patch comes in.  That teaches btrfs to actually check 
> each chunk.  Once it sees that there's actually at least one copy of each 
> chunk available, it'll allow mounting degraded, writable, again, so you 
> can fix the problem.
> 
> (Tho the more direct scenario that the patch addresses is a bit 
> different, loss of one device of a two-device raid1, in which case 
> mounting degraded writable will force new chunks to be written in single 
> mode, because there's not a second device to write to so writing raid1 is 
> no longer possible.  So far, so good.  But then on an unmount and attempt 
> to mount again, btrfs sees single mode chunks on a two-device btrfs, and 
> knows that single mode normally won't allow a missing device, so forces 
> read-only, thus blocking adding a new device and rebalancing all the 
> single chunks back to raid1.  But in actuality, the only single mode 
> chunks there are the ones written when the second device wasn't 
> available, so they HAD to be written to the available device, and it's 
> not POSSIBLE for any to be on the missing device.  Again, the patch 
> teaches btrfs to actually look at what's there and see that it can 
> actually deal with it, thus allowing writable mounting, instead of 
> jumping to conclusions and giving up, as soon as it sees a situation 
> that /could/, in a different situation, mean entirely missing chunks with 
> no available copies on remaining devices.)
> 
> Again, these patches are in newer kernel versions, so there (assuming no 
> further bugs) they "just work".  On older kernels, however, you either 
> have to cherry-pick the patches yourself, or manually avoid or work 
> around the problem they fix.  This is why we typically stress new 
> versions so much -- they really /do/ fix active bugs and make problems 
> /much/ easier to deal with. =:^)

Thanks for explanation. You understood the question correctly, basically
I wondered if btrfs checks that all data can be read before allowing
read-only mount. In my case I was luck and I just copied the date from
mounted volume to another place and then copied it back.

>> Do you have any ideas why "btrfs balance" has pulled all data to two
>> drives (and not balanced between three)?
> 
> Hugo did much better answering that, than I would have initially done, as 
> most of my btrfs are raid1 here, but they're all exactly two-device, with 
> the two devices exactly the same size, so I'm not used to thinking in 
> terms of different sizes and didn't actually notice the situation, thus 
> leaving me clueless, until Hugo pointed it out.
> 
> But he's right.  Here's my much more detailed way of saying the same 
> thing, now that he reminded me of why that would be the deciding factor 
> here.
> 
> Given that (1) your devices are different sizes, that (2) btrfs raid1 
> means exactly two copies, not one per device, and that (3), the btrfs 
> chunk-allocator allocates chunks from the device with the most free space 
> left, subject to the restriction that both copies of a raid1 chunk can't 
> be allocated to the same device...
> 
> A rebalance of raid1 chunks would indeed start filling the two biggest 
> devices first, until the space available on the smallest of the two 
> biggest devices (thus the second largest) was equal to the space 
> available on the third largest device, at which point it would continue 
> allocating from the largest for one copy (until it too reached equivalent 
> space available), while alternating between the others for the second 
> copy.
> 
> Given that the amount of data you had fit a copy each on the two largest 
> devices, before the space available on either one dwindled to that 
> available on the third largest device, only the two largest devices 
> actually had chunk allocations, leaving the third device, still with less 
> space total than the other two each had remaining available, entirely 
> empty.

I think the mentioned strategy (fill in the device with most free space)
is not most effective. If the data is spread equally, the read
performance would be higher (reading from 3 disks instead of 2). In my
case this is even crucial, because the smallest drive is SSD (and it is
not loaded at all).

Maybe I don't see the benefit from the strategy which is currently
implemented (besides that it is robust and well-tested)?

>> Does btrfs has the following optimization for mirrored data: if drive is
>> non-rotational, then prefer reads from it? Or it simply schedules the
>> read to the drive that performs faster (irrelative to rotational
>> status)?
> 
> Such optimizations have in general not yet been done to btrfs -- not even 
> scheduling to the faster drive.  In fact, the lack of such optimizations 
> is arguably the biggest "objective" proof that btrfs devs themselves 
> don't yet consider btrfs truly stable.
> 
> As any good dev knows there's a real danger to "premature optimization", 
> with that danger appearing in one or both of two forms: (a) We've now 
> severely limited the alternative code paths we can take, because 
> implementing things differently will force throwing away all that 
> optimization work we did as it won't work with what would otherwise be 
> the better alternative, and (b) We're now throwing away all that 
> optimization work we did, making it a waste, because the previous 
> implementation didn't work, and the new one does, but doesn't work with 
> the current optimization code, so that work must now be redone as well.
> 
> Thus, good devs tend to leave moderate to complex optimization code until 
> they know the implementation is stable and won't be changing out from 
> under the optimization.  To do differently is "premature optimization", 
> and devs tend to be well aware of the problem, often because of the 
> number of times they did it themselves earlier in their career.
> 
> It follows that looking at whether devs (assuming you consider them good 
> enough to be aware of the dangers of premature optimization, which if 
> they're doing the code that runs your filesystem, you better HOPE they're 
> at least that good, or you and your data are in serious trouble!) have 
> actually /done/ that sort of optimization, ends up being a pretty good 
> indicator of whether they consider the code actually stable enough to 
> avoid the dangers of premature optimization, or not.
> 
> In this case, definitely not, since these sorts of optimizations in 
> general remain to be done.
> 
> Meanwhile, the present btrfs raid1 read-scheduler is both pretty simple 
> to code up and pretty simple to arrange tests for that run either one 
> side or the other, but not both, or that are well balanced to both.  
> However, it's pretty poor in terms of ensuring optimized real-world 
> deployment read-scheduling.
> 
> What it does is simply this.  Remember, btrfs raid1 is specifically two 
> copies.  It chooses which copy of the two will be read very simply, based 
> on the PID making the request.  Odd PIDs get assigned one copy, even PIDs 
> the other.  As I said, simple to code, great for ensuring testing of one 
> copy or the other or both, but not really optimized at all for real-world 
> usage.
> 
> If your workload happens to be a bunch of all odd or all even PIDs, well, 
> enjoy your testing-grade read-scheduler, bottlenecking everything reading 
> one copy, while the other sits entirely idle.
> 
> (Of course on fast SSDs with their zero seek-time, which is what I'm 
> using for my own btrfs, that's not the issue it'd be on spinning rust.  
> I'm still using my former reiserfs standard for spinning rust, which I 
> use for backup and media files.  But normal operations are on btrfs on 
> ssd, and despite btrfs lack of optimization, on ssd, it's fast /enough/ 
> for my usage, and I particularly like the data integrity features of 
> btrfs raid1 mode, so...)

I think PID-based solution is not the best one. Why not simply take a
random device? Then at least all drives in the volume are equally loaded
(in average).

>From what you said I believe that certain servers will not benefit from
btrfs, e.g. dedicated server that runs only one "fat" Java process, or
one "huge" MySQL database.

In general I think that btrfs should not check for rotational flag, as
even SATA-III is two times faster than SATA-II. So ideal scheduler
should assign read requests to the drive that simply copes with reads
faster :) If SSD drive can read 10 blocks while normal HDD reads only
one during the same time - let it do it.

Maybe my case is a corner one, as I am mixing "fast" and "slow" drives
in one volume, more over, faster drive is the smallest. If I would have
the drives of the same performance - the strategy I suggest would not
matter.

>> No, it was particular my decision to use btrfs on various reasons.
>> First of all, I am using raid1 on all data. Second, I benefit from
>> transparent compression. Third I need CRC consistency: some of the
>> drives (like /dev/sdd in my case) seem to fail, also once I have a buggy
>> DIMM so btrfs helps me not to loose the data "silently". Anyway,
>> it much better then md-raid.
> 
> The fact that despite it being available, mdraid couldn't be configured 
> to runtime-verify integrity using either parity or redundancy, nor 
> checksums (which weren't available) was a very strong disappointment for 
> me.
> 
> To me, the fact that btrfs /does/ do runtime checksumming on write and 
> data integrity checking on read, and in raid1/10 mode, will actually 
> fallback to the second copy if the first one fails checksum verification, 
> is one of its best features, and why I use btrfs raid1 (or on a couple 
> single-device btrfs, mixed-bg mode dup). =:^)
> 
> That's also why my personally most hotly anticipated features is N-way-
> mirroring, with 3-way being my ideal balance, since that will give me a 
> fallback to the fallback, if both the first read copy and the first 
> fallback copy fail verification.  Four-way would be too much, but I just 
> don't quite rest as easy as I otherwise could, because I know that if 
> both the primary-read copy and the fallback happen to be bad, same 
> logical place at the same time, there's no third copy to fall back on!  
> It seems as much of a shame not to have that on btrfs with its data 
> integrity, as it did to have mdraid with N-way-mirroring but no runtime 
> data integrity.  But at least btrfs does have N-way-mirroring on the 
> roadmap, actually for after raid56, which is now done, so N-way-mirroring 
> should be coming up rather soon (even if on btrfs, "soon" is relative), 
> while AFAIK, mdraid has no plans to implement runtime data integrity 
> checking.
> 
>> And dynamic assignment is not a problem since udev was introduced (so
>> one can add extra persistent symlinks):
>>
>> https://wiki.debian.org/Persistent_disk_names
> 
> FWIW, I actually use labels as my own form of "human-readable" UUID, 
> here.  I came up with the scheme back when I was on reiserfs, with 15-
> character label limits, so that's what mine are.  Using this scheme, I 
> encode the purpose of the filesystem (root/home/media/whatever), the size 
> and brand of the media, the sequence number of the media (since I often 
> have more than one of the same brand and size), the machine the media is 
> targeted at, the date I did the formatting, and the sequence-number of 
> the partition (root-working, root-backup1, root-backup2, etc).
> 
> hm0238gcnx+35l0
> 
> home, on a 238 gig corsair neutron, #x (the filesystem is multidevice, 
> across #0 and #1), targeted at + (the workstation), originally 
> partitioned in (201)3, on May (5) 21 (l), working copy (0)
> 
> I use GPT partitioning, which takes partition labels (aka names) as 
> well.  The two partitions hosting that filesystem are on identically 
> partitioned corsair neutrons, 256 GB = 238 GiB.  The gpt labels on those 
> two partitions are identical to the above, except one will have a 0 
> replacing the x, while the other has a 1, as they are my first and second 
> media of that size and brand.
> 
> hm0238gcn0+35l0
> hm0238gcn1+35l0
> 
> The primary backup of home, on a different pair of partitions on the same 
> physical devices, is labeled identically, except the partition number is 
> one:
> 
> hm0238gcnx+35l1
> 
> ... and its partitions:
> 
> hm0238gcn0+35l1
> hm0238gcn1+35l1
> 
> The secondary backup is on a reiserfs, on spinning rust:
> 
> hm0465gsg0+47f0
> 
> In that case the partition label and filesystem label are the same, since 
> the partition and its filesystem correspond 1:1.  It's home on the 465 
> GiB (aka 500 GB) seagate #0, targeted at the workstation, first formatted 
> in (201)4, on July 15, first (0) copy there.  (I could make it #3 instead 
> of #0, indicating second backup, but didn't, as I know that 0465gsg0+ is 
> the media and backups spinning rust device for the workstation.)
> 
> Both my internal and USB attached devices have the same labeling scheme, 
> media identified by size, brand, media sequence number and what it's 
> targetting, partition/filesystem identified by purpose, original 
> partition/format date, and partition sequence number.
> 
> As I said, it's effectively human-readable GUID, my own scheme for my own 
> devices.
> 
> And I use LABEL= in fstab as well, running gdisk -l to get a listing of 
> partitions with their gpt-labels when I need to associate actual sdN 
> mapping to specific partitions (if I don't already have the mapping from 
> mount or whatever).
> 
> Which makes it nice when btrfs fi show outputs filesystem label as well. 
> =:^)
> 
> The actual GUID is simply machine-readable but not necessary for the 
> human to deal with "noise", to me, as the label (of either the gpt 
> partition or the filesystem it hosts) gives me *FAR* more and more useful 
> information, while being entirely unique within my ID system.
> 
>> If "btrfs device scan" is user-space, then I think doing some output is
>> better then outputting nothing :) (perhaps with "-v" flag). If it is
>> kernel-space, then I agree that logging to dmesg is not very evident
>> (from perspective that user should remember where to look),
>> but I think has a value.
> 
> Well, btrfs is a userspace tool, but in this case, btrfs device scan's 
> use is purely to make a particular kernel call, which triggers the btrfs 
> module to do a device rescan to update its own records, *not* for human 
> consumption.  -v to force output could work if it had been designed that 
> way, but getting that output is precisely what btrfs filesystem show is 
> for, printing for both mounted and unmounted filesystems unless told 
> otherwise.
> 
> Put it this way.  If neither your initr* nor some service started before 
> whatever mounts local filesystems doesn't do a btrfs device scan, then 
> attempting to mount a multi-device btrfs will fail, unless all its 
> component devices have been fed in using device= options.  Why?  Because 
> mount takes exactly one device to mount.  With traditional filesystems, 
> that's enough, since they only consist of a single device.  And with 
> single-device btrfs, it's enough as well.  But with a multi-device btrfs, 
> something has to supply the other devices to btrfs, along with the one 
> that mount tells it about.  It is possible to list all those component 
> devices in device= options, but those take /dev/sd* style device nodes, 
> and those may change from boot to boot, so that's not very reliable.  
> Which is where btrfs device scan comes in.  It tells the btrfs module to 
> do a general scan and map out internally which devices belong to which 
> filesystems, after which a mount supplying just one of them can work, 
> since this internal map, the generation or refresh of which is triggered 
> by btrfs device scan, supplies the others.
> 
> IOW, btrfs device scan needs no output, because all the userspace command 
> does is call a kernel function, which triggers the mapping internal to 
> the btrfs kernel module, so it can then handle mounts with just one of 
> the possibly many devices handed to it from mount.
> 
> Outputting that mapping is an entirely different function, with the 
> userspace side of that being btrfs filesystem show, which calls a kernel 
> function that generates output back to the btrfs userspace app, which 
> then further formats it for output back to the user.

I understand that. If btrfs can show the mapping for *unmounted* volume
(e.g. "btrfs fi show /dev/sdb") that would be great. Also I think that
btrfs kernel-space can be smart enough and perform a scan, if mount was
attempted without a prio scan. So one should be able to mount (provided
that all devices are present) without a hassle.

>> Thanks. I have carefully read changelog wiki page and found that:
>>
>> btrfs-progs 4.2.2:
>> scrub: report status 'running' until all devices are finished
> 
> Thanks.  As I said, I had seen the patch on the list, and /thought/ it 
> was now in, but had lost track of specifically when it went in, or 
> indeed, /whether/ it had gone in.
> 
> Now I know it's in 4.2.2, without having to actually go look it up in the 
> git log again, myself.
> 
>> Idea concerning balance is listed on wiki page "Project ideas":
>>
>> balance: allow to run it in background (fork) and report status
>> periodically
> 
> FWIW, it sort of does that today, except that the btrfs bal start doesn't 
> actually return to the command prompt.  But again, what it actually does 
> is call a kernel function to initiate the balance, and then it's simply 
> waiting.  On my relatively small btrfs on partitioned ssd, the return is 
> often within a minute or two anyway, but on multi-TB spinning rust...
> 
> In any case, once the kernel function has triggered the balance, ctrl-C 
> should I believe terminate the userspace side and get you back to the 
> prompt, without terminating the balance as that continues on in kernel 
> space.
> 
> But it would still be useful to have balance start actually return 
> quickly, instead of having to ctrl-C it.

Thanks for expression your thoughts. I will keep my eye on new features
development.

-- 
With best regards,
Dmitry
