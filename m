Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:38313 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751895AbdHBNru (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Aug 2017 09:47:50 -0400
Received: by mail-io0-f193.google.com with SMTP id o9so3729673iod.5
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Aug 2017 06:47:50 -0700 (PDT)
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
To: Lutz Vieweg <lvml@5t9.de>, linux-btrfs@vger.kernel.org
References: <84806456-eed9-00b9-b3f6-99e46cefba33@swiftspirit.co.za>
 <1cfc817b-2f35-9ca5-9d6c-ab2c6ec53ba9@gmail.com>
 <olsi37$qhm$1@blaine.gmane.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <5b59dfbb-ea90-d44a-e745-22d6543a93a1@gmail.com>
Date: Wed, 2 Aug 2017 09:47:46 -0400
MIME-Version: 1.0
In-Reply-To: <olsi37$qhm$1@blaine.gmane.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-02 08:55, Lutz Vieweg wrote:
> On 08/02/2017 01:25 PM, Austin S. Hemmelgarn wrote:
>> And this is a worst-case result of the fact that most
>> distros added BTRFS support long before it was ready.
> 
> RedHat still advertises "Ceph", and given Ceph initially recommended 
> btrfs as
> the filesystem to use for its nodes, it is interesting to read how clearly
> they recommend against btrfs now:
> 
> http://docs.ceph.com/docs/master/rados/configuration/filesystem-recommendations/ 
> 
>> We recommand against using btrfs due to the lack of a stable version
>> to test against and frequent bugs in the ENOSPC handling.
Yes, and the one thing they don't mention there is that Ceph is already 
doing most of the same things that BTRFS is, so you end up having 
performance issues due to duplicated work too.  What they specifically 
call out though is first the reason that it should not be supported yet 
in RHEL, OEL, and many other distros (I'm explicitly leaving 
SLES/OpenSUSE off of that list, because while I disagree with their 
choices of default behavior WRT BTRFS, they are actively involved in 
it's development, unlike most of the other distros that 'support' it), 
and then second one of the biggest issues for regular usage.
> 
> German IT magazine "Golem" speculates that RedHat's decision
> is influenced by its recent acquisition of Permabit.
> 
> But I don't really see how XFS or Permabit tackle the problem
> that if you need to create consistent backups of file systems while they 
> are
> in use, block-device level snapshots damage the write performance
> big time.
When you're talking about data safety though, most people are willing to 
sacrifice write performance in favor of significantly lowering perceived 
risk.  The misguided early support of BTRFS without sufficient 
explanation of exactly how 'in-development' it is by many distros means 
that there are a lot of stories of issues and failures with BTRFS than 
ones of success (partly also because the filesystem is one of those 
things that people tend to complain about if it breaks, and not praise 
all that much if it works), and as a result, the general perception 
outside of people who use it actively is that it's pretty risky to use 
(which is absolutely accurate if you don't do routine maintenance on it).
> 
> (That backup topic is the one reason we use btrfs for a lot of
> /home/ directories.)
> 
> I understand that XFS is expected to get some COW-features in the future
> as well - but it remains to be seen what performance and robustness
> implications that will have on XFS.
I believe basic reflink functionality is already upstream, and I wasn't 
aware of any other specific development for XFS.
