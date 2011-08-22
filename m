From: John Fremlin <john@fremlin.org>
Subject: Re: BTRFS should increase the hard-link in the same directory limit
Date: Mon, 22 Aug 2011 17:05:45 +0100
Message-ID: <87ipppa0ti.fsf-genuine-vii@john.fremlin.org>
References: <874o1aztkm.fsf-genuine-vii@john.fremlin.org>
	<4E526D9D.8010202@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E526D9D.8010202@redhat.com> (Josef Bacik's message of "Mon, 22
	Aug 2011 10:54:21 -0400")
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik <josef@redhat.com> writes:
> On 08/21/2011 11:13 AM, John Fremlin wrote:
[...]
>> This restriction causes btrfs-convert 0.19 to crash out with a segfault and
>> no helpful message: something like btrfs-convert: segfault at
>> ffffffffcfb25fb9 ip 000000000040f9f1 sp 00007fffddefb398 error 6 in
>> btrfs-convert[400000+21000].
>> 
>> Is there any plan to alleviate this unfortunate limit (or at least make
>> btrfs-convert give the location of the file which causes it to fail?).
>
> It's a disk format change, something we don't do lightly.

It would indeed require a disk format change, and hardlinks are always
tiresome for FS designers ;-)

I think however that the format change could be designed to only affect
people who sadly cannot at the moment use BTRFS because of this
limitation, and be more or less unnoticeable to other people.

As James points out there are other applications that benefit from being
able to create many names for the same inode in the same directory, and
256 is a very low limit!

Could this at least be put on the list of things to change? Is there a
way to vote for it?

And the fact that btrfs-convert crashes horribly could be fixed without a
disk-format change. . . 
