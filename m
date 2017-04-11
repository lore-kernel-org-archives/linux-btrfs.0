Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:40902 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752918AbdDKVAZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Apr 2017 17:00:25 -0400
Date: Tue, 11 Apr 2017 23:00:23 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Amin Hassani <ahassani@chromium.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs disk layout question
Message-ID: <20170411210023.vfqck3h6nepdow3z@angband.pl>
References: <CACh0r45KQb+wLCbRP50WUfe8Loa=zF-Y13n2MhgUbRKi=UT8bw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACh0r45KQb+wLCbRP50WUfe8Loa=zF-Y13n2MhgUbRKi=UT8bw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 11, 2017 at 12:15:32PM -0700, Amin Hassani wrote:
> I am working on a project with Btrfs and I was wondering if there is
> any way to see the disk layout of the btrfs image. Let's assume I have
> a read-only btrfs image with compression on and only using one disk
> (no raid or anything). Is it possible to get a set of offset-lengths
> for each file

While btrfs-specific ioctls give more information, you might want to look at
FIEMAP (Documentation/filesystems/fiemap.txt) as it works on most
filesystems, not just btrfs.  One interface to FIEMAP is provided in
"/usr/sbin/filefrag -v".

-- 
⢀⣴⠾⠻⢶⣦⠀ Meow!
⣾⠁⢠⠒⠀⣿⡁
⢿⡄⠘⠷⠚⠋⠀ Collisions shmolisions, let's see them find a collision or second
⠈⠳⣄⠀⠀⠀⠀ preimage for double rot13!
