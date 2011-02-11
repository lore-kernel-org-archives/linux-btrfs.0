From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: ENOSPC Regression
Date: Fri, 11 Feb 2011 12:23:21 -0600
Message-ID: <AANLkTik1jvJquga4zUrj6n4VK-=jdBtSJX-Bd0JhSbAd@mail.gmail.com>
References: <AANLkTin87cx5fK8cxhMHZwC8YjUcDL7Nwbb6UREmM+o-@mail.gmail.com>
	<20110211162208.GB2693@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110211162208.GB2693@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 11, 2011 at 10:22 AM, Josef Bacik <josef@redhat.com> wrote:
> On Fri, Feb 11, 2011 at 07:21:47AM -0600, Mitch Harder wrote:
>> I'm encountering premature ENOSPC issues recently where my Btrfs
>> testing partition will either prematurely return an ENOSPC, or lock =
up
>> the operations trying to access the partition.
>>
>> I have bisected the problem to this commit:
>> http://git.kernel.org/?p=3Dlinux/kernel/git/mason/btrfs-unstable.git=
;a=3Dcommit;h=3D914ee295af418e936ec20a08c1663eaabe4cd07a
>> (Btrfs: pwrite blocked when writing from the mmaped buffer of the sa=
me page)
>>
>> I am encountering the problem on a small-ish 3.5 GB Btrfs partition.
>> I can replicate the problem with and without compression. =A0I can a=
lso
>> replicate the problem with and without reformating the partition.
>>
>> For most operations I run on this partition, Btrfs is performing
>> without error. =A0But when I compile openmotif-2.3.3 on a kernel tha=
t is
>> after the above referenced commit, I'll get either an ENOSPC error o=
r
>> the partition locks up.
>>
>> When I encounter a lock-up issue, there are no errors in dmesg, and =
no
>> delayed processes are showing (unless I try to run an additional
>> operation on that partition, such as 'ls', which will subsequently
>> show up as delayed). =A0However, the build process for openmotif-2.3=
=2E3
>> appears frozen, and several processes related to the build are shown
>> as running, and will not even respond to 'kill -s 9 <pid>'
>>
>> The partition only has about 500 MB of data when I encounter the
>> problems, and openmotif-2.3.3 typically only requires about 30-60 MB
>> to compile.
>>
>> However, running 'btrfs fi show' indicates that btrfs has attempted =
to
>> reserve all the space on the disk for data and metadata. =A0When run=
ning
>> a kernel prior to the above referenced commit, btrfs will compile
>> openmotif-2.3.3 without needing to reserve much extra space on the
>> partition.
>>
>> Let me know if you would like any additional information or tests.
>
> Can you try my btrfs-work tree and see if you still have the same pro=
blem?
> Thanks,
>
> Josef
>

I've built and tested the 2.6.38-rc1 kernel from the master branch of
git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-work.git,
and I am still getting the same issue.

I've just noticed there is another thread going on about this same prob=
lem.

I'll just pile on that thread if I come across something new.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
