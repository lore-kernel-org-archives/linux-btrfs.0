Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:4738 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754209AbbEZNXE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 May 2015 09:23:04 -0400
Message-ID: <55646D1F.6000506@fb.com>
Date: Tue, 26 May 2015 08:54:55 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Josh Boyer <jwboyer@fedoraproject.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs
References: <20150523000905.GA16230@ret.masoncoding.com> <CA+5PVA7yA-q3V_KHp-zL+4G_bO9Fp4i0jH_UXdez0r+4D4KqYQ@mail.gmail.com>
In-Reply-To: <CA+5PVA7yA-q3V_KHp-zL+4G_bO9Fp4i0jH_UXdez0r+4D4KqYQ@mail.gmail.com>
Content-Type: text/plain; charset="windows-1252"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/26/2015 08:33 AM, Josh Boyer wrote:
> On Fri, May 22, 2015 at 9:14 PM, Chris Mason <clm@fb.com> wrote:
>> Hi Linus,
>>
>> My for-linus-4.1 branch has three more fixes:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.1
>>
>> I fixed up a regression from 4.0 where conversion between different raid
>> levels would sometimes bail out without converting.
>>
>> Filipe tracked down a race where it was possible to double allocate
>> chunks on the drive.
>>
>> Mark has a fix for fiemap.  All three will get bundled off for stable as
>> well.
>>
>> Chris Mason (1) commits (+18/-0):
>>     Btrfs: fix regression in raid level conversion
> 
> Shouldn't this be CC'd to stable since it fixes a broken commit in 4.0?

Yes, I'm retesting two of these against 4.0

-chris

