Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:37247 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751069AbdEES0S (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 May 2017 14:26:18 -0400
Received: by mail-it0-f52.google.com with SMTP id x188so12862823itb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 05 May 2017 11:26:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170505182247.GL10575@twin.jikos.cz>
References: <20170421100943.GA2942@ircssh-2.c.rugged-nimbus-611.internal>
 <20170421110558.lx56fsrbengxqwuy@angband.pl> <CAMp4zn_XkDpmcG4szqv95mAeVeikkTUJWH1vAObduLu7fozL4w@mail.gmail.com>
 <20170505182247.GL10575@twin.jikos.cz>
From: Sargun Dhillon <sargun@sargun.me>
Date: Fri, 5 May 2017 11:25:36 -0700
Message-ID: <CAMp4zn9BmNqkmToxVSBF9FsUTBoHzr2CLSXPBjADS-ZTZqn_fw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: allow processes with cap_sys_resource to exceed quota
To: dsterba@suse.cz, Sargun Dhillon <sargun@sargun.me>,
        Adam Borowski <kilobyte@angband.pl>,
        BTRFS ML <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If you see my follow-on patch, it allows disabling the quota limit for
folks with cap_sys_resource per filesystem. I don't want to have any
process to be able to turn off quota limits, but just the process that
is the logrotator (and has the proper capabilities). Unfortunately,
most folks don't lock down their capabilities, so I agree, making it
blindly based on capabilities seems like a poor idea.

On Fri, May 5, 2017 at 11:22 AM, David Sterba <dsterba@suse.cz> wrote:
> On Fri, Apr 21, 2017 at 07:27:23AM -0500, Sargun Dhillon wrote:
>> What do you think about putting this behaviour behind a sysctl? Seems
>> better than to start introducing a new mechanism of marking tasks?
>
> Technically it's easy to add own btrfs-specific ioctl, temporarily
> turning off quota limits, but I'm still not sure about all the
> consequences as this would apply to the whole system, no? The
> capabilities are per process, much more fine grained. I don't have other
> ideas how to address the problem though.
