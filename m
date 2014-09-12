Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:35493 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752879AbaILCK2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Sep 2014 22:10:28 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:53173 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XSGJf-000u28-SS
	for linux-btrfs@vger.kernel.org; Thu, 11 Sep 2014 20:10:27 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: how long should "btrfs device delete missing ..."  take?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <pan$a2cc2$dc8ad02$d35780a0$4fefc791@cox.net>
Date: Thu, 11 Sep 2014 20:10:26 -0600
Message-Id: <6AE06E73-C89E-42F0-9A09-FA92C68DED69@colorremedies.com>
References: <84a98bc5f667c04ca74ff77b56f537d9@admin.virtall.com> <pan$2d5ba$86c3ebd8$b81abab$13e892ea@cox.net> <4A9B52AD-8104-4C31-9BA4-13D329D2F952@colorremedies.com> <pan$a2cc2$dc8ad02$d35780a0$4fefc791@cox.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 11, 2014, at 5:51 PM, Duncan <1i5t5.duncan@cox.net> wrote:

> Chris Murphy posted on Thu, 11 Sep 2014 15:25:51 -0600 as excerpted:
> 
>> On Sep 11, 2014, at 1:31 PM, Duncan <1i5t5.duncan@cox.net> wrote:
>>> 
>>> I wouldn't try defragging now, but it might be worthwhile to stop the
>>> device delete (rebooting to do so since I don't think there's a cancel)
>> 
>> 'btrfs replace cancel' does exist, although I haven't tried it.
> 
> Btrfs replace cancel exists, yes, but does it work for btrfs device 
> delete, which is what the OP used?

Oops, right! I'm not sure what can do this safely.

And then when I think about just creating a new fs, using btrfs send/receive, the snapshots need to be ro first. So if there's any uncertainty about safely canceling the 'device delete' those ro snapshots need to be taken first, in the event only an ro mount is possible subsequently. And then there's some uncertainty how long 260+ ro snapshots will take (should be fast, but) and how much worse that makes the current situation. But probably worth the risk to take the snapshots and just wait a while before trying something like umount or sysrq+s followed by sysrq+u.



> 
>> Something isn't right though, because it's clearly neither reading nor
>> writing at anywhere close to 1/2 the drive read throughput. I'm curious
>> what 'iotop -d30 -o' shows (during the replace, before cancel), which
>> should be pretty consistent by averaging 30 seconds worth of io. And
>> then try 'iotop -d3 -o' and see if there are spikes. I'm willing to bet
>> there's a lot of nothing going on, with occasional spikes, rather than a
>> constant trickle.
>> 
>> And then the question is to find out what btrfs is thinking about while
>> nothing is reading or writing. Even though it's not 5000+ snapshots, I
>> wonder if the balance code (and hence btrfs replace) makes extensive use
>> of fiemap that's causing this to go catatonic.
>> http://comments.gmane.org/gmane.comp.file-systems.btrfs/35724
> 
> Not sure (some of that stuff's beyond me), but one thing we /do/ know is 
> that btrfs has so far been focused mostly on features and debugging, not 
> on optimization beyond the worst-cases, which themselves remain a big 
> enough problem, tho it's slowly getting better.

Sure. But what's the next step? Given 260+ snapshots might mean well more than 350GB of data, depending on how deduplicated the fs is, it still probably would be faster to rsync this to a pile of drives in linear/concat+XFS than wait a month (?) for device delete to finish.

Alternatively, script some way to create 260+ ro snapshots to btrfs send/receive to a new btrfs volume; and turn it into a raid1 later.

I'm curious if a sysrq+s followed by sysrq+u might leave the filessystem in a state where it could still be rw mountable. But I'm skeptical of anything interrupting the device delete before being fully prepared for the fs to be toast for rw mount. If only ro mount is possible, any chance of creating ro snapshots is out.


Chris Murphy