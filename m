Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:50059 "EHLO
        mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932208AbdKGNCX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Nov 2017 08:02:23 -0500
Received: by mail-it0-f47.google.com with SMTP id y15so2283401ita.4
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Nov 2017 05:02:22 -0800 (PST)
Subject: Re: Problem with file system
To: Dave <davestechshop@gmail.com>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Cc: Chris Murphy <lists@colorremedies.com>
References: <CAJyZh6S4f=6W+oA6DT1zu2FRuCgO7w8TfRzC96rPWNzUszvRmg@mail.gmail.com>
 <9871a669-141b-ac64-9da6-9050bcad7640@cn.fujitsu.com>
 <f6428a81-6fc8-1a73-0151-d13dd550c277@rqc.ru>
 <bb12a331-1fec-448a-cbf8-881b434766e7@cn.fujitsu.com>
 <CAJyZh6RxKuMukM-vCd=_u_8y38MJO_oUG1nYFpaxBroeK8xpAQ@mail.gmail.com>
 <CAH=dxU4OV6tQ0hCy_0Ug7eqkOM7HTUWTKjAr4qg+uO2gVxk2Jw@mail.gmail.com>
 <CAJCQCtS9BPZn-hnS+wP7Eu3oHQP_tS8EEM4j4FQDwRmzcFH+_A@mail.gmail.com>
 <CAH=dxU4MOWGZ0JSZ-ZV004p5EnH_aOnZ7XEo2rSOmbXJZJmwBA@mail.gmail.com>
 <CAJCQCtTOefBfRpfb0h1H6SQxzGd9j-7ZSM07iA37xhy3+Lm=fw@mail.gmail.com>
 <CAH=dxU61J94HCnr+UUokBsxqNMjKQBdz8xE2WNbWAHOtKP4w0w@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <2164b4b2-1447-3670-73ae-465404754b87@gmail.com>
