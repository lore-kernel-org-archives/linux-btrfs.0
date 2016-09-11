Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nmsh3.e.nsc.no ([193.213.121.74]:33078 "EHLO nmsh3.e.nsc.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755728AbcIKMaz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Sep 2016 08:30:55 -0400
Subject: Re: Is stability a joke?
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org
References: <57D51BF9.2010907@online.no> <13278435.QSGp0b77ZB@merkaba>
 <57D53E3A.1030106@online.no> <15194548.valIGHoaRh@merkaba>
From: Waxhead <waxhead@online.no>
Message-ID: <57D54E7B.5040202@online.no>
Date: Sun, 11 Sep 2016 14:30:51 +0200
MIME-Version: 1.0
In-Reply-To: <15194548.valIGHoaRh@merkaba>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin Steigerwald wrote:
> Am Sonntag, 11. September 2016, 13:21:30 CEST schrieb Zoiled:
>> Martin Steigerwald wrote:
>>> Am Sonntag, 11. September 2016, 10:55:21 CEST schrieb Waxhead:
>>>> I have been following BTRFS for years and have recently been starting to
>>>> use BTRFS more and more and as always BTRFS' stability is a hot topic.
>>>> Some says that BTRFS is a dead end research project while others claim
>>>> the opposite.
>>> First off: On my systems BTRFS definately runs too stable for a research
>>> project. Actually: I have zero issues with stability of BTRFS on *any* of
>>> my systems at the moment and in the last half year.
>>>
>>> The only issue I had till about half an year ago was BTRFS getting stuck
>>> at
>>> seeking free space on a highly fragmented RAID 1 + compress=lzo /home.
>>> This
>>> went away with either kernel 4.4 or 4.5.
>>>
>>> Additionally I never ever lost even a single byte of data on my own BTRFS
>>> filesystems. I had a checksum failure on one of the SSDs, but BTRFS RAID 1
>>> repaired it.
>>>
>>>
>>> Where do I use BTRFS?
>>>
>>> 1) On this ThinkPad T520 with two SSDs. /home and / in RAID 1, another
>>> data
>>> volume as single. In case you can read german, search blog.teamix.de for
>>> BTRFS.
>>>
>>> 2) On my music box ThinkPad T42 for /home. I did not bother to change / so
>>> far and may never to so for this laptop. It has a slow 2,5 inch harddisk.
>>>
>>> 3) I used it on Workstation at work as well for a data volume in RAID 1.
>>> But workstation is no more (not due to a filesystem failure).
>>>
>>> 4) On a server VM for /home with Maildirs and Owncloud data. /var is still
>>> on Ext4, but I want to migrate it as well. Whether I ever change /, I
>>> don´t know.
>>>
>>> 5) On another server VM, a backup VM which I currently use with
>>> borgbackup.
>>> With borgbackup I actually wouldn´t really need BTRFS, but well…
>>>
>>> 6) On *all* of my externel eSATA based backup harddisks for snapshotting
>>> older states of the backups.
>> In other words, you are one of those who claim the opposite :) I have
>> also myself run btrfs for a "toy" filesystem since 2013 without any
>> issues, but this is more or less irrelevant since some people have
>> experienced data loss thanks to unstable features that are not clearly
>> marked as such.
>> And making a claim that you have not lost a single byte of data does not
>> make sense, how did you test this? SHA256 against a backup? :)
> Do you have any proof like that with *any* other filesystem on Linux?
>
> No, my claim is a bit weaker: BTRFS own scrubbing feature and well no I/O
> errors on rsyncing my data over to the backup drive - BTRFS checks checksum on
> read as well –, and yes I know BTRFS uses a weaker hashing algorithm, I think
> crc32c. Yet this is still more than what I can say about *any* other
> filesystem I used so far. Up to my current knowledge neither XFS nor Ext4/3
> provide data checksumming. They do have metadata checksumming and I found
> contradicting information on whether XFS may support data checksumming in the
> future, but up to now, no *proof* *whatsoever* from side of the filesystem
> that the data is, what it was when I saved it initially. There may be bit
> errors rotting on any of your Ext4 and XFS filesystem without you even
> noticing for *years*. I think thats still unlikely, but it can happen, I have
> seen this years ago after restoring a backup with bit errors from a hardware
> RAID controller.
>
> Of course, I rely on the checksumming feature within BTRFS – which may have
> errors. But even that is more than with any other filesystem I had before.
>
> And I do not scrub daily, especially not the backup disks, but for any scrubs
> up to now, no issues. So, granted, my claim has been a bit bold. Right now I
> have no up-to-this-day scrubs so all I can say is that I am not aware of any
> data losses up to the point in time where I last scrubbed my devices. Just
> redoing the scrubbing now on my laptop.
The way I see it BTRFS is the best filesystem we got so far. It is also 
the first (to my knowledge) that provides checksums of both data and 
metadata. My point was simply that such an extraordinary claim require 
some evidence. I am not saying it is unlikely that you have never lost a 
byte, I am just saying that it is a fantastic thing to claim.
>>>> The Debian wiki for BTRFS (which is recent by the way) contains a bunch
>>>> of warnings and recommendations and is for me a bit better than the
>>>> official BTRFS wiki when it comes to how to decide what features to use.
>>> Nice page. I wasn´t aware of this one.
>>>
>>> If you use BTRFS with Debian, I suggest to usually use the recent backport
>>> kernel, currently 4.6.
>>>
>>> Hmmm, maybe I better remove that compress=lzo mount option. Never saw any
>>> issue with it, tough. Will research what they say about it.
>> My point exactly: You did not know about this and hence the risk of your
>> data being gnawed on.
> Well I do follow BTRFS mailinglist to some extent and I recommend anyone who
> uses BTRFS in production to do this. And: So far I see no data loss from using
> that option and for me personally it is exactly that what counts. J
>
> Still: An information on what features are stable with what version of kernel
> and btrfs-progrs is important. I totally agree with that and there is not the
> slighted need to discuss about it.
>
> But also just saying: I wasn´t aware is no excuse either. BTRFS is not
> officially declared fully production ready. Just read this:
>
> https://btrfs.wiki.kernel.org/index.php/Main_Page#Stability_status
>
> It just talks about the disk format being stable and a bit cowardly avoids any
> statement regarding production stability. If I´d read this, I´d think: Okay, I
> may use this, but I better check back more closely and be prepared to upgrade
> kernels and read BTRFS mailinglist.
>
> That said, the statement avoids clarity to some extent and I think it would be
> better for formulate it in a clearer way.
>
Regarding the stability status it can give a false impression that if 
for example if feature XYZ was introduced 5-6 kernel releases back it is 
stable and good to go which may or may not be the case. Yes it indicates 
that btrfs is stabilizing , but as you said it is not very precise.
>>>> The Nouveau graphics driver have a nice feature matrix on it's webpage
>>>> and I think that BTRFS perhaps should consider doing something like that
>>>> on it's official wiki as well
>>> BTRFS also has a feature matrix. The links to it are in the "News" section
>>> however:
>>>
>>> https://btrfs.wiki.kernel.org/index.php/Changelog#By_feature
>> I disagree, this is not a feature / stability matrix. It is a clearly a
>> changelog by kernel version.
> It is a *feature* matrix. I fully said its not about stability, but about
> implementation – I just wrote this a sentence after this one. There is no need
> whatsoever to further discuss this as I never claimed that it is a feature /
> stability matrix in the first place.
Ok I was a bit unclear... it is a feature matrix , but not a feature + 
stability matrix.
My mistake - sorry about that.
>>> Thing is: This just seems to be when has a feature been implemented
>>> matrix.
>>> Not when it is considered to be stable. I think this could be done with
>>> colors or so. Like red for not supported, yellow for implemented and
>>> green for production ready.
>> Exactly, just like the Nouveau matrix. It clearly shows what you can
>> expect from it.
>>
>>> Another hint you can get by reading SLES 12 releasenotes. SUSE dares to
>>> support BTRFS since quite a while – frankly, I think for SLES 11 SP 3 this
>>> was premature, at least for the initial release without updates, I have a
>>> VM that with BTRFS I can break very easily having BTRFS say it is full,
>>> while it is has still 2 GB free. But well… this still seems to happen for
>>> some people according to the threads on BTRFS mailing list.
>>>
>>> SUSE doesn´t support all of BTRFS. They even put features they do not
>>> support behind a "allow_unsupported=1" module option:
>>>
>>> https://www.suse.com/releasenotes/x86_64/SUSE-SLES/12/#fate-314697
>>>
>>> But they even seem to contradict themselves by claiming they support RAID
>>> 0, RAID 1 and RAID10, but not RAID 5 or RAID 6, but then putting RAID
>>> behind that module option – or I misunderstood their RAID statement
>>>
>>> "Btrfs is supported on top of MD (multiple devices) and DM (device mapper)
>>> configurations. Use the YaST partitioner to achieve a proper setup.
>>> Multivolume Btrfs is supported in RAID0, RAID1, and RAID10 profiles in
>>> SUSE
>>> Linux Enterprise 12, higher RAID levels are not yet supported, but might
>>> be
>>> enabled with a future service pack."
>>>
>>> and they only support BTRFS on MD for RAID. They also do not support
>>> compression yet. They even do not support big metadata.
>>>
>>> https://www.suse.com/releasenotes/x86_64/SUSE-SLES/12/#fate-317221
>>>
>>> Interestingly enough RedHat only supports BTRFS as a technology preview,
>>> even with RHEL 7.
>> I would much rather prefer to rely on the btrfs wiki as the source and
>> not distro's ideas about what is reliable or not. The Debian wiki is
>> nice, but there should honestly not be any need for it if the btrfs wiki
>> had the relevant information.
> See, this is what you prefer. And then there is reality.
>
> It seems reality doesn´t match what you prefer. You can now spend time
> complaining about this, or… offer your help to improve the situation.
I do not intend to be hostile. This depends on how you view the my mail 
and how you interpret my response.
Regardless if you consider my mail to be a complaint or not the 
intention is to of course improve the situation and my posting to the 
mailing list I hope to do exactly that.
>
> If you choose the complaining path, I am out, and rather spend my time
> enjoying to use BTRFS as I do. Maybe reviewing that compress=lzo thing.
>
> As I first read your subject "Is stability a joke?" I wondered whether to even
> answer this. Fortunately your post has been a bit more than this complaint.
The subject was chosen for the following reason:
I like BTRFS and think the filesystem is fantastic. Many of the issues 
people run into are on older kernels, and the BTRFS wiki is not very 
clear on the stability stuff. Ergo should not the stability of the 
filesystem be taken a bit more seriously from a documentation point of view?
> And trust me, I have been there. I complained myself about stability here. And
> I found that it didn´t help my cause very much.
>
>>>> For example something along the lines of .... (the statuses are taken
>>>> our of thin air just for demonstration purposes)
>>> I´d say feel free to work with the feature matrix already there and fill
>>> in
>>> information about stability. I think it makes sense tough to discuss first
>>> on how to do it with still keeping it manageable.
>> I am afraid the changelog is not a stability/status feature matrix as
>> you yourself have mentioned, but absolutely I could have edited the wiki
>> and see what happened :)
> I think what would be a good next step would be to ask developers / users
> about feature stability and then update the wiki. If thats important to you, I
> suggest you invest some energy in doing that. And ask for help. This
> mailinglist is a good idea.
>
> I already gave you my idea on what works for me.
>
> There is just one thing I won´t go further even a single step: The complaining
> path. As it leads to no desirable outcome.
>
> Thanks,
My intention was not to be hostile and if my response sound a bit harsh 
for you then by all means I do apologize for that.
I pointed out what I felt needed improvements and I did also supply a 
example of how to improve it. I am sorry, but I do not myself see any 
part of my mail that come off as complaining. It may have been 
unnecessary for me to point out your "did not loose a single byte" claim 
as this was obviously more a figure of speech and if this felt a bit 
hostile , I'm sorry about that. I hope that I with this this cleared up 
any potential confusion. Have a still nice day Sir :)

