Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16691 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753903AbaHLRjT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Aug 2014 13:39:19 -0400
Message-ID: <53EA513F.3080804@fb.com>
Date: Tue, 12 Aug 2014 13:39:11 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>, Josef Bacik <jbacik@fb.com>
CC: <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: Fix memory corruption by ulist_add_merge() on
 32bit arch
References: <1406537824-2376-1-git-send-email-tiwai@suse.de>	<53D64D40.80606@fb.com>	<s5hzjft7fwm.wl%tiwai@suse.de>	<s5hsill7fak.wl%tiwai@suse.de>	<s5hsiljrwwy.wl%tiwai@suse.de>	<53D9015A.90001@fb.com>	<s5h61iesxen.wl%tiwai@suse.de>	<s5h1tt2sx94.wl%tiwai@suse.de>	<53D911DE.7000806@fb.com>	<s5hwqaurgic.wl%tiwai@suse.de>	<53D916DB.9020901@fb.com>	<s5hsilirehv.wl%tiwai@suse.de>	<53D924A8.2050008@fb.com>	<s5ha97q91vj.wl%tiwai@suse.de> <s5h38d94pm7.wl%tiwai@suse.de>
In-Reply-To: <s5h38d94pm7.wl%tiwai@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/06/2014 11:14 AM, Takashi Iwai wrote:
>>>
>>> I meant that I don't care how you do it, if you want to do it the simple way
>>> first and then send the cleanup later thats fine by me.  Thanks,
>>
>> Ah, misunderstood.  Then please disregard my v2 patches and take just
>> v1 patch.  It's even good for 3.16, if possible.
>>
>> I'll send the cleanup patch on top of that.
> 
> Ping.  I don't want to play a bot, but slowly wondering what's going
> on...

Sorry for the delay Takashi.  This patch is a ';' away from compiling.
I've fixed it up here and I'm running tests, but I wanted to double
check this was the latest version.

-chris
