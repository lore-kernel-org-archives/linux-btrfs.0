Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50908 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391160AbeIVAiq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Sep 2018 20:38:46 -0400
From: Nick Terrell <terrelln@fb.com>
To: Daniel Kiper <dkiper@net-space.pl>
CC: "grub-devel@gnu.org" <grub-devel@gnu.org>,
        Kernel Team <Kernel-team@fb.com>, David Sterba <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/3] btrfs: Import kernel zstd
Date: Fri, 21 Sep 2018 18:48:16 +0000
Message-ID: <7130ADBC-A7B0-4685-988D-A69DFDEBFFDC@fb.com>
References: <20180828013654.1627080-1-terrelln@fb.com>
 <20180828013654.1627080-2-terrelln@fb.com>
 <20180921181025.GB29978@router-fw-old.i.net-space.pl>
In-Reply-To: <20180921181025.GB29978@router-fw-old.i.net-space.pl>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> On Sep 21, 2018, at 11:10 AM, Daniel Kiper <dkiper@net-space.pl> wrote:
> 
> On Mon, Aug 27, 2018 at 06:36:52PM -0700, Nick Terrell wrote:
>> Import xxhash and zstd from the upstream kernel as-is. This will not
>> compile. The next patch in the series contains all the changes needed to
>> make zstd compile in grub. Only the files needed for decompression are
>> imported from zstd.
>> 
>> The files are copied from these locations:
>> include/linux/{xxhash,zstd}.h
>> lib/xxhash.c
>> lib/zstd/
> 
> First of all, may I ask you to import zstd from original repository
> (https://github.com/facebook/zstd) instead of Linux kernel?

Sure, I'll rework the patch set to use upstream zstd, and incorporate
your comments.

I'll upstream any changes we need to reduce the noise when importing,
like changing "byte" to "value" because of a typedef of the same name.

Thanks for the review,
Nick
