Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:52745 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890Ab3C2NHC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Mar 2013 09:07:02 -0400
Received: by mail-la0-f48.google.com with SMTP id fq13so524855lab.35
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Mar 2013 06:07:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130329125832.GB1876@localhost.localdomain>
References: <515563D7.3020706@petaramesh.org> <20130329125832.GB1876@localhost.localdomain>
From: Harald Glatt <mail@hachre.de>
Date: Fri, 29 Mar 2013 14:06:39 +0100
Message-ID: <CAFWF=akTNuVDSbPzb9aPeMkL2uf6zKAKm6C=VFrMNVKRznQqcg@mail.gmail.com>
Subject: Re: scrub "correcting" tons of errors ?
To: Josef Bacik <jbacik@fusionio.com>
Cc: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On that note, is btrfs doing automatic background scrubs of its own or
do I have to use crontab to schedule scrubs?

Thanks!

On Fri, Mar 29, 2013 at 1:58 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> On Fri, Mar 29, 2013 at 03:50:15AM -0600, Swāmi Petaramesh wrote:
>> Hi there,
>>
>> I've started "btrfs scrub start /" on one of my machines (Kernel
>> 3.8.0-15 Ubuntu AMD64), which typically "behaves well" so I wasn't
>> suspected any disk issue.
>>
>> After having ran for only 165 seconds, "scrub status" shows it pretends
>> having found and corrected 22926 CSUM errors ??!?!?!?!!???
>>
>> This is a rather new HDD, in perfect shape (SMART all OK, never
>> reallocated a single sector, less than 200 hours total runtime...)
>>
>> WTF ?!?
>>
>> I've cancelled scrub for now, until I get further understanding of what
>> can be happening...
>>
>
> So this is probably because of the extent tree corruption you had, it's just
> cleaning things up and you should be fine once it finishes.  Thanks,
>
> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
