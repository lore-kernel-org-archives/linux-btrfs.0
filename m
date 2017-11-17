Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40016 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751680AbdKQUI2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Nov 2017 15:08:28 -0500
From: Nick Terrell <terrelln@fb.com>
To: Uli Heller <uli.heller@daemons-point.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs progs pre-release 4.14-rc1
Date: Fri, 17 Nov 2017 20:08:21 +0000
Message-ID: <520341F4-58FE-4A62-BC46-78FA1709A323@fb.com>
References: <20171114153335.5657-1-dsterba@suse.com>
 <66b53cc9-76bc-2864-1b00-cb4a459e0b4e@daemons-point.com>
In-Reply-To: <66b53cc9-76bc-2864-1b00-cb4a459e0b4e@daemons-point.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> On Nov 17, 2017, at 8:48 AM, Uli Heller <uli.heller@daemons-point.com> wrote:
> 
> I tried to compile these on ubuntu-14.04 running 4.4.0-98-generic
> - I had to install libzstd-dev
> - I had to disable the zstd tests
> 
> Do you think this ends up in a working binary? Or am I doing something strange?

You'll need to install libzstd-dev to compile with zstd enabled, since you
need the libraries and headers. What version of libzstd do you have? You'll
need a version >= 0.8.1 in order to read the compressed data.

On the zstd side, we're working on getting the version of zstd in Ubuntu
16.04 upgraded from 0.5.1 to a version >= 1.0.0 [1]. zstd-0.5.1 was
released before the format stabilized, and can't read data produced by zstd
>= 0.6.

I would expect the zstd tests to fail if the zstd version is < 0.8.1.
Otherwise, could you tell me which version of zstd you have, and I'll
attempt to reproduce the issue.

[1] https://bugs.launchpad.net/xenial-backports/+bug/1717040

-Nick