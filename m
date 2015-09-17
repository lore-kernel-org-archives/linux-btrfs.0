Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns211617.ip-188-165-215.eu ([188.165.215.42]:45370 "EHLO
	mx.speed47.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753077AbbIQGLZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Sep 2015 02:11:25 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Thu, 17 Sep 2015 08:11:20 +0200
From: =?UTF-8?Q?St=C3=A9phane_Lesimple?= <stephane_btrfs@lesimple.fr>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: kernel BUG at linux-4.2.0/fs/btrfs/extent-tree.c:1833 on
 rebalance
In-Reply-To: <55FA2D9A.1060405@cn.fujitsu.com>
References: <9c864637fe7676a8b7badc5ddd7a4e0c@all.all>
 <2c00c4b7c15e424659fb2e810170e32e@all.all> <55F83181.9010201@fb.com>
 <532aadf0f92d08d3d2b274173548aee1@all.all>
 <pan$e885$1290ceef$c5017ead$b38037f1@cox.net>
 <f81878fadaf2980a72522e54010e0415@all.all> <55F9486F.4040302@googlemail.com>
 <0973de930ee87e102c533c719807b748@all.all>
 <pan$5599c$cb01bfb8$910004c8$d38ea6b6@cox.net>
 <d2f30d85fa83b8b98af3c7e5a862044d@all.all> <55FA2D9A.1060405@cn.fujitsu.com>
Message-ID: <e80ea6421a1f6a5f84c5d1032fc6a3e8@all.all>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 2015-09-17 05:03, Qu Wenruo a écrit :
> Stéphane Lesimple wrote on 2015/09/16 22:41 +0200:
>> Le 2015-09-16 22:18, Duncan a écrit :
>>> Stéphane Lesimple posted on Wed, 16 Sep 2015 15:04:20 +0200 as 
>>> excerpted:
>>> 
>> 
>> Well actually it's the (d) option ;)
>> I activate the quota feature for only one reason : being able to track
>> down how much space my snapshots are taking.
> 
> Yeah, that's completely one of the ideal use case of btrfs qgroup.
> 
> But I'm quite curious about the btrfsck error report on qgroup.
> 
> If btrfsck report such error, it means either I'm too confident about
> the recent qgroup accounting rework, or btrfsck has some bug which I
> didn't take much consideration during the kernel rework.
> 
> Would you please provide the full result of previous btrfsck with 
> qgroup error?

Sure, I've saved the log somewhere just in case, here your are :

Counts for qgroup id: 3359 are different
our:            referenced 7530119168 referenced compressed 7530119168
disk:           referenced 7530086400 referenced compressed 7530086400
diff:           referenced 32768 referenced compressed 32768
our:            exclusive 49152 exclusive compressed 49152
disk:           exclusive 32768 exclusive compressed 32768
diff:           exclusive 16384 exclusive compressed 16384
Counts for qgroup id: 3361 are different
our:            referenced 7530119168 referenced compressed 7530119168
disk:           referenced 7530086400 referenced compressed 7530086400
diff:           referenced 32768 referenced compressed 32768
our:            exclusive 49152 exclusive compressed 49152
disk:           exclusive 32768 exclusive compressed 32768
diff:           exclusive 16384 exclusive compressed 16384
Counts for qgroup id: 3362 are different
our:            referenced 7530119168 referenced compressed 7530119168
disk:           referenced 7530086400 referenced compressed 7530086400
diff:           referenced 32768 referenced compressed 32768
our:            exclusive 49152 exclusive compressed 49152
disk:           exclusive 32768 exclusive compressed 32768
diff:           exclusive 16384 exclusive compressed 16384
Counts for qgroup id: 3363 are different
our:            referenced 7530119168 referenced compressed 7530119168
disk:           referenced 7530086400 referenced compressed 7530086400
diff:           referenced 32768 referenced compressed 32768
our:            exclusive 49152 exclusive compressed 49152
disk:           exclusive 32768 exclusive compressed 32768
diff:           exclusive 16384 exclusive compressed 16384
Counts for qgroup id: 3361 are different
our:            referenced 7530119168 referenced compressed 7530119168
disk:           referenced 7530086400 referenced compressed 7530086400
diff:           referenced 32768 referenced compressed 32768
our:            exclusive 49152 exclusive compressed 49152
disk:           exclusive 32768 exclusive compressed 32768
diff:           exclusive 16384 exclusive compressed 16384
Counts for qgroup id: 3362 are different
our:            referenced 7530119168 referenced compressed 7530119168
disk:           referenced 7530086400 referenced compressed 7530086400
diff:           referenced 32768 referenced compressed 32768
our:            exclusive 49152 exclusive compressed 49152
disk:           exclusive 32768 exclusive compressed 32768
diff:           exclusive 16384 exclusive compressed 16384
Counts for qgroup id: 3363 are different
our:            referenced 7530119168 referenced compressed 7530119168
disk:           referenced 7530086400 referenced compressed 7530086400
diff:           referenced 32768 referenced compressed 32768
our:            exclusive 49152 exclusive compressed 49152
disk:           exclusive 32768 exclusive compressed 32768
diff:           exclusive 16384 exclusive compressed 16384
Counts for qgroup id: 3364 are different
our:            referenced 7530119168 referenced compressed 7530119168
disk:           referenced 7530086400 referenced compressed 7530086400
diff:           referenced 32768 referenced compressed 32768
our:            exclusive 49152 exclusive compressed 49152
disk:           exclusive 32768 exclusive compressed 32768
diff:           exclusive 16384 exclusive compressed 16384
Counts for qgroup id: 3365 are different
our:            referenced 7530119168 referenced compressed 7530119168
disk:           referenced 7530086400 referenced compressed 7530086400
diff:           referenced 32768 referenced compressed 32768
our:            exclusive 49152 exclusive compressed 49152
disk:           exclusive 32768 exclusive compressed 32768
diff:           exclusive 16384 exclusive compressed 16384
Counts for qgroup id: 3366 are different
our:            referenced 7530119168 referenced compressed 7530119168
disk:           referenced 7530086400 referenced compressed 7530086400
diff:           referenced 32768 referenced compressed 32768
our:            exclusive 16384 exclusive compressed 16384
disk:           exclusive 16384 exclusive compressed 16384

If you need the really complete log (even with the "crossing stripe 
boundary" false positives), I can post it somewhere for you.

I can't do a btrfs qgroup show because I've since disabled quota as 
stated above. However you can find the IDs corresponding to subvolumes 
and snapshots in my previous post.

Don't hesitate to ask for more information if needed.

Thanks,

-- 
Stéphane.

