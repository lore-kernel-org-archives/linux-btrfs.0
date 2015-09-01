Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from v-27-120-84-145.ub-freebit.net ([27.120.84.145]:56631 "EHLO
	mail.reasonset.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426AbbIAKnB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Sep 2015 06:43:01 -0400
Received: from hydrangea (211-19-57-172.flets.kamome.or.jp [211.19.57.172])
	by mail.reasonset.net (Postfix) with ESMTPSA id 8EF2125108E6
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Sep 2015 19:42:58 +0900 (JST)
Date: Tue, 1 Sep 2015 19:42:57 +0900
From: MASAKI Yuhsuke <yek@reasonset.net>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs send/receive freezes a system
Message-Id: <20150901194257.f93dfa3096eb4ffdf5ffc5b1@reasonset.net>
In-Reply-To: <20150826210416.04c96b66ab9e4d0727c0ec67@reasonset.net>
References: <20150821021146.eb0d8b756fe7f3600685ee53@reasonset.net>
	<pan$cfe41$8e4e4add$ad942ea0$b8e86edd@cox.net>
	<20150826210416.04c96b66ab9e4d0727c0ec67@reasonset.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: MASAKI Yuhsuke <aki@reasonset.net>
To: MASAKI Yuhsuke <yek@reasonset.net>
Subject: Re: btrfs send/receive freezes a system
Date: Tue, 1 Sep 2015 17:41:38 +0900
Organization: HARUKA Sound
X-Mailer: Sylpheed 3.4.3 (GTK+ 2.24.28; x86_64-unknown-linux-gnu)

I report result of a trying between latest kernel.
(I'm late bacause of some difficulties no relative btrfs.)

[Result]
FAILED (same as previous try)

[Kernel]
Sender/Receiver : 4.2rc8 (Manjaro Linux)

[Network]
Generic 1000BASE-T wired network, onboard NIC with a hub.

[Command]
sudo btrfs send -v ~/share/snapshots/syncsnap-new | ssh root@daisy.local btrfs receive -v /MirrorSlave

[Passed]
Approximately sixteen hours.

[Transfared]
2.79TiB of 3.47TiB.
This is same as every trying just after created new btrfs filesystem.
(It succeeded at eighth try with nc.)

[Detail]

Sender freezed up. Didn't response.

Receiver's network and storage access light turned off.

--
Silenced after transfared 2.79TiB.

[jrh@daisy ~]$ LANG=C sudo btrfs filesystem df /MirrorSlave/
Data, single: total=2.79TiB, used=2.79TiB
System, RAID1: total=8.00MiB, used=320.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, RAID1: total=8.00GiB, used=6.03GiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=512.00MiB, used=0.00B
---
ssh process died.

[jrh@daisy ~]$ ps aux | grep ssh
root       533  0.0  0.1  40420  4152 ?        Ss   Aug31   0:00 /usr/bin/sshd -D
root      1217  0.0  0.1  99904  5268 ?        Ss   00:45   0:00 sshd: jrh [priv]
jrh       1219  0.0  0.0  99904  2956 ?        S    00:45   0:00 sshd: jrh@pts/0
root      1276 55.0  0.2 104020  9464 ?        Ss   00:47 527:21 sshd: root@notty
---
btrfs receive process lived.

[jrh@daisy ~]$ ps aux | grep btrfs
root      1077  0.0  0.0      0     0 ?        S<   Aug31   0:00 [btrfs-worker]
root      1080  0.0  0.0      0     0 ?        S<   Aug31   0:00 [btrfs-worker-hi]
root      1081  0.0  0.0      0     0 ?        S<   Aug31   0:00 [btrfs-delalloc]
root      1082  0.0  0.0      0     0 ?        S<   Aug31   0:00 [btrfs-flush_del]
root      1083  0.0  0.0      0     0 ?        S<   Aug31   0:00 [btrfs-cache]
root      1084  0.0  0.0      0     0 ?        S<   Aug31   0:00 [btrfs-submit]
root      1085  0.0  0.0      0     0 ?        S<   Aug31   0:00 [btrfs-fixup]
root      1086  0.0  0.0      0     0 ?        S<   Aug31   0:00 [btrfs-endio]
root      1087  0.0  0.0      0     0 ?        S<   Aug31   0:00 [btrfs-endio-met]
root      1088  0.0  0.0      0     0 ?        S<   Aug31   0:00 [btrfs-endio-met]
root      1089  0.0  0.0      0     0 ?        S<   Aug31   0:00 [btrfs-endio-rai]
root      1090  0.0  0.0      0     0 ?        S<   Aug31   0:00 [btrfs-endio-rep]
root      1091  0.0  0.0      0     0 ?        S<   Aug31   0:00 [btrfs-rmw]
root      1092  0.0  0.0      0     0 ?        S<   Aug31   0:00 [btrfs-endio-wri]
root      1093  0.0  0.0      0     0 ?        S<   Aug31   0:00 [btrfs-freespace]
root      1094  0.0  0.0      0     0 ?        S<   Aug31   0:00 [btrfs-delayed-m]
root      1095  0.0  0.0      0     0 ?        S<   Aug31   0:00 [btrfs-readahead]
root      1096  0.0  0.0      0     0 ?        S<   Aug31   0:00 [btrfs-qgroup-re]
root      1097  0.0  0.0      0     0 ?        S<   Aug31   0:00 [btrfs-extent-re]
root      1098  0.0  0.0      0     0 ?        S    Aug31   0:29 [btrfs-cleaner]
root      1099  0.1  0.0      0     0 ?        S    Aug31   1:53 [btrfs-transacti]
root      1282 32.1  0.0  15636  1548 ?        Ss   00:47 308:25 btrfs receive -v /MirrorSlave
jrh       1957  0.0  0.0   9008   880 pts/1    S+   16:46   0:00 grep --colour=auto btrfs
---
Sender didn't response mdns request.

[jrh@daisy ~]$ sudo ping hydrangea.local
ping: unknown host hydrangea.local
---

Shoud I report this as a bug?




> Hi Duncan, thank you for your reply.
> 
> I understood it is guessed from development between 3.10 and 4.1.
> 
> I will try to replace CentOS 7 Receiver with Manjaro (same as sender) and sync.
> I will report the result here anyway.
> If it doesn't work, I report it Kernel BTS.
> 
> 
> I searched distro for server use with later kernel.
> But I couldn't find.
> I wonder Arch Linux is better if I desire btrfs stability.
> 
> 
> After on previous post, it completed on 8th try with nc and piped btrfs receive.
> But the unstability make me nervous.
> I hope that latest kernel makes good.
> 
> 
> Thank you. 
> 
> You wrote:
> > MASAKI Yuhsuke posted on Fri, 21 Aug 2015 02:11:46 +0900 as excerpted:
> > 
> > > I want to "soft" mirroring between two remote btrfs volumes.
> > > I tried to use btrfs send/receive [but] it failed everytime.
> > > 
> > > 1st ) Pipe with SSH, to fresh filesystem. sender was flozen after
> > > transfared 2.79TiB.
> > > 2nd ) Delete snapshots and try again. sender was flozen after transfared
> > > 1.34TiB.
> > 
> > [...] 
> > 
> > > (Sender) ... Linux 4.1.5-1-MANJARO ...
> > > (Receiver) ... Linux 3.10.0-229.11.1.el7.x86_64 ...
> > 
> > On this list current kernels are strongly recommended, as btrfs remains 
> > in heavy development and is still not entirely stable yet. Now redhat 
> > (and presumably centos) does port many of the btrfs stability patches and 
> > some of the functionality back, such that the btrfs above is probably 
> > newer than the 3.10 would suggest, but there's still a rather large gap 
> > between the 4.1 on the sender side and the 3.10 on the receiver, and a 
> > lot of send/receive bugs have been found and fixed in the eleven 
> > intervening kernel cycles... about two years worth of development on a 
> > filesystem that as I said is under "heavy development"... between the two.
> > 
> > In fact, given that the "experimental" labels didn't even come off until 
> > 3.12, IIRC, a 3.10 kernel is still officially experimental btrfs where 
> > even *more* stress was placed on keeping current as stable-patch backports 
> > weren't yet routine and thus should be *WELL* out of service more than 
> > two years and eleven kernel cycles later!
> > 
> > So I'd suggest trying a relatively new kernel, closer to the 4.1 on the 
> > receiver side, on the sender side as well, at least to test if it makes a 
> > difference in your send/receive results.  If possible, I'd recommend 
> > testing with the same kernel version, perhaps the latest longterm-stable 
> > series 3.18 (with 3.18.20 now current according to kernel.org), or the 
> > latest stable 4.1, on both.  You can try syncing up userspace versions as 
> > well (4.1.2 being latest stable last I checked a week or so ago).
> > 
> > Again, for testing, at least.  That way, you eliminate version 
> > differences as a possible problem.
> > 
> > If it works then, I'd suggest filing a bug with RH/CentOS, since their 
> > supposedly stable-backported version isn't compatible with a newer 
> > version, and that'd be a bug, due either to lack of appropriate 
> > backporting or lack of keeping reasonably current versions with a still 
> > in heavy development filesystem, one of the two.
> > 
> > If it doesn't work with send/receive versions synced and either current 
> > stable 4.1 series or latest current LTS 3.18 series, then it's a more 
> > current bug and this is the right place to report it, updated with the 
> > synced-current-version test results.
> > 
> > Because I know that quite a few send/receive fixes actually did go in 
> > over the last couple years, and while your distro may well have backported 
> > them, this is the upstream list, not your distro list, and that version 
> > number still says to us that you're using a more than two years outdated 
> > kernel, where btrfs was in fact still experimental, and for all we know, 
> > it's still lacking all those send/receive patches that have been applied 
> > in the mean time, and is thus still crawling with bugs that have long 
> > been exterminated in current stable.
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
