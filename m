Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:43399 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359Ab2LCB7v (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Dec 2012 20:59:51 -0500
Received: by mail-qc0-f174.google.com with SMTP id o22so1258505qcr.19
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Dec 2012 17:59:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGJTRchOD0_jX-h5=kN-K2cG3cc0jCshfAjP489iA5FY8jS5rg@mail.gmail.com>
References: <CAEx9m478rbpHCSSNsSv4yyOk3-yrAuSk0DQQ23X+iFWMocAhzg@mail.gmail.com>
	<20121202224635.GA7289@carfax.org.uk>
	<8B5B2183-4049-46F5-9116-2FD15FCE4023@colorremedies.com>
	<CAGJTRchOD0_jX-h5=kN-K2cG3cc0jCshfAjP489iA5FY8jS5rg@mail.gmail.com>
Date: Sun, 2 Dec 2012 19:59:51 -0600
Message-ID: <CAGJTRch9auoQzofAx8i2u56YZcZ-2o4P+_7e83BB9P5adpTFtg@mail.gmail.com>
Subject: Re: basic questions regarding some btrfs features
From: Michael <mike@draftx.net>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Subvolid 0 is always the root.

On Sun, Dec 2, 2012 at 7:59 PM, Michael <mike@draftx.net> wrote:
>
> Subvolid=0 is always the root subvolume.
>
> On Sun, Dec 2, 2012 at 6:32 PM, Chris Murphy <lists@colorremedies.com> wrote:
>>
>>
>> On Dec 2, 2012, at 3:46 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>>
>> > No, there's precisely one top-level subvolume (subvolid=5).
>>
>> What is subvolid=0? I recently got myself into a subvolume maze and ended up mounting subvolid=0 to get back to the top level and that seemed to work at the time.
>>
>> Chris Murphy
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
