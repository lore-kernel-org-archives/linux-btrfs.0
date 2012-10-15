Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38284 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729Ab2JOULT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Oct 2012 16:11:19 -0400
Received: by mail-wi0-f178.google.com with SMTP id hr7so2571452wib.1
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Oct 2012 13:11:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121015143222.GA31310@shiny>
References: <1350048772-20658-1-git-send-email-sensille@gmx.net>
	<50791203.6060406@gmx.net>
	<20121013080857.GA1491@campbell-lange.net>
	<20121013154128.GA10679@twin.jikos.cz>
	<20121015143222.GA31310@shiny>
Date: Mon, 15 Oct 2012 22:11:18 +0200
Message-ID: <CAOcd+r27HqW71ty+ogCDgVFtNWLYWx7Kt75k8x7WatPT9QrbLA@mail.gmail.com>
Subject: Re: [PATCH] Fits: tool to parse stream
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Arne Jansen <sensille@gmx.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks, Arne,
it will definitely help to debug issues.

Alex.


On Mon, Oct 15, 2012 at 4:32 PM, Chris Mason <chris.mason@fusionio.com> wrote:
> On Sat, Oct 13, 2012 at 09:41:28AM -0600, David Sterba wrote:
>> On Sat, Oct 13, 2012 at 09:08:57AM +0100, Rory Campbell-Lange wrote:
>> > Perhaps "BTRFS Incremental Stream" or "Backup Incremental Stream" should
>> > be considered, with the file extension ".bis".
>>
>> From the brainstorming we had about the name, the intention behind the
>> stream is to be filesystem independent.
>>
>> So this might be named FIS with .fis extension, that is not far from the
>> proposed name. However, this hasn't been approved by the Slang committee
>> yet :)
>
> urbandictionary has some entries for fis, although I'm not really sure
> that matters.  .fs is still my favorite, or .fss if you want to have the
> word stream in there.
>
> The stream parser is really cool though, thanks Arne.
>
> -chris
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
