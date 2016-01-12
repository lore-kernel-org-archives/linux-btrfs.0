Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:34201 "EHLO
	mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145AbcALUqG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jan 2016 15:46:06 -0500
Received: by mail-lf0-f49.google.com with SMTP id 17so40275963lfz.1
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jan 2016 12:46:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160112142806.GL4227@twin.jikos.cz>
References: <1450070396-20744-1-git-send-email-quwenruo@cn.fujitsu.com>
	<20160112142806.GL4227@twin.jikos.cz>
Date: Tue, 12 Jan 2016 21:46:04 +0100
Message-ID: <CAPmG0jZDKQbuFmFZXxQkcwyw_3oLzy-8nvr+W=mv3e7UEpfa4w@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: Format change for btrfs fi df
From: Henk Slager <eye1tm@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 12, 2016 at 3:28 PM, David Sterba <dsterba@suse.cz> wrote:
> On Mon, Dec 14, 2015 at 01:19:56PM +0800, Qu Wenruo wrote:
>> The GlobalReserve space in 'btrfs fi df' is always confusing for a lot
>> of users.
>> As it is not a special chunk type like DATA or METADATA, it's in fact a
>> sub-type of METADATA.
>>
>> So change the output to skip GlobalReserve by default, and adding its
>> total to metadata used.
>> And add a new option '-r|--reserve' to show the GlobalReserve, but skip
>> the profile of GlobalReserve.
>
> How about this:
>
> - keep the global reserve in the output, separate from metadata and not
>   accounted
> - add new option to account the global reserve into metadata and then
>   drop it from the output

I think this alternative does not remove the confusion for people,
maybe even keeps it and/or increases it. The default 'btrfs fi df'
would then still include a confusing term and numbers belonging to it
that still don't make sense.

Maybe there are scripts around that try to do something with the
number belonging to GlobalReserve, but I think such would already be
part of the problem. Such calculations should be in progs itself by
default. If people want more detail or more output, the -r can be
used. If the used= for metadata is smaller by default and there is
some 'free space hidden', the risk is higher that scripts/people let
the fs grow to even close to full with all the trouble we see so often
in this list and elsewhere.

So I think the original patch is the way forward; It should also be
applied to 'btrfs fi us' I think.

Additionally, when 'btrfs fi df' is default 3 lines, those 3 lines
could exactly match lines that 'btrfs fi us' outputs for
Data/System/Metadata, so aligning Size: with total=  etc. Hopefully
this gives options for making the code more compact for 'btrfs fi df'
+ 'btrfs fi sh' + 'btrfs fi us' + 'btrfs de us'.
