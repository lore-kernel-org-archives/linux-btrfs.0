Return-Path: <SRS0=iJ2R=NK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 685C2C2BC61
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 17:46:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A79E2081B
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 17:46:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="MTa1jsUy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1A79E2081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbeJaClL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 30 Oct 2018 22:41:11 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:39408 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727679AbeJaClL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Oct 2018 22:41:11 -0400
Received: by mail-lf1-f65.google.com with SMTP id n18so1233259lfh.6
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Oct 2018 10:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to;
        bh=8h6zBTyJZTP1rbEKS9d8Mb7nVCjoYLztbXSwDvHTu2g=;
        b=MTa1jsUyD0kP4qVgUY1U/WsR8gccnEYstMdt81k62WEgKK3MIlDTy+NmPD2VCtUbhh
         R8cWxDrnSL43Thq45WiLFYKckHRYRNEGq1WXgaM/OcRrbq3xa//gEFkhzCwl6ymzLigO
         39pI+YL4nXo7v6g/GQCzgXJ5NhsjkCr3594h/Ifm+UKtK+OGZNkh29TorNSw1hPP9mb+
         KJ4KQU0AtMJP/3eH1yJghPd/0uRUTlWxvXEP0wwMmwr0wrK3kYpnocB5yxFcQhxN+mYT
         PyZJfvOvhMsMB0yH2Uvdmm6TClZormAnMZzluGya2IuHz5Vrg8QJAqnc7ly7LlGmHaWR
         iL0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:in-reply-to:references:from
         :date:message-id:subject:to;
        bh=8h6zBTyJZTP1rbEKS9d8Mb7nVCjoYLztbXSwDvHTu2g=;
        b=kW2BjlRYT0cOA+n/Ot3+3x/rN6E+g+/tPYBlll5Fs+o6E0zfpjOXtbjYtoCrjYpXew
         OOuhOLl0tfC8vxkhFazhZCPjvfwVA+fbtjOWlVcRJ9tmaTSAHEASCBp8nTZsa7cTH8NA
         XAED+r/aZEosnKSWTTBZhiQAuIjt8PmfcRozFx6e6puQiyG7efHiQJgTpesgAmET2FsD
         OZk6cHvYQLggHtKJGtXi/CQgqJN7601cV+dt1+WC2427v5nN1XGbqKj4osp4a2/dmUTV
         zhdS1zDI1Hn8HbfNwD0lEF59u7Ypq5veIVT1IiGm3gteQN1SW8FVNIMOZPyADmr51JOs
         R7lg==
X-Gm-Message-State: AGRZ1gKMXjtfVy20c6Hz7gA6LZKRsaUgY+zUZ7y1EazaLKuMt8JjhqOI
        RWJTFsX0Y5zk51g1Mb3l2nfJCMfvIrbHJhlfiKpuOjez
X-Google-Smtp-Source: AJdET5cF8pPm4R1e8rkmUYJBduxEznCdF1FiAgtc6yJfCBFDhCM+X0vs0CDOQ4lcP0/rf95PZojFMe0HWCjkmvmf3Bw=
X-Received: by 2002:a19:1901:: with SMTP id 1mr2253889lfz.99.1540921603321;
 Tue, 30 Oct 2018 10:46:43 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab3:4f11:0:0:0:0:0 with HTTP; Tue, 30 Oct 2018 10:46:42
 -0700 (PDT)
X-Originating-IP: [192.240.96.67]
In-Reply-To: <20181030161003.GA25765@rus.uni-stuttgart.de>
References: <20181029181141.GA31256@rus.uni-stuttgart.de> <85a63523-7e77-f4ca-9947-2c957c5c577a@georgianit.com>
 <20181030161003.GA25765@rus.uni-stuttgart.de>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Tue, 30 Oct 2018 11:46:42 -0600
X-Google-Sender-Auth: hJjIZl2sW3j3ZUM0DBWI86vw464
Message-ID: <CAJCQCtTQM84sptDiiXvGPQZF2XujANskdAA2PwK3exSuRvs4fg@mail.gmail.com>
Subject: Re: Understanding "btrfs filesystem usage"
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Oct 30, 2018 at 10:10 AM, Ulli Horlacher
<framstag@rus.uni-stuttgart.de> wrote:
>
> On Mon 2018-10-29 (17:57), Remi Gauvin wrote:
>> On 2018-10-29 02:11 PM, Ulli Horlacher wrote:
>>
>> > I want to know how many free space is left and have problems in
>> > interpreting the output of:
>> >
>> > btrfs filesystem usage
>> > btrfs filesystem df
>> > btrfs filesystem show
>>
>> In my not so humble opinion, the filesystem usage command has the
>> easiest to understand output.  It' lays out all the pertinent information.
>>
>> You can clearly see 825GiB is allocated, with 494GiB used, therefore,
>> filesystem show is actually using the "Allocated" value as "Used".
>> Allocated can be thought of "Reserved For".
>
> And what is "Device unallocated"? Not reserved?

That's a reasonable interpretation. Unallocated space is space that's
not used for anything: no data, no metadata, and isn't reference by
any block group.

It's not a relevant number day to day, I'd say it's advanced leaning
toward esoteric knowledge of Btrfs internals. At this point I'd like
to see a simper output by default, and have a verbose option for
advanced users, and an export option that spits out a superset of all
available information in a format parsable for scripts. But I know
there are other project that depend on btrfs user space output, rather
than having something specifically invented for them that's easily
parsed, and can be kept consistent and extendible, separate from human
user consumption. Oh well!




>> The disparity between 498GiB used and 823Gib is pretty high.  This is
>> probably the result of using an SSD with an older kernel.  If your
>> kernel is not very recent, (sorry, I forget where this was fixed,
>> somewhere around 4.14 or 4.15), then consider mounting with the nossd
>> option.
>
> I am running kernel 4.4 (it is a Ubuntu 16.04 system)
> But /local is on a SSD. Should I really use nossd mount option?!

Yes. But it's not a file system integrity suggestion, it's an optimization.


>
>
>
>> You can improve this by running a balance.
>>
>> Something like:
>> btrfs balance start -dusage=55
>
> I run balance via cron weekly (adapted
> https://software.opensuse.org/package/btrfsmaintenance)

With a newer kernel you can probably reduce this further depending on
your workload and use case. And optionally follow it up with executing
fstrim, or just enable fstrim.timer (we don't recommend using discard
mount option for most use cases as it too aggressively discards very
recently stale Btrfs metadata and can make recovery from crashes
harder).

There is a trim bug that causes FITRIM to only get applied to
unallocated space on older file systems, that have been balanced such
that block group logical addresses are outside the physical address
space of the device which prevents the free space inside of such block
groups to be passed over for FITRIM. Looks like this will be fixed in
kernel 4.20/5.0




-- 
Chris Murphy
