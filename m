Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns211617.ip-188-165-215.eu ([188.165.215.42]:45564 "EHLO
	mx.speed47.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752828AbbIRHgY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Sep 2015 03:36:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Fri, 18 Sep 2015 09:36:19 +0200
From: =?UTF-8?Q?St=C3=A9phane_Lesimple?= <stephane_btrfs@lesimple.fr>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Subject: Re: kernel BUG at linux-4.2.0/fs/btrfs/extent-tree.c:1833 on
 rebalance
In-Reply-To: <55FB61E9.4000300@cn.fujitsu.com>
References: <9c864637fe7676a8b7badc5ddd7a4e0c@all.all>
 <2c00c4b7c15e424659fb2e810170e32e@all.all> <55F83181.9010201@fb.com>
 <532aadf0f92d08d3d2b274173548aee1@all.all>
 <pan$e885$1290ceef$c5017ead$b38037f1@cox.net>
 <f81878fadaf2980a72522e54010e0415@all.all> <55F9486F.4040302@googlemail.com>
 <0973de930ee87e102c533c719807b748@all.all>
 <pan$5599c$cb01bfb8$910004c8$d38ea6b6@cox.net>
 <d2f30d85fa83b8b98af3c7e5a862044d@all.all> <55FA2D9A.1060405@cn.fujitsu.com>
 <e80ea6421a1f6a5f84c5d1032fc6a3e8@all.all> <55FA60C5.5090002@cn.fujitsu.com>
 <7a6f2d794fb6cbf7d598b92e3470201c@all.all> <55FA759E.6030707@cn.fujitsu.com>
 <3386a8bfa1a5796460306a53a668e47e@all.all> <55FA98D8.5010301@gmx.com>
 <53a5553a9c5301789e246144bb264e43@all.all> <55FB61E9.4000300@cn.fujitsu.com>
Message-ID: <2ce9b35f73732b145e0f80b18f230a52@all.all>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 2015-09-18 02:59, Qu Wenruo a écrit :
> Stéphane Lesimple wrote on 2015/09/17 20:47 +0200:
>> Le 2015-09-17 12:41, Qu Wenruo a écrit :
>>>> In the meantime, I've reactivated quotas, umounted the filesystem 
>>>> and
>>>> ran a btrfsck on it : as you would expect, there's no qgroup problem
>>>> reported so far.
>>> 
>>> At least, rescan code is working without problem.
>>> 
>>>> I'll clear all my snapshots, run an quota rescan, then
>>>> re-create them one by one by rsyncing from my ext4 system I still 
>>>> have.
>>>> Maybe I'll run into the issue again.
>>>> 
>>> 
>>> Would you mind to do the following check for each subvolume rsync?
>>> 
>>> 1) Do 'sync; btrfs qgroup show -prce --raw' and save the output
>>> 2) Create the needed snapshot
>>> 3) Do 'sync; btrfs qgroup show -prce --raw' and save the output
>>> 4) Avoid doing IO if possible until step 6)
>>> 5) Do 'btrfs quota rescan -w' and save it
>>> 6) Do 'sync; btrfs qgroup show -prce --raw' and save the output
>>> 7) Rsync data from ext4 to the newly created snapshot
>>> 
>>> The point is, as you mentioned, rescan is working fine, we can 
>>> compare
>>> output from 3), 6) and 1) to see which qgroup accounting number
>>> changes.
>>> 
>>> And if differs, which means the qgroup update at write time OR
>>> snapshot creation has something wrong, at least we can locate the
>>> problem to qgroup update routine or snapshot creation.
>> 
>> I was about to do that, but first there's something that sounds 
>> strange
>> : I've begun by trashing all my snapshots, then ran a quota rescan, 
>> and
>> waited for it to complete, to start on a sane base.
>> However, this is the output of qgroup show now :
> 
> By "trashing", did you mean deleting all the files inside the 
> subvolume?
> Or "btrfs subv del"?

Sorry for the confusion here, yes, I meant btrfs subvolume del.

