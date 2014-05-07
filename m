Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:56993 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbaEGU6H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 May 2014 16:58:07 -0400
Received: by mail-lb0-f172.google.com with SMTP id l4so2247279lbv.31
        for <linux-btrfs@vger.kernel.org>; Wed, 07 May 2014 13:58:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140507205035.GA8921@birch.djwong.org>
References: <1399460193-1713-1-git-send-email-bo.li.liu@oracle.com>
	<20140507110806.GD26824@mother.pipebreaker.pl>
	<20140507205035.GA8921@birch.djwong.org>
Date: Wed, 7 May 2014 13:58:05 -0700
Message-ID: <CAAS2fgRVyjCZU=f4JDqZy3BbgF9cHbOA4f5+XThSD9dNnpGC=Q@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] Btrfs: add xxhash algorithm
From: Gregory Maxwell <gmaxwell@gmail.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Tomasz Torcz <tomek@pipebreaker.pl>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Liu Bo <bo.li.liu@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 7, 2014 at 1:50 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> Just for kicks I (sloppily) benchmarked a few of the kernel's hash
> implementations on a Core i5-3320M CPU @3.3GHz:
> xxhash: 6.0GB/s
> crc32c-intel: 11.5GB/s
> crc32c (no hw accel): 1.8GB/s

CRC also usually has the very mild data recovery advantage that if
your error is just a bitflip you can correct it using the crc in a
computationally efficient manner, potentially enabling fancy recovery
tools... so it it were merely equal in speed you'd still probably
prefer to use a CRC.
