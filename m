Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:28326 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756709AbcBWBco (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Feb 2016 20:32:44 -0500
Subject: Re: [Question]: Contributing to btrfs
To: Simon Quigley <tsimonq2@ubuntu.com>, Filipe Manana <fdmanana@gmail.com>
References: <20160220210903.GA3182@carbon.home>
 <20160220224050.GA10864@carbon.home> <56CA61CC.7010703@cn.fujitsu.com>
 <20160222072659.GC17243@carbon.ljdarc.local>
 <CAL3q7H7Ty4R8dQO=MWayn3xzROjRub7uzuGVdM7zMCfU0As1Eg@mail.gmail.com>
 <1456142520.3587.3.camel@ubuntu.com>
 <CAL3q7H7hhaDQ3e2oCW96iwr6NPww-57e9b675oQ-MY6EVTrVQA@mail.gmail.com>
 <CAM2nqdoqHdPbqg6n5=9KbCKwbFm6rM_7qQ+y1S5AfyiAMbWMNw@mail.gmail.com>
CC: Philippe Loctaux <phil@philippeloctaux.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56CBB6B0.9020307@cn.fujitsu.com>
Date: Tue, 23 Feb 2016 09:32:32 +0800
MIME-Version: 1.0
In-Reply-To: <CAM2nqdoqHdPbqg6n5=9KbCKwbFm6rM_7qQ+y1S5AfyiAMbWMNw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Simon Quigley wrote on 2016/02/22 08:45 -0600:
> On Mon, Feb 22, 2016 at 7:29 AM, Filipe Manana <fdmanana@gmail.com> wrote:
>> On Mon, Feb 22, 2016 at 12:02 PM, Simon Quigley <tsimonq2@ubuntu.com> wrote:
>>>> 1) You don't learn anything by doing them. You don't learn nothing
>>>> about btrfs internals, filesystems in general, kernel programming in
>>>> general, general programming in C, etc. It ends up being only a waste
>>>> of time for you;
>>>
>>> It is useful for one reason. If you would like to get used to the workflow of kernel development,
>>
>> No, that's silly. Generating a patch file and sending it to the
>> mailing list is very trivial. There's not much to learn there.
>> Certainly you don't need to send around 10 whitespace/style patches
>> for that. 1 is enough to "test the waters". And most people learn that
>> by observing others for a while too.
>>
>>> this seems to be useful for a lot of people. In fact, Linus himself has encouraged this.
>>
>> Whitespace/style patches I doubt. He probably encourages for small
>> cleanup/optimizations as the first patch, like he did recently at
>> https://lkml.org/lkml/2015/9/15/919. That's something that requires
>> some thinking and understanding. Now running checkpatch and fix its
>> warnings, doesn't require any skill at all.
>> What were you planning? Sending more 100 patches, each one to fix a
>> different style issue for each function? There's probably hundreds or
>> thousands more style/whitespace "issues" to fix in btrfs alone.
>>
>> Just think about what you want to accomplish. It's normal to not know
>> what do initially, I think everyone goes through that phase, specially
>> if not employed to work on btrfs (or whatever project interests you).

And, even employed, at least I also went through that phase.
(Not to mention I also started by sending small cleanups)

>> Just read code, find issues in it, make changes for your own testing,
>> read bug reports and performance issue reports here in the list and in
>> kernel's bugzilla - some bugs might be easy to fix, other might
>> require very deep knowledge of the internals or no one figured out yet
>> how to reproduce. Or run xfstests and filesystem stress testing tools
>> to find problems (there's plenty of races, deadlocks, etc that happen
>> often and no one knows about them yet). Over time you'll find plenty
>> of things to do, that make you learn a lot and do something useful for
>> users and other developers.

Despite reading the code, which sometimes is quite boring and easy to 
get lost especially when you are not familiar with btrfs,
personally I recommend to start from btrfs on-disk format with 
btrfs-dedup-tree.

And my personal quick-and-dirty skill up roadmap would be:
1) Understand btrfs on-disk format
2) btrfs-progs contributor
3) btrfs kernel contributor

On-disk data is static and you don't need to care any of the complicated 
implementation or details.
All you need to care is, what is on disk, what's the meaning of that 
on-disk data, and how on-disk data change after you did something with 
the btrfs filesystem, like creating a empty file/dir, or write some data 
into it.

Also, when you play with btrfs-debug-tree, it's quite easy to get 
familiar how btrfs-debug-tree works, and maybe found some easy 
enhancement for btrfs-debug-tree.

On-disk format also provides a super good entry point for further reading.

If you want to understand how btrfs inserts file extents, as long as you 
find file extents use EXTENT_DATA key type, you can easily find the 
direct code which inserts that key into btrfs btree.


With btrfs-debug-tree as a learning tool, you will be quite easy to 
begin your contribution to btrfs-progs, like adding some output which 
current btrfs-debug-tree lacks.

After you're familiar with btrfs-progs enough, all skills learnt will 
help you to start your kernel contribution, although kernel is never as 
easy as btrfs-progs, but I think that's your object.

>
> I guess you have a point, I apologize. Overall though, I am curious as
> to what Chris Mason has to say about this.

I think David, one of the kernel maintainers and btrfs-progs maintainer, 
and Filipe, one of the core and the most active developer, their words 
have carries a lot of weight.

Thanks,
Qu


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


