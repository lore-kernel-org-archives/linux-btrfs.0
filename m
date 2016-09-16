Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:51536 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752097AbcIPGu1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Sep 2016 02:50:27 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bkmyS-0004CV-4D
        for linux-btrfs@vger.kernel.org; Fri, 16 Sep 2016 08:50:12 +0200
To: linux-btrfs@vger.kernel.org
From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: [RFC] Preliminary BTRFS Encryption
Date: Fri, 16 Sep 2016 06:49:53 +0000 (UTC)
Message-ID: <nrg4mh$bkn$1@blaine.gmane.org>
References: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
        <20160916011213.GV22388@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 16 Sep 2016 11:12:13 +1000, Dave Chinner wrote:

> On Tue, Sep 13, 2016 at 09:39:46PM +0800, Anand Jain wrote:
>> 
>> This patchset adds btrfs encryption support.
>> 
>> The main objective of this series is to have bugs fixed and stability.
>> I have verified with fstests to confirm that there is no regression.
>> 
>> A design write-up is coming next, however here below is the quick
>> example on the cli usage. Please try out, let me know if I have missed
>> something.
> 
> Yup, that best practices say "do not roll your own encryption
> infrastructure".

IMO, (some of) this _is_ substantively justified by subvolumes being a 
meaningful unit of isolation/separation. However, yes, other parts really 
should be using Things That Have Already Been Figured Out, such as AEAD.

> This is just my 2c worth - take it or leave it, don't other flaming.
> Keep in mind that I'm not picking on btrfs here - I asked similar hard
> questions about the proposed f2fs encryption implementation.
> That was a "copy and snowflake" version of the ext4 encryption code -
> they made changes and now we have generic code and common functionality
> between ext4 and f2fs.
> 
>> Also would like to mention that a review from the security experts is
>> due,
>> which is important and I believe those review comments can be
>> accommodated without major changes from here.
> 
> That's a fairly significant red flag to me - security reviews need to be
> done at the design phase against specific threat models -
> security review is not a code/implementation review...
> 
> The ext4 developers got this right by publishing threat models and
> design docs, which got quite a lot of review and feedback before code
> was published for review.
> 
> https://docs.google.com/document/
d/1ft26lUQyuSpiu6VleP70_npaWdRfXFoNnB8JYnykNTg/edit#heading=h.qmnirp22ipew
> 
> [small reorder of comments]
> 
>> As of now these patch set supports encryption on per subvolume, as
>> managing properties on per subvolume is a kind of core to btrfs, which
>> is easier for data center solution-ing, seamlessly persistent and easy
>> to manage.
> 
> We've got dmcrypt for this sort of transparent "device level"
> encryption. Do we really need another btrfs layer that re-implements
> generic, robust, widely deployed, stable functionality?

The reason we do, in four words: dmcrypt cannot use AEAD. Because it 
operates on blocks rather than extents, it is _incapable_ of providing 
the security advantages of AEAD, as those intrinsically cause ciphertext 
expansion.

> What concerns me the most here is that it seems like that nothing has
> been learnt from the btrfs RAID5/6 debacle. i.e. the btrfs
> reimplementation of existing robust, stable, widely deployed
> infrastructure was fatally flawed and despite regular corruption reports
> they were ignored for, what, 2 years? And then a /user/
> spent the time to isolate the problem, and now several months later it
> still hasn't been fixed. I haven't seen any developer interest in fixing
> it, either.

This is, fundamentally, not comparable to dmcrypt - this is not a 
reimplementation of the same tool, but a substantively different tool 
despite a similar goal in the _specific_ domain of "composability".

Because dm-crypt cannot use AEAD, it is incapable (as in, there's a 
nonexistence proof) of meeting the IND-CCA2 security notion. By operating 
on extents, this can.

> This meets the definition of unmaintained software, and it sets a poor
> example for how complex new btrfs features might be maintained in the
> long term. Encryption simply cannot be treated like this - it has to be
> right, and it has to be well maintained.

Entirely agreed - but dmcrypt does not do the job this aims to do, so the 
conversation needs to be reframed. This is, honestly, more like 
integrating a vastly more efficient ecryptfs, keyed on a per-subvolume 
basis, than dmcrypt - and needs to be evaluated as such.

> So what is being done differently ito the RAID5/6 review process this
> time that will make the new btrfs-specific encryption implementation
> solid and have minimal risk of zero-day fatal flaws?
> And how are you going to guarantee that it will be adequately maintained
> several years down the track?
> 
>> Also yes, thanks for the emails, I hear, per file encryption and inline
>> with vfs layer is also important, which is wip among other things in
>> the list.
> 
> The generic file encryption code is solid, reviewed, tested and already
> widely deployed via two separate filesystems. There is a much wider pool
> of developers who will maintain it, reveiw changes and know all the
> traps that a new implementation might fall into.
> There's a much bigger safety net here, which significantly lowers the
> risk of zero-day fatal flaws in a new implementation and of flaws in
> future modifications and enhancements.

This, I do agree with - I think it would be a good idea to start from the 
generic file encryption code. However it's fallacious to think that 
simply applying the generic file encryption code to btrfs automatically 
dodges the trap of "rolling your own".

The main issue I see is that subvolumes as btrfs has them _do_ introduce 
novel concerns - in particular, how should snapshots interact with keying 
(and nonces)? None of the AEADs currently in the kernel are nonce-misuse 
resistant, which means that if different data is encrypted under the same 
key and nonce, things go _very_ badly wrong. With writable snapshots, I'd 
consider that a nontrivial risk.

> Hence, IMO, the first thing to do is implement and make the generic file
> encryption support solid and robust, not tack it on as an afterthought
> for the magic btrfs encryption pixies to take care of.

Sure, though that will require very carefully examining how its 
invariants hold up under writable snapshots of subvolumes with encrypted 
files.

> Indeed, with the generic file encryption, btrfs may not even need the
> special subvolume encryption pixies. i.e. you can effectively implement
> subvolume encryption via configuration of a multi-user encryption key
> for each subvolume and apply it to the subvolume tree root at creation
> time. Then only users with permission to unlock the subvolume key can
> access it.

See above; I 100% disagree with this. Any difference between the context 
crypto was designed for, and the context it is applied in, requires 
exceedingly careful validation.

> Once the generic file encryption is solid and fulfils the needs of most
> users, then you can look to solving the less common threat models that
> neither dmcrypt or per-file encryption address. Only if the generic code
> cannot be expanded to address specific threat models should you then
> implement something that is unique to btrfs....

No argument here. (One that particularly interests me is the possibility 
of encrypting the btrees themselves, using the same extent-level 
primitives used for file encryption, and thus enabling AEAD there as 
well).