>> qgroupid          rfer                 excl     max_rfer     max_excl
>> parent  child
>> --------          ----                 ----     --------     --------
>> ------  -----
>> 0/5              16384                16384         none         none
>> ---     ---
>> 0/1906   1657848029184        1657848029184         none         none
>> ---     ---
>> 0/1909    124950921216         124950921216         none         none
>> ---     ---
>> 0/1911   1054587293696        1054587293696         none         none
>> ---     ---
>> 0/3270     23727300608          23727300608         none         none
>> ---     ---
>> 0/3314     23206055936          23206055936         none         none
>> ---     ---
>> 0/3317     18472996864                    0         none         none
>> ---     ---
>> 0/3318     22235709440 18446744073708421120         none         none
>> ---     ---
>> 0/3319     22240333824                    0         none         none
>> ---     ---
>> 0/3320     22289608704                    0         none         none
>> ---     ---
>> 0/3321     22289608704                    0         none         none
>> ---     ---
>> 0/3322     18461151232                    0         none         none
>> ---     ---
>> 0/3323     18423902208                    0         none         none
>> ---     ---
>> 0/3324     18423902208                    0         none         none
>> ---     ---
>> 0/3325     18463506432                    0         none         none
>> ---     ---
>> 0/3326     18463506432                    0         none         none
>> ---     ---
>> 0/3327     18463506432                    0         none         none
>> ---     ---
>> 0/3328     18463506432                    0         none         none
>> ---     ---
>> 0/3329     18585427968                    0         none         none
>> ---     ---
>> 0/3330     18621472768 18446744073251348480         none         none
>> ---     ---
>> 0/3331     18621472768                    0         none         none
>> ---     ---
>> 0/3332     18621472768                    0         none         none
>> ---     ---
>> 0/3333     18783076352                    0         none         none
>> ---     ---
>> 0/3334     18799804416                    0         none         none
>> ---     ---
>> 0/3335     18799804416                    0         none         none
>> ---     ---
>> 0/3336     18816217088                    0         none         none
>> ---     ---
>> 0/3337     18816266240                    0         none         none
>> ---     ---
>> 0/3338     18816266240                    0         none         none
>> ---     ---
>> 0/3339     18816266240                    0         none         none
>> ---     ---
>> 0/3340     18816364544                    0         none         none
>> ---     ---
>> 0/3341      7530119168           7530119168         none         none
>> ---     ---
>> 0/3342      4919283712                    0         none         none
>> ---     ---
>> 0/3343      4921724928                    0         none         none
>> ---     ---
>> 0/3344      4921724928                    0         none         none
>> ---     ---
>> 0/3345      6503317504 18446744073690902528         none         none
>> ---     ---
>> 0/3346      6503452672                    0         none         none
>> ---     ---
>> 0/3347      6509514752                    0         none         none
>> ---     ---
>> 0/3348      6515793920                    0         none         none
>> ---     ---
>> 0/3349      6515793920                    0         none         none
>> ---     ---
>> 0/3350      6518685696                    0         none         none
>> ---     ---
>> 0/3351      6521511936                    0         none         none
>> ---     ---
>> 0/3352      6521511936                    0         none         none
>> ---     ---
>> 0/3353      6521544704                    0         none         none
>> ---     ---
>> 0/3354      6597963776                    0         none         none
>> ---     ---
>> 0/3355      6598275072                    0         none         none
>> ---     ---
>> 0/3356      6635880448                    0         none         none
>> ---     ---
>> 0/3357      6635880448                    0         none         none
>> ---     ---
>> 0/3358      6635880448                    0         none         none
>> ---     ---
>> 0/3359      6635880448                    0         none         none
>> ---     ---
>> 0/3360      6635880448                    0         none         none
>> ---     ---
>> 0/3361      6635880448                    0         none         none
>> ---     ---
>> 0/3362      6635880448                    0         none         none
>> ---     ---
>> 0/3363      6635880448                    0         none         none
>> ---     ---
>> 0/3364      6635880448                    0         none         none
>> ---     ---
>> 0/3365      6635880448                    0         none         none
>> ---     ---
>> 0/3366      6635896832                    0         none         none
>> ---     ---
>> 0/3367     24185790464          24185790464         none         none
>> ---     ---
>> 
> 
> Nooooo!! What a wired result here!
> Qg 3345 is having minus number again, even after a qgroup rescan....
> IIRC, from the code, rescan is just passing old_roots as NULL, and use
> correct new_roots to build up "rfer" and "excl".
> So in theory it should never go below zero in rescan.
> 
> The only hope for me is, that's a orphan qgroup.(mentioned below)
> 
>> I would have expected all these qgroupids to have been trashed with 
>> the
>> snapshots, but it seems not. It reminded me of the bug you were 
>> talking
>> about, where deleted snapshots don't always clear correctly their
>> qgroup, but as these don't disappear after a rescan either... I'm a 
>> bit
>> surprised.
> 
> If you mean you "btrfs qgroup del" the subvolume, then it's known the
> qgroup won't be deleted, and won't be associated to any subvolume.
> (It's possible later created subvolume uses the old subvolid, and be
> associated to the qgroup again).
> 
> If above qgroups with 0 or even minus "excl" number are orphan, I'll
> be much relieved, as it'll be a minor orphan qgroup bug other than
> another possible qgroup rework(or at least huge review).

The only qgroup subcommand I use is qroup show, I never deleted a qgroup 
directly by using qgroup del... I guess this is not good news :(

>> I've just tried quota disable / quota enable, and not it seems OK. 
>> Just
>> wanted to let you know, in case it's not known behavior ...

There's a typo above, I was meaning "and *now* it seems OK".
I'm sure you corrected, I just want to be sure there's no possibility of 
misinterpretation.

> Thanks for your info a lot, which indeed expose something we didn't
> take much consideration.
> 
> And if the qgroups are the same with above description, would you mind
> to remove these qgroups?

Sure, I did a quota disable / quota enable before running the snapshot 
debug procedure, so the qgroups were clean again when I started :

qgroupid          rfer          excl     max_rfer     max_excl parent  
child
--------          ----          ----     --------     -------- ------  
-----
0/5              16384         16384         none         none ---     
---
0/1906   1657848029184 1657848029184         none         none ---     
---
0/1909    124950921216  124950921216         none         none ---     
---
0/1911   1054587293696 1054587293696         none         none ---     
---
0/3270     23727300608   23727300608         none         none ---     
---
0/3314     23221784576   23221784576         none         none ---     
---
0/3341      7479275520    7479275520         none         none ---     
---
0/3367     24185790464   24185790464         none         none ---     
---

The test is running, I expect to post the results within an hour or two.

-- 
Stéphane.
