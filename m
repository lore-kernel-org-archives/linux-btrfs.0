Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:39423 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751845AbaABRhc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Jan 2014 12:37:32 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: coredump in btrfsck
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52C4982C.1040606@gmail.com>
Date: Thu, 2 Jan 2014 10:37:28 -0700
Message-Id: <4656C292-30C5-4D72-AB46-654EC7C4FBD3@colorremedies.com>
References: <52C4884F.6040000@gmail.com> <45E0985F-4F75-47D1-BD6E-2286D5844AE3@colorremedies.com> <52C4982C.1040606@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Oliver Mangold <o.mangold@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 1, 2014, at 3:35 PM, Oliver Mangold <o.mangold@gmail.com> wrote:

> On 01.01.2014 22:58, Chris Murphy wrote:
>> On Jan 1, 2014, at 2:27 PM, Oliver Mangold <o.mangold@gmail.com> wrote:
>> 
>>> I fear, I broke my FS by running btrfsck. I tried 'btrfsck --repair' and it fixed several problems but finally crashed with some debug message from 'extent-tree.c', so I also tried 'btrfsck --repair --init-extent-tree'.
>> It is sort of a (near) last restort, you know this right? What did you try before btrfsck? Did you set dmesg -n7, then mount -o recovery and if so what was recorded in dmesg?
> Ehm, actually, no.

https://btrfs.wiki.kernel.org/index.php/FAQ#When_will_Btrfs_have_a_fsck_like_tool.3F

This is a bit dated, but the general idea is to not use repair except on advice of a developer, and also there are still some risks. Just a week or so ago, one said it was a little dangerous still. So yeah, -o recovery should be the first choice.


> Before I ran btrfsck there was no reason to use '-o recovery' or something, because the filesystem seemed to work.

Ahh so you ran btrfsck without --repair first? It found problems so then you next ran it with --repair?


> But I was worried after running btrfsck, because the FS apparently was in an inconsistent state. So I tried 'btrfsck --repair' and when that crashed 'btrfsck --init-extent-tree'. Didn't know it is considered 'last resort'. It did the trick for several previous problems and seemed to have no negative consequences, so I tried it now also.

It's sort of a sledgehammer.


> But it looks like I can still recover my data with 'btrfs restore', so it's less critical than assumed.

That's good news.


> Sorry, that I can't give you the logs you would have liked.

Yeah, I'm not certain anyone can give you much advice without more details. What kernel version and btfs-progs were you using at the time of the problem, and the btrfsck? You report a crash but no dmesg of the crash?


> Didn't expect anything bad to happen. I would just wsh that btrfsck could fix that kind of problem. 

Sure but the problem is unclear, and you have no logs to make it more clear what even happened.



Chris Murphy