Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:35998 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751235AbdESIka (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 May 2017 04:40:30 -0400
Received: by mail-oi0-f54.google.com with SMTP id h4so84050060oib.3
        for <linux-btrfs@vger.kernel.org>; Fri, 19 May 2017 01:40:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170512144818.GI27439@twin.jikos.cz>
References: <20170511211658.GA8401@ircssh-2.c.rugged-nimbus-611.internal> <20170512144818.GI27439@twin.jikos.cz>
From: Sargun Dhillon <sargun@sargun.me>
Date: Fri, 19 May 2017 01:39:49 -0700
Message-ID: <CAMp4zn8AZtYs21Cf-6_kfRjGS0khe5ScpEe__H6XC4i-Ci=ZQw@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] btrfs: allow mechanism to override quota
To: dsterba@suse.cz, Sargun Dhillon <sargun@sargun.me>,
        BTRFS ML <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 12, 2017 at 7:48 AM, David Sterba <dsterba@suse.cz> wrote:
> On Thu, May 11, 2017 at 09:17:01PM +0000, Sargun Dhillon wrote:
>> This patchset makes it so that on a per-filesystem basis one can disable
>> quota enforcement for users with cap_sys_resource. This patchset can
>> likely later be extended to per-qgroup, or a per-volume basis. I'm
>> thinking of extending the sysfs interface to list the qgroups and
>> this same interface for the qgroups themselves.
>>
>> Changes since v1:
>>   -Rather than a separate member of btrfs_fs_info, use the existing
>>    flags field
>
> Looks good to me, thanks.
I'm curious as to whether this approach is fine to get an Acked-by, or
if I need to figure out how to make it more leak-tolerant. I don't
think modifying the overridden extents inflight is a problem. I'm not
sure of a way a user would be able to create *new* chunks of data.
Alternatively, I'd be quite happy making this applicable to metadata
only, for file xattrs, creation, deletion, etc..

Opinions?
