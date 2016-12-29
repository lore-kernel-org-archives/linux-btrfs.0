Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([195.154.117.182]:52962 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753059AbcL2Qx4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Dec 2016 11:53:56 -0500
Date: Thu, 29 Dec 2016 21:53:50 +0500
From: Roman Mamedov <rm@romanrm.net>
To: =?UTF-8?B?TWljaGHFgg==?= Zegan <webczat_200@poczta.onet.pl>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: problems with btrfs filesystem loading
Message-ID: <20161229215350.76a455b4@natsu>
In-Reply-To: <a971405b-d8c3-6af0-95bd-1ac5085ca349@poczta.onet.pl>
References: <05893a24-2bf7-d485-1f9c-b10650419955@poczta.onet.pl>
        <a971405b-d8c3-6af0-95bd-1ac5085ca349@poczta.onet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 29 Dec 2016 16:42:09 +0100
Michał Zegan <webczat_200@poczta.onet.pl> wrote:

> I have odroid c2, processor architecture aarch64, linux kernel from
> master as of today from http://github.com/torwalds/linux.git.
> It seems that the btrfs module cannot be loaded. The only thing that
> happens is that after modprobe i see:
> modprobe: can't load module btrfs (kernel/fs/btrfs/btrfs.ko.gz): unknown
> symbol in module, or unknown parameter
> No errors in dmesg, like I have ignore_loglevel in kernel cmdline and no
> logs in console appear except logs for loading dependencies like xor
> module, but that is probably not important.
> The kernel has been recompiled few minutes ago from scratch, the only
> thing left was .config file. What is that? other modules load correctly
> from what I can see.

In the past there's been some trouble with crc32 dependencies:
https://www.spinics.net/lists/linux-btrfs/msg32104.html
Not sure if that's relevant anymore, but in any case, check if you have
crc32-related stuff either built-in or compiled as modules, if latter, try
loading those before btrfs (/lib/modules/*/kernel/crypto/crc32*)

-- 
With respect,
Roman
