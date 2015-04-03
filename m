Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:37921 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbbDCUVu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Apr 2015 16:21:50 -0400
Received: by igbqf9 with SMTP id qf9so101528421igb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Apr 2015 13:21:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150403182825.GA11030@birch.djwong.org>
References: <20150403182825.GA11030@birch.djwong.org>
Date: Fri, 3 Apr 2015 14:21:49 -0600
Message-ID: <CAJCQCtR76kVMv1Zx3VZWR=10zRWZ8yxeXUbj3o3Q1Ydt5dibhQ@mail.gmail.com>
Subject: Re: LPC2015: File and Storage Systems uconf
From: Chris Murphy <lists@colorremedies.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 3, 2015 at 12:28 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:

> http://wiki.linuxplumbersconf.org/2015:file_and_storage_systems
"userspace interactions with ongoing work in the filesystem and IO stack"

I'm finding some weird [1] behaviors with Btrfs multiple device
volumes in gnome-shell. The 2012 status report on Btrfs and
gnome/nautilus integration [2] was that developers needed more
reliable information from the kernel. Since that time a bunch of sysfs
and vfs work has been done, including Btrfs related work, yet I have
no idea if this meets the requirements for the DE's to convey the
information and behaviors they want to the user.

I'm not sure who the relevant DE stake holders are, but it might be a
good idea to track some of them down. There is a 2010 open udisks RFE
[3] for Btrfs support that's most likely the ultimate source of the
various other bugs, which aren't bugs insofar as udisks just needs to
know more about Btrfs behavior, but I also don't know if all the DE's
use udisks or something else.


Chris Murphy


[1]
https://bugzilla.gnome.org/show_bug.cgi?id=746769
[2]
https://bugzilla.gnome.org/show_bug.cgi?id=608204#c7
[3]
https://bugs.freedesktop.org/show_bug.cgi?id=26258
