Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:48985 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932390AbaJUQkD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Oct 2014 12:40:03 -0400
Received: by mail-vc0-f174.google.com with SMTP id hq12so755480vcb.33
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Oct 2014 09:40:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$32992$bbc3a80d$ad912ad2$31fcc5ce@cox.net>
References: <20141016113337.GC22943@twin.jikos.cz>
	<20141020163403.GW22943@twin.jikos.cz>
	<pan$32992$bbc3a80d$ad912ad2$31fcc5ce@cox.net>
Date: Tue, 21 Oct 2014 12:40:01 -0400
Message-ID: <CAGfcS_nTbXQQTOC+QcBX8dbwk18Qbf-+JonQSw4WP6MOFg2z7A@mail.gmail.com>
Subject: Re: Poll: time to switch skinny-metadata on by default?
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 21, 2014 at 5:29 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> David Sterba posted on Mon, 20 Oct 2014 18:34:03 +0200 as excerpted:
>
>> On Thu, Oct 16, 2014 at 01:33:37PM +0200, David Sterba wrote:
>>> I'd like to make it default with the 3.17 release of btrfs-progs.
>>> Please let me know if you have objections.
>>
>> For the record, 3.17 will not change the defaults. The timing of the
>> poll was very bad to get enough feedback before the release. Let's keep
>> it open for now.
>
> FWIW my own results agree with yours, I've had no problem with skinny-
> metadata here, and it has been my default now for a couple backup-and-new-
> mkfs.btrfs generations, now.
>

How does one enable it for an existing filesystem?  Is it safe to just
run btrfstune -x?  Can this be done on a mounted filesystem?  Are
there any risks with converting?

--
Rich
