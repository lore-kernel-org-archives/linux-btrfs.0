Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60165 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934626AbaFTRSb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jun 2014 13:18:31 -0400
Date: Fri, 20 Jun 2014 10:18:29 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Josef Bacik <jbacik@fb.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>
Subject: Re: btrfs: qgroup: account shared subtrees during snapshot delete
Message-ID: <20140620171829.GS5484@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1403214567-3137-1-git-send-email-mfasheh@suse.de> <1403214567-3137-3-git-send-email-mfasheh@suse.de> <53A36348.4010106@fb.com> <20140619231626.GQ5484@wotan.suse.de> <53A36F85.60607@fb.com> <20140620112534.GB1553@twin.jikos.cz> <20140620152958.GR5484@wotan.suse.de> <53A456F3.4000500@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53A456F3.4000500@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 20, 2014 at 08:44:51AM -0700, Josef Bacik wrote:
> On 06/20/2014 08:29 AM, Mark Fasheh wrote:
>> On Fri, Jun 20, 2014 at 01:25:34PM +0200, David Sterba wrote:
>>> On Thu, Jun 19, 2014 at 04:17:25PM -0700, Josef Bacik wrote:
>>>>>> We don't pay attention to the return value, we should probably abort the
>>>>>> transaction if there is a problem.
>>>>>
>>>>> Abort or log an error and continue? I ask because technically we could
>>>>> continue with the subvolume drop but obviously qgroup state will need to be
>>>>> fixed via a future rescan. I guess the question is which is more 'friendly'
>>>>> to the user.
>>>>
>>>> I'd be ok with log an error and tell the user to rescan.  Thanks,
>>>
>>> I agree.
>>
>> Great, I went ahead and did that. Below is patch #2 with all review comments
>> implemented.
>>
>
> Looks good, you can add
>
> Reviewed-by: Josef Bacik <jbacik@fb.com>
>
> However I'd like to see an xfstest or two for this case so we're sure to be
> testing everything properly.  Once we have that we can merge it.  Thanks,

Adding a test is no problem - I can just import a little script I
have to make a shared tree. FYI though - btrfsck will still report some
inconsistency until we fix the last bit of accounting problems so I guess it
won't really 'pass' at first.
	--Mark

--
Mark Fasheh
