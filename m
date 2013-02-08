Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:34766 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946385Ab3BHPNh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Feb 2013 10:13:37 -0500
Received: by mail-oa0-f43.google.com with SMTP id l10so4125974oag.16
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Feb 2013 07:13:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130208145307.GF12339@twin.jikos.cz>
References: <1360273114-4672-1-git-send-email-mitch.harder@sabayonlinux.org>
	<20130208002854.GA1575@twin.jikos.cz>
	<CAKcLGm_z+bMYtBZYvQYRXrPVHxEfrnfaVNPo8=qeKb3JSUOgiw@mail.gmail.com>
	<20130208145307.GF12339@twin.jikos.cz>
Date: Fri, 8 Feb 2013 09:13:35 -0600
Message-ID: <CAKcLGm9vBxnN9Y8dhzJ=80piB12vUdLdqKTgrKZAZXhKLgRd+A@mail.gmail.com>
Subject: Re: [RFC] Btrfs: Allow the compressed extent size limit to be
 modified v2
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, zab@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 8, 2013 at 8:53 AM, David Sterba <dsterba@suse.cz> wrote:
> On Thu, Feb 07, 2013 at 11:17:46PM -0600, Mitch Harder wrote:
>> On Thu, Feb 7, 2013 at 6:28 PM, David Sterba <dave@jikos.cz> wrote:
>> > On Thu, Feb 07, 2013 at 03:38:34PM -0600, Mitch Harder wrote:
>> >> --- a/fs/btrfs/relocation.c
>> >> +++ b/fs/btrfs/relocation.c
>> >> @@ -144,7 +144,7 @@ struct tree_block {
>> >>       unsigned int key_ready:1;
>> >>  };
>> >>
>> >> -#define MAX_EXTENTS 128
>> >> +#define MAX_EXTENTS 512
>> >
>> > Is this really related to compression? IIRC I've seen it only in context
>> > of batch work in reloc, but not anywhere near compression. (I may be
>> > wrong of course, just checking).
>> >
>>
>> When you defragment compressed extents, it will run through relocation.
>>
>> If autodefrag is enabled, I found most everything I touched was
>> running through relocation.
>
> AFAIK defragmentation runs through the writeback loop, blocks are marked
> dirty, delalloc tries to make them contiguous and then synced back to
> disk. Autodefrag uses the same loop, just affects newly written data.
>
>> It has been a while since I looked at the issue, but I think balancing
>> your data will also run through relocation.
>
> Balance does go through reloc for sure.
>
> From the commit that introduces MAX_EXTENTS it's imo quite clear that
> it's only a balance speedup:
>
> (0257bb82d21bedff26541bcf12f1461c23f9ed61)
> Btrfs: relocate file extents in clusters
>
> The extent relocation code copy file extents one by one when
> relocating data block group. This is inefficient if file
> extents are small. This patch makes the relocation code copy
> file extents in clusters. So we can can make better use of
> read-ahead.

In an earlier version of the patch, I had the changes to relocation.c
in a separate patch.  But, I couldn't consistently attain the changed
maximum extent size unless I also addressed the issue with relocation.
