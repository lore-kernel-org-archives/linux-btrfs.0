Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:36004 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbcCAR6L (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Mar 2016 12:58:11 -0500
Received: by mail-qg0-f50.google.com with SMTP id u110so19066724qge.3
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Mar 2016 09:58:10 -0800 (PST)
Subject: Re: [RFC] Experimental btrfs encryption
To: Chris Mason <clm@fb.com>, Tomasz Torcz <tomek@pipebreaker.pl>,
        linux-btrfs@vger.kernel.org
References: <1456848492-4814-1-git-send-email-anand.jain@oracle.com>
 <20160301162952.GB718307@mother.pipebreaker.pl>
 <20160301164616.dbbeuzccfkzupign@floor.thefacebook.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56D5D7E0.1040103@gmail.com>
Date: Tue, 1 Mar 2016 12:56:48 -0500
MIME-Version: 1.0
In-Reply-To: <20160301164616.dbbeuzccfkzupign@floor.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-03-01 11:46, Chris Mason wrote:
> On Tue, Mar 01, 2016 at 05:29:52PM +0100, Tomasz Torcz wrote:
>> On Wed, Mar 02, 2016 at 12:08:09AM +0800, Anand Jain wrote:
>>> This patchset adds btrfs encryption support.
>>>
>>> Warning:
>>> The code is in prototype/experimental stage and is not suitable
>>> for the production data yet.
>>
>>    Can you share some design documents?  Will it be compatible
>> with existing encrypting filesystems:
>>   – ext4 ?
>>   – ZFS ?
>>
>>    It would be nice to have common API for encryption, not a dozen
>> of filesystem-specific interfaces.
>
> We'll definitely move in line with the common API over time.  Thanks
> Anand for starting this!
>
> I'd prefer that we keep it per-subvolume for now, just because
> subvolumes are so cheap and because it seems like a better collection
> point for general use.  But as the other filesystems add features we'll
> make sure and keep parity with what users expect.
I hate to tell you, but if you want feature parity, it needs to have \ 
per-file functionality from the start.  Both ext4 and F2FS do per-file, 
as does NTFS (not certain about ZFS, but people are not as likely to be 
coming to BTRFS from ZFS as they are from ext4 or F2FS from what I've seen).

