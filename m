Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:35587 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932705AbcHJAGX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Aug 2016 20:06:23 -0400
Received: by mail-oi0-f52.google.com with SMTP id 4so39456704oih.2
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Aug 2016 17:06:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtReDSm46LVVZaiMO3oSRgi9EBQnY9+JkH6Fia1SFH4AWg@mail.gmail.com>
References: <a70af895-6d3e-3b8a-eeb3-71d6609f8154@techsquare.com> <CAJCQCtReDSm46LVVZaiMO3oSRgi9EBQnY9+JkH6Fia1SFH4AWg@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 9 Aug 2016 18:06:22 -0600
Message-ID: <CAJCQCtSR6S_RQ5eMjQC9qwifEakme58uw11wHcewiDxqNfq_kw@mail.gmail.com>
Subject: Re: BTRFS: error (device sda1) in btrfs_run_delayed_refs:2963:
 errno=-17 Object already exists
To: Chris Murphy <lists@colorremedies.com>
Cc: Matt McKinnon <matt@techsquare.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 9, 2016 at 6:01 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Tue, Aug 9, 2016 at 5:15 PM, Matt McKinnon <matt@techsquare.com> wrote:
>> Hello,
>>
>> Our server recently crashed and was rebooted.  When it returned our BTRFS
>> volume is mounting read-only:
>
> What happens when you try mounting with -o usebackuproot ?
>
> If that fails, what output do you get for 'btrfs check' (without
> --repair)? If you only get some "errors 400, nbytes wrong" then
> --repair should fix the problem.

This could also be a regression somewhere...
https://bugzilla.kernel.org/show_bug.cgi?id=60522


-- 
Chris Murphy
