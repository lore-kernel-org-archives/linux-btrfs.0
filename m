Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nmsh2.e.nsc.no ([193.213.121.73]:49910 "EHLO nmsh2.e.nsc.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755724AbcIKMON (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Sep 2016 08:14:13 -0400
Subject: Re: Is stability a joke?
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org
References: <57D51BF9.2010907@online.no> <13278435.QSGp0b77ZB@merkaba>
From: Zoiled <zoiled@online.no>
Message-ID: <57D53E3A.1030106@online.no>
Date: Sun, 11 Sep 2016 13:21:30 +0200
MIME-Version: 1.0
In-Reply-To: <13278435.QSGp0b77ZB@merkaba>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin Steigerwald wrote:
> Am Sonntag, 11. September 2016, 10:55:21 CEST schrieb Waxhead:
>> I have been following BTRFS for years and have recently been starting to
>> use BTRFS more and more and as always BTRFS' stability is a hot topic.
>> Some says that BTRFS is a dead end research project while others claim
>> the opposite.
> First off: On my systems BTRFS definately runs too stable for a research
> project. Actually: I have zero issues with stability of BTRFS on *any* of my
> systems at the moment and in the last half year.
>
> The only issue I had till about half an year ago was BTRFS getting stuck at
> seeking free space on a highly fragmented RAID 1 + compress=lzo /home. This
> went away with either kernel 4.4 or 4.5.
>
> Additionally I never ever lost even a single byte of data on my own BTRFS
> filesystems. I had a checksum failure on one of the SSDs, but BTRFS RAID 1
> repaired it.
>
>
> Where do I use BTRFS?
>
> 1) On this ThinkPad T520 with two SSDs. /home and / in RAID 1, another data
> volume as single. In case you can read german, search blog.teamix.de for
> BTRFS.
>
> 2) On my music box ThinkPad T42 for /home. I did not bother to change / so far
> and may never to so for this laptop. It has a slow 2,5 inch harddisk.
>
> 3) I used it on Workstation at work as well for a data volume in RAID 1. But
> workstation is no more (not due to a filesystem failure).
>
> 4) On a server VM for /home with Maildirs and Owncloud data. /var is still on
> Ext4, but I want to migrate it as well. Whether I ever change /, I don´t know.
>
> 5) On another server VM, a backup VM which I currently use with borgbackup.
> With borgbackup I actually wouldn´t really need BTRFS, but well…
>
> 6) On *all* of my externel eSATA based backup harddisks for snapshotting older
> states of the backups.
In other words, you are one of those who claim the opposite :) I have 
also myself run btrfs for a "toy" filesystem since 2013 without any 
issues, but this is more or less irrelevant since some people have 
experienced data loss thanks to unstable features that are not clearly 
marked as such.
And making a claim that you have not lost a single byte of data does not 
make sense, how did you test this? SHA256 against a backup? :)
>> The Debian wiki for BTRFS (which is recent by the way) contains a bunch
>> of warnings and recommendations and is for me a bit better than the
>> official BTRFS wiki when it comes to how to decide what features to use.
> Nice page. I wasn´t aware of this one.
>
> If you use BTRFS with Debian, I suggest to usually use the recent backport
> kernel, currently 4.6.
>
> Hmmm, maybe I better remove that compress=lzo mount option. Never saw any
> issue with it, tough. Will research what they say about it.
My point exactly: You did not know about this and hence the risk of your 
data being gnawed on.
>> The Nouveau graphics driver have a nice feature matrix on it's webpage
>> and I think that BTRFS perhaps should consider doing something like that
>> on it's official wiki as well
> BTRFS also has a feature matrix. The links to it are in the "News" section
> however:
>
> https://btrfs.wiki.kernel.org/index.php/Changelog#By_feature
I disagree, this is not a feature / stability matrix. It is a clearly a 
changelog by kernel version.
> Thing is: This just seems to be when has a feature been implemented matrix.
> Not when it is considered to be stable. I think this could be done with colors
> or so. Like red for not supported, yellow for implemented and green for
> production ready.
Exactly, just like the Nouveau matrix. It clearly shows what you can 
expect from it.
> Another hint you can get by reading SLES 12 releasenotes. SUSE dares to
> support BTRFS since quite a while – frankly, I think for SLES 11 SP 3 this was
> premature, at least for the initial release without updates, I have a VM that
> with BTRFS I can break very easily having BTRFS say it is full, while it is
> has still 2 GB free. But well… this still seems to happen for some people
> according to the threads on BTRFS mailing list.
>
> SUSE doesn´t support all of BTRFS. They even put features they do not support
> behind a "allow_unsupported=1" module option:
>
> https://www.suse.com/releasenotes/x86_64/SUSE-SLES/12/#fate-314697
>
> But they even seem to contradict themselves by claiming they support RAID 0,
> RAID 1 and RAID10, but not RAID 5 or RAID 6, but then putting RAID behind that
> module option – or I misunderstood their RAID statement
>
> "Btrfs is supported on top of MD (multiple devices) and DM (device mapper)
> configurations. Use the YaST partitioner to achieve a proper setup.
> Multivolume Btrfs is supported in RAID0, RAID1, and RAID10 profiles in SUSE
> Linux Enterprise 12, higher RAID levels are not yet supported, but might be
> enabled with a future service pack."
>
> and they only support BTRFS on MD for RAID. They also do not support
> compression yet. They even do not support big metadata.
>
> https://www.suse.com/releasenotes/x86_64/SUSE-SLES/12/#fate-317221
>
> Interestingly enough RedHat only supports BTRFS as a technology preview, even
> with RHEL 7.
>
I would much rather prefer to rely on the btrfs wiki as the source and 
not distro's ideas about what is reliable or not. The Debian wiki is 
nice, but there should honestly not be any need for it if the btrfs wiki 
had the relevant information.
>> For example something along the lines of .... (the statuses are taken
>> our of thin air just for demonstration purposes)
> I´d say feel free to work with the feature matrix already there and fill in
> information about stability. I think it makes sense tough to discuss first on
> how to do it with still keeping it manageable.
>
> Thanks,
I am afraid the changelog is not a stability/status feature matrix as 
you yourself have mentioned, but absolutely I could have edited the wiki 
and see what happened :)

