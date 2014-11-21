Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:36629 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758726AbaKUQhM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Nov 2014 11:37:12 -0500
MIME-Version: 1.0
In-Reply-To: <20141121161509.GD8568@twin.jikos.cz>
References: <danieru.dressler@gmail.com>
	<1416557707-9243-1-git-send-email-danieru.dressler@gmail.com>
	<20141121161509.GD8568@twin.jikos.cz>
Date: Sat, 22 Nov 2014 01:37:10 +0900
Message-ID: <CAGC3nLAUSy-dJGAzz2THDeX6UoSsbZ8BOWUb2pGRoVSWqQpZaw@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: disk-io: replace root args iff only fs_info used
From: Daniel Dressler <danieru.dressler@gmail.com>
To: dsterba@suse.cz, Daniel Dressler <danieru.dressler@gmail.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        "open list:BTRFS FILE SYSTEM" <linux-btrfs@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you David this is helpful feedback.

What would a cover letter be like? Would that be a separate email to
the list, or maybe the first email in a patch series?

Sorry I've twice looked for the integration repo. I found some that
look like it could be but those had older commits. Could you direct me
to the exact branch I'd love to work against it. These patches were
done against linux-next.

I think small one function patches might be best. I have the codebase
mapped out and each file's functions-to-be-cleaned count varies
wildly. If I did batch files together and split large files apart
there would be no rhyme or reason for the groupings. With single
function patches it is very clear what changes are justified since
they should only occur in the affected function or in a call-site.
With multiple functions the call-site changes get mixed up would it
would be harder to review.

Daniel


2014-11-22 1:15 GMT+09:00 David Sterba <dsterba@suse.cz>:
> On Fri, Nov 21, 2014 at 05:15:07PM +0900, Daniel Dressler wrote:
>> This is the 3rd independent patch of a larger
>> project to cleanup btrfs's internal usage of
>> btrfs_root. Many functions take btrfs_root
>> only to grab the fs_info struct.
>>
>> By requiring a root these functions cause
>> programmer overhead. That these functions can
>> accept any valid root is not obvious until
>> inspection.
>>
>> This patch reduces the specificity of such
>> functions to accept the fs_info directly.
>>
>> These patches can be applied independently
>> and thus are not being submitted as a patch
>> series. There should be about 26 patches by
>> the project's completion. Each patch will
>> cleanup between 1 and 34 functions apiece.
>> Each patch covers a single file's functions.
>
> It's good to have this kind of introduction but it really belongs ot the
> cover letter not the individual patches.
>>
>> This patch affects the following function(s):
>>   1) csum_tree_block
>>   2) csum_dirty_buffer
>>   3) check_tree_block_fsid
>>   4) btrfs_find_tree_block
>>   5) clean_tree_block
>
> Now that I see that, I'm not sure that my previous comment about 'one
> patch per function' is the right way to go. This patch looks good as it
> stands. The change is simple enough that I won't be opposed to grouping
> even more functions together as long as it stays revieweable.
>
> The patches are likely to clash with a lot of pending patches, so you
> may want to base it on the integration branch next time. This would make
> maintainers' life easier and also raises chances to merge the patches.
>
> Reviewed-by: David Sterba <dsterba@suse.cz>
