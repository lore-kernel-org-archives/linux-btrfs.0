Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:45656 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751529AbcJOWh2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 15 Oct 2016 18:37:28 -0400
Subject: Re: speed up cp --reflink=always
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <6e902770-05f3-2562-eeb3-dd9ef53b9406@profihost.ag>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <4e88008a-b844-e7d6-cba3-f86ce976b753@mendix.com>
Date: Sun, 16 Oct 2016 00:37:21 +0200
MIME-Version: 1.0
In-Reply-To: <6e902770-05f3-2562-eeb3-dd9ef53b9406@profihost.ag>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 10/15/2016 10:49 PM, Stefan Priebe - Profihost AG wrote:
> 
> cp --reflink=always takes sometimes very long. (i.e. 25-35 minutes)
> 
> An example:
> 
> source file:
> # ls -la vm-279-disk-1.img
> -rw-r--r-- 1 root root 204010946560 Oct 14 12:15 vm-279-disk-1.img
> 
> target file after around 10 minutes:
> # ls -la vm-279-disk-1.img.tmp
> -rw-r--r-- 1 root root 65022328832 Oct 15 22:13 vm-279-disk-1.img.tmp

Two quick thoughts:
1. How many extents does this img have?
2. Is this an XY problem? Why not just put the img in a subvolume and
snapshot that?

K
