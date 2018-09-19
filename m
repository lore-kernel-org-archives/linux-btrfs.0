Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38627 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727002AbeITBPH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Sep 2018 21:15:07 -0400
Received: by mail-wr1-f65.google.com with SMTP id j8-v6so3249175wrw.5
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2018 12:35:43 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Wed, 19 Sep 2018 21:35:40 +0200
From: =?UTF-8?Q?J=C3=BCrgen_Herrmann?= <t-5@t-5.eu>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs send hangs after partial transfer and blocks all IO
In-Reply-To: <CAJCQCtRK9tW80GB-LCbNG5eL0jqNN1euGt+KP3LLgM2jpYJ=aA@mail.gmail.com>
References: <8c2c436d404bca00617614d08e9720c1@t-5.eu>
 <63ab2fb7-15a8-f807-4a2f-04ce53f3f168@suse.com>
 <bb7c2fdd78c731bdf9b5044f4dfc4223@t-5.eu>
 <cb7403dd-0e76-8e8c-2389-30283b9e319d@suse.com>
 <165d2939520.27fe.1e2eed663022c8efc8eff86f8ee324b8@t-5.eu>
 <7956cebe-3227-f153-6f0e-be272abe2c61@suse.com>
 <165d2c48478.27fe.1e2eed663022c8efc8eff86f8ee324b8@t-5.eu>
 <91b2f76b-5b1c-6df3-ac8c-058696f27788@suse.com>
 <165d2e8e110.27fe.1e2eed663022c8efc8eff86f8ee324b8@t-5.eu>
 <322267c4-5671-73f3-acca-797dd6fe3572@suse.com>
 <CAJCQCtQFfGzNrCSVsZXutfx+O5BdNEELieVuHbJ0mLBqATc-cw@mail.gmail.com>
 <5c0b3895-05c8-63b1-195a-316d3eaca072@suse.com>
 <CAJCQCtRK9tW80GB-LCbNG5eL0jqNN1euGt+KP3LLgM2jpYJ=aA@mail.gmail.com>
Message-ID: <d8571e74a64369177dcd3945478eac1f@t-5.eu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 13.9.2018 18:22, schrieb Chris Murphy:
> (resend to all)
> 
> On Thu, Sep 13, 2018 at 9:44 AM, Nikolay Borisov <nborisov@suse.com> 
> wrote:
>> 
>> 
>> On 13.09.2018 18:30, Chris Murphy wrote:
>>> This is the 2nd or 3rd thread containing hanging btrfs send, with
>>> kernel 4.18.x. The subject of one is "btrfs send hung in pipe_wait"
>>> and the other I can't find at the moment. In that case though the 
>>> hang
>>> is reproducible in 4.14.x and weirdly it only happens when a snapshot
>>> contains (perhaps many) reflinks. Scrub and check lowmem find nothing
>>> wrong.
>>> 
>>> I have snapshots with a few reflinks (cp --reflink and also
>>> deduplication), and I see maybe 15-30 second hangs where nothing is
>>> apparently happening (in top or iotop), but I'm also not seeing any
>>> blocked tasks or high CPU usage. Perhaps in my case it's just
>>> recovering quickly.
>>> 
>>> Are there any kernel config options in "# Debug Lockups and Hangs"
>>> that might hint at what's going on? Some of these are enabled in
>>> Fedora debug kernels, which are built practically daily, e.g. right
>>> now the latest in the build system is 4.19.0-0.rc3.git2.1 - which
>>> translates to git 54eda9df17f3.
>> 
>> If it's a lock-related problem then you need Lock Debugging => Lock
>> debugging: prove locking correctness
> 
> OK looks like that's under a different section as CONFIG_PROVE_LOCKING
> which is enabled on Fedora debug kernels.
> 
> 
> # Debug Lockups and Hangs
> CONFIG_LOCKUP_DETECTOR=y
> CONFIG_SOFTLOCKUP_DETECTOR=y
> # CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
> CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
> CONFIG_HARDLOCKUP_DETECTOR_PERF=y
> CONFIG_HARDLOCKUP_CHECK_TIMESTAMP=y
> CONFIG_HARDLOCKUP_DETECTOR=y
> # CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
> CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
> # Lock Debugging (spinlocks, mutexes, etc...)
> CONFIG_LOCK_DEBUGGING_SUPPORT=y
> CONFIG_PROVE_LOCKING=y
> CONFIG_LOCK_STAT=y
> CONFIG_DEBUG_SPINLOCK=y
> CONFIG_DEBUG_LOCK_ALLOC=y
> CONFIG_LOCKDEP=y
> # CONFIG_DEBUG_LOCKDEP is not set
> # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
> CONFIG_LOCK_TORTURE_TEST=m

Hello again!

I have CONFIG_PROVE_LOCKING enabled in my kernel, but no change to
the observed behaviour.

Best regards, Jürgen


-- 
Jürgen Herrmann
https://t-5.eu
ALbertstraße 2
94327 Bogen
