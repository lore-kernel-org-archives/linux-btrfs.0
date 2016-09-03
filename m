Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:36586 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750749AbcICEO3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Sep 2016 00:14:29 -0400
Received: by mail-oi0-f51.google.com with SMTP id r205so107815736oih.3
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Sep 2016 21:14:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1472874426.27624.2.camel@gmail.com>
References: <1471023419.16857.9.camel@gmail.com> <1472676550.8145.1.camel@gmail.com>
 <CAJCQCtR8EKENcy0ApONzDTX0RNZb8Dh-+_au4cMkyK24RzDoNw@mail.gmail.com>
 <CAJCQCtTWJMigkeLUP0+aTFPwdpuJtMa3C4isercAfE_Wh3b=PQ@mail.gmail.com>
 <52290114-3b37-2de5-9c9f-ceda6dff955b@suse.com> <CAJCQCtSPLw5Kwunm6WdhDCiE8Kc7BcfZy6W9veuns7kBmgyivw@mail.gmail.com>
 <a61878b9-7b88-7aee-40cf-05368cd01d78@suse.com> <CAJCQCtTBfhXOLg3URfreG29NVfujPjEc0O_cnDFCzDQm0iRtaA@mail.gmail.com>
 <1472734635.3137.4.camel@gmail.com> <0778dff0-cb43-d279-adb2-0e314b61110d@gmail.com>
 <1472747695.3137.7.camel@gmail.com> <b0ec9154-16a5-5293-952a-0d5a988488e8@gmail.com>
 <ab83503e-58c5-e1b4-b1ba-1e1ea8313607@suse.com> <b9bd0a3d-0ae0-a30c-c14d-c85434134890@gmail.com>
 <CAJCQCtT1RptgW-_esKmm2_5eRTxd10wHNxwgNWHSD86LZJ7edQ@mail.gmail.com>
 <d1319d2e-3016-7eef-5f3f-87677600e13c@suse.com> <1472827395.3713.6.camel@gmail.com>
 <9dee919a-0e81-5ba7-ddc6-7dcdb3a6b873@suse.com> <1472829630.3713.8.camel@gmail.com>
 <506f2875-8cea-2d99-3664-52ee546adcfd@suse.com> <1472846181.13263.2.camel@gmail.com>
 <CAJCQCtQDmhU92-Jw=QFALzuKpGL1VdEo5XbJ3ipKbambNqtaFg@mail.gmail.com>
 <1472854386.9717.7.camel@gmail.com> <CAJCQCtSuCcd36zGcBYazhOPBVh4Ujg8WD0GR2vM2sFbTnFn1Jw@mail.gmail.com>
 <1472870869.8290.17.camel@gmail.com> <CAJCQCtRtbYNV+XML2B1O8G4FZJ-oZ9TQe50t3r7K4HKPT+LQOA@mail.gmail.com>
 <1472874426.27624.2.camel@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 2 Sep 2016 22:14:24 -0600
Message-ID: <CAJCQCtRV+PLXs9CM0+cSkd2bTs7zUeh-fW7igp3yKEa=SNVn0w@mail.gmail.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
To: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 2, 2016 at 9:47 PM, Ronan Arraes Jardim Chagas
<ronisbr@gmail.com> wrote:
> Hi Chris,
>
> Em Sex, 2016-09-02 às 21:41 -0600, Chris Murphy escreveu:
>> I suggest removing the hardware, and the proprietary driver, and
>> retest the system with the existing Tumbleweed 4.7.0 kernel; and if
>> that still fails, then try the Leap 4.4 kernel.
>>
>> Proprietary kernels can do all kinds of crazy things they shouldn't
>> so
>> it's entirely possible that driver is a factor in the problem.
>
> Actually it is just a module that I load. It is only loaded when I need
> to work with it. However, I can assure this is not the problem because
> I installed the board one month ago +-, but I have been seeing ENOSPC
> since the beginning of the year IIRC. I am using Tumbleweed default
> kernel right now, but I just can try Leap when 42.2 is released.

If you want a work around sooner than later, pick up one of the latest
Leap 42.2 kernels from the URL I provided, I haven't tried it but it
ought to work. Leap 42.2 isn't going to be released for another 2.5
months.


-- 
Chris Murphy
