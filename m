Return-Path: <SRS0=aenA=QS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 143F3C169C4
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 05:22:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D70F120855
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 05:22:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=shaw.ca header.i=@shaw.ca header.b="qf69Wok8";
	dkim=pass (2048-bit key) header.d=shaw.ca header.i=@shaw.ca header.b="qf69Wok8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbfBKFW5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Feb 2019 00:22:57 -0500
Received: from smtp-out-no.shaw.ca ([64.59.134.13]:52380 "EHLO
        smtp-out-no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbfBKFW5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Feb 2019 00:22:57 -0500
Received: from cds126.dcs.int.inet ([10.0.153.159])
        by shaw.ca with ESMTP
        id t43SgsOfA8uQmt43TgiaZF; Sun, 10 Feb 2019 22:22:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shaw.ca;
        s=s20180605; t=1549862575;
        bh=HhS+6TwOfDaIfaFH7RAPxS5vPM2nSHi4nDjnJJ3nfnY=;
        h=Date:From:To:Cc:In-Reply-To:References:Subject;
        b=qf69Wok8Dh0Pj9xrgCnJKK//PoiKguEo4i0hAuIOkUnpD69ej7UmkctRaZB9eZQZH
         +36y+Bc7rWBl3oruQSbHCxOgxzNIcBnKAk9dGhoaegevHZ5I8K0y7QDlyMn6zZMfsy
         hb0P7Utk/lirfDpqrwUkDUIOYbjpvNjI+8y6/mpx7Hy3Dwzg4yx4rtxB2LEAIkrsMd
         xzN9jZq0MLYq1YpgbFNLWeVgyG/ulZbcnayu4WCAMiXhEzafHlyP8Lz/gL2YGzJq1m
         2j5DCntvDq6Jcghsp3pHy6PhAqpv/OSQZRUP5d31vyAxx1LdQUE+eeXUmKXcYkLIvk
         wFOQOJISZcHrQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shaw.ca;
        s=s20180605; t=1549862575;
        bh=HhS+6TwOfDaIfaFH7RAPxS5vPM2nSHi4nDjnJJ3nfnY=;
        h=Date:From:To:Cc:In-Reply-To:References:Subject;
        b=qf69Wok8Dh0Pj9xrgCnJKK//PoiKguEo4i0hAuIOkUnpD69ej7UmkctRaZB9eZQZH
         +36y+Bc7rWBl3oruQSbHCxOgxzNIcBnKAk9dGhoaegevHZ5I8K0y7QDlyMn6zZMfsy
         hb0P7Utk/lirfDpqrwUkDUIOYbjpvNjI+8y6/mpx7Hy3Dwzg4yx4rtxB2LEAIkrsMd
         xzN9jZq0MLYq1YpgbFNLWeVgyG/ulZbcnayu4WCAMiXhEzafHlyP8Lz/gL2YGzJq1m
         2j5DCntvDq6Jcghsp3pHy6PhAqpv/OSQZRUP5d31vyAxx1LdQUE+eeXUmKXcYkLIvk
         wFOQOJISZcHrQ==
X-Authority-Analysis: v=2.3 cv=XKpOtjpE c=1 sm=1 tr=0
 a=EkTsUpOA0cE3MUbiN07fnA==:117 a=FKkrIqjQGGEA:10 a=GyfE53u7cosA:10
 a=IkcTkHD0fZMA:10 a=pGLkceISAAAA:8 a=_Dj-zB-qAAAA:8 a=gqtoqyd28ke8O9_N_O0A:9
 a=QEXdDO2ut3YA:10 a=c-cOe7UV8MviEfHuAVEQ:22
Date:   Sun, 10 Feb 2019 22:22:54 -0700 (MST)
From:   STEVE LEUNG <sjleung@shaw.ca>
To:     Thiago Ramon <thiagoramon@gmail.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <8939586.241815809.1549862574354.JavaMail.zimbra@shaw.ca>
In-Reply-To: <CAO1Y9wr7WA1PS+3cvyPBKGgd-_Xf-nnesWhLvmgV83_XTa7RUA@mail.gmail.com>
References: <1690578645.233565651.1549781791550.JavaMail.zimbra@shaw.ca> <CAO1Y9wr7WA1PS+3cvyPBKGgd-_Xf-nnesWhLvmgV83_XTa7RUA@mail.gmail.com>
Subject: Re: corruption with multi-device btrfs + single bcache, won't mount
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.73.161.213, 24.70.176.219]
X-Mailer: Zimbra 8.6.0_GA_1240 (ZimbraWebClient - FF64 (Linux)/8.6.0_GA_1240)
Thread-Topic: corruption with multi-device btrfs + single bcache, won't mount
Thread-Index: VCNiI+Ytj5fUjVoyZmkm0SrX0+kIpg==
X-CMAE-Envelope: MS4wfEC0C+BuSEE9lIAeJ3grZ6ji9cGqMrcNPcbedRCAkeYZT0w8lpALJ53TdEa5oVTMmuX9oIY+CZbaLRnF4aFkbx2KsV1wySOpByEfKeSPsPAf/S8Hkrjt
 rgmV4/GhrXE5q1E8WuZMKYMrHrgMk/3G3ciUNoX0pxL6yYJwGVPsH6dwgvxUcHHjl3HxHjf1Jusn7OsR3cEqzcwQe/36D7KYx2Y=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



----- Original Message -----
> From: "Thiago Ramon" <thiagoramon@gmail.com>
> On Sun, Feb 10, 2019 at 5:07 AM STEVE LEUNG <sjleung@shaw.ca> wrote:
>>
>> Hi all,
>>
>> I decided to try something a bit crazy, and try multi-device raid1 btrfs on
>> top of dm-crypt and bcache.  That is:
>>
>>   btrfs -> dm-crypt -> bcache -> physical disks
>>
>> I have a single cache device in front of 4 disks.  Maybe this wasn't
>> that good of an idea, because the filesystem went read-only a few
>> days after setting it up, and now it won't mount.  I'd been running
>> btrfs on top of 4 dm-crypt-ed disks for some time without any
>> problems, and only added bcache (taking one device out at a time,
>> converting it over, adding it back) recently.
>>
>> This is complete speculation, but I do wonder if having the single
>> cache device for multiple btrfs disks triggered the problem.
> 
> But before you try to restore anything, can you go back in your kernel
> logs and check for errors? Either one of your devices is failing, you
> might have physical link issues or bad memory. Even with a complex
> setup like this you shouldn't be getting random corruption like this.

Indeed, it looks like plugging in the 5th device for caching may have
destabilized things (maybe I'm drawing too much power from the power
supply or something), as I've observed some spurious ATA errors
trying to boot from rescue media.  Things seem to go back to normal
if I take the cache device out.

This hardware is old, but has seemed reliable enough.  Although that
said, this is my second btrfs corruption I've run into (fortunately
no data lost), so maybe the hardware is not as solid as I'd thought.

I guess I should have given it more of a shakedown before rolling out
bcache everywhere.  :)  Thanks for the insight.

Steve
