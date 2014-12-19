Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51784 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752650AbaLSWGR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 17:06:17 -0500
Message-ID: <5494A152.7030203@fb.com>
Date: Fri, 19 Dec 2014 17:06:10 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Phillip Susi <psusi@ubuntu.com>, Daniele Testa <daniele.testa@gmail.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs is using 25% more disk than it should
References: <CAN6BF2Luf3ERd+ShLyUavzM3bLmy9dT918Zg17xL9T42DNVtVQ@mail.gmail.com>	<54947432.5010107@ubuntu.com> <CAN6BF2JoMki_KmpmVYVM-_ECqCg_w-qo9_6P=MiZbabMQyVN_g@mail.gmail.com> <5494955C.3020603@fb.com> <54949E60.7010201@ubuntu.com>
In-Reply-To: <54949E60.7010201@ubuntu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/19/2014 04:53 PM, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 12/19/2014 4:15 PM, Josef Bacik wrote:
>> Please God don't turn off of checksums.  Checksums are tracked in
>> metadata anyway, they won't show up in the data accounting.  Our
>> csums are 8 bytes per block, so basic math says you are going to
>> max out at 604 megabytes for that big of a file.
>
> Yes, and it is exactly that metadata space he is complaining about.
> So if you don't want to use up all of that space ( and have no use for
> the checksums ), then you turn them off.
>
>> Please people try to only take advice from people who know what
>> they are talking about.  So unless it's from somebody who has
>> commits in btrfs/btrfs-progs take their feedback with a grain of
>> salt.  Thanks,
>
> Well that is rather arrogant and rude.  For that matter, I *do* have
> commits in btrfs-progs.
>

root@destiny ~/btrfs-progs# git log --oneline --author="Phillip Susi"
c65345d btrfs-progs: document --rootdir mkfs switch
f6b6e93 btrfs-progs: removed extraneous whitespace from mkfs man page

Sorry I should have qualified that statement better.

So unless it's from somebody who has had commits to meaningful portions 
of btrfs/btrfs-progs take their feedback with a grain of salt.

There are too many people on this list who give random horribly wrong 
advice to users that can result in data loss or corruption.  Now I'll 
admit I read her question wrong so what you said wasn't incorrect, I'm 
sorry for that.  I've seen a lot of people responding to questions 
recently that I don't recognize that have been completely full of crap, 
I just assumed you were in that camp as well.  Thanks,

Josef
