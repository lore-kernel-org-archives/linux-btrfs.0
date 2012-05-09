From: Atila <atila.alr@dpf.gov.br>
Subject: Re: kernel 3.3.4 damages filesystem (?)
Date: Wed, 09 May 2012 15:06:47 -0300
Message-ID: <4FAAB237.3060107@dpf.gov.br>
References: <C8PBkd9uCXB@helmut.hullen.de> <pan.2012.05.09.17.32.01@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <pan.2012.05.09.17.32.01@cox.net>
List-ID: <linux-btrfs.vger.kernel.org>

I dont know if this is related or not, but I updated two different 
computers to ubuntu 12, which uses kernel 3.2, and in both I had the 
same problem: using btrfs with compress-force=lzo, after some IO stress 
the filesystem became unusable, some sort of busy.
Im using kernel 3.0 right now, with no such problem.

On 09-05-2012 14:32, Duncan wrote:
> Helmut Hullen posted on Mon, 07 May 2012 12:46:00 +0200 as excerpted:
>
>> The 3 btrfs disks are connected via a SiI 3114 SATA-PCI-Controller.
>> Only 1 of the 3 disks seems to be damaged.
> I don't plan to rehash the raid0/single discussion here, but here's some
> perhaps useful additional information on that hardware:
>
>
> For some years I've been running that same hardware, SiI 3114 SATA PCI,
> on an old dual-socket 3-digit Opteron system, running for some years now
> dual dual-core Opteron 290s (the highest they went, 2.8 GHz, 4 cores in
> two sockets).  However, I *WAS* running them in RAID-1, 4-disk md RAID-1,
> to be exact (with reiserfs, FWIW).
>
>
> What's VERY interesting is that I've just returned from being offline for
> several days due to severe disk-I/O hardware issues of my own -- again,
> on that Sil-SATA 3114.
>
> Most of the time I was getting full system crashes, but perhaps 25-33% of
> the time it didn't fully crash the system, simply error out with an
> eventual ATA reset.  When the system didn't crash immediately, most of
> the time (about 80% I'd say) the reset would be good and I'd be back up,
> but sometimes it'd repeatedly reset, occasionally not ever becoming
> usable again.
>
> As the drives are all the same quite old Seagate 300 gig drives, at about
> half their rated SMART operating hours but I think well beyond the 5 year
> warrantee, I originally thought I'd just learned my lesson on the don't
> use all the same model or you're risking them all going out at once rule,
> but I bought a new drive (half-TB seagate 2.5" drive, I've been thinking
> about going 2.5" for awhile now and this was the chance, I'll RAID it
> later with at least one more, preferably a different run at least if not
> a different model) and have been SLOWLY, PAINFULLY, RESETTINGLY copying
> stuff over from one or another of the four RAID-1 drives.
>
> The reset problem, however, hasn't gone away, tho it's rather reduced on
> the newer hardware.
>
> I also happened to have a 4-3.5-in-3-5.25-slot drive enclosure that
> seemed to be making the problem worse, as when I first tried the new 2.5
> inch retrofitted into it, the reset problem was as bad with it as with
> the old drives, but when I ran it "lose", just cabled into the mobo and
> power-supply directly, resets went down significantly but did NOT go away.
>
>
> So... I've now concluded that I need a new controller and will probably
> buy one in a day or two.
>
> Meanwhile, I THOUGHT it was "just me" with the SIL-SATA controller, until
> I happened to see the same hardware mentioned on this thread.
>
>
> Now, I'm beginning to suspect that there's some new kernel DMA or storage
> or perhaps xorg/mesa (AMD AGPGART, after all, handling the DMA using half
> the aperture. if either the graphics or storage try writing to the wrong
> half...) problem that stressed what was already aging hardware,
> triggering the problem.  It's worth noting that I tried running an older
> kernel and rebuilding (on Gentoo) most of X/mesa/anything-else-I-could-
> think-might-be-related between older versions that WERE working find
> before and newer versions, and reverting to older didn't help, so it's
> apparently NOT a direct software-only-bug.  However, what I'm wondering
> now is whether as I said, software upgrades added stress to already aging
> hardware, such that it tipped it over the edge, and by the time I tried
> reverting, I'd already had enough crashes and etc that my entire system
> was unstable, and reverting to older software didn't help because now the
> hardware was unstable as well.
>
> I'd still chalk it up to simply failing hardware, except that it's a
> rather interesting coincidence that both you and I had their SIL-SATA
> 3114s go bad at very close to the same time.
>
>
> Meanwhile, I did recently see an interesting kernel commit, either late
> 3.4-rc5+ or early 3.4-rc6+.  I don't want to try to track it down and
> lose this post to a crash on a less than stable system, but it did
> mention that AMD AGPGARTs sometimes poked holes in memory allocations and
> the commit was to try to allow for that.  I'm not sure how long the bad
> code had been in the kernel, but if it was introduced at say the 3.2 or
> 3.3 kernel, it could be that is what first started triggering the lockups
> that lead to more and more system instability, until now I've bought a
> new drive and it looks like I'm going to need to replace the onboard SIL-
> SATA.
>
> So, some questions:
>
> * Do you run OpenGL/Mesa at all on that system, possibly with an OpenGL
> compositing window manager?
>
> * If so, how new is your mesa and xorg-server, and what is your video
> card/driver?
>
> * Do you run quite new kernels, say 3.3/3.4?
>
> * What libffi and cairo? (I did notice reverting libffi seemed to lessen
> the crashing a bit, especially with firefox on my bank's SSL site, which
> was where the problem first became ugly for me as I kept crashing trying
> to get in to pay bills, etc, but I'm not positive that's related, or it
> might be that likely otherwise separate bug's crashes advanced the ATA-
> resets issue too.)
>
> * Perhaps most critically, is your system an old AMD with the AGPGART?
>
> * Also, amd64/x86_64, x86 (32), or?
>
> FWIW, amd64, KDE 4.8 here with kwin OpenGL compositing, generally leading
> edge mesa/xorg.  I run git kernels so am on pre-release 3.4 now, and was
> pre-release 3.3 before that, when the problem perhaps started.  (It
> seemed to get worse so I can't say for sure when it went from normal to
> getting gradually worse, but for sure it wasn't back in the 3.2 era as I
> was stable and happy back then.)  Radeon hd4650 card, freedomware drivers.
>
> If any of that, especially the AGPGART, sounds familiar, we may have a
> hardware-burner bug that caught us both.  If you're running a bit older
> versions of all that stuff or no compositing/opengl, and have say an
> nVidia card and no AMD AGPGART, it's probably simply coincidence.  But if
> it's not, and we can catch and get this fixed before the folks running
> older software as well upgrade and start burning their SIL-SATAs...
>
> (FWIW, I hadn't yet upgraded to btrfs at all when the trouble started
> happening here, tho I was looking at it, thus my being on the list.  I
> didn't trust the two-way-only btrfs raid1 mode on my older disks and was
> waiting on N-way raid1 mode, roadmapped for after raid-5/6 mode, which is
> now roadmapped for 3.5...  But with a new disk, eventually to add another
> for raid, I don't have that problem now, so with the upgrade I'm trying
> btrfs dual-metadata single-data on a few working partitions now, backup's
> still reiserfs, tho.)
>

