Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:37583 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbaBFWs2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Feb 2014 17:48:28 -0500
Received: by mail-ob0-f169.google.com with SMTP id wo20so3060366obc.14
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Feb 2014 14:48:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140206212209.GU1364@twin.jikos.cz>
References: <1391711648-7224-1-git-send-email-mitch.harder@sabayonlinux.org>
	<20140206212209.GU1364@twin.jikos.cz>
Date: Thu, 6 Feb 2014 16:48:27 -0600
Message-ID: <CAKcLGm8yjzS8iGmgqGFrqAzFTaxZBhtRsX9YgqPq+Laf2wiPsQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: Convert BUG() to BUG_ON(1)
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: David Sterba <dsterba@suse.cz>,
        Mitch Harder <mitch.harder@sabayonlinux.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 6, 2014 at 3:22 PM, David Sterba <dsterba@suse.cz> wrote:
> On Thu, Feb 06, 2014 at 12:34:08PM -0600, Mitch Harder wrote:
>> Convert the instances of BUG() to BUG_ON(1) to provide information
>> about the location of the abort.
>
> kerncompat.h:
>
> #define BUG() abort()
>
> #define BUG_ON(c) assert(!(c))
>
> I'd rather fix the definition to do the same thing, that way no
> developer would need to know the difference (that actually exists only
> in the userspace tools, in kernel the two produce the same outout).
>
>
> david

Thanks for the feedback.

Changing the definition of BUG() in kerncompat.h will be much more concise.

I'll restructure the patch and resubmit it after I test it.
