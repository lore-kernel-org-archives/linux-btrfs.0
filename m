Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f45.google.com ([209.85.216.45]:47951 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbaK3EAe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Nov 2014 23:00:34 -0500
Received: by mail-qa0-f45.google.com with SMTP id x12so5916584qac.32
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Nov 2014 20:00:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAH-HCWXVn3pyejxzy7_sQmGPwARf6hLxYdHPWBrhd5bkZvExpQ@mail.gmail.com>
References: <CAH-HCWXVn3pyejxzy7_sQmGPwARf6hLxYdHPWBrhd5bkZvExpQ@mail.gmail.com>
From: Shriramana Sharma <samjnaa@gmail.com>
Date: Sun, 30 Nov 2014 09:30:12 +0530
Message-ID: <CAH-HCWV9dBN4Z0B2p_hRAOdwTgAHr7bOcPLjZ7oRKBp9780emQ@mail.gmail.com>
Subject: Re: Change "total" in btrfs filesystem df output to "alloc"
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 31, 2014 at 7:25 AM, Shriramana Sharma <samjnaa@gmail.com> wrote:
> Hello. There seem to be lots of questions in various forums re the
> output of btrfs fi df -- especially w.r.t. the usage of the word
> "total". For example see https://community.oracle.com/thread/2459838
>
> I feel it would make the intent clearer if "total" were changed to
> "alloc" or "allocated" (if the short form is felt unclear). It would
> also help people understand the output of regular df on a btrfs system
> since one can understand easier that pre-allocated space would count
> as "used" space as it is not free!

Where should I report a bug to get this fixed? Thanks.

-- 
Shriramana Sharma ஶ்ரீரமணஶர்மா श्रीरमणशर्मा
