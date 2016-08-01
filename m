Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:35923 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbcHAMqQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Aug 2016 08:46:16 -0400
Received: by mail-io0-f174.google.com with SMTP id b62so181534289iod.3
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Aug 2016 05:44:41 -0700 (PDT)
Subject: Re: systemd KillUserProcesses=yes and btrfs scrub
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtQ4CXjBzR6eo0zibDCb9_p0jAiS2q_fCRUkUNVWiM9i6g@mail.gmail.com>
 <CAJCQCtQ8yPQf8O2LA92-Gd95GGXQiDp-ZomKZgP4bNv-MmKHYw@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <ac28e105-f228-de18-08c2-e504e304052d@gmail.com>
Date: Mon, 1 Aug 2016 08:44:34 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ8yPQf8O2LA92-Gd95GGXQiDp-ZomKZgP4bNv-MmKHYw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-30 20:29, Chris Murphy wrote:
> On Sat, Jul 30, 2016 at 2:02 PM, Chris Murphy <lists@colorremedies.com> wrote:
>> Short version: When systemd-logind login.conf KillUserProcesses=yes,
>> and the user does "sudo btrfs scrub start" in e.g. GNOME Terminal, and
>
> Same thing with Xfce, so it's not DE specific. (Unsuprising.)
>
> I inflated the size of the test volume, and it seems pretty clear that
> the scrub is not completing, as the kernel threads stop sooner when
> logging out vs not logging out. So the status reporting an
> interruption appears to be valid for the net operation, not merely the
> user space tool being interrupted.
You have your terminals set to start the shell as a login shell I'm 
guessing.  That's probably why closing the terminal window is triggering 
systemd's process killing.  It will of course still trigger when you 
close the graphical session though.  Personally, this is yet another 
reason for me to not like systemd.  This setting breaks traditional UNIX 
userspace semantics.

Personally, I'm with Duncan on this one though, if resume works 
correctly, then it's not a bug, just a bad interaction between an 
administrative tool designed for a server and an init system designed 
for a desktop.

