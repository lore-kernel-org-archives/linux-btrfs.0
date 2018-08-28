Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:39558 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726975AbeH1TjZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Aug 2018 15:39:25 -0400
Received: by mail-it0-f50.google.com with SMTP id h1-v6so1162723itj.4
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Aug 2018 08:47:09 -0700 (PDT)
Subject: Re: 14Gb of space lost after distro upgrade on BTFS root partition
 (long thread with logs)
To: Noah Massey <noah.massey@gmail.com>, menion@gmail.com
Cc: Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAJVZm6fbXOrXieL-hBnd9fqVRH5GdJMmN2ahyzTKCcrOibGJeg@mail.gmail.com>
 <CAJCQCtTTpXgv-gnZaxL9yR72hysUN-Ng57W1SyzHTCT3_oFtfg@mail.gmail.com>
 <CAJVZm6dyJqBa7PoqRuiByKHxR4UWYCsT=V-sej8z+FZDxD99eA@mail.gmail.com>
 <CADfjVrhcZT1u5uTC4x9XOf2ke+3H+gNH6s-4hufOT1VSkpTGaw@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <d46b344f-6d03-5425-188d-88e823caa074@gmail.com>
Date: Tue, 28 Aug 2018 11:47:05 -0400
MIME-Version: 1.0
In-Reply-To: <CADfjVrhcZT1u5uTC4x9XOf2ke+3H+gNH6s-4hufOT1VSkpTGaw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-08-28 11:27, Noah Massey wrote:
> On Tue, Aug 28, 2018 at 10:59 AM Menion <menion@gmail.com> wrote:
>>
>> [sudo] password for menion:
>> ID      gen     top level       path
>> --      ---     ---------       ----
>> 257     600627  5               <FS_TREE>/@
>> 258     600626  5               <FS_TREE>/@home
>> 296     599489  5
>> <FS_TREE>/@apt-snapshot-release-upgrade-bionic-2018-08-27_15:29:55
>> 297     599489  5
>> <FS_TREE>/@apt-snapshot-release-upgrade-bionic-2018-08-27_15:30:08
>> 298     599489  5
>> <FS_TREE>/@apt-snapshot-release-upgrade-bionic-2018-08-27_15:33:30
>>
>> So, there are snapshots, right? The time stamp is when I have launched
>> do-release-upgrade, but it didn't ask anything about snapshot, neither
>> I asked for it.
> 
> This is an Ubuntu thing
> `apt show apt-btrfs-snapshot`
> which "will create a btrfs snapshot of the root filesystem each time
> that apt installs/removes/upgrades a software package."
Not Ubuntu, Debian.  It's just that Ubuntu installs and configures the 
package by default, while Debian does not.

This behavior in general is not specific to Debian either, a lot of 
distributions are either working on or already have this type of 
functionality, because it's the only sane and correct way to handle 
updates short of rebuilding the entire system from scratch.
> 
>> During the do-release-upgrade I got some issues due to the (very) bad
>> behaviour of the script in remote terminal, then I have fixed
>> everything manually and now the filesystem is operational in bionic
>> version
>> If it is confirmed, how can I remove the unwanted snapshot, keeping
>> the current "visible" filesystem contents
> 
> By default, the package runs a weekly cron job to cleanup old
> snapshots. (Defaults to 90d, but you can configure that in
> APT::Snapshots::MaxAge) Alternatively, you can cleanup with the
> command yourself. Run `sudo apt-btrfs-snapshot list`, and then `sudo
> apt-btrfs-snapshot delete <snapshot to delete>`
