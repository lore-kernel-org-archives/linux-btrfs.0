Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ia0-f172.google.com ([209.85.210.172]:43889 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091Ab3CPNNw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Mar 2013 09:13:52 -0400
Received: by mail-ia0-f172.google.com with SMTP id l29so4050573iag.31
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Mar 2013 06:13:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130316124415.GL24591@merlins.org>
References: <201303162302.14746.russell@coker.com.au>
	<CAE5mzvj4DF98MmzW7M29WZtKiW3p_f7=GzZ54q3+jo6CWgPvxw@mail.gmail.com>
	<20130316124415.GL24591@merlins.org>
Date: Sat, 16 Mar 2013 07:13:52 -0600
Message-ID: <CAE5mzvizwuf_-K+oLKy3CQ0r9r2kjOUmiH=PLY747jAc2VWAvg@mail.gmail.com>
Subject: Re: multiple btrfsck runs
From: cwillu <cwillu@cwillu.com>
To: Marc MERLIN <marc@merlins.org>
Cc: russell@coker.com.au, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 16, 2013 at 6:44 AM, Marc MERLIN <marc@merlins.org> wrote:
> On Sat, Mar 16, 2013 at 06:24:47AM -0600, cwillu wrote:
>> On Sat, Mar 16, 2013 at 6:02 AM, Russell Coker <russell@coker.com.au> wrote:
>> > Is it expected that running btrfsck more than once will keep reporting errors?
>>
>> Without options, btrfsck does not write to the disk.
>
> Aaaaah, that explains why I never got it to work the day I wanted to try
> it.
> I should note that waht you're saying is neither documented in the man
> page, nor in https://btrfs.wiki.kernel.org/index.php/Btrfsck
>
> For that matter, the wiki actually states there are no options.
>
> Is that mostly intentional so that whoever isn't reading the source
> doesn't really run the tool because it's not ready?

At least a bit, yeah.  People have getting better about updating the
documentation recently though.
