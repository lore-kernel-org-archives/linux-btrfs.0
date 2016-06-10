Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:35092 "EHLO
	mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbcFJRMt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jun 2016 13:12:49 -0400
Received: by mail-it0-f51.google.com with SMTP id z189so760280itg.0
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Jun 2016 10:12:48 -0700 (PDT)
Subject: Re: fsck: to repair or not to repair
To: Adam Borowski <kilobyte@angband.pl>, Nikolaus Rath <Nikolaus@rath.org>
References: <87y47g1esh.fsf@thinkpad.rath.org>
 <87fuslg19q.fsf@vostro.rath.org>
 <ec929c7d-079d-8ea5-87d7-fce0ed1c45b7@gmail.com>
 <87twh1t4xv.fsf@thinkpad.rath.org> <20160610165046.GA18657@angband.pl>
Cc: linux-btrfs@vger.kernel.org
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <271297eb-f557-4b9b-e236-81dd3f70c1be@gmail.com>
Date: Fri, 10 Jun 2016 13:12:42 -0400
MIME-Version: 1.0
In-Reply-To: <20160610165046.GA18657@angband.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-06-10 12:50, Adam Borowski wrote:
> On Fri, Jun 10, 2016 at 08:54:36AM -0700, Nikolaus Rath wrote:
>> On Jun 10 2016, "Austin S. Hemmelgarn" <ahferroin7@gmail.com> wrote:
>>> JFYI, if you've using GNU cp, you can pass '--reflink=never' to avoid
>>> it making reflinks.
>>
>> I would have expected so, but at least in coreutils 8.23 the only valid
>> options are "never" and "auto" (at least according to cp --help and the
>> manpage).
>
> Where do you get "never" from?
>
> .--====
> cp: invalid argument ‘never’ for ‘--reflink’
> Valid arguments are:
>   - ‘auto’
>   - ‘always’
> Try 'cp --help' for more information.
> `----
>
> And, as of coreutils 8.25, the default is no reflink, with "never" not being
> recognized even as a way to avoid an alias.  As far as I remember, this
> applies to every past version with support for reflinks too.
>
Odd, I could have sworn that was an option...

And I do know there was talk at least at one point of adding it and 
switching to reflink=auto by default.
