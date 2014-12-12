Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-01v.sys.comcast.net ([96.114.154.160]:49146 "EHLO
	resqmta-po-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751226AbaLLW2I (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 17:28:08 -0500
Message-ID: <548B6BF6.2060306@pobox.com>
Date: Fri, 12 Dec 2014 14:28:06 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: mkfs.btrfs limits "odd" [and maybe a "failed" phantom device?]
References: <5488C6CF.1080608@pobox.com> <20141212035651.GD22023@hungrycats.org> <548A84A2.4000501@pobox.com> <20141212164544.GB25614@hungrycats.org>
In-Reply-To: <20141212164544.GB25614@hungrycats.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/12/2014 08:45 AM, Zygo Blaxell wrote:
> On Thu, Dec 11, 2014 at 10:01:06PM -0800, Robert White wrote:
>> So RAID5 with three media M is
>>
>> M    MM   MMM
>> D1   D2   P(a)
>> D3   P(b) D4
>> P(c) D5   D6
>
> RAID5 with two media is well defined, and looks like this:
>
> M    MM
> D1   P(a)
> P(b) D2
> D3   P(c)

Like I said in the other fork of this thread... I see (now) that the 
math works but I can find no trace of anyone having ever implemented 
this for arity less than 3 RAID greater than one paradigm (outside btrfs 
and its associated materials).

It's like talking about a two-wheeled tricycle. 8-)

I would _genuinely_ like to see any third party discussion of this. It 
just isn't done (probably because, as you've shown it just a really 
complicated and CPU intensive way to end up with a simple mirror). I 
spent several hours looking. I can see the math works, and I understand 
what you are doing (as I said at some length in the grandparent message) 
but it "just isn't done".

The reason I use the tricycle example is that, while most people know 
this instinctively few are aware of the fact that going from two wheels 
to three-or-more wheels reverses the steering paradigm. On a bike you 
push-left lean-left and go-left. At the higher arity vehicles (including 
adding a side-car to a bike) you push-right go left (you lean left too, 
but that's just to keep from nosing over 8-). I find that quite apt in 
the whole RAID1 vs RAID5 discussion since the former is about copying 
one-or-more times and the latter is about starting with a theoretically 
zeroed buffer and doing reversible checksumming into it.

I doubt that I will be the last person to be confused by BTRFS' 
implementation of a two-wheeled tricycle.

You're going to get a lot of mail over the years. 8-)


MEANWHILE

the system really needs to be able to explicitly express and support the 
"missing" media paradigm.

  M     x    MMM
  D1    .    P(a)
  D3    .    D4
  P(c)  .    D6

The correct logic here to "remove" (e.g. "replace with nothing" instead 
of "delete") a media just doesn't seem to exist. And it's already 
painfully missing in the RAID1 situation.

If I have a system with N SATA ports, and I have connected N drives, and 
device M is starting to fail... I need to be able to disconnect M and 
then connect M(new). Possibly with a non-trivial amount of time in 
there. For all RAID levels greater than zero this is a natural operation 
in a degraded mode. And for a nearly full filesystem the shrink 
operation that is btrfs device delete would not work. And for any 
nontrivially occupied fiesystem it would be way slow, and need to be 
reversed for another way-slow interval.

So I need to be able to "replace" a drive with a "nothing" so that the 
number of active media becomes N-1 but the arity remains N.

mdadm has the "missing" keyword. the Device Mapper has the "zero" 
target. As near as I can tell btrfs has got nothing in this functional slot.

Imagine, if you will, a block device that is the anti-/dev/null. All 
operations on this block device return EFAULT. lets call it 
/dev/nothing. And lets say I have a /dev/sdc that has to come out 
immediately (and all my stuff is RAID1/5/6).  The operational chain would be

btrfs replace start /dev/sdc /dev/nothing /
(time pases, physical device is removed and replace)
btrfs replace start /dev/nothing /dev/sdc /

Now that's good-ish, but really the first replace is pernicious. The 
internal state for the filesystem should just be able to record that 
device id 3 (assuming /dev/sda is devid1 and b is 2 etc for this 
example) is just gone. The replace-with-nothing becomes more-or-less 
instant.

The first replace is also pernicious if its the second media failure on 
a fully RAID6 array since that would trying to put the same kernel level 
device in the array twice.

The restore operation, the replace of the nothing with the something, 
remains fully elaborate.

The "nothing" devices need to show up in the device id tables for a 
running array in their geographically correct positions and all that.

Without this "missing" status as a first-class part of the system, 
dealing with failures and communicating about those failures with the 
operator will become vexatious.


[The use of "device delete" and "device add" as changes in arity and 
size, and its inaplicability to cases where failure is being dealt with 
abent a change of arity, could be clearer in the documentation.]