Date: Tue, 7 Nov 2017 08:02:18 -0500
MIME-Version: 1.0
In-Reply-To: <CAH=dxU61J94HCnr+UUokBsxqNMjKQBdz8xE2WNbWAHOtKP4w0w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-11-07 02:01, Dave wrote:
> On Sat, Nov 4, 2017 at 1:25 PM, Chris Murphy <lists@colorremedies.com> wrote:
>>
>> On Sat, Nov 4, 2017 at 1:26 AM, Dave <davestechshop@gmail.com> wrote:
>>> On Mon, Oct 30, 2017 at 5:37 PM, Chris Murphy <lists@colorremedies.com> wrote:
>>>>
>>>> That is not a general purpose file system. It's a file system for admins who understand where the bodies are buried.
>>>
>>> I'm not sure I understand your comment...
>>>
>>> Are you saying BTRFS is not a general purpose file system?
>>
>> I'm suggesting that any file system that burdens the user with more
>> knowledge to stay out of trouble than the widely considered general
>> purpose file systems of the day, is not a general purpose file system.
>>
>> And yes, I'm suggesting that Btrfs is at risk of being neither general
>> purpose, and not meeting its design goals as stated in Btrfs
>> documentation. It is not easy to admin *when things go wrong*. It's
>> great before then. It's a butt ton easier to resize, replace devices,
>> take snapshots, and so on. But when it comes to fixing it when it goes
>> wrong? It is a goddamn Choose Your Own Adventure book. It's way, way
>> more complicated than any other file system I'm aware of.
> 
> It sounds like a large part of that could be addressed with better
> documentation. I know that documentation such as what you are
> suggesting would be really valuable to me!
Documentation would help, but most of it is a lack of automation of 
things that could be automated (and are reasonably expected to be based 
on how LVM and ZFS work), including but not limited to:
* Handling of device failures.  In particular, BTRFS has absolutely zero 
hot-spare support currently (though there are patches to add this), 
which is considered a mandatory feature in almost all large scale data 
storage situations.
* Handling of chunk-level allocation exhaustion.  Ideally, when we can't 
allocate a chunk, we should try to free up space from the other chunk 
type through repacking of data.  Handling this better would 
significantly improve things around one of the biggest pitfalls with 
BTRFS, namely filling up a filesystem completely (which many end users 
seem to think is perfectly fine, despite that not being the case for 
pretty much any filesystem).
* Optional automatic correction of errors detected during normal usage. 
Right now, you have to run a scrub to correct errors. Such a design 
makes sense with MD and LVM, where you don't know which copy is correct, 
but BTRFS does know which copy is correct (or how to rebuild the correct 
data), and it therefore makes sense to have an option to automatically 
rebuild data that is detected to be incorrect.
> 
>>> If btrfs isn't able to serve as a general purpose file system for
>>> Linux going forward, which file system(s) would you suggest can fill
>>> that role? (I can't think of any that are clearly all-around better
>>> than btrfs now, or that will be in the next few years.)
>>
>> ext4 and XFS are clearly the file systems to beat. They almost always
>> recover from crashes with just a normal journal replay at mount time,
>> file system repair is not often needed. When it is needed, it usually
>> works, and there is just the one option to repair and go with it.
>> Btrfs has piles of repair options, mount time options, btrfs check has
>> options, btrfs rescue has options, it's a bit nutty honestly. And
>> there's zero guidance in the available docs what order to try things
>> in, not least of which some of these repair tools are still considered
>> dangerous at least in the man page text, and the order depends on the
>> failure. The user is burdened with way too much.
> 
> Neither one of those file systems offers snapshots. (And when I
> compared LVM snapshots vs BTRFS snapshots, I got the impression BTRFS
> is the clear winner.)
> 
> Snapshots and volumes have a lot of value to me and I would not enjoy
> going back to a file system without those features.
While that is true, that's not exactly the point Chris was trying to 
make.  The point is that if you install a system with XFS, you don't 
have to do pretty much anything to keep the filesystem running 
correctly, and ext4 is almost as good about not needing user 
intervention (repairs for ext4 are a bit more involved, and you have to 
watch inode usage because it uses static inode tables).  In contrast, 
you have to essentially treat BTRFS like a small child and keep an eye 
on it almost constantly to make sure it works correctly.
> 
>> Even as much as I know about Btrfs having used it since 2008 and my
>> list activity, I routinely have WTF moments when people post problems,
>> what order to try to get things going again. Easy to admin? Yeah for
>> the most part. But stability is still a problem, and it's coming up on
>> a 10 year anniversary soon.
>>
>> If I were equally familiar with ZFS on Linux as I am with Btrfs, I'd
>> use ZoL hands down.
> 
> Might it be the case that if you were equally familiar with ZFS, you
> would become aware of more of its pitfalls? And that greater knowledge
> could always lead to a different decision (such as favoring BTRFS)..
> In my experience the grass is always greener when I am less familiar
> with the field.
Quick summary of the big differences, with ZFS parts based on my 
experience using it with FreeNAS at work:

BTRFS:
* Natively supported by the mainline kernel, unlike ZFS which can't ever 
be included in the mainline kernel due to licensing issues.  This is 
pretty much the only significant reason I stick with BTRFS over ZFS, as 
it greatly simplifies updates (and means I don't have to wait as long 
for kernel upgrades).
* Subvolumes are implicitly rooted in the filesystem hierarchy, unlike 
ZFS datasets which always have to be explicitly mounted.  This is 
largely cosmetic to be honest.
* Able to group subvolumes for quotas without having to replicate the 
grouping with parent subvolumes, unlike ZFS which requires a common 
parent dataset if you want to group datasets for quotas.  This is very 
useful as it reduces the complexity needed in the subvolume hierarchy.
* Has native support for most forms of fallocate(), while ZFS doesn't. 
This isn't all that significant for most users, but it does provide some 
significant benefit if you use lots of large sparse files (you have to 
do batch deduplication on ZFS to make them 'sparse' again, whereas you 
just call fallocate to punch holes on BTRFS, which takes far less time).

ZFS:
* Provides native support for exposing virtual block devices (zvols), 
unlike BTRFS which just provides filesystem functionality.  This is 
really big for NAS usage, as it's much more efficient to expose a zvol 
as an iSCSI, ATAoE, or NBD device than it is to expose a regular file as 
one.
* Includes hot-spare and automatic rebuild support, unlike BTRFS which 
does not (but we are working on this).  Really important for enterprise 
usage and high availability.
* Provides the ability to control stripe width for parity RAID modes, 
unlike BTRFS.  This is extremely important when dealing with large 
filesystems, by using reduced stripe width, you improve rebuild times 
for a given stripe, and in theory can sustain more lost disks before 
losing data.
* Has a much friendlier scrub mechanism that doesn't have anywhere near 
as much impact on other things accessing the device as BTRFS does.
