Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:42197 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932220AbeEWKJy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 May 2018 06:09:54 -0400
Received: by mail-wr0-f180.google.com with SMTP id w10-v6so2595021wrk.9
        for <linux-btrfs@vger.kernel.org>; Wed, 23 May 2018 03:09:53 -0700 (PDT)
Message-ID: <5B053DF2.4030301@gmail.com>
Date: Wed, 23 May 2018 12:09:54 +0200
From: ein <ein.net@gmail.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: csum failed root raveled during balance
References: <5B047817.3040106@gmail.com>        <e04ab862-abe3-7187-1519-b89776df9362@suse.com> <5B052068.5000608@gmail.com> <pan$d9d06$238f0899$805884d5$1c7cb19b@cox.net>
In-Reply-To: <pan$d9d06$238f0899$805884d5$1c7cb19b@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/23/2018 11:09 AM, Duncan wrote:
> ein posted on Wed, 23 May 2018 10:03:52 +0200 as excerpted:
> 
>>> IMHO the best course of action would be to disable checksumming for you
>>> vm files.
>>
>> Do you mean '-o nodatasum' mount flag? Is it possible to disable
>> checksumming for singe file by setting some magical chattr? Google
>> thinks it's not possible to disable csums for a single file.
> 
> You can use nocow (-C), but of course that has other restrictions (like 
> setting it on the files when they're zero-length, easiest done for 
> existing data by setting it on the containing dir and copying files (no 
> reflink) in) as well as the nocow effects, and nocow becomes cow1 after a 
> snapshot (which locks the existing copy in place so changes written to a 
> block /must/ be written elsewhere, thus the cow1, aka cow the first time 
> written after the snapshot but retain the nocow for repeated writes 
> between snapshots).
> 
> But if you're disabling checksumming anyway, nocow's likely the way to go.

Disabling checksumming only may be a way to go - we live without it
every day. But nocow @ VM files defeats whole purpose of using BTRFS for
me, even with huge performance penalty - backup reasons - I mean few
snapshots (20-30), send & receive.


-- 
PGP Public Key (RSA/4096b):
ID: 0xF2C6EA10
SHA-1: 51DA 40EE 832A 0572 5AD8 B3C0 7AFF 69E1 F2C6 EA10
