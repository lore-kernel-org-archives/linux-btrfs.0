Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:38504 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbbLVQ5J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Dec 2015 11:57:09 -0500
Received: by mail-ig0-f181.google.com with SMTP id jw2so61935344igc.1
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Dec 2015 08:57:09 -0800 (PST)
Subject: Re: [PATCH v4 1/2] btrfs: Introduce new mount option backuproot to
 replace recovery
To: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <1450750596-14627-1-git-send-email-quwenruo@cn.fujitsu.com>
 <CAHji153JzZu0BW80fJo38GwEesAGWbwWcLhrianwXqbvTFjJaA@mail.gmail.com>
Cc: linux-btrfs@vger.kernel.org
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56798093.9020205@gmail.com>
Date: Tue, 22 Dec 2015 11:55:47 -0500
MIME-Version: 1.0
In-Reply-To: <CAHji153JzZu0BW80fJo38GwEesAGWbwWcLhrianwXqbvTFjJaA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-12-22 07:30, Holger Hoffstätte wrote:
> On Tue, Dec 22, 2015 at 3:16 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>> Current "recovery" mount option will only try to use backup root.
>> However the word "recovery" is too generic and may be confusing for some
>> users.
>>
>> Here introduce a new and more specific mount option, "backuproot" to
>> replace "recovery" mount option.
>> "Recovery" will be kept for compatibility reason, but will be
>> deprecated.
>
> I agree that this makes much more sense from a user's perspective, so +1.
>
> But why not go all the way: try backuproot automatically when the
> initial mount fails,
> log the fallback and simply deprecate/ignore the option?
>
> Either this works - in which case there is no need to involve a human,
> which may not
> even exist - or it does not. If it does not, things are hosed anyway
> and we can fail
> properly.
I have seen cases where mounting -o ro,recovery didn't work, but restore 
did, so there are cases where data is recoverable but this mount option 
won't work.
>
> Any reasons not to do this?
I'm not 100% certain, but I think that there is a chance if it doesn't 
work that it will make things worse.  That, and TBH, it really should be 
the administrator's choice; personally, if I come across a filesystem on 
one of my systems that needs this, then I'm nuking the filesystem and 
restoring from backup, because I don't trust that the rest of the 
filesystem isn't broken.  It's also consistent with other filesystems 
(at least ext4 requires an option to force using a backup superblock). 
Perhaps we could add a module parameter that specifies whether or not to 
automatically try this?
