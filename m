Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:42788 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab3BHFRr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Feb 2013 00:17:47 -0500
Received: by mail-oa0-f50.google.com with SMTP id l20so3710162oag.9
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Feb 2013 21:17:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130208002854.GA1575@twin.jikos.cz>
References: <1360273114-4672-1-git-send-email-mitch.harder@sabayonlinux.org>
	<20130208002854.GA1575@twin.jikos.cz>
Date: Thu, 7 Feb 2013 23:17:46 -0600
Message-ID: <CAKcLGm_z+bMYtBZYvQYRXrPVHxEfrnfaVNPo8=qeKb3JSUOgiw@mail.gmail.com>
Subject: Re: [RFC] Btrfs: Allow the compressed extent size limit to be
 modified v2
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: dave@jikos.cz, Mitch Harder <mitch.harder@sabayonlinux.org>,
        linux-btrfs@vger.kernel.org, zab@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 7, 2013 at 6:28 PM, David Sterba <dave@jikos.cz> wrote:
> On Thu, Feb 07, 2013 at 03:38:34PM -0600, Mitch Harder wrote:
>> --- a/fs/btrfs/relocation.c
>> +++ b/fs/btrfs/relocation.c
>> @@ -144,7 +144,7 @@ struct tree_block {
>>       unsigned int key_ready:1;
>>  };
>>
>> -#define MAX_EXTENTS 128
>> +#define MAX_EXTENTS 512
>
> Is this really related to compression? IIRC I've seen it only in context
> of batch work in reloc, but not anywhere near compression. (I may be
> wrong of course, just checking).
>

When you defragment compressed extents, it will run through relocation.

If autodefrag is enabled, I found most everything I touched was
running through relocation.

It has been a while since I looked at the issue, but I think balancing
your data will also run through relocation.
