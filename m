Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bongo.birch.relay.mailchannels.net ([23.83.209.21]:51600 "EHLO
        bongo.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753973AbcIPLE3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Sep 2016 07:04:29 -0400
Subject: Re: [RFC] Preliminary BTRFS Encryption
To: Dave Chinner <david@fromorbit.com>, Anand Jain <anand.jain@oracle.com>
References: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
 <20160916011213.GV22388@dastard>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, dsterba@suse.cz
From: Brendan Hide <brendan@swiftspirit.co.za>
Message-ID: <16999034-f663-9b37-a5dc-f9dd3347c1b7@swiftspirit.co.za>
Date: Fri, 16 Sep 2016 12:45:11 +0200
MIME-Version: 1.0
In-Reply-To: <20160916011213.GV22388@dastard>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For the most part, I agree with you, especially about the strategy being 
backward - and file encryption being a viable more-easily-implementable 
direction.

However, you are doing yourself a disservice to compare btrfs' features 
as a "re-implementation" of existing tools. The existing tools cannot do 
what btrfs' devs want to implement. See below inline.

On 09/16/2016 03:12 AM, Dave Chinner wrote:
> On Tue, Sep 13, 2016 at 09:39:46PM +0800, Anand Jain wrote:
>>
>> This patchset adds btrfs encryption support.
>>
>> The main objective of this series is to have bugs fixed and stability.
>> I have verified with fstests to confirm that there is no regression.
>>
>> A design write-up is coming next, however here below is the quick example
>> on the cli usage. Please try out, let me know if I have missed something.
>
> Yup, that best practices say "do not roll your own encryption
> infrastructure".

100% agreed

>
> This is just my 2c worth - take it or leave it, don't other flaming.
> Keep in mind that I'm not picking on btrfs here - I asked similar
> hard questions about the proposed f2fs encryption implementation.
> That was a "copy and snowflake" version of the ext4 encryption code -
> they made changes and now we have generic code and common
> functionality between ext4 and f2fs.
>
>> Also would like to mention that a review from the security experts is due,
>> which is important and I believe those review comments can be accommodated
>> without major changes from here.
>
> That's a fairly significant red flag to me - security reviews need
> to be done at the design phase against specific threat models -
> security review is not a code/implementation review...

Also agreed. This is a bit backward.

>
> The ext4 developers got this right by publishing threat models and
> design docs, which got quite a lot of review and feedback before
> code was published for review.
>
> https://docs.google.com/document/d/1ft26lUQyuSpiu6VleP70_npaWdRfXFoNnB8JYnykNTg/edit#heading=h.qmnirp22ipew
>
> [small reorder of comments]
>
>> As of now these patch set supports encryption on per subvolume, as
>> managing properties on per subvolume is a kind of core to btrfs, which is
>> easier for data center solution-ing, seamlessly persistent and easy to
>> manage.
>
> We've got dmcrypt for this sort of transparent "device level"
> encryption. Do we really need another btrfs layer that re-implements ...

[snip]
Woah, woah. This is partly addressed by Roman's reply - but ...

Subvolumes:
Subvolumes are not comparable to block devices. This thinking is flawed 
at best; cancerous at worst.

As a user I tend to think of subvolumes simply as directly-mountable 
folders.

As a sysadmin I also think of them as snapshottable/send-receiveable 
folders.

And as a dev I know they're actually not that different from regular 
folders. They have some extra metadata so aren't as lightweight - but of 
course they expose very useful flexibility not available in a regular 
folder.

MD/raid comparison:
In much the same way, comparing btrfs' raid features to md directly is 
also flawed. Btrfs even re-uses code in md to implement raid-type 
features in ways that md cannot.

I can't answer for the current raid5/6 stability issues - but I am 
confident that the overall design is good, and that it will be fixed.

>
> The generic file encryption code is solid, reviewed, tested and
> already widely deployed via two separate filesystems. There is a
> much wider pool of developers who will maintain it, reveiw changes
> and know all the traps that a new implementation might fall into.
> There's a much bigger safety net here, which significantly lowers
> the risk of zero-day fatal flaws in a new implementation and of
> flaws in future modifications and enhancements.
>
> Hence, IMO, the first thing to do is implement and make the generic
> file encryption support solid and robust, not tack it on as an
> afterthought for the magic btrfs encryption pixies to take care of.
>
> Indeed, with the generic file encryption, btrfs may not even need
> the special subvolume encryption pixies. i.e. you can effectively
> implement subvolume encryption via configuration of a multi-user
> encryption key for each subvolume and apply it to the subvolume tree
> root at creation time. Then only users with permission to unlock the
> subvolume key can access it.
>
> Once the generic file encryption is solid and fulfils the needs of
> most users, then you can look to solving the less common threat
> models that neither dmcrypt or per-file encryption address. Only if
> the generic code cannot be expanded to address specific threat
> models should you then implement something that is unique to
> btrfs....
>

Agreed, this sounds like a far safer and achievable implementation process.

> Cheers,
>
> Dave.
>

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97
