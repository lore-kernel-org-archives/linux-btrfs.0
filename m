Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.161.172]:36529 "EHLO
        mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751364AbdDOUfR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 15 Apr 2017 16:35:17 -0400
Received: by mail-yw0-f172.google.com with SMTP id j9so44995794ywj.3
        for <linux-btrfs@vger.kernel.org>; Sat, 15 Apr 2017 13:35:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170415185049.ig65w5pi22d42ajm@angband.pl>
References: <CAJCQCtTU6M1c-B1thYtTBidyEpM9AWPMSPU=NGxj3QHnqTM7+A@mail.gmail.com>
 <20170415183156.mmgm6t4rygm2mt3j@angband.pl> <CAJCQCtR3ZcyauCnJhDNp6rSFvnRWcNy2UsWJsbPJEyR+4tsiEA@mail.gmail.com>
 <20170415185049.ig65w5pi22d42ajm@angband.pl>
From: Chris Murphy <chris@colorremedies.com>
Date: Sat, 15 Apr 2017 14:35:16 -0600
Message-ID: <CAJCQCtTyGHUFVsXcK35N3fA_xjb04UGo+j7UFaf2_Aj6pFs0_Q@mail.gmail.com>
Subject: Re: remount and conflicting ssd options?
To: Adam Borowski <kilobyte@angband.pl>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 15, 2017 at 12:50 PM, Adam Borowski <kilobyte@angband.pl> wrote:
> On Sat, Apr 15, 2017 at 12:41:14PM -0600, Chris Murphy wrote:
>> On Sat, Apr 15, 2017 at 12:31 PM, Adam Borowski <kilobyte@angband.pl> wrote:
>> > On Sat, Apr 15, 2017 at 12:17:25PM -0600, Chris Murphy wrote:
>> >> Then later I tried
>> >>
>> >> mount -o remount,ssd
>> >>
>> >> To go back to regular ssd option, but nothing happens, mount still
>> >> shows ssd_spread.
>> >
>> > ssd_spread implies ssd.
>>
>> OK so it's possible to remount from ssd to ssd_spread but not back to
>> ssd? If I trust the mount output, it's only possible to transition
>> from ssd to ssd_spread, but not from ssd_spread to ssd.
>
> Yeah.  This is a very minor problem (workaround: remount with nossd then
> ssd), but in the light of Hans van Kranenburg's findings, it'd be a bad idea
> to introduce new mount options the kernel would need to keep recognizing
> forever, as the effect of those options needs some rethinking anyways.

Yeah it's confusing aside from the mount behavior.

I have a performance test based on doing a bunch of system updates
(~100 rpm packages), and even with the same mount options, back to
back tests are sufficiently inconsistent that I can't tell which of
the allocator options is better. So the allocation options must be
about something other than time based performance.

I can't tell what is a slow ssd these days so I'm not sure what ssd vs
ssd_spread really mean. Plus then on spinning rust people have
reported better performance with ssd rather than the default of nossd.
While others who are using iSCSI end up with ssd by default and worse
results than with nossd.



-- 
Chris Murphy
