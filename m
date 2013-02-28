Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:57014 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759881Ab3B1O7u (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Feb 2013 09:59:50 -0500
Received: by mail-ie0-f174.google.com with SMTP id k10so2139748iea.19
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Feb 2013 06:59:49 -0800 (PST)
Message-ID: <1362063611.18057.69.camel@cwalton-XPS-8300>
Subject: Re: Does defragmenting even work
From: Calvin Walton <calvin.walton@kepstin.ca>
To: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Cc: "BTRFS, Linux" <linux-btrfs@vger.kernel.org>
Date: Thu, 28 Feb 2013 10:00:11 -0500
In-Reply-To: <512F6B30.1060409@petaramesh.org>
References: <512F6B30.1060409@petaramesh.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2013-02-28 at 15:35 +0100, Swâmi Petaramesh wrote:
> BTW...
> 
> I'm not even sure that "btrfs filesystem defrag <somefile>" actually
> does anything...
> 
> If I run "filefrag <somefile>" afterwards, it typically shows the same
> number of fragments that it did prior to running defrag...

If you have compression enabled in your system, the files are split up
into smallish extents for the compression blocks. Merely counting the
number of fragments doesn't really give you any useful information - you
have to check if the fragments are contiguous.

Try running "filefrag -v somefile", and compare the 'physical' and
'expected' values to look for gaps between fragments.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

