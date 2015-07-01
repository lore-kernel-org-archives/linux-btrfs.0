Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail001.aei.ca ([206.123.6.130]:40063 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567AbbGAVAa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Jul 2015 17:00:30 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Chris Mason <clm@fb.com>
Cc: <fdmanana@kernel.org>, <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [GIT PULL] Btrfs bug fixes
Date: Wed, 01 Jul 2015 17:00:28 -0400
MIME-Version: 1.0
Message-ID: <6080f1b0-4b14-4fe0-a01d-2df947782bb0@aei.ca>
In-Reply-To: <20150701172441.GG23627@ret.masoncoding.com>
References: <1435702831-25334-1-git-send-email-fdmanana@kernel.org>
 <20150701172441.GG23627@ret.masoncoding.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris,

Have you looked at Omar Sandoval's

[PATCH v2 0/5] Btrfs: RAID 5/6 missing device scrub+replace

It would be really nice to have these when/if a disk dies...  I
been running with them since v1 without issue.

Thanks
Ed Tomlinson

On Wednesday, July 1, 2015 1:24:41 PM EDT, Chris Mason wrote:
> On Tue, Jun 30, 2015 at 11:20:31PM +0100, fdmanana@kernel.org wrote:
>> From: Filipe Manana <fdmanana@suse.com>
>> 
>> Hi Chris,
>> 
>> Please consider the following changes (or a subset at your will in case
>> they are too many or too large) for the kernel 4.2 release. All these
>> patches have been available in the mailing list for at least 2 weeks. ...
>
> Thanks! These are queued along with a few others I pulled from the list,
> Mark's dedup fixes, and the ones Qu mentioned.  Once it passes tests
> here I'll push out.
>
> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>

