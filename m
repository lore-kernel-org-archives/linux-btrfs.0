Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns211617.ip-188-165-215.eu ([188.165.215.42]:33617 "EHLO
	mx.speed47.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752145AbbIPUlQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Sep 2015 16:41:16 -0400
Received: from rc.speed47.net (nginx [192.168.80.2])
	by box.speed47.net (Postfix) with ESMTP id 20B96855
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2015 22:41:13 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Wed, 16 Sep 2015 22:41:13 +0200
From: =?UTF-8?Q?St=C3=A9phane_Lesimple?= <stephane_btrfs@lesimple.fr>
To: linux-btrfs@vger.kernel.org
Subject: Re: kernel BUG at linux-4.2.0/fs/btrfs/extent-tree.c:1833 on
 rebalance
In-Reply-To: <pan$5599c$cb01bfb8$910004c8$d38ea6b6@cox.net>
References: <9c864637fe7676a8b7badc5ddd7a4e0c@all.all>
 <2c00c4b7c15e424659fb2e810170e32e@all.all> <55F83181.9010201@fb.com>
 <532aadf0f92d08d3d2b274173548aee1@all.all>
 <pan$e885$1290ceef$c5017ead$b38037f1@cox.net>
 <f81878fadaf2980a72522e54010e0415@all.all> <55F9486F.4040302@googlemail.com>
 <0973de930ee87e102c533c719807b748@all.all>
 <pan$5599c$cb01bfb8$910004c8$d38ea6b6@cox.net>
Message-ID: <d2f30d85fa83b8b98af3c7e5a862044d@all.all>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 2015-09-16 22:18, Duncan a écrit :
> Stéphane Lesimple posted on Wed, 16 Sep 2015 15:04:20 +0200 as 
> excerpted:
> 
>> Le 2015-09-16 12:46, Holger Hoffstätte a écrit :
>>> 
>> I also disabled quota because it has almost for sure nothing to
>> do with the bug, and now btrsfck is 100% happy:
> 
> Yes.  Quotas have been a continuing issue on btrfs.  AFAIK, they're on
> the third rewrite now, and still have some bugs to work out.  So what
> I've been recommending is unless you're (a) directly and specifically
> working with the devs to find and fix the quota issues (in which case
> please keep at it! =:^), either you (b) really depend on quotas working
> and btrfs isn't appropriate for you at this time, since they're known 
> to
> be buggy, so use a more mature filesystem where they're known to work, 
> or
> (c) you don't actually need quotas at all, so disable them and remove 
> the
> quota tracking metadata, thus avoiding the bugs in the feature 
> entirely.
> =:^)

Well actually it's the (d) option ;)
I activate the quota feature for only one reason : being able to track 
down how much space my snapshots are taking.
I've been using ZFS in the past, and I was really missing the "zfs list" 
command that is able to tell you how much space a given snapshot is 
actually taking under btrfs.
With quota enabled, I was able to somehow mimic zfs list with a perl 
script I wrote, btrfs-list :

PATH                                    ID     TYPE     REFER      USED
'tank'                                  -1       df         -     2.66T 
(13.26G free)
    /tank                                 5      vol    48.00K    48.00K
    media                              1906   subvol     1.04T     1.04T
    photos                             1909   subvol   116.37G   116.37G
    main                               1911   subvol   973.23G   973.23G
    bkp-slash                          3270   subvol    15.86G    15.86G
    bkp-quasar                         3314   subvol    18.26G    16.00K
       .snaps/bkp-quasar@2015-01-17    3317   rosnap    17.77G    40.76M
       .snaps/bkp-quasar@2015-03-06    3318   rosnap    17.89G    88.88M
       .snaps/bkp-quasar@2015-04-05    3319   rosnap    17.92G    90.97M
       .snaps/bkp-quasar@2015-05-31    3320   rosnap    17.95G     1.02M
       .snaps/bkp-quasar@2015-06-13    3321   rosnap    17.95G   760.00K
       .snaps/bkp-quasar@2015-07-26    3322   rosnap    18.19G    17.88M
       .snaps/bkp-quasar@2015-07-31    3323   rosnap    18.19G    14.58M
       .snaps/bkp-quasar@2015-08-03    3324   rosnap    18.19G    17.43M
    bkp-liznodisk                      3341   subvol     7.01G    16.00K
       .snaps/bkp-liznodisk@2015-03-01 3342   rosnap     6.96G    75.37M
       .snaps/bkp-liznodisk@2015-03-28 3343   rosnap     6.98G    84.93M
       .snaps/bkp-liznodisk@2015-04-26 3344   rosnap     6.96G    67.14M
       .snaps/bkp-liznodisk@2015-05-24 3345   rosnap     6.95G    47.67M
       .snaps/bkp-liznodisk@2015-06-27 3346   rosnap     6.96G    67.97M
       .snaps/bkp-liznodisk@2015-07-25 3347   rosnap     6.98G    60.30M
       .snaps/bkp-liznodisk@2015-08-16 3348   rosnap     7.10G   159.44M
    bkp-skyline                        3367   subvol    22.52G    22.52G

I just pushed it to https://github.com/speed47/btrfs-list, if anybody is 
interested.

Anyway, balance is running again for 7+ hours, trying to reproduce the 
bug twice, but no crash yet ... should happen soon now !

-- 
Stéphane.

