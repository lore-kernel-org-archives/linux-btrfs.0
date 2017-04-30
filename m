Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:36053 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1949891AbdD3U5Z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 30 Apr 2017 16:57:25 -0400
Received: by mail-it0-f52.google.com with SMTP id r185so19830658itd.1
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Apr 2017 13:57:24 -0700 (PDT)
Message-ID: <59064FB2.8020306@gmail.com>
Date: Sun, 30 Apr 2017 16:57:22 -0400
From: "J. Hart" <jfhart085@gmail.com>
Reply-To: jfhart085@gmail.com
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: ERROR: cannot find parent subvolume, can't see reason for it.
References: <590555B8.3070006@gmail.com> <CAJCQCtRfpQU6o3kUuhCe-W3NA2bxh2q=52kfJiuVmv6K-11K+w@mail.gmail.com>
In-Reply-To: <CAJCQCtRfpQU6o3kUuhCe-W3NA2bxh2q=52kfJiuVmv6K-11K+w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you very much for your response.

I had just discovered exactly this a few hours ago.  In sending an 
original snapshot instead of using a duplicate already in place, I was 
able to get around this problem.
As you mentioned, the error was coming from the receive side.

I am presently investigating a another error I have detailed in another 
message:

ERROR: rename o3528-7220-0 -> usr failed: Directory not empty

It is probably not related.  I will file a report with Kernel.org 
bugzilla on it.


On 04/30/2017 04:43 PM, Chris Murphy wrote:
> On Sat, Apr 29, 2017 at 9:10 PM, J. Hart <jfhart085@gmail.com> wrote:
>> I am trying to do a "send -p src/snp1 src/snp2 dst/" and getting the
>> following error:
>>
>> ERROR: cannot find parent subvolume
>>
>> The "src/snp1" is present in both "src/" and "dst/".
> It's not merely that it must be present. The src/snp1 must have
> originally been sent to dst/ using btrfs send/receive. And in
> particular it's trying to match subvolume UUIDs; so really the error
> is "cannot find parent subvolume uuid on the destination"  - at least
> I *think* that's what's going on.
>
> You'd need to use -v or possibly -vv with both the send and receive
> commands to get more verbose output and maybe see whether it's the
> send or receive side having the problem. I'm gonna guess it's the
> receive side.
>
>

