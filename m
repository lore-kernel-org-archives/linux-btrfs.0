Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:48620 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932582Ab3DCIrh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Apr 2013 04:47:37 -0400
Received: by mail-wi0-f171.google.com with SMTP id hn17so3368148wib.4
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Apr 2013 01:47:36 -0700 (PDT)
Message-ID: <515BECA0.8020302@gmail.com>
Date: Wed, 03 Apr 2013 09:47:28 +0100
From: Uncle Stoatwarbler <stoatwblr@gmail.com>
MIME-Version: 1.0
To: zfs-discuss@zfsonlinux.org, Roman Mamedov <rm@romanrm.ru>,
        "BTRFS, Linux" <linux-btrfs@vger.kernel.org>
Subject: Re: [zfs-discuss] Re: Moving...
References: <515A95C7.5090607@petaramesh.org> <20130402230421.016afe58@natsu> <515B120F.6000004@petaramesh.org>
In-Reply-To: <515B120F.6000004@petaramesh.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/04/13 18:14, Swâmi Petaramesh wrote:

> My netbook (now ZFS) boots to GDM in less than 30 seconds. My son's same
> machine (except for the FS) takes 75 MORE seconds.

my (5 year old) laptop with a relatively slow SSD in it boots to GDM 
(Mint LXDE) in about 5 seconds with ext4. A 9 year old laptop fitted 
with a very slow PATA SSD takes about 9 seconds to do the same.

I'm not so sure that ZFS is a good fit for single drive machines ((Nor 
is ext4 for SSDs for that matter), but I'm happy to be corrected.

What I do know from banging hard on both is that I'd far sooner trust 
ZFS in an enterprise environment than BTRFS (or XFS), because I'm not 
really that happy about the idea of having to periodically restore 
500Tb+ of data from backups. Speed is a secondary issue, but ZFS is 
definitely faster at large scale.

There's a lot of wheel reinvention going on and I feel there must be 
some way of merging the good parts of both sets of code, then moving on.


