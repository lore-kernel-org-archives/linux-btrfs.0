Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:36488 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1039178AbdDUM2E (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Apr 2017 08:28:04 -0400
Received: by mail-oi0-f50.google.com with SMTP id s131so6303421oia.3
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Apr 2017 05:28:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170421110558.lx56fsrbengxqwuy@angband.pl>
References: <20170421100943.GA2942@ircssh-2.c.rugged-nimbus-611.internal> <20170421110558.lx56fsrbengxqwuy@angband.pl>
From: Sargun Dhillon <sargun@sargun.me>
Date: Fri, 21 Apr 2017 07:27:23 -0500
Message-ID: <CAMp4zn_XkDpmcG4szqv95mAeVeikkTUJWH1vAObduLu7fozL4w@mail.gmail.com>
Subject: Re: [PATCH] btrfs: allow processes with cap_sys_resource to exceed quota
To: Adam Borowski <kilobyte@angband.pl>
Cc: BTRFS ML <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

What do you think about putting this behaviour behind a sysctl? Seems
better than to start introducing a new mechanism of marking tasks?

On Fri, Apr 21, 2017 at 6:05 AM, Adam Borowski <kilobyte@angband.pl> wrote:
> On Fri, Apr 21, 2017 at 10:09:46AM +0000, Sargun Dhillon wrote:
>> This patch allows processes with CAP_SYS_RESOURCE to exceed the qgroup
>> limit. It's useful for administrative programs, such as log rotation,
>> that may need to temporarily use more disk space in order to free up
>> a greater amount of overall disk space without yielding more disk
>> space to the rest of userland.
>
>>  static bool qgroup_check_limits(const struct btrfs_qgroup *qg, u64 num_bytes)
>>  {
>> +     if (capable(CAP_SYS_RESOURCE))
>> +             return true;
>> +
>
> I don't think it's a good idea to make random root-uid processes ignore
> qgroups completely.  Just because the daemon in question doesn't use a
> separate uid is no reason to not protect you from it consuming all the disk
> space.
>
> A temporary request "please let me exceed limits" would make sense, though.
>
> The problem with CAP_SYS_RESOURCE is that it's always on unless explicitly
> dropped.
>
> --
> ⢀⣴⠾⠻⢶⣦⠀ Meow!
> ⣾⠁⢠⠒⠀⣿⡁
> ⢿⡄⠘⠷⠚⠋⠀ Collisions shmolisions, let's see them find a collision or second
> ⠈⠳⣄⠀⠀⠀⠀ preimage for double rot13!
