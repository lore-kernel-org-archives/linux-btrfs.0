Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48422 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759174AbcIPLoh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Sep 2016 07:44:37 -0400
Subject: Re: [RFC] Preliminary BTRFS Encryption
To: Dave Chinner <david@fromorbit.com>
References: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
 <20160916011213.GV22388@dastard>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, dsterba@suse.cz
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <ba84b8d5-e91e-73d6-55a5-4b7c8f57ab17@oracle.com>
Date: Fri, 16 Sep 2016 19:46:23 +0800
MIME-Version: 1.0
In-Reply-To: <20160916011213.GV22388@dastard>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/16/2016 09:12 AM, Dave Chinner wrote:
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
>
> The ext4 developers got this right by publishing threat models and
> design docs, which got quite a lot of review and feedback before
> code was published for review.
>
> https://docs.google.com/document/d/1ft26lUQyuSpiu6VleP70_npaWdRfXFoNnB8JYnykNTg/edit#heading=h.qmnirp22ipew


  As mentioned 'inline with vfs layer' I mean to say to use
  fs/crypto KPIs. Which I haven't seen what parts of the code
  from ext4 was made as generic KPIs. If that's getting stuff
  correct in the encryption related, I think it would here as well.

  Internal to btrfs - I had challenges to get the extents encoding
  done properly without bailout, and the test plan. Which I think
  is addressed here in this code.


Thanks, Anand


> [small reorder of comments]
>
>> As of now these patch set supports encryption on per subvolume, as
>> managing properties on per subvolume is a kind of core to btrfs, which is
>> easier for data center solution-ing, seamlessly persistent and easy to
>> manage.
>
> We've got dmcrypt for this sort of transparent "device level"
> encryption. Do we really need another btrfs layer that re-implements
> generic, robust, widely deployed, stable functionality?
>
> What concerns me the most here is that it seems like that nothing
> has been learnt from the btrfs RAID5/6 debacle. i.e. the btrfs
> reimplementation of existing robust, stable, widely deployed
> infrastructure was fatally flawed and despite regular corruption
> reports they were ignored for, what, 2 years? And then a /user/
> spent the time to isolate the problem, and now several months later
> it still hasn't been fixed. I haven't seen any developer interest in
> fixing it, either.
>
> This meets the definition of unmaintained software, and it sets a
> poor example for how complex new btrfs features might be maintained
> in the long term. Encryption simply cannot be treated like this - it
> has to be right, and it has to be well maintained.
>
> So what is being done differently ito the RAID5/6 review process
> this time that will make the new btrfs-specific encryption
> implementation solid and have minimal risk of zero-day fatal flaws?
> And how are you going to guarantee that it will be adequately
> maintained several years down the track?
>
>> Also yes, thanks for the emails, I hear, per file encryption and inline
>> with vfs layer is also important, which is wip among other things in the
>> list.
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
> Cheers,
>
> Dave.
>
