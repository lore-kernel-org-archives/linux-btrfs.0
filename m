Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.161.172]:36696 "EHLO
        mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162636AbdD3Ung (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 30 Apr 2017 16:43:36 -0400
Received: by mail-yw0-f172.google.com with SMTP id l18so49873400ywh.3
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Apr 2017 13:43:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <590555B8.3070006@gmail.com>
References: <590555B8.3070006@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 30 Apr 2017 14:43:35 -0600
Message-ID: <CAJCQCtRfpQU6o3kUuhCe-W3NA2bxh2q=52kfJiuVmv6K-11K+w@mail.gmail.com>
Subject: Re: ERROR: cannot find parent subvolume, can't see reason for it.
To: jfhart085@gmail.com
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 29, 2017 at 9:10 PM, J. Hart <jfhart085@gmail.com> wrote:
> I am trying to do a "send -p src/snp1 src/snp2 dst/" and getting the
> following error:
>
> ERROR: cannot find parent subvolume
>
> The "src/snp1" is present in both "src/" and "dst/".

It's not merely that it must be present. The src/snp1 must have
originally been sent to dst/ using btrfs send/receive. And in
particular it's trying to match subvolume UUIDs; so really the error
is "cannot find parent subvolume uuid on the destination"  - at least
I *think* that's what's going on.

You'd need to use -v or possibly -vv with both the send and receive
commands to get more verbose output and maybe see whether it's the
send or receive side having the problem. I'm gonna guess it's the
receive side.


-- 
Chris Murphy
