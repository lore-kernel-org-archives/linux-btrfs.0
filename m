Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:34808 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbaDATTM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Apr 2014 15:19:12 -0400
Received: by mail-wg0-f48.google.com with SMTP id l18so8007733wgh.7
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Apr 2014 12:19:11 -0700 (PDT)
Subject: Re: [Help] Errors found in extent allocation tree or chunk allocation
Date: Tue, 01 Apr 2014 19:05:16 -0000
From: Michael Witten <mfwitten@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <8e4932bb29f743419660da1846c2363b-mfwitten@gmail.com>
In-Reply-To: <20b782af1cb448c39cce358cd6d37e8c-mfwitten@gmail.com>
References: <ac786c9023364c699d8212b42da536f2-mfwitten@gmail.com>
            <pan$6d267$8b0a867f$c580cca9$4eb55f7b@cox.net>
            <20b782af1cb448c39cce358cd6d37e8c-mfwitten@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> I'd actually put more faith in the btrfs balance command...
>> Btrfs scrub is another alternative
>
> I suppose, then, that my ultimate plan of action is thus:
>
>   * Back up important data.
>
>   * Give `btrfs scrub' a try.
>
>   * Give `btrfs balance' a try.
>
>   * Rebuild the file system if necessary.

The `btrfs scrub' completed successfully without error, but did not
solve my issues.

The `btrfs balance' completed successfully without error, and DID
solve my issues; it "relocated" every chunk, after which `btrfsck'
ran smoothly.

Thanks for the advice! You've put me at ease, and you've saved me
a lot of time and energy.
