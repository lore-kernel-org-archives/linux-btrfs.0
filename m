Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-01v.sys.comcast.net ([96.114.154.160]:57563 "EHLO
	resqmta-po-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752078AbaLLW6v (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 17:58:51 -0500
Message-ID: <548B7329.80208@pobox.com>
Date: Fri, 12 Dec 2014 14:58:49 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Tomasz Chmielewski <tch@virtall.com>
CC: Josef Bacik <jbacik@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: 3.18.0: kernel BUG at fs/btrfs/relocation.c:242!
References: <e4a8d9ba015981b895919256a2223950@admin.virtall.com> <542EE83D.8050701@fb.com> <999a300ed462a1e1388aee4d6f03a30e@admin.virtall.com> <438e043f73392614d1453892b7fe225c@admin.virtall.com> <0f30c49c7d208903ef84e31a928e4051@admin.virtall.com> <548B5FD6.5080306@pobox.com> <ce7dba343916e4262a92071af863d014@admin.virtall.com> <548B6D58.6080804@pobox.com> <a3dfa2330fae3ef52d19f9f2a951e7b9@admin.virtall.com>
In-Reply-To: <a3dfa2330fae3ef52d19f9f2a951e7b9@admin.virtall.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/12/2014 02:46 PM, Tomasz Chmielewski wrote:
> On 2014-12-12 23:34, Robert White wrote:
>> On 12/12/2014 01:46 PM, Tomasz Chmielewski wrote:
>>> On 2014-12-12 22:36, Robert White wrote:
>>>
>>>> In another thread [that was discussing SMART] you talked about
>>>> replacing a drive and then needing to do some patching-up of the
>>>> result because of drive failures. Is this the same filesystem where
>>>> that happened?
>>>
>>> Nope, it was on a different server.
>>>
>>
>> okay, so how did the btrfsck turn out?
>
> # time btrfsck /dev/sdc1 &>/root/btrfsck.log
>
> real    22m0.140s
> user    0m3.090s
> sys     0m6.120s
>
> root@bkp010 /usr/src/btrfs-progs # echo $?
> 1
>
> # cat /root/btrfsck.log
> root item for root 8681, current bytenr 5568935395328, current gen
> 70315, current level 2, new bytenr 5569014104064, new gen 70316, new
> level 2
> Found 1 roots with an outdated root item.
> Please run a filesystem check with the option --repair to fix them.
>
>
> Now, I'm a bit afraid to run --repair - as far as I remember, some time
> ago, it used to do all weird things except the actual repair.
> Is it better nowadays? I'm using latest clone from
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
>
>

I don't have the history to answer this definitively, but I don't think 
you have a choice. Nothing else is going to touch that error.

I have not seen any "oh my god, btrfsck just ate my filesystem errors" 
since I joined the list -- but I am a relative newcomer.

I know that you, of course, as a contentious and well-traveled system 
administrator, already have a current backup since you are doing storage 
maintenance... right? 8-)

