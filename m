Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:40600 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750716AbdKSFXq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 19 Nov 2017 00:23:46 -0500
Received: by mail-oi0-f41.google.com with SMTP id l138so4232550oib.7
        for <linux-btrfs@vger.kernel.org>; Sat, 18 Nov 2017 21:23:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <e9428f4b-8eae-1df9-aa2e-3ac96703338a@mokrynskyi.com>
References: <0d0062da-6310-7662-a7ec-edc6591b4542@mokrynskyi.com>
 <CAJCQCtSBxDP7ZyCnQuZZLQXXURrKLT+1Ja61pD_uR0oGH0piDA@mail.gmail.com>
 <20171118033335.2ha45mvia5edu6p6@angband.pl> <277c8155-8651-f593-0f3f-e36add09d943@mokrynskyi.com>
 <CAJCQCtTAvVKUmMdTaD=S-34anDghHWmQcjn76i+Q3wYc58+gTA@mail.gmail.com>
 <f73a2482-e82d-e658-02aa-a2e2988a0012@mokrynskyi.com> <CAJCQCtRKPekR+bEE0xaX02Wwz0E_N1wcUxJdc_D-C9By2qMvWw@mail.gmail.com>
 <e9428f4b-8eae-1df9-aa2e-3ac96703338a@mokrynskyi.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 18 Nov 2017 22:23:45 -0700
Message-ID: <CAJCQCtSGXWqTPUfHB467P7rB6yg0oZPOuBCCNU0YE4yzrkejyg@mail.gmail.com>
Subject: Re: Unrecoverable scrub errors
To: Nazar Mokrynskyi <nazar@mokrynskyi.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 18, 2017 at 10:13 PM, Nazar Mokrynskyi <nazar@mokrynskyi.com> wrote:

>
> That was eventually useful:
>
> * found some familiar file names (mangled eCryptfs file names from times when I used it for home directory) and decided to search for it in old snapshots of home directory (about 1/3 of snapshots on that partition)
> * file name was present in snapshots back to July of 2015, but during search through snapshot from 2016-10-26_18:47:04 I've got I/O error reported by find command at one directory
> * tried to open directory in file manager - same error, fails to open
> * after removing this lets call it "broken" snapshot started new scrub, hopefully it'll finish fine
>
> If it is not actually related to recent memory issues I'd be positively surprised. Not sure what happened towards the end of October 2016 though, especially that backups were on different physical device back then.

Wrong csum computation during the transfer? Did you use btrfs send receive?

-- 
Chris Murphy
