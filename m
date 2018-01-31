Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:51977 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753815AbeAaQMB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Jan 2018 11:12:01 -0500
Received: by mail-it0-f54.google.com with SMTP id p139so204546itb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Jan 2018 08:12:00 -0800 (PST)
Subject: Re: [PATCH 0/2] Policy to balance read across mirrored devices
To: Peter Becker <floyd.net@gmail.com>, Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20180130063020.14850-1-anand.jain@oracle.com>
 <CAEtw4r2rj7YF+c3wXprM+PNXKVJZDFLMTznjc9egqB1bSR+Wxw@mail.gmail.com>
 <80358280-ce31-9049-61a8-c9a4b78f4b2b@oracle.com>
 <CAEtw4r1PM+zhmQHYXK8SfHczESg=NVsK9O2rd6FZ8-33_7at=A@mail.gmail.com>
 <cd9f0109-8c7c-3c98-53d8-100f06dcd46f@oracle.com>
 <CAEtw4r1gZCexSZnq_G43d55MwpXN0s-vS2Uyn2M9N2Cvi15QYA@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <8a2e10b7-7476-f655-f3b8-aeb191049104@gmail.com>
Date: Wed, 31 Jan 2018 11:11:57 -0500
MIME-Version: 1.0
In-Reply-To: <CAEtw4r1gZCexSZnq_G43d55MwpXN0s-vS2Uyn2M9N2Cvi15QYA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-01-31 09:52, Peter Becker wrote:
> This is all clear. My question referes to "use the lower devid disk
> containing the stripe"
> 
> 2018-01-31 10:01 GMT+01:00 Anand Jain <anand.jain@oracle.com>:
>>   When a stripe is not present on the read optimized disk it will just
>>   use the lower devid disk containing the stripe (instead of failing back
>>   to the pid based random disk).
> 
> Use only one disk (the disk with the lowest devid that containing the
> stripe) as fallback should be not a good option imho.
> Instead of it should still be used the pid as fallback to distribute
> the workload among all available drives.
> 
> [stripe to use] = [preffer stripes present on read_mirror_policy
> devids] > [fallback to pid % stripe count]
> 
> Perhaps I'm not be able to express myself in English or did I misunderstand you?
Unless I'm seriously misunderstanding the commit messages, the primary 
purpose of having this as an option at all is for testing.  The fact 
that it happens to allow semantics similar to MD's write-mostly flag 
when dealing with a 2-device raid1 profile is just a bonus.
